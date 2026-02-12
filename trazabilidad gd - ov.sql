SELECT
    T1."DocEntry",
    CASE
        T0."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
    END AS "Sucursal",
    T0."DocNum",
    T0."FolioPref",
    T0."FolioNum",
    T0."DocDate",
    T0."CardCode",
    T0."CardName",
    T1."ItemCode",
    T1."Dscription",
    T1."PriceBefDi",
    T1."Quantity",
    T1."LineTotal",
    T1."WhsCode",
    Case
        when T1."BaseType" = 17 then 'Orden de Venta'
        else ''
    end "Doc. Base",
    T4."DocEntry" "Doc. Entry  Base",
    T5."DocNum" "N° Orden de Venta",
    T5."DocDate" "Fecha OV"
FROM
    "ODLN" T0
    INNER JOIN "DLN1" T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN "RDR1" T4 ON T1."BaseEntry" = T4."DocEntry"
    LEFT JOIN "ORDR" T5 ON T4."DocEntry" = T5."DocEntry"
WHERE
    T1."BaseType" = 17
    and T0."DocDate" >= [%0]
    and T0."DocDate" <= [%1]
    and T0."BPLId" = [%2]