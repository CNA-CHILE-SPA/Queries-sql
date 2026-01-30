SELECT
    CASE
        T6."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    EnD AS "Sucursal",
    CASE
        when days_between(T0."DueDate", CURRENT_DATE) < 0 then 'No Vencido'
        when days_between(T0."DueDate", CURRENT_DATE) <= 10 then '1. Menor 10 Días'
        when days_between(T0."DueDate", CURRENT_DATE) <= 30 then '2. 11 a 30 Días'
        when days_between(T0."DueDate", CURRENT_DATE) <= 60 then '3. 31 a 60 Días'
        when days_between(T0."DueDate", CURRENT_DATE) <= 90 then '4. 61 a 90 Días'
        else '5. Más de 90 Días'
    END Edad,
    days_between(T0."DueDate", CURRENT_DATE) as Dias,
    T0."TransId" AS "Nro. Asiento",
    T0."LineMemo",
    T0."Line_ID",
    T2."Memo" AS "Comentarios",
    T0."Account" AS "Cuenta",
    T8."AcctName" as "Nombre cuenta",
    T6."Series",
    T1."CardCode" as "Codigo SN",
    T1."CardName" as "Nombre SN",
    T0."RefDate" AS "Fecha Contable",
    T0."DueDate" AS "Fecha Vence",
    T6."U_newduedate" AS "Fecha Aplazamiento",
    T6."U_Comment",
    DAYS_BETWEEN(t0."RefDate", T0."DueDate") AS "Plazo",
    CASE
        WHEN T0."TransType" IN ('13', '14')
        and T6."DocSubType" IN ('DN') THEN T10."SeriesName"
        WHEN T0."TransType" IN ('13', '14') THEN T10."SeriesName"
    END AS "Prefijo",
    CASE
        WHEN T0."TransType" IN ('13', '14')
        and T6."DocSubType" IN ('DN') THEN T6."NumAtCard"
        WHEN T0."TransType" = 30 THEN T0."Ref1"
    END AS "Num. Doc",
    CASE
        WHEN T0."TransType" = 13
        AND T6."DocSubType" = 'DN' THEN 'Nota Debito'
        WHEN T0."TransType" = 13 THEN 'Factura'
        WHEN T0."TransType" = 14 THEN 'Nota credito'
        WHEN T0."TransType" = 30 THEN 'Asiento'
        WHEN T0."TransType" = 24 THEN 'Pago'
    END AS "Tipo Doc.",
    (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) "Saldo",
    (
        T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSumFC", 0)
    ) "Saldo FC",
    (
        CASE
            WHEN days_between(T0."DueDate", CURRENT_DATE) < 0 THEN T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
            ELSE 0
        END
    ) "No vencido",
    (
        CASE
            WHEN days_between(T0."DueDate", CURRENT_DATE) < 0 THEN T0."FCDebit" - T0."FCCredit" - COALESCE(T5."ReconSum", 0)
            ELSE 0
        END
    ) "No vencido FC",
    T2."Ref1",
    T2."Ref2",
    T2."FolioPref",
    T2."FolioNum",
    T11."SlpName" AS "Vendedor"
FROM
    "JDT1" T0
    INNER JOIN "OCRD" T1 ON T0."ShortName" = T1."CardCode"
    INNER JOIN "OJDT" T2 ON T0."TransId" = T2."TransId"
    LEFT JOIN (
        SELECT
            T4."ShortName",
            T4."TransId",
            T4."TransRowId",
            sum(
                T4."ReconSum" * case
                    WHEN T4."IsCredit" = 'D' then 1
                    else -1
                end
            ) as "ReconSum",
            sum(
                T4."ReconSumFC" * case
                    WHEN T4."IsCredit" = 'D' then 1
                    else -1
                end
            ) as "ReconSumFC"
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
    and T0."ShortName" = T5."ShortName"
    AND T5."TransRowId" = T0."Line_ID"
    LEFT JOIN "OINV" T6 ON T6."TransId" = T2."TransId"
    LEFT JOIN "OACT" T8 ON T0."Account" = T8."AcctCode"
    LEFT JOIN "NNM1" T10 ON T10."Series" = T6."Series"
    INNER JOIN "OSLP" T11 ON T6."SlpCode" = T11."SlpCode"
WHERE
    T2."RefDate" <= CURRENT_DATE
    AND T1."CardType" = 'C'
    AND (
        T0."Debit" - T0."Credit" - COALESCE(T5."ReconSum", 0)
    ) <> 0