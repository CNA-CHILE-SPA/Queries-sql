SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('8') THEN 'True'
        else 'False'
    end
FROM
    DUMMY