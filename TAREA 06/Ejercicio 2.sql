-- Sesión 1
UPDATE employees
SET salary = salary + 500
WHERE employee_id = 103;
-- No ejecutar COMMIT aún

-- Sesión 2
UPDATE employees
SET salary = salary + 1000
WHERE employee_id = 103;
-- Esta sesión quedará bloqueada esperando a la sesión 1

-- Sesión 1
ROLLBACK;

----------------------------------------------------------
-- Vistas útiles para analizar bloqueos:
----------------------------------------------------------
SELECT * FROM v$locked_object;
SELECT * FROM v$session;
SELECT * FROM v$lock;

----------------------------------------------------------
-- Preguntas y respuestas
----------------------------------------------------------
-- a) ¿Por qué la segunda sesión quedó bloqueada?
--    Porque la primera sesión mantenía un bloqueo de fila
--    sin confirmar los cambios con COMMIT o ROLLBACK.
--
-- b) ¿Qué comando libera los bloqueos?
--    COMMIT o ROLLBACK en la sesión que bloquea.
--
-- c) ¿Qué vistas ayudan a identificar bloqueos?
--    v$locked_object, v$lock , v$session y dba_waiters.