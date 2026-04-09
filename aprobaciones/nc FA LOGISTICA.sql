SELECT
    CASE
        -- WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('16') THEN 'True'
        WHEN $[ORIN."U_MOTIVO_NCND".0.0] in ('18', '19', '20', '21', '22', '24') THEN 'True'
        else 'False'
    end
FROM
    DUMMY