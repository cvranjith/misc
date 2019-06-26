DECLARE
	l_gl		GLTMS_GLMASTER.gl_code%TYPE;
	l_lvl		NUMBER;
	l_leaf		GLTMS_GLMASTER.leaf%TYPE;
	l_last_leaf	GLTMS_GLMASTER.leaf%TYPE := 'N';
	CURSOR	C1
	IS	SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = '0'
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C2
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C3
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C4
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C5
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C6
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	CURSOR	C7
	IS
		SELECT	GL_CODE, LEAF
		FROM	GLTMS_GLMASTER
		WHERE	PARENT_GL = l_gl
		ORDER BY CATEGORY,GL_CODE;
	l_num	NUMBER;

	PROCEDURE pr_ins
	IS
		l_rowcount	INTEGER;
	BEGIN
		l_num := l_num+1;
		INSERT INTO GLTB_TREE
			(
			gl_code,
			lvl,
			rnum
			)
		VALUES
			(
			l_gl,
			l_lvl,
			l_num
			);
	END;
BEGIN
	l_num :=0;
	DELETE	GLTB_TREE;
	FOR x1 IN c1
	LOOP
		l_gl := x1.gl_code;
		l_lvl := 1;
		l_leaf := x1.leaf;
		pr_ins;
		FOR x2 IN c2
		LOOP
			l_gl := x2.gl_code;
			l_lvl := 2;
			l_leaf := x2.leaf;
			pr_ins;
			FOR x3 IN c3
			LOOP
				l_gl := x3.gl_code;
				l_lvl := 3;
				l_leaf := x3.leaf;
				pr_ins;
				FOR x4 IN c4
				LOOP
					l_gl := x4.gl_code;
					l_lvl := 4;
					l_leaf := x4.leaf;
					pr_ins;
					FOR x5 IN c5
					LOOP
						l_gl := x5.gl_code;
						l_lvl := 5;
						l_leaf := x5.leaf;
						pr_ins;
						FOR x6 IN c6
						LOOP
							l_gl := x6.gl_code;
							l_lvl := 6;
							l_leaf := x6.leaf;
							pr_ins;
							FOR x7 IN c7
							LOOP
								l_gl := x7.gl_code;
								l_lvl := 7;
								l_leaf := x7.leaf;
								pr_ins;
							END LOOP;
						END LOOP;
					END LOOP;
				END LOOP;
			END LOOP;
		END LOOP;
	END LOOP;
END;
/
