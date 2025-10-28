CREATE OR REPLACE PACKAGE pkg_317 AS
  FUNCTION horas_laboradas(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER;
  FUNCTION horas_falta    (p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER;
  PROCEDURE sueldos_del_mes(p_mes IN NUMBER, p_anio IN NUMBER, rc OUT SYS_REFCURSOR);
END pkg_317;
/
CREATE OR REPLACE PACKAGE BODY pkg_317 AS
  FUNCTION horas_laboradas(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER IS v NUMBER;
  BEGIN
    SELECT NVL(SUM( (hora_termino_real - hora_inicio_real) * 24 ),0)
      INTO v FROM asistencia_empleado
     WHERE employee_id=p_emp_id
       AND EXTRACT(MONTH FROM fecha_real)=p_mes
       AND EXTRACT(YEAR  FROM fecha_real)=p_anio;
    RETURN v;
  END;

  FUNCTION horas_falta(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER IS
    v_esp NUMBER:=0; v_lab NUMBER;
  BEGIN
    SELECT NVL(SUM( (h.hora_termino - h.hora_inicio) * 24 ),0)
      INTO v_esp
      FROM empleado_horario eh
      JOIN horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
     WHERE eh.employee_id=p_emp_id;

    v_lab := horas_laboradas(p_emp_id,p_mes,p_anio);
    RETURN GREATEST(v_esp - v_lab, 0);
  END;

  PROCEDURE sueldos_del_mes(p_mes IN NUMBER, p_anio IN NUMBER, rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT e.employee_id,
             e.first_name AS nombre,
             e.last_name  AS apellido,
             e.salary,
             pkg_317.horas_laboradas(e.employee_id,p_mes,p_anio) AS horas_lab,
             pkg_317.horas_falta    (e.employee_id,p_mes,p_anio) AS horas_falta,
             CASE
               WHEN (pkg_317.horas_laboradas(e.employee_id,p_mes,p_anio)
                   + pkg_317.horas_falta    (e.employee_id,p_mes,p_anio)) = 0
               THEN 0
               ELSE ROUND(
                 e.salary * pkg_317.horas_laboradas(e.employee_id,p_mes,p_anio)
                 /(pkg_317.horas_laboradas(e.employee_id,p_mes,p_anio)
                  + pkg_317.horas_falta(e.employee_id,p_mes,p_anio)),2)
             END AS sueldo_mes
      FROM employees e
      ORDER BY 4 DESC, 2, 3;
  END;
END pkg_317;
/
VAR rc REFCURSOR
EXEC pkg_317.sueldos_del_mes(EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE), :rc)
PRINT rc
