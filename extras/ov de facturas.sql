SELECT
    T0."DocEntry",
    T0."DocNum",
    T0."CardCode",
    T0."CardName",
    T0."NumAtCard",
    T0."Comments",
    -- T1."ItemCode",
    -- T1."Dscription",
    -- T1."Quantity",
    -- T1."OpenQty",
    T0."DocDate",
    T0."DocTotalSy",
    T0."Comments"
FROM
    ORDR T0 -- INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    TRIM(T0."Comments") <> ''
    AND t0."Comments" <> '2000100'
    AND REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(T0."Comments", '0', ''),
                                        '1',
                                        ''
                                    ),
                                    '2',
                                    ''
                                ),
                                '3',
                                ''
                            ),
                            '4',
                            ''
                        ),
                        '5',
                        ''
                    ),
                    '6',
                    ''
                ),
                '7',
                ''
            ),
            '8',
            ''
        ),
        '9',
        ''
    ) = ''