CREATE TABLE horario (
  dia_semana   VARCHAR2(3),
  turno        VARCHAR2(1),
  hora_inicio  DATE,
  hora_termino DATE,
  CONSTRAINT horario_pk PRIMARY KEY (dia_semana, turno)
);
/
CREATE TABLE empleado_horario (
  employee_id  NUMBER(6) REFERENCES employees(employee_id),
  dia_semana   VARCHAR2(3),
  turno        VARCHAR2(1),
  CONSTRAINT emp_hor_pk PRIMARY KEY (employee_id, dia_semana, turno),
  CONSTRAINT emp_hor_fk FOREIGN KEY (dia_semana, turno)
    REFERENCES horario(dia_semana, turno)
);
/
CREATE TABLE asistencia_empleado (
  employee_id       NUMBER(6) REFERENCES employees(employee_id),
  dia_semana        VARCHAR2(3),
  fecha_real        DATE,
  hora_inicio_real  DATE,
  hora_termino_real DATE,
  estado            VARCHAR2(10) DEFAULT 'ASIST',
  CONSTRAINT asis_pk PRIMARY KEY (employee_id, fecha_real)
);
/

-- Datos
INSERT INTO horario VALUES ('LUN','A', TRUNC(SYSDATE)+9/24,  TRUNC(SYSDATE)+18/24);
INSERT INTO horario VALUES ('MAR','A', TRUNC(SYSDATE)+9/24,  TRUNC(SYSDATE)+18/24);
INSERT INTO horario VALUES ('MIE','A', TRUNC(SYSDATE)+9/24,  TRUNC(SYSDATE)+18/24);
INSERT INTO horario VALUES ('JUE','A', TRUNC(SYSDATE)+9/24,  TRUNC(SYSDATE)+18/24);
INSERT INTO horario VALUES ('VIE','A', TRUNC(SYSDATE)+9/24,  TRUNC(SYSDATE)+18/24);

INSERT INTO empleado_horario VALUES (100,'LUN','A');
INSERT INTO empleado_horario VALUES (100,'MAR','A');
INSERT INTO empleado_horario VALUES (101,'LUN','A');
INSERT INTO empleado_horario VALUES (102,'MIE','A');

COMMIT;
/