CREATE OR REPLACE PACKAGE pkg_311 AS
  PROCEDURE top4_rotaciones(rc OUT SYS_REFCURSOR);
END pkg_311;
/
CREATE OR REPLACE PACKAGE BODY pkg_311 AS
  PROCEDURE top4_rotaciones(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT e.employee_id,
             e.last_name||', '||e.first_name AS empleado,
             NVL(j.cambios,0) AS cambios_puesto
      FROM employees e
      LEFT JOIN (SELECT employee_id, COUNT(*) cambios
                   FROM job_history GROUP BY employee_id) j
        ON j.employee_id=e.employee_id
      ORDER BY NVL(j.cambios,0) DESC, e.employee_id
      FETCH FIRST 4 ROWS ONLY;
  END;
END pkg_311;
/
VAR rc REFCURSOR
EXEC pkg_311.top4_rotaciones(:rc)
PRINT rc
