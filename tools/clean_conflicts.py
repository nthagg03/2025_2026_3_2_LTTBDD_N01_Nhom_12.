import os
import re
from pathlib import Path

root = Path(__file__).resolve().parent.parent
text_exts = {
    '.dart', '.yaml', '.yml', '.md', '.txt', '.gradle', '.kts', '.xml', '.plist',
    '.properties', '.swift', '.java', '.kt', '.cc', '.cpp', '.h', '.hpp', '.rc',
    '.gitignore', '.cmake', '.json', '.js', '.ts', '.scss', '.html', '.css', '.toml'
}
ignore_dirs = {'.git', '.dart_tool', 'build', 'coverage', '.idea'}

pattern = re.compile(r'<<<<<<< HEAD\s*(.*?)\s*=======\s*(.*?)\s*>>>>>>>.*', re.S)

count = 0
for path in root.rglob('*'):
    if not path.is_file():
        continue
    if any(part in ignore_dirs for part in path.parts):
        continue
    if path.name == '.DS_Store':
        continue
    ext = path.suffix.lower()
    if ext not in text_exts and path.name != '.gitignore':
        continue
    try:
        text = path.read_text(encoding='utf-8')
    except Exception:
        continue
    if '<<<<<<< HEAD' not in text:
        continue
    new_text = pattern.sub(r'\1', text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        count += 1

print(f'cleaned_files={count}')
