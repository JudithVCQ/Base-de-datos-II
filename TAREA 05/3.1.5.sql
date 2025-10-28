CREATE OR REPLACE PACKAGE pkg_315 AS
  FUNCTION horas_laboradas(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER;
END pkg_315;
/
CREATE OR REPLACE PACKAGE BODY pkg_315 AS
  FUNCTION horas_laboradas(p_emp_id IN NUMBER, p_mes IN NUMBER, p_anio IN NUMBER) RETURN NUMBER IS v NUMBER;
  BEGIN
    SELECT NVL(SUM( (hora_termino_real - hora_inicio_real) * 24 ),0)
      INTO v
      FROM asistencia_empleado
     WHERE employee_id=p_emp_id
       AND EXTRACT(MONTH FROM fecha_real)=p_mes
       AND EXTRACT(YEAR  FROM fecha_real)=p_anio;
    RETURN v;
  END;
END pkg_315;
/
SELECT pkg_315.horas_laboradas(100, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE)) AS horas_lab
FROM dual;
