IF :object_type = '14'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN DECLARE v_Cont INT := 0;

SELECT
    COUNT(*) INTO v_Cont
FROM
    ORIN T0
    INNER JOIN OWHS T1 ON T1."WhsCode" = T0."U_BOD_DOC"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND T1."U_TP_ALMACEN" = 'AUXILIAR';

IF v_Cont > 0 THEN error := 87;

error_message := 'No se pueden hacer NC hacia bodegas AUXILIAR.';

END IF;

END IF;