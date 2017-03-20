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
			( SELECT 0 AS a0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 ) AS gen0
		  CROSS JOIN
			( SELECT 0 AS a1 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 ) AS gen1
		  CROSS JOIN
			( SELECT 0 AS a2 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 ) AS gen2
		  CROSS JOIN
			( SELECT 0 AS a3 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 ) AS gen3
		)
	) = 4096
) AS tests;

