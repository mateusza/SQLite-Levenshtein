SQLite Levenshtein extension
============================

Author: Mateusz Adamowski
License: public domain


Build:
------
### Linux, Unix etc:

    $ make

#### Obtaining missing header files
##### Debian, Ubuntu

    # apt-get install libsqlite3-dev

##### others

    Get source of SQLite [http://www.sqlite.org](http://www.sqlite.org)

### Windows

    C:\> gcc -s -O4 -I /path/to/sqlite/headers/ -shared -o levenshtein.dll levenshtein.c

[More info][win-build]


Usage:
------

### SQLite commandline interface

    sqlite> .load levenshtein.sqlext
    sqlite> SELECT LEVENSHTEIN( 'This is not correct', 'This is correct' );
    4
    sqlite> SELECT LEVENSHTEIN( NULL, 'aaa' ) IS NULL;
    1

### SQLite library calls

    sqlite_exec( "SELECT LOAD_EXTENSION('levenshtein.sqlext')" );

  [win-build]: http://stackoverflow.com/questions/14521922/compiling-sqlite-levenshtein-function-for-system-data-sqlite

