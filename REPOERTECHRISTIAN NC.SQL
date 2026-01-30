SELECT
    T0."DocEntry",
    'Nota de Crédito' AS "Tipo",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Emisor",
    T0."DocNum",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T0."DocDate" AS "Fecha Contabilización",
    T0."DocDueDate" AS "Fecha Vencimiento",
    T0."TaxDate" AS "Fecha Documento",
    T0."FolioPref" AS "Prefijo",
    T0."FolioNum" AS "Folio SII",
    T1."ItemCode" AS "Código Producto",
    T1."Dscription" AS "Descripción",
    T3."InvntryUom" AS "Unidad de Medida",
    T1."Quantity" AS "Cantidad",
    T0."DocTotalSy" as "Total NC CLP",
    T4."FolioNum" as "Factura Asociada",
    T0."U_EXX_FE_TDBSII" as "Tipo Documento Base SII",
    T0."U_EXX_FE_FOLIODB" AS "Folio Documento Base SII",
    T0."U_EXX_FE_FECHADB" AS "Fecha Documento Base SII",
    T1."U_EXX_FE_Descripcion" as "Comentarios linea",
    T0."Comments" AS "Comentarios"
FROM
    ORIN T0
    INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
    INNER JOIN OITM T3 ON T1."ItemCode" = T3."ItemCode"
    LEFT JOIN OINV T4 ON T1."BaseEntry" = T4."DocEntry"