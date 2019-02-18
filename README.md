# binary-search

A command-line tool that searches text files using the [binary search algorithm](https://en.wikipedia.org/wiki/Binary_search_algorithm).

Useful when searching extremely large text files (e.g. multi-GB), such as the _Have I Been Pwned_ password [list](https://haveibeenpwned.com/Passwords) by Troy Hunt.

## Installation

Xcode 9 is required to build the binary.

```bash
$ git clone git@github.com:allewun/binary-search.git
$ cd binary-search
$ make # build and install binary at /usr/local/bin/binary-search
``` 

Or just use the [pre-compiled binary](https://github.com/allewun/binary-search/releases/latest).

## Usage

```
$ binary-search --help
Usage:

    $ binary-search <string> <file>

Arguments:

    string - The string to search for.
    file - The *sorted* file to search.
```

## Example

Find your password in the Pwned Passwords list:

```bash
$ binary-search "$(echo -n 'hello' | sha1sum | awk '{print toupper($1)}')" pwned-passwords-ordered-2.0.txt
AAF4C61DDCC5E8A2DABEDE0F3B482CD9AEA9434D:229926
```

## What's the point of this?

With a 29 GB _sorted_ list of 500 million SHA1 hashes, searching for a record using `grep` takes over 10 minutes because `grep` searches linearly through the file.

```
$ time grep FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160 pwned-passwords-ordered-2.0.txt
FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160:2
grep FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160   656.23s user 32.66s system 83% cpu 13:42.34 total
```

Using binary search cuts this down to an instant:

```
$ time binary-search FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160 pwned-passwords-ordered-2.0.txt
FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160:2
binary-search FFFFFFFEE791CBAC0F6305CAF0CEE06BBE131160   0.01s user 0.01s system 27% cpu 0.064 total
```

Cool.