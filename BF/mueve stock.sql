SELECT
    CASE
        -- 1) Cuenta contable parte con 2
        WHEN LEFT($ [$38.159.0], 1) = '2' THEN 'NO MUEVE STOCK' -- 2) Cuenta parte con $ y sin contabilización de cantidad = Y
        WHEN LEFT($ [$38.159.0], 1) = '4'
        AND $ [$38.1250002121.0] = 'Y' THEN 'NO MUEVE STOCK' -- 3) Cuenta parte con $ y sin contabilización de cantidad = N
        WHEN LEFT($ [$38.159.0], 1) = '4'
        AND $ [$38.1250002121.0] = 'N' THEN 'SI MUEVE STOCK' -- Opcional: cualquier otro caso
        ELSE ''
    END
FROM
    DUMMY;