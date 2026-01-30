SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('3', '11', '12', '13', '15') THEN 'True'
        else 'False'
    end
FROM
    DUMMY