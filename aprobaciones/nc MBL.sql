SELECT
    CASE
        WHEN $[ORIN."U_BOD ".0.0] in ('CNA_MBL', 'FA_MBL') THEN 'True'
        else 'False'
    end
FROM
    DUMMY