#!/usr/bin/env python3

import os


def get_filepaths(suffix: str, directory: str) -> list[str]:
    filepaths = list()
    for dirpath, dirnames, files in os.walk(directory):
        for filename in files:
            if filename.endswith(f'.{suffix}'):
                filepaths.append(os.path.join(dirpath, filename))
    return filepaths


def append_filepath(filepath: str) -> bool:
    with open(filepath, 'r') as f:
        appended = f.readline() == f'# {filepath}\n'
        f.seek(0, 0)
        orig_content = f.read()
    if not appended:
        with open(filepath, 'w') as f:
            f.write(f'# {filepath}\n\n{orig_content}')
    return appended


def main():
    filepaths = get_filepaths("tf", "modules")
    for filepath in filepaths:
        append_filepath(filepath)


if __name__ == '__main__':
    main()
