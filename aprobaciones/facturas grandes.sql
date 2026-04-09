SELECT
    CASE
        WHEN IFNULL(
            CAST($[OINV."DocTotalSy".0.0] AS DECIMAL(19, 6)),
            0
        ) >= 100000000 THEN 'True'
        ELSE 'False'
    END AS RequiereAprobacion
FROM
    DUMMY;

    1000000000