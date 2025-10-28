BEGIN
  -- Incrementar 8% salarios en dept 100
  UPDATE employees
  SET salary = salary * 1.08
  WHERE department_id = 100;
  SAVEPOINT s1;

  -- Incrementar 5% salarios en dept 80
  UPDATE employees
  SET salary = salary * 1.05
  WHERE department_id = 80;
  SAVEPOINT s2;

  -- Eliminar empleados del dept 50
  DELETE FROM employees
  WHERE department_id = 50;

  -- Revertir hasta el SAVEPOINT s2
  ROLLBACK TO s2;

  COMMIT;
END;
/
----------------------------------------------------------
-- Preguntas y respuestas
----------------------------------------------------------
-- a) ¿Qué modificaciones se conservaron?
--    Los aumentos del 8% (dept 100) y 5% (dept 80).
--
-- b) ¿Qué pasó con las filas eliminadas?
--    Se restauraron gracias al ROLLBACK al savepoint s2.
--
-- c) ¿Cómo verificar los efectos del commit?
--    En la misma sesión:
--      SELECT department_id, COUNT(*), SUM(salary)
--      FROM employees
--      GROUP BY department_id;
--    En otra sesión, los cambios se reflejan solo después del COMMIT.