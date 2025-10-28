CREATE OR REPLACE PACKAGE pkg_313 AS
  PROCEDURE gastos_y_stats_por_region(rc OUT SYS_REFCURSOR);
END pkg_313;
/
CREATE OR REPLACE PACKAGE BODY pkg_313 AS
  PROCEDURE gastos_y_stats_por_region(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT r.region_name,
             SUM(e.salary) AS suma_salarios,
             COUNT(e.employee_id) AS cantidad_empleados,
             MIN(e.hire_date) AS fecha_mas_antigua
      FROM employees e
      JOIN departments d ON d.department_id=e.department_id
      JOIN locations  l ON l.location_id=d.location_id
      JOIN countries  c ON c.country_id=l.country_id
      JOIN regions    r ON r.region_id=c.region_id
      GROUP BY r.region_name
      ORDER BY r.region_name;
  END;
END pkg_313;
/
VAR rc REFCURSOR
EXEC pkg_313.gastos_y_stats_por_region(:rc)
PRINT rc
