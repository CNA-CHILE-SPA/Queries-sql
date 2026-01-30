SELECT
    CASE
        WHEN IFNULL(
            CAST($ [OPDN."DocTotalSy".0.0] AS DECIMAL(19, 6)),
            0
        ) > 50000000
        AND $ [OPDN."CardCode".0.0] LIKE 'PN%' THEN 'True'
        ELSE 'False'
    END
FROM
    DUMMY;