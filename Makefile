CC = gcc

levenshtein.sqlext: src/levenshtein.c
	$(CC) -shared -fPIC -Isqlite3 -o levenshtein.sqlext src/levenshtein.c
