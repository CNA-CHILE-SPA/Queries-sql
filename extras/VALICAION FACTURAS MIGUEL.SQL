SELECT
    T0."DocEntry",
    T0."BPLId",
    T0."CardCode",
    T0."DocDate",
    T0."DocDueDate",
    T0."TaxDate",
    T0."DocCur",
    T0."FolioNum",
    T0."FolioPref",
    T0."Comments",
    T2."Segment_0" as "Nro Cuenta",
    T2."AcctName",
    (T0."DocTotalSy" - T0."VatSumSy") as "Neto",
    T0."VatSumSy",
    T0."DocTotalSy",
    T1."Dscription",
    T1."Currency"
FROM
    OPCH T0
    INNER JOIN PCH1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OACT T2 ON T1."AcctCode" = T2."AcctCode"
WHERE
    T0."Comments" = 'cargar_masiva_11_2025'