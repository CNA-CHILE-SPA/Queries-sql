SELECT
    COALESCE(
        DAYS_BETWEEN(
            TO_DATE($[$U_EXX_FE_FECHADB.0.0], 'DD/MM/YYYY'),
            TO_DATE($[$10.0.0], 'DD/MM/YYYY')
        ),
        0
    ) AS dias_IVA
FROM
    DUMMY