DECLARE
  v_old_dept   NUMBER;
  v_new_dept   NUMBER := 110;
  v_emp_id     NUMBER := 104;
  v_job_id     VARCHAR2(10);
  v_start_date DATE;
BEGIN
  -- Obtener información actual del empleado
  SELECT department_id, job_id, hire_date
  INTO v_old_dept, v_job_id, v_start_date
  FROM employees
  WHERE employee_id = v_emp_id;

  -- Cambiar de departamento al empleado
  UPDATE employees
  SET department_id = v_new_dept
  WHERE employee_id = v_emp_id;

  -- Registrar cambio en job_history
  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
  VALUES (v_emp_id, v_start_date, SYSDATE, v_job_id, v_old_dept);

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error durante la transferencia: ' || SQLERRM);
END;
/
----------------------------------------------------------
-- Preguntas y respuestas
----------------------------------------------------------
-- a) ¿Por qué se requiere atomicidad?
--    Para asegurar que el cambio de departamento y la inserción
--    en job_history se ejecuten como una sola unidad de trabajo.
--
-- b) ¿Qué ocurre si hay un error antes del COMMIT?
--    Se ejecuta el ROLLBACK y no se conserva ningún cambio.
--
-- c) ¿Cómo se garantiza la integridad de los datos?
--    Mediante claves foráneas y el control transaccional que
--    asegura la coherencia entre employees y job_history.