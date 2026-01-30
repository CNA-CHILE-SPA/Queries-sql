IF :object_type = '14'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN
/* Caso 1: Motivos con devolución -> todas las líneas deben ser 'N' */
IF EXISTS (
    SELECT
        1
    FROM
        "RIN1" T1
        INNER JOIN "ORIN" T0 ON T0."DocEntry" = T1."DocEntry"
    WHERE
        T1."DocEntry" = :list_of_cols_val_tab_del
        AND IFNULL(T0."U_MOTIVO_NCND", 0) IN (1, 7, 8, 16)
        AND T1."NoInvtryMv" <> 'N'
        AND T1."ItemCode" NOT LIKE 'NC%' -- 👈 exclusión
) THEN error := 1;

error_message := 'Para este motivo de nota de crédito, todas las líneas deben tener devolución de cantidad y ser aprobadas por gerencia de logística';

END IF;

/* Caso 2: Motivos sin devolución -> todas las líneas deben ser 'Y' */
IF EXISTS (
    SELECT
        1
    FROM
        "RIN1" T1
        INNER JOIN "ORIN" T0 ON T0."DocEntry" = T1."DocEntry"
    WHERE
        T1."DocEntry" = :list_of_cols_val_tab_del
        AND IFNULL(T0."U_MOTIVO_NCND", 0) IN (4, 6, 9, 10, 12, 13, 17)
        AND T1."NoInvtryMv" <> 'Y'
        AND T1."ItemCode" NOT LIKE 'NC%' -- 👈 exclusión
) THEN error := 1;

error_message := 'Para este motivo de nota de crédito, no debe existir devolución de cantidad en las líneas';

END IF;

END IF;