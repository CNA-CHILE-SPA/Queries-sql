IF :object_type = '14'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN IF EXISTS (
    SELECT
        1
    FROM
        ORIN T0
    WHERE
        T0."DocEntry" = :list_of_cols_val_tab_del
        AND (
            T0."MOV_STOCK" IS NULL
            OR T0."MOV_STOCK" = ''
        )
) THEN error := 10001;

error_message := 'El campo Mueve Stock es obligatorio para la Nota de Crédito.';

END IF;

END IF;