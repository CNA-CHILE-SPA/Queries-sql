SELECT
    CASE
        WHEN $[ORIN."U_MOTIVO_NCND".0.0] in ('8')
        and $[ORIN."U_BOD_DOC".0.0] in (
            'CNA_CBS',
            'CNA_LIN',
            'CNA_SLLM',
            'CNA_SOL',
            'CNA_MAV',
            'CNA_LIPL',
            'CNA_LOG',
            'CNA_EQA',
            'CNA_QCT'
        ) THEN 'True'
        else 'False'
    end
FROM
    DUMMY