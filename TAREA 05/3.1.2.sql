CREATE OR REPLACE PACKAGE pkg_312 AS
  PROCEDURE resumen_contrataciones_por_mes(rc OUT SYS_REFCURSOR);
  FUNCTION  total_meses_contrataciones RETURN PLS_INTEGER;
END pkg_312;
/
CREATE OR REPLACE PACKAGE BODY pkg_312 AS
  PROCEDURE resumen_contrataciones_por_mes(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT TO_CHAR(TRUNC(hire_date,'MM'),'Month','NLS_DATE_LANGUAGE=ENGLISH') AS mes,
             COUNT(*) AS contrataciones
      FROM employees
      GROUP BY TRUNC(hire_date,'MM')
      ORDER BY TRUNC(hire_date,'MM');
  END;
  FUNCTION total_meses_contrataciones RETURN PLS_INTEGER IS v PLS_INTEGER;
  BEGIN
    SELECT COUNT(DISTINCT TRUNC(hire_date,'MM')) INTO v FROM employees;
    RETURN v;
  END;
END pkg_312;
/
VAR rc REFCURSOR
EXEC pkg_312.resumen_contrataciones_por_mes(:rc)
PRINT rc
SELECT pkg_312.total_meses_contrataciones AS total_meses FROM dual;
