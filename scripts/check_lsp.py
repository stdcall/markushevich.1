"""Verify native references resolve to their literal labels in Tinymist."""
import argparse
import json
import os
from pathlib import Path
import queue
import re
import subprocess
import tempfile
import threading
from urllib.parse import unquote, urlparse


def position(text, offset):
    before = text[:offset]
    return {'line': before.count('\n'), 'character':
            len(before.rsplit('\n', 1)[-1].encode('utf-16-le')) // 2}


def check(root):
    from project import source_files
    sources = source_files(root)
    cases = []
    seen = set()
    labels = set()
    for path in sources:
        labels.update(re.findall(r'<([a-z][\w:.-]+)>', path.read_text()))
    for path in sources:
        text = path.read_text()
        if re.match(r"\d\d-", path.name):
            prose = re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)
            legacy = re.search(
                r'#(?:xref|book-ref|eq-ref|equation-ref|section-ref|chapter-ref|'
                r'part-ref|theorem-ref|lemma-ref|proposition-ref|corollary-ref|'
                r'figure-ref|sec-ref|ch-ref|sec-ch-ref|fig-ref|idx-ref|number-ref)'
                r'\s*\(\s*(?:<|")', prose)
            assert legacy is None, (str(path.relative_to(root)),
                                    'Use a native @label reference')
        for pattern in (r'@([a-z][\w-]*:[\w:.-]+)',):
            for m in re.finditer(pattern, text):
                label = m.group(1).rstrip('.:')
                if label not in seen:
                    cases.append((path, label, m.start(1) + 1))
                    seen.add(label)
    missing = sorted({label for _, label, _ in cases if label not in labels})
    config = json.loads((root / 'config/project.json').read_text())
    if config.get('stage') == 'final':
        assert not missing, ('Unresolved references', missing)
    elif missing:
        print('Pending targets:', ', '.join(missing))
        cases = [case for case in cases if case[1] in labels]
    assert cases, 'No native references found'
    # Keep the local editor registration unchanged.
    lock = root / 'tinymist.lock'
    saved = lock.read_bytes() if lock.exists() else None
    with tempfile.TemporaryFile() as log, tempfile.TemporaryDirectory() as tmp:
        subprocess.run(['tinymist', 'compile', '--save-lock', '--root', '.',
                        '--ignore-system-fonts',
                        '--input', 'stage=' + config['stage'],
                        '--font-path', 'assets/fonts', 'content/main.typ',
                        str(Path(tmp) / 'book.pdf')], cwd=root, check=True,
                       stdout=subprocess.DEVNULL, stderr=log)
        process = subprocess.Popen(['tinymist', 'lsp'], cwd=root.parent,
                                   stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                   stderr=log)
        inbox = queue.Queue()
        events = []
        serial = 0

        def receive():
            while True:
                headers = {}
                while line := process.stdout.readline():
                    if line == b'\r\n':
                        break
                    k, v = line.decode().split(':', 1)
                    headers[k.lower()] = v.strip()
                if not headers:
                    return
                inbox.put(json.loads(process.stdout.read(
                    int(headers['content-length']))))

        threading.Thread(target=receive, daemon=True).start()

        def send(method, params, request=True):
            nonlocal serial
            serial += 1
            message = {'jsonrpc': '2.0', 'method': method, 'params': params}
            if request:
                message['id'] = serial
            data = json.dumps(message).encode()
            process.stdin.write(f'Content-Length: {len(data)}\r\n\r\n'.encode()
                                + data)
            process.stdin.flush()
            if request:
                while True:
                    reply = inbox.get(timeout=60)
                    if reply.get('id') == serial:
                        assert 'error' not in reply, reply
                        return reply.get('result')
                    events.append(reply)

        opened = set()

        def open_document(path):
            if path in opened:
                return
            send('textDocument/didOpen', {'textDocument': {
                'uri': path.as_uri(), 'languageId': 'typst', 'version': 1,
                'text': path.read_text()}}, request=False)
            opened.add(path)

        try:
            send('initialize', {
                'processId': os.getpid(), 'rootUri': root.as_uri(),
                'capabilities': {'textDocument': {
                    'definition': {'linkSupport': True}}},
                'initializationOptions': {
                    'rootPath': str(root), 'compileStatus': 'enable',
                    'fontPaths': [str(root / 'assets/fonts')],
                    'systemFonts': False,
                    'projectResolution': 'lockDatabase'}})
            send('initialized', {}, request=False)
            first = cases[0][0]
            open_document(first)
            send('workspace/executeCommand', {
                'command': 'tinymist.focusMain', 'arguments': [str(first)]})
            while True:
                event = events.pop(0) if events else inbox.get(timeout=60)
                if event.get('method') == 'tinymist/compileStatus':
                    assert event['params']['status'] != 'compileError', event
                    if event['params']['status'] == 'compileSuccess':
                        assert event['params']['path'] == '/content/main.typ', event
                        break
            # API entries may have no reference in the text yet. Probe each declared
            # entry through a virtual link without editing the book on disk.
            extra = sorted({m.group(1) for path in sources
                            for pattern in (r'\]\s+<(ref:[\w:.-]+)>',
                                            r'\b(?:ref|link)\s*\(\s*<([\w:.-]+)>')
                            for m in re.finditer(pattern, path.read_text())} - seen)
            if extra:
                main = root / 'content/main.typ'
                open_document(main)
                modified = main.read_text() + '\n#show ref: it => link(it.target)[.]\n'
                for label in extra:
                    offset = len(modified) + 2
                    modified += '@' + label + '\n'
                    cases.append((main, label, offset))
                send('textDocument/didChange', {
                    'textDocument': {'uri': main.as_uri(), 'version': 2},
                    'contentChanges': [{'text': modified}]}, request=False)
                while True:
                    event = inbox.get(timeout=60)
                    if event.get('method') == 'tinymist/compileStatus':
                        assert event['params']['status'] != 'compileError', event
                        if event['params']['status'] == 'compileSuccess':
                            break
            else:
                modified = None
            failures = []
            cross_file = 0
            for path, label, offset in cases:
                open_document(path)
                result = send('textDocument/definition', {
                    'textDocument': {'uri': path.as_uri()},
                    'position': position(modified if modified is not None and path == main
                                         else path.read_text(), offset)})
                if not result or len(result) != 1:
                    failures.append((str(path.relative_to(root)), label, result))
                    continue
                target = result[0]
                destination = Path(unquote(urlparse(target['targetUri']).path))
                region = target['targetSelectionRange']
                if region['start']['line'] != region['end']['line']:
                    failures.append((label, 'multi-line selection', target))
                    continue
                lines = destination.read_text().splitlines()
                if region['start']['line'] >= len(lines):
                    failures.append((label, 'jumped to virtual reference', target))
                    continue
                line = lines[region['start']['line']]
                encoded = line.encode('utf-16-le')
                selected = encoded[2 * region['start']['character']:
                                   2 * region['end']['character']].decode('utf-16-le')
                if selected != '<' + label + '>':
                    failures.append((label, str(destination.relative_to(root)), selected))
                cross_file += destination != path
            assert not failures, json.dumps(failures[:12], ensure_ascii=False, indent=2)
            path, label, offset = cases[0]
            text = path.read_text()
            # Completion is requested in real markup, replacing one @reference.
            item = next(((p, l, o) for p, l, o in cases
                         if p.read_text()[o-2:o-1] == '@'), None)
            if item:
                path, label, offset = item
                original = path.read_text()
                start = offset - 2
                for version, prefix in enumerate(('@', '@'+label.split(':')[0]+':'), 2):
                    probe = original + '\n#let navigation-completion = ['
                    start = len(probe)
                    modified = probe + prefix + ']\n'
                    send('textDocument/didChange', {
                        'textDocument': {'uri': path.as_uri(), 'version': version},
                        'contentChanges': [{'text': modified}]}, request=False)
                    reply = send('textDocument/completion', {
                        'textDocument': {'uri': path.as_uri()},
                        'position': position(modified, start+len(prefix)),
                        'context': {'triggerKind': 1}})
                    items = reply.get('items', []) if isinstance(reply, dict) else reply
                    assert any(i['label'] == label for i in items or []), prefix
            send('shutdown', None)
            send('exit', None, request=False)
            process.wait(timeout=10)
            print(f'{root.name}: {len(cases)} exact label destinations '
                  f'({cross_file} cross-file); automatic main and completion OK')
        finally:
            if process.poll() is None:
                process.kill()
                process.wait(timeout=10)
            if saved is not None:
                lock.write_bytes(saved)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('project', nargs='?', type=Path,
                        default=Path(__file__).absolute().parents[1])
    check(parser.parse_args().project.resolve())
