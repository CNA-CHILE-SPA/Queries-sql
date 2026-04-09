-- VALIDACIÓN DE SERIE PARA NOTA DE CRÉDITO CON MOTIVO 12
-- Valida que cuando el motivo de NC es 12, la serie del documento sea únicamente la serie 10
-- Nicolás Tapia / [Tu Usuario] - [Fecha]
IF :object_type = '14' -- 14 = Nota de Crédito de Clientes
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
)
AND (:error = 0) THEN IF EXISTS (
    SELECT
        1
    FROM
        ORIN T0
    WHERE
        T0."DocEntry" = :list_of_cols_val_tab_del
        AND T0."U_MOTIVO_NCND" = '12'
        AND T0."Series" <> '10'
) THEN error := 1402;

error_message := 'Cuando el motivo de Nota de Crédito es 12, la serie del documento debe ser 10';

END IF;

END IF;