CREATE OR REPLACE TRIGGER trg_restringe_entrada
BEFORE INSERT ON asistencia_empleado
FOR EACH ROW
DECLARE
  v_hi   DATE;
  v_hf   DATE;
  v_dyes VARCHAR2(3);
BEGIN
  :NEW.dia_semana := UPPER(TRIM(:NEW.dia_semana));
  v_dyes := TO_CHAR(:NEW.fecha_real,'DY','NLS_DATE_LANGUAGE=SPANISH');

  SELECT h.hora_inicio, h.hora_termino
    INTO v_hi, v_hf
    FROM empleado_horario eh
    JOIN horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
   WHERE eh.employee_id=:NEW.employee_id AND eh.dia_semana=v_dyes
     AND ROWNUM=1;

  IF :NEW.hora_inicio_real NOT BETWEEN (v_hi - 30/1440) AND (v_hi + 30/1440) THEN
    :NEW.estado := 'FALTA';
    :NEW.hora_inicio_real  := NULL;
    :NEW.hora_termino_real := NULL;
  END IF;
END;
/
