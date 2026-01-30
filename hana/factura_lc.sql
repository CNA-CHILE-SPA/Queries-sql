IF (:object_type = '13') -- AR Invoice
AND (:transaction_type = 'A') -- Add
AND (:error = 0) THEN DECLARE v_DocEntry INT := TO_INT(:list_of_cols_val_tab_del);

DECLARE v_BPL INT;

DECLARE v_CardCode NVARCHAR(20);

DECLARE v_Credit DECIMAL(19, 6) := 0;

-- Obtiene sucursal y socio
SELECT
  "BPLId",
  "CardCode" INTO v_BPL,
  v_CardCode
FROM
  "OINV"
WHERE
  "DocEntry" = v_DocEntry;

-- Resuelve la línea de crédito en una sola consulta, devolviendo 0 si no hay fila
SELECT
  COALESCE(
    CASE
      WHEN v_BPL = 1 THEN CAST(MAX("CreditLine") AS DECIMAL(19, 6))
      WHEN v_BPL = 2 THEN CAST(MAX("U_LC_FA") AS DECIMAL(19, 6))
      ELSE 0
    END,
    0
  ) INTO v_Credit
FROM
  "OCRD"
WHERE
  "CardCode" = v_CardCode;

-- Marca asegurada según crédito
UPDATE
  "OINV"
SET
  "U_Asegurada" = CASE
    WHEN v_Credit > 0 THEN 'Si'
    ELSE 'No'
  END
WHERE
  "DocEntry" = v_DocEntry;

END IF;