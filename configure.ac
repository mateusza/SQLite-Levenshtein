AC_INIT([sqlite-ext-levenshtein], [0.9], [mateusz+sqlite-levenshtein@adamowski.pl])
AM_INIT_AUTOMAKE([foreign -Wall -Werror])
AC_CONFIG_MACRO_DIR([m4])
LT_INIT
AC_PROG_CC
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile src/Makefile])
PKG_CHECK_MODULES([SQLITE], [sqlite3 >= 3.7.0])
AC_OUTPUT
