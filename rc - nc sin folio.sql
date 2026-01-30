SELECT
    DISTINCT T0."DocEntry",
    T0."DocNum",
    T0."CardCode",
    T0."CardName",
    T0."DocDate",
    T0."DocTotalSy",
    T0."Comments",
    T0."U_EXX_FE_TDBSII" as "Tipo Documento Base SII",
    T0."U_EXX_FE_FOLIODB" AS "Folio Documento Base SII",
    T0."U_EXX_FE_FECHADB" AS "Fecha Documento Base SII",
    T3."FolioNum" AS "Folio Factura asociada sap",
    T1."LineNum",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN INV1 T2 ON T1."BaseEntry" = T2."DocEntry"
    INNER JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry"
WHERE
    T0."FolioNum" IS NULL