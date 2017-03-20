.load ../levenshtein.sqlext
.mode column
.width 50 10
.head on

SELECT
	desc || ':' AS description,
	CASE
		WHEN pass IS NULL THEN 'error'
		WHEN pass = 1 THEN 'passed'
		WHEN pass = 0 THEN 'failed'
	END AS result
FROM (
SELECT
	'Empty strings 0 distance' AS desc,
	LEVENSHTEIN( '','' ) == 0 AS pass
UNION ALL
SELECT
	'''Asia'' and ''Kasia'' -> 2',
	LEVENSHTEIN( 'Asia', 'Kasia' ) == 2
UNION ALL
SELECT
	'NULL handled correctly (1st)',
	LEVENSHTEIN( NULL, 'any' ) IS NULL
UNION ALL
SELECT
	'NULL handled correctly (2nd)',
	LEVENSHTEIN( 'any', NULL ) IS NULL
UNION ALL
SELECT
	'NULL handled correctly (both)',
	LEVENSHTEIN( NULL, NULL ) IS NULL
UNION ALL
SELECT
	'Maximum length strings',
	LEVENSHTEIN( HEX(RANDOMBLOB(512)), HEX(RANDOMBLOB(512)) ) > 0
UNION ALL
SELECT
	'Too long strings',
	LEVENSHTEIN( HEX(RANDOMBLOB(513)), 'any' ) IS NULL
UNION ALL
SELECT	
	'Random text and zero length text',
	LEVENSHTEIN( HEX(RANDOMBLOB(10)), '' ) = 20
UNION ALL
SELECT	
	'Random text and zero length text',
	LEVENSHTEIN( '', HEX(RANDOMBLOB(10)) ) = 20
UNION ALL
SELECT
	'4096 tests',
	( SELECT
		count(leven)
		FROM
		( SELECT
			LEVENSHTEIN( HEX( RANDOMBLOB( 512 ) ), HEX( RANDOMBLOB( 512 ) ) ) AS leven
		  FROM
			(Values (0),(1),(2),(3),(4),(5),(6),(7)) AS gen0
		  CROSS JOIN
			(Values (0),(1),(2),(3),(4),(5),(6),(7)) AS gen1
		  CROSS JOIN
			(Values (0),(1),(2),(3),(4),(5),(6),(7)) AS gen2
		  CROSS JOIN
			(Values (0),(1),(2),(3),(4),(5),(6),(7)) AS gen3
		)
	) = 4096
) AS tests;

