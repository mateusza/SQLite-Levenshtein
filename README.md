SQLite Levenshtein Distance extension
=====================================

Author: Mateusz Adamowski

License: public domain


Build:
------
### Linux, Unix etc:

    $ ./configure
    $ make

#### Obtaining dependencies
##### Debian, Ubuntu

    # apt-get install libsqlite3-dev

##### others

Get source of SQLite from [http://www.sqlite.org](http://www.sqlite.org)

Usage:
------

### SQLite commandline interface

    sqlite> .load ./liblevenshtein.so
    sqlite> SELECT LEVENSHTEIN( 'This is not correct', 'This is correct' );
    4
    sqlite> SELECT LEVENSHTEIN( NULL, 'aaa' ) IS NULL;
    1

### SQLite library calls

    sqlite_exec( "SELECT LOAD_EXTENSION('/path/liblevenshtein.so')" );

