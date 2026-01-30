SELECT
    CASE
        WHEN $ [ORIN."U_MOTIVO_NCND".0.0] in ('1', '2', '4', '7', '14')
        and $ [ORIN."U_BOD_DOC".0.0] in (
            'CNA_CBS',
            'FA_CBS',
            'CNA_LIN',
            'CNA_SLLM',
            'CNA_SOL',
            'FA_LIN',
            'FA_SLLM',
            'FA_SOL',
            'CNA_MAV',
            'FA_MAV',
            'CNA_LIPL',
            'FA_LIPL'
        ) THEN 'True'
        else 'False'
    end
FROM
    DUMMY