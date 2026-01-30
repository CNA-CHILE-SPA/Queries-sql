SELECT
    CASE
        T6."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Sucursal",
    T0."TransId" AS "Nro. Asiento",
    T1."CardCode" AS "Codigo SN",
    T1."CardName" AS "Nombre SN",
    T0."RefDate" AS "Fecha Contable",
    T0."DueDate" AS "Fecha Vence",
    T6."U_newduedate" AS "Fecha Aplazamiento",
    T6."U_Comment",
    DAYS_BETWEEN(T0."RefDate", T0."DueDate") AS "Plazo",
    CASE
        WHEN T0."TransType" = 13
        AND T6."DocSubType" = 'DN' THEN 'Nota Debito'
        WHEN T0."TransType" = 13 THEN 'Factura'
        WHEN T0."TransType" = 30 THEN 'Asiento'
        WHEN T0."TransType" = 24 THEN 'Pago'
    END AS "Tipo Doc.",
    (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) AS "Saldo",
    (
        T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSumFC", 0)
    ) AS "Saldo FC",
    CASE
        WHEN DAYS_BETWEEN(T0."DueDate", CURRENT_DATE) < 0 THEN T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
        ELSE 0
    END AS "No vencido",
    CASE
        WHEN DAYS_BETWEEN(T0."DueDate", CURRENT_DATE) < 0 THEN T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSumFC", 0)
        ELSE 0
    END AS "No vencido FC",
    T2."FolioNum" as "Número de folio",
    T11."SlpName" AS "Vendedor",
    T6."U_Asegurada"
FROM
    "JDT1" T0
    INNER JOIN "OCRD" T1 ON T0."ShortName" = T1."CardCode"
    INNER JOIN "OJDT" T2 ON T0."TransId" = T2."TransId"
    LEFT JOIN (
        SELECT
            T4."ShortName",
            T4."TransId",
            T4."TransRowId",
            SUM(
                T4."ReconSum" * CASE
                    WHEN T4."IsCredit" = 'D' THEN 1
                    ELSE -1
                END
            ) AS "ReconSum",
            SUM(
                T4."ReconSumFC" * CASE
                    WHEN T4."IsCredit" = 'D' THEN 1
                    ELSE -1
                END
            ) AS "ReconSumFC"
        FROM
            "OITR" T3
            INNER JOIN "ITR1" T4 ON T3."ReconNum" = T4."ReconNum"
        WHERE
            T3."ReconDate" <= CURRENT_DATE
        GROUP BY
            T4."ShortName",
            T4."TransId",
            T4."TransRowId"
    ) T5 ON T0."TransId" = T5."TransId"
    AND T0."ShortName" = T5."ShortName"
    AND T5."TransRowId" = T0."Line_ID"
    LEFT JOIN "OINV" T6 ON T6."TransId" = T2."TransId"
    INNER JOIN "OSLP" T11 ON T6."SlpCode" = T11."SlpCode"
WHERE
    T2."RefDate" <= CURRENT_DATE
    AND T1."CardType" = 'C'
    AND (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) <> 0
UNION
ALL
SELECT
    CASE
        T6."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Sucursal",
    T0."TransId" AS "Nro. Asiento",
    T1."CardCode" AS "Codigo SN",
    T1."CardName" AS "Nombre SN",
    T0."RefDate" AS "Fecha Contable",
    T0."DueDate" AS "Fecha Vence",
    T6."U_newduedate" AS "Fecha Aplazamiento",
    T6."U_Comment",
    DAYS_BETWEEN(T0."RefDate", T0."DueDate") AS "Plazo",
    'Nota credito' AS "Tipo Doc.",
    (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) AS "Saldo",
    (
        T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSumFC", 0)
    ) AS "Saldo FC",
    CASE
        WHEN DAYS_BETWEEN(T0."DueDate", CURRENT_DATE) < 0 THEN T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
        ELSE 0
    END AS "No vencido",
    CASE
        WHEN DAYS_BETWEEN(T0."DueDate", CURRENT_DATE) < 0 THEN T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSumFC", 0)
        ELSE 0
    END AS "No vencido FC",
    T2."FolioNum" as "Número de folio",
    T11."SlpName" AS "Vendedor",
    T6."U_Asegurada"
FROM
    "JDT1" T0
    INNER JOIN "OCRD" T1 ON T0."ShortName" = T1."CardCode"
    INNER JOIN "OJDT" T2 ON T0."TransId" = T2."TransId"
    LEFT JOIN (
        SELECT
            T4."ShortName",
            T4."TransId",
            T4."TransRowId",
            SUM(
                T4."ReconSum" * CASE
                    WHEN T4."IsCredit" = 'D' THEN 1
                    ELSE -1
                END
            ) AS "ReconSum",
            SUM(
                T4."ReconSumFC" * CASE
                    WHEN T4."IsCredit" = 'D' THEN 1
                    ELSE -1
                END
            ) AS "ReconSumFC"
        FROM
            "OITR" T3
            INNER JOIN "ITR1" T4 ON T3."ReconNum" = T4."ReconNum"
        WHERE
            T3."ReconDate" <= CURRENT_DATE
        GROUP BY
            T4."ShortName",
            T4."TransId",
            T4."TransRowId"
    ) T5 ON T0."TransId" = T5."TransId"
    AND T0."ShortName" = T5."ShortName"
    AND T5."TransRowId" = T0."Line_ID"
    LEFT JOIN "ORIN" T6 ON T6."TransId" = T2."TransId"
    INNER JOIN "OSLP" T11 ON T6."SlpCode" = T11."SlpCode"
WHERE
    T2."RefDate" <= CURRENT_DATE
    AND T1."CardType" = 'C'
    AND (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) <> 0