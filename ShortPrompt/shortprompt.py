#!/usr/bin/python
# -*- coding: utf-8 *-*
# vim: set fileencoding=utf-8:

COMMENT = """\
Create a terminal's prompt. It is shortened and colorized.

Just ad this into the .bashrc file:

export PS1 = python shortprompt.py $HOME 5 $(pwd)
"""


import sys
from os.path import normpath, basename, dirname, expandvars
from os import sep, environ


def trim_directory_name(dir_name, chars=5, end_chars=2):
    ndir = len(dir_name)
    if (ndir - 2) > chars:
        # dir_name = '{}..{}'.format(
        dir_name = '\[\e[1;31m\]{}\[\e[0;36m\]..\[\e[0;35m\]{}\[\e[1;31m\]'.format(
            dir_name[:(chars - end_chars)] if
            chars > end_chars else '',
            dir_name[(ndir - end_chars):] if
            chars > end_chars else
            dir_name[-chars:]
        )
    return dir_name


def make_path_name(path, n_chars=5, final_chars=2):
    '''
    Shorten PWD name
    '''
    path = normpath(path)
    short_names = []
    if path == sep:
        return sep
    while path != '/':
        if (path == expandvars('$HOME')):
            # Substitute $HOME with '~' if root is $HOME
            short_names.extend(['~'])
            break
        if (len(short_names) >= int(environ['PROMPT_DIRTRIM'])) and \
           (int(environ['PROMPT_DIRTRIM']) > 0):
            short_names.extend(['...'])
            break
        dir_name, path = basename(path), dirname(path)
        short_names.extend([sep + trim_directory_name(dir_name,
                                                      n_chars,
                                                      final_chars)])
    short_names.reverse()
    short_name = ''.join(short_names)
    if short_name[0:6] == '/home/':
        short_name = '~' + short_name[6:]
    return short_name


if __name__ == '__main__':
    # print(sys.argv)
    nchars = sys.argv[1]
    nchars_end = sys.argv[2]
    cur_dir = make_path_name(environ['PWD'],
                             int(nchars),
                             int(nchars_end))
    print(cur_dir)
