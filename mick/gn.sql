SET HEAD OFF FEED OFF
SELECT	'Global names parameter IS - '||value||' 
Global name IS            - '||GLOBAL_NAME
FROM	GLOBAL_NAME A,
	V$PARAMETER B
WHERE	B.NAME = 'global_names'
/
SET HEAD ON FEED ON
