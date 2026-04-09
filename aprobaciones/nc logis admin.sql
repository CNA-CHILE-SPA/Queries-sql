SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('1','2', '4', '7', '14' ) THEN 'True'
        else 'False'
    end
FROM
    DUMMY