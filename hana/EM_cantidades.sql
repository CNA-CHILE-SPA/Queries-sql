----- CHEQUEO DE CANTIDADES EN ENTRADA DE MERCANCIA -----------------------------
-- Entrega no permite ingresar cantidad mayor a la pendiente del doc.base
--- Nicolás Tapia 14.11.25
IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT = 0;

SELECT
    COUNT (T0."DocEntry") INTO CONT
FROM
    "OPDN" T0
    INNER JOIN PDN1 T1 ON T1."DocEntry" = T0."DocEntry"
WHERE
    T0."DocEntry" = list_of_cols_val_tab_del
    AND T1."Quantity" > IFNULL (T1."BaseOpnQty", 0)
    AND ifnull(T1."BaseEntry", 0) > 0;

IF CONT > 0 THEN error := 83;

error_message := 'La Cantidad a Ingresar no puede exceder la cantidad pendiente del Doc. Base';

END IF;

END IF;