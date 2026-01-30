-- CHEQUEO DE DOCUMENTO BASE EN ENTRADA DE MERCANCIA -----------------------------
-- No permite crear entrada de mercancía sin documento base
IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OPDN T0
    INNER JOIN PDN1 T1 ON T1."DocEntry" = T0."DocEntry"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND IFNULL(T1."BaseEntry", 0) = 0;

IF CONT > 0 THEN error := 84;

error_message := 'No se permite crear Entradas de Mercancía sin documento base (Pedido).';

END IF;

END IF;