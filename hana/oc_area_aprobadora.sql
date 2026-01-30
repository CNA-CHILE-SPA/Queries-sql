-- Area Aprobadora
-- En creación de OV se valida que el campo are aprobadora no esté vacío
IF :object_type = '22' -- 22 = Orden de Compra
AND :transaction_type = 'A' -- A = Add (crear)
THEN DECLARE v_Motivo NVARCHAR(100);

SELECT
  T0."U_AreaAprobadora" INTO v_Motivo
FROM
  OPOR T0
WHERE
  T0."DocEntry" = CAST(:list_of_cols_val_tab_del AS INT);

IF (
  v_Motivo IS NULL
  OR LENGTH(TRIM(v_Motivo)) = 0
) THEN error := 1;

error_message := 'Debe ingresar el area aprobadora de la compra antes de crear la Orden de Compra.';

END IF;

END IF;