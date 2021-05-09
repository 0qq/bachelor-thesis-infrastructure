#!/usr/bin/env python3

import os


def get_filepaths(suffix, directory):
    for dirpath, _, files in os.walk(directory):
        for filename in files:
            _, ext = os.path.splitext(filename)
            if ext == suffix:
                yield (os.path.join(dirpath, filename))


def append_filepath(filepath):
    expected_first_line = f'# {filepath}\n'

    with open(filepath, 'r') as f:
        if f.readline() == expected_first_line:
            return
        f.seek(0)
        orig_content = f.read()

    with open(filepath, 'w') as f:
        f.write(expected_first_line + '\n' + orig_content)


def main():
    filepaths = get_filepaths(".json", "modules")
    for filepath in filepaths:
        append_filepath(filepath)


if __name__ == '__main__':
    main()
