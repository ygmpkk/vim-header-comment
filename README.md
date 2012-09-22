Header Comments in Vim
----------------------

A simple vim-plugin to generate header comments
for Author, Copyright and Creation Date.

Example:

    %%
    %% Copyright (C) 2012 Hapida AB
    %%
    %% File:    test.erl
    %% Author:  Björn-Egil Dahlberg
    %% Created: 2012-09-22
    %%


Author and Copyright holder is set in your .vimrc

Example:

    " Define headers for copyright and author
    let g:header_comment_author = "Björn-Egil Dahlberg"
    let g:header_comment_copyright = "Hapida AB"

Note:
This plugin was mainly created to get an idea on how vim plugins works =)
