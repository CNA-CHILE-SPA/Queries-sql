SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('8')
        and $ [ORIN."U_BOD_DOC".0.0] in ('CNA_MBL', 'FA_MBL') THEN 'True'
        else 'False'
    end
FROM
    DUMMY