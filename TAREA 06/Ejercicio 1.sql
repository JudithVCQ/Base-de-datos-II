BEGIN
  -- Incrementar en 10% los salarios del departamento 90
  UPDATE employees
  SET salary = salary * 1.10
  WHERE department_id = 90;

  SAVEPOINT sp_dept90;

  -- Incrementar en 5% los salarios del departamento 60
  UPDATE employees
  SET salary = salary * 1.05
  WHERE department_id = 60;

  -- Revertir hasta el punto guardado
  ROLLBACK TO sp_dept90;

  COMMIT;
END;
/
----------------------------------------------------------
-- Preguntas y respuestas
----------------------------------------------------------
-- a) ¿Qué departamento mantuvo los cambios?
--    El departamento 90 conservó el aumento del 10%.
--
-- b) ¿Qué efecto tuvo el rollback parcial?
--    Se deshicieron las operaciones posteriores al savepoint.
--    El aumento del 5% al dept. 60 no se guardó.
--
-- c) ¿Qué pasaría con un rollback total sin savepoint?
--    Se revertiría toda la transacción hasta el último commit.