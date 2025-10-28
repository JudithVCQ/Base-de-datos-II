CREATE OR REPLACE TRIGGER trg_validar_asistencia
BEFORE INSERT OR UPDATE ON asistencia_empleado
FOR EACH ROW
DECLARE
  v_dy_es VARCHAR2(3);
  v_hi    DATE;
  v_hf    DATE;
BEGIN
  :NEW.dia_semana := UPPER(TRIM(:NEW.dia_semana));
  v_dy_es := TO_CHAR(:NEW.fecha_real,'DY','NLS_DATE_LANGUAGE=SPANISH');

  IF v_dy_es <> :NEW.dia_semana THEN
    RAISE_APPLICATION_ERROR(-20001,'El día de la semana no coincide con la fecha real.');
  END IF;

  BEGIN
    SELECT h.hora_inicio, h.hora_termino
      INTO v_hi, v_hf
      FROM empleado_horario eh
      JOIN horario h ON h.dia_semana=eh.dia_semana AND h.turno=eh.turno
     WHERE eh.employee_id=:NEW.employee_id AND eh.dia_semana=v_dy_es
       AND ROWNUM=1;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20004,'No existe horario registrado para este empleado y día.');
  END;

  IF TO_CHAR(:NEW.hora_inicio_real,'HH24:MI') <> TO_CHAR(v_hi,'HH24:MI') THEN
    RAISE_APPLICATION_ERROR(-20002,'La hora de inicio real no coincide con el horario asignado.');
  END IF;
  IF TO_CHAR(:NEW.hora_termino_real,'HH24:MI') <> TO_CHAR(v_hf,'HH24:MI') THEN
    RAISE_APPLICATION_ERROR(-20003,'La hora de término real no coincide con el horario asignado.');
  END IF;
END;
/
