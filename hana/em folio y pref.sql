IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OPDN T0
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND (
        IFNULL(T0."FolioPref", 0) NOT IN (52, 33)
        OR IFNULL(T0."FolioNum", 0) = 0
    );

IF CONT > 0 THEN error := 85;

error_message := 'La Entrada de Mercancía debe tener Prefijo 52 y Numero de Folio.';

END IF;

END IF;