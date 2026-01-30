IF object_type = '15'
AND (transaction_type = 'A' OR transaction_type = 'U') THEN

    CONT := 0;

    SELECT
        COUNT(*)
    INTO CONT
    FROM
        ODLN T0
    WHERE
        T0."DocEntry" = :list_of_cols_val_tab_del
        AND NOT EXISTS (
            SELECT 1
            FROM OCRD C
            WHERE C."LicTradNum" = T0."U_EXX_FE_RUTTRANSPORTISTA"
        );

    IF CONT > 0 THEN
        error := 86;
        error_message := 'El RUT del transportista no existe como Socio de Negocio.';
    END IF;

END IF;