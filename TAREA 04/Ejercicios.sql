
CREATE OR REPLACE PACKAGE pkg_sp AS
  c_lb_to_gr CONSTANT NUMBER := 453.59237; --libras a gramos

  -- 4.1.1
  PROCEDURE pr_partes_no_paris_mayor10(rc OUT SYS_REFCURSOR);

  -- 4.1.2
  PROCEDURE pr_partes_peso_gramos(rc OUT SYS_REFCURSOR);

  -- 4.1.3
  PROCEDURE pr_proveedores_detalle(rc OUT SYS_REFCURSOR);

  -- 4.1.4
  PROCEDURE pr_colocalizados_sp(rc OUT SYS_REFCURSOR);

  -- 4.1.5
  PROCEDURE pr_pares_ciudades(rc OUT SYS_REFCURSOR);

  -- 4.1.6
  PROCEDURE pr_pares_proveedores_coloc(rc OUT SYS_REFCURSOR);

  -- 4.1.7
  FUNCTION fn_total_proveedores RETURN NUMBER;

  -- 4.1.8
  PROCEDURE pr_min_max_p2(p_min OUT NUMBER, p_max OUT NUMBER);

  -- 4.1.9
  PROCEDURE pr_total_por_parte(rc OUT SYS_REFCURSOR);

  -- 4.1.10
  PROCEDURE pr_partes_mas_de_un_prov(rc OUT SYS_REFCURSOR);

  -- 4.1.11
  PROCEDURE pr_proveedores_de_p2(rc OUT SYS_REFCURSOR);

  -- 4.1.12
  PROCEDURE pr_proveedores_que_abastecen_algo(rc OUT SYS_REFCURSOR);

  -- 4.1.13
  PROCEDURE pr_proveedores_status_menor_max(rc OUT SYS_REFCURSOR);

  -- 4.1.14
  PROCEDURE pr_proveedores_de_p2_exists(rc OUT SYS_REFCURSOR);

  -- 4.1.15
  PROCEDURE pr_proveedores_que_no_abastecen_p2(rc OUT SYS_REFCURSOR);

  -- 4.1.16
  PROCEDURE pr_proveedores_que_abastecen_todas(rc OUT SYS_REFCURSOR);

  -- 4.1.17
  PROCEDURE pr_partes_peso_gt16_o_s2(rc OUT SYS_REFCURSOR);
END pkg_sp;
/

CREATE OR REPLACE PACKAGE BODY pkg_sp AS

  -- 4.1.1
  PROCEDURE pr_partes_no_paris_mayor10(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT p#, pname, color, city
      FROM P
      WHERE city <> 'Paris' AND weight > 10;
  END;

  -- 4.1.2
  PROCEDURE pr_partes_peso_gramos(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      'SELECT p#, ROUND(weight * :k, 2) AS weight_grams FROM P'
      USING c_lb_to_gr;
  END;

  -- 4.1.3
  PROCEDURE pr_proveedores_detalle(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT * FROM S;
  END;

  -- 4.1.4
  PROCEDURE pr_colocalizados_sp(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT s.s#, p.p#, s.city
      FROM S s
      JOIN P p ON s.city = p.city;
  END;

  -- 4.1.5
  PROCEDURE pr_pares_ciudades(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT DISTINCT s.city AS city_supplier, p.city AS city_part
      FROM SP sp
      JOIN S s ON s.s# = sp.s#
      JOIN P p ON p.p# = sp.p#;
  END;

  -- 4.1.6
  PROCEDURE pr_pares_proveedores_coloc(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT a.s# AS s1, b.s# AS s2, a.city
      FROM S a
      JOIN S b ON a.city = b.city AND a.s# < b.s#;
  END;

  -- 4.1.7
  FUNCTION fn_total_proveedores RETURN NUMBER IS
    v NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v FROM S;
    RETURN v;
  END;

  -- 4.1.8
  PROCEDURE pr_min_max_p2(p_min OUT NUMBER, p_max OUT NUMBER) IS
  BEGIN
    SELECT MIN(qty), MAX(qty)
      INTO p_min, p_max
      FROM SP
     WHERE p# = 'P2';
  END;

  -- 4.1.9
  PROCEDURE pr_total_por_parte(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT p#, SUM(qty) AS total_qty
      FROM SP
      GROUP BY p#;
  END;

  -- 4.1.10
  PROCEDURE pr_partes_mas_de_un_prov(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT p#
      FROM SP
      GROUP BY p#
      HAVING COUNT(DISTINCT s#) > 1;
  END;

  -- 4.1.11
  PROCEDURE pr_proveedores_de_p2(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT DISTINCT s.sname
      FROM S s
      JOIN SP sp ON s.s# = sp.s#
      WHERE sp.p# = 'P2';
  END;

  -- 4.1.12
  PROCEDURE pr_proveedores_que_abastecen_algo(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT DISTINCT s.sname
      FROM S s
      WHERE EXISTS (SELECT 1 FROM SP sp WHERE sp.s# = s.s#);
  END;

  -- 4.1.13
  PROCEDURE pr_proveedores_status_menor_max(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT s#
      FROM S
      WHERE status < (SELECT MAX(status) FROM S);
  END;

  -- 4.1.14
  PROCEDURE pr_proveedores_de_p2_exists(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT sname
      FROM S s
      WHERE EXISTS (
        SELECT 1 FROM SP sp
        WHERE sp.s# = s.s# AND sp.p# = 'P2'
      );
  END;

  -- 4.1.15
  PROCEDURE pr_proveedores_que_no_abastecen_p2(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT sname
      FROM S s
      WHERE NOT EXISTS (
        SELECT 1 FROM SP sp
        WHERE sp.s# = s.s# AND sp.p# = 'P2'
      );
  END;

  -- 4.1.16
  PROCEDURE pr_proveedores_que_abastecen_todas(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT s.sname
      FROM S s
      WHERE NOT EXISTS (
        SELECT 1
        FROM P p
        WHERE NOT EXISTS (
          SELECT 1 FROM SP sp
          WHERE sp.s# = s.s# AND sp.p# = p.p#
        )
      );
  END;

  -- 4.1.17
  PROCEDURE pr_partes_peso_gt16_o_s2(rc OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN rc FOR
      SELECT DISTINCT p.p#
      FROM P p
      LEFT JOIN SP sp ON sp.p# = p.p#
      WHERE p.weight > 16 OR sp.s# = 'S2';
  END;

END pkg_sp;
/

--Ejecutar

SET SERVEROUTPUT ON
VAR rc REFCURSOR

-- 4.1.1
EXEC pkg_sp.pr_partes_no_paris_mayor10(:rc);
PRINT rc;

-- 4.1.2
EXEC pkg_sp.pr_partes_peso_gramos(:rc);
PRINT rc;

-- 4.1.3
EXEC pkg_sp.pr_proveedores_detalle(:rc);
PRINT rc;

-- 4.1.4
EXEC pkg_sp.pr_colocalizados_sp(:rc);
PRINT rc;

-- 4.1.5
EXEC pkg_sp.pr_pares_ciudades(:rc);
PRINT rc;

-- 4.1.6
EXEC pkg_sp.pr_pares_proveedores_coloc(:rc);
PRINT rc;

-- 4.1.7
SELECT pkg_sp.fn_total_proveedores AS total_proveedores FROM dual;

-- 4.1.8
VAR vmin NUMBER;
VAR vmax NUMBER;
EXEC pkg_sp.pr_min_max_p2(:vmin, :vmax);
PRINT vmin;
PRINT vmax;

-- 4.1.9
EXEC pkg_sp.pr_total_por_parte(:rc);
PRINT rc;

-- 4.1.10
EXEC pkg_sp.pr_partes_mas_de_un_prov(:rc);
PRINT rc;

-- 4.1.11
EXEC pkg_sp.pr_proveedores_de_p2(:rc);
PRINT rc;

-- 4.1.12
EXEC pkg_sp.pr_proveedores_que_abastecen_algo(:rc);
PRINT rc;

-- 4.1.13
EXEC pkg_sp.pr_proveedores_status_menor_max(:rc);
PRINT rc;

-- 4.1.14
EXEC pkg_sp.pr_proveedores_de_p2_exists(:rc);
PRINT rc;

-- 4.1.15
EXEC pkg_sp.pr_proveedores_que_no_abastecen_p2(:rc);
PRINT rc;

-- 4.1.16
EXEC pkg_sp.pr_proveedores_que_abastecen_todas(:rc);
PRINT rc;

-- 4.1.17
EXEC pkg_sp.pr_partes_peso_gt16_o_s2(:rc);
PRINT rc;
