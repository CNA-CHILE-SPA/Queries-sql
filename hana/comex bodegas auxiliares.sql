IF :object_type = '15'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T1."DocEntry" = T0."DocEntry"
    INNER JOIN OWHS W ON W."WhsCode" = T1."WhsCode"
    INNER JOIN OUSR U ON U."USERID" = T0."UserSign"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND W."U_TP_ALMACEN" = 'AUXILIAR'
    AND U."USER_CODE" NOT IN ('SJIMENEZ', 'BSANCRISTOBAL', 'BGONZALEZ');

IF CONT > 0 THEN error := 87;

error_message := 'Solo los usuarios de COMEX pueden crear guías desde bodegas AUXILIAR.';

END IF;

END IF;

IF :object_type = '67'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OWTR T0
    INNER JOIN WTR1 T1 ON T1."DocEntry" = T0."DocEntry"
    INNER JOIN OWHS W ON W."WhsCode" = T1."FromWhsCod"
    INNER JOIN OUSR U ON U."USERID" = T0."UserSign"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND W."U_TP_ALMACEN" = 'AUXILIAR'
    AND U."USER_CODE" NOT IN ('SJIMENEZ', 'BSANCRISTOBAL', 'BGONZALEZ');

IF CONT > 0 THEN error := 87;

error_message := 'Solo los usuarios de COMEX pueden crear transferencias desde bodegas AUXILIAR.';

END IF;

END IF;