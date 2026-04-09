SELECT
    CASE
        -- WHEN $[ORIN."U_MOTIVO_NCND".0.0] in ('9', '5') 
        WHEN $[ORIN."U_MOTIVO_NCND".0.0] in () THEN 'True'
        else 'False'
    end
FROM
    DUMMY