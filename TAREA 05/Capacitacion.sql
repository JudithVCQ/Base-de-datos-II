CREATE OR REPLACE PACKAGE cap_pkg AS
  FUNCTION horas_capacitacion_total(p_emp_id IN NUMBER) RETURN NUMBER;
  PROCEDURE listado_capacitaciones_empleados(rc OUT SYS_REFCURSOR);
  PROCEDURE detalle_capacitaciones_de(p_emp_id IN NUMBER, rc OUT SYS_REFCURSOR);
END cap_pkg;
/
CREATE OR REPLACE PACKAGE BODY cap_pkg AS
  FUNCTION horas_capacitacion_total(p_emp_id IN NUMBER) RETURN NUMBER IS v NUMBER;
  BEGIN
    SELECT NVL(SUM(c.horas),0) INTO v
    FROM empleadocapacitacion ec JOIN capacitacion c USING(cap_id)
    WHERE ec.employee_id=p_emp_id;
    RETURN v;
  END;

  PROCEDURE listado_capacitaciones_empleados(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT e.employee_id,
             e.last_name||', '||e.first_name AS empleado,
             cap_pkg.horas_capacitacion_total(e.employee_id) AS horas_cap
      FROM employees e
      ORDER BY horas_cap DESC, empleado;
  END;

  PROCEDURE detalle_capacitaciones_de(p_emp_id IN NUMBER, rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT c.cap_id, c.nombre, c.horas, c.descripcion
      FROM empleadocapacitacion ec
      JOIN capacitacion c ON c.cap_id=ec.cap_id
      WHERE ec.employee_id=p_emp_id
      ORDER BY c.cap_id;
  END;
END cap_pkg;
/
-- Pruebas
VAR rc REFCURSOR
EXEC cap_pkg.listado_capacitaciones_empleados(:rc)
PRINT rc
EXEC cap_pkg.detalle_capacitaciones_de(100, :rc)
PRINT rc
SELECT cap_pkg.horas_capacitacion_total(100) AS horas_cap_100 FROM dual;
