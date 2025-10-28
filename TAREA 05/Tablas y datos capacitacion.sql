CREATE TABLE capacitacion (
  cap_id      NUMBER PRIMARY KEY,
  nombre      VARCHAR2(100),
  horas       NUMBER(5,2),
  descripcion VARCHAR2(200)
);
/
CREATE TABLE empleadocapacitacion (
  employee_id NUMBER(6) REFERENCES employees(employee_id),
  cap_id      NUMBER     REFERENCES capacitacion(cap_id),
  CONSTRAINT empcap_pk PRIMARY KEY (employee_id, cap_id)
);
/

-- Datos de ejemplo
INSERT INTO capacitacion VALUES (1,'Oracle Básico',6,'Intro DB');
INSERT INTO capacitacion VALUES (2,'SQL Avanzado',8,'Consultas');
INSERT INTO capacitacion VALUES (3,'PL/SQL',10,'Subprogramas');
INSERT INTO empleadocapacitacion VALUES (100,1);
INSERT INTO empleadocapacitacion VALUES (100,2);
INSERT INTO empleadocapacitacion VALUES (101,3);
COMMIT;
/