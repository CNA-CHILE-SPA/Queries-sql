SELECT
    CASE
        WHEN $[ORIN."U_BOD ".0.0] in (
            'CNA_PCO',
            'CNA_AB',
            'CNA_EMPO',
            'FA_PCO',
            'FA_AB',
            'FA_EMPO'
        ) THEN 'True'
        else 'False'
    end
FROM
    DUMMY