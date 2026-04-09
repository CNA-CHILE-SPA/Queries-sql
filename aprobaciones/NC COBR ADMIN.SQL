SELECT
    CASE
        -- WHEN $[ORIN."U_MOTIVO_NCND".0.0] in ('3', '11', '12', '13', '6', '10', '15')
        WHEN $[ORIN."U_MOTIVO_NCND".0.0] in ('1', '7', '10', '11', '13', '14', '16', '17') THEN 'True'
        else 'False'
    end
FROM
    DUMMY