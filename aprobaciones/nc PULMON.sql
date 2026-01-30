SELECT
    CASE
        WHEN $[ORIN."U_BOD ".0.0] in ('CNA_RANC', 'FA_RANC', 'CNA_LANG', 'FA_LANG') THEN 'True'
        else 'False'
    end
FROM
    DUMMY