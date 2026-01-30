IF :object_type = '14' -- Nota de crédito de clientes
AND :transaction_type = 'A'
AND :error = 0 THEN DECLARE v_count INT;

SELECT
    COUNT(*) INTO v_count
FROM
    ORIN
WHERE
    "DocEntry" = :list_of_cols_val_tab_del
    AND (
        IFNULL("U_MOTIVO_NCND", '') = ''
        OR IFNULL("U_BOD_DOC", '') = ''
    );

IF v_count > 0 THEN error := 1;

error_message := 'Debe ingresar obligatoriamente el Motivo de NC y la Bodega del Documento.';

END IF;

END IF;