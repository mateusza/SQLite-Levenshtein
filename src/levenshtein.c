#include <sqlite3ext.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>

#include "config.h"

#define LEVENSHTEIN_MAX_STRLEN 1024
// O(n*m) !!!

SQLITE_EXTENSION_INIT1

int levenshtein_distance_fast(char*, char*);

static void levenFunc( context, argc, argv )
	sqlite3_context *context;
	int argc;
	sqlite3_value **argv;
{
	int result;

	if ( sqlite3_value_type( argv[0] ) == SQLITE_NULL || sqlite3_value_type( argv[1] ) == SQLITE_NULL ){
		sqlite3_result_null( context );
		return;
	}

	result = levenshtein_distance_fast(
		(char*) sqlite3_value_text( argv[0] ),
		(char*) sqlite3_value_text( argv[1] )
	);

	if ( result == -1 ){
		// one argument too long
		sqlite3_result_null( context );
                return;
	}

	sqlite3_result_int( context, result );
}

int sqlite3_extension_init(
	sqlite3 *db,
	char **pzErrMsg,
	const sqlite3_api_routines *pApi
){
	SQLITE_EXTENSION_INIT2(pApi)
	sqlite3_create_function(db, "levenshtein", 2, SQLITE_ANY, 0, levenFunc, 0, 0);
	return 0;
}


#define MIN3(a, b, c) ((a) < (b) ? ((a) < (c) ? (a) : (c)) : ((b) < (c) ? (b) : (c)))

int levenshtein_distance_fast(char *s1, char *s2) {
	unsigned int s1len, s2len, x, y, lastdiag, olddiag;
	s1len = strlen(s1);
	s2len = strlen(s2);

	if (s1len == 0 || s2len == 0) {
		return s1len > s2len ? s1len : s2len;
	}
	unsigned int* column = malloc(sizeof(unsigned int) * (s1len+1));

	if (s1len > LEVENSHTEIN_MAX_STRLEN || s2len > LEVENSHTEIN_MAX_STRLEN) {
		return -1;
	}

	for (y = 1; y <= s1len; y++)
		column[y] = y;

	for (x = 1; x <= s2len; x++) {
		column[0] = x;
		for (y = 1, lastdiag = x-1; y <= s1len; y++) {
			olddiag = column[y];
			column[y] = MIN3(column[y] + 1, column[y-1] + 1, lastdiag + (s1[y-1] == s2[x-1] ? 0 : 1));
			lastdiag = olddiag;
		}
	}
	unsigned int result = column[s1len];
	free(column);
	return result;
}
