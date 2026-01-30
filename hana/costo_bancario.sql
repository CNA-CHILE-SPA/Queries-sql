IF :object_type = '24'
AND :transaction_type = 'A' THEN DECLARE v_DocEntry INT := CAST(:list_of_cols_val_tab_del AS INT);

DECLARE v_DocCurr NVARCHAR(3);

DECLARE v_BkChg DECIMAL(19, 6) := 0;

DECLARE v_Threshold DECIMAL(19, 6) := 0;

/* 1) Obtener moneda y gasto bancario DEL PAGO que se está ingresando */
SELECT
  T0."DocCurr",
  IFNULL(T0."BcgSumSy", 0) INTO v_DocCurr,
  v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

/* 2) Definir umbral según DocCurr */
IF v_DocCurr = 'USD' THEN v_Threshold := 75;

SELECT
  IFNULL(T0."BcgSum", 0) INTO v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

ELSEIF v_DocCurr = 'CLP' THEN v_Threshold := 75000;

SELECT
  IFNULL(T0."BcgSumSy", 0) INTO v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

ELSE v_Threshold := 0;

v_BkChg := 0;

END IF;

/* 3) Validación */
IF v_Threshold > 0
AND v_BkChg > v_Threshold THEN error := 1;

error_message := 'Bloqueado: el gasto bancario ingresado (' || TO_NVARCHAR(ROUND(v_BkChg, 2)) || ' ' || v_DocCurr || ') excede el tope permitido de ' || TO_NVARCHAR(v_Threshold) || ' ' || v_DocCurr || '.';

END IF;

END IF;