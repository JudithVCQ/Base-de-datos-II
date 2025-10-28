CREATE OR REPLACE PACKAGE pkg_314 AS
  FUNCTION tiempo_servicio_anios(p_emp_id IN NUMBER) RETURN NUMBER;
  FUNCTION meses_vacaciones(p_emp_id IN NUMBER) RETURN NUMBER;
END pkg_314;
/
CREATE OR REPLACE PACKAGE BODY pkg_314 AS
  FUNCTION tiempo_servicio_anios(p_emp_id IN NUMBER) RETURN NUMBER IS v NUMBER;
  BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE,hire_date)/12)
      INTO v FROM employees WHERE employee_id=p_emp_id;
    RETURN v;
  END;
  FUNCTION meses_vacaciones(p_emp_id IN NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN tiempo_servicio_anios(p_emp_id); -- 1 mes por año
  END;
END pkg_314;
/
SELECT employee_id,
       pkg_314.tiempo_servicio_anios(employee_id) AS anios,
       pkg_314.meses_vacaciones(employee_id)     AS meses_vac
FROM employees WHERE ROWNUM<=5;
