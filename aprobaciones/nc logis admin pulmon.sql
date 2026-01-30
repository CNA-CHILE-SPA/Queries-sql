SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('1', '2', '4', '7', '14')
        and $ [ORIN."U_BOD_DOC".0.0] in ('CNA_RANC', 'FA_RANC', 'CNA_LANG', 'FA_LANG') THEN 'True'
        else 'False'
    end
FROM
    DUMMY