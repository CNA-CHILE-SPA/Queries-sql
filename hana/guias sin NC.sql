IF :object_type = '15'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
)
AND (:error = 0) THEN DECLARE v_NC_EnAutorizacion INT := 0;

DECLARE v_DocEntry INT := CAST(:list_of_cols_val_tab_del AS INT);

-- PASO 1: Partir desde OWDD (tabla de flujos en aprobación)
-- PASO 2: Unir OWDD con ODRF usando DraftEntry
-- PASO 3: Unir ODRF con DRF1 usando DocEntry para obtener líneas
-- PASO 4: Unir DLN1 de la guía actual para obtener su BaseRef
-- PASO 5: Filtrar comparando BaseRef de DRF1 (NC) con BaseRef de DLN1 (Guía)
SELECT
    COUNT(*) INTO v_NC_EnAutorizacion
FROM
    OWDD T0 -- PASO 1: Flujos en aprobación
    INNER JOIN ODRF D ON T0."DraftEntry" = D."DocEntry" -- PASO 2: Documentos borrador
    INNER JOIN DRF1 T1 ON D."DocEntry" = T1."DocEntry" -- PASO 3: Líneas NC borrador
    INNER JOIN DLN1 T2 ON T2."DocEntry" = v_DocEntry -- PASO 4: Líneas guía actual
WHERE
    T0."Status" = 'W' -- PASO 1: Solo en proceso
    AND T0."ObjType" = '14' -- Nota de Crédito
    AND T1."BaseType" = 13 -- NC vinculada a factura
    AND T1."BaseRef" = T2."BaseRef";

-- PASO 5: Mismo DocNum
IF v_NC_EnAutorizacion > 0 THEN error := 702;

error_message := 'No se puede emitir la Guía de Despacho. La Nota de Crédito de la factura asociada está en proceso de autorización.';

END IF;

END IF;