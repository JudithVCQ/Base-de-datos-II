CREATE OR REPLACE PACKAGE pkg_316 AS
  FUNCTION horas_falta(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER;
END pkg_316;
/
CREATE OR REPLACE PACKAGE BODY pkg_316 AS
  --horas esperadas = suma de horas por cada día programado del empleado
  FUNCTION horas_falta(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER IS
    v_esp NUMBER:=0; v_lab NUMBER;
  BEGIN
    SELECT NVL(SUM( (h.hora_termino - h.hora_inicio) * 24 ),0)
      INTO v_esp
      FROM empleado_horario eh
      JOIN horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
     WHERE eh.employee_id=p_emp_id;

    SELECT NVL(SUM( (hora_termino_real - hora_inicio_real) * 24 ),0)
      INTO v_lab
      FROM asistencia_empleado
     WHERE employee_id=p_emp_id
       AND EXTRACT(MONTH FROM fecha_real)=p_mes
       AND EXTRACT(YEAR  FROM fecha_real)=p_anio;

    RETURN GREATEST(v_esp - v_lab, 0);
  END;
END pkg_316;
/
SELECT pkg_316.horas_falta(100, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE)) AS horas_falta
FROM dual;
