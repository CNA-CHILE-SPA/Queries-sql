SELECT
    T0."DocEntry",
    T0."FolioNum",
    T0."CardCode",
    T0."CardName",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T2."DocRate" as "Tipo Cambio OV",
    RDR."Currency" AS "Moneda Precio",
    RDR."Price",
    T1."WhsCode",
    T0."DocDate",
    T0."NumAtCard",
    T12."CityS",
    T0."Comments",
    T0."Address2" AS "Direccion de despacho",
    T8."SlpName",
    T1."U_EXX_FE_Descripcion"
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN DLN12 T12 ON T0."DocEntry" = T12."DocEntry"
    INNER JOIN OSLP T8 ON T0."SlpCode" = T8."SlpCode"
    INNER JOIN RDR1 RDR ON T1."BaseEntry" = RDR."DocEntry"
    AND T1."BaseLine" = RDR."LineNum"
    INNER JOIN ORDR T2 ON RDR."DocEntry" = T2."DocEntry"
WHERE
    T1."BaseType" = 17 -- Entrega desde Pedido
UNION
ALL
SELECT
    T0."DocEntry",
    T0."FolioNum",
    T0."CardCode",
    T0."CardName",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity",
    T2."DocRate" as "Tipo Cambio OV",
    RDR."Currency" AS "Moneda Precio",
    RDR."Price",
    T1."WhsCode",
    T0."DocDate",
    T0."NumAtCard",
    T12."CityS",
    T0."Comments",
    T0."Address2" AS "Direccion de despacho",
    T8."SlpName",
    T1."U_EXX_FE_Descripcion"
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
    LEFT JOIN DLN12 T12 ON T0."DocEntry" = T12."DocEntry"
    INNER JOIN OSLP T8 ON T0."SlpCode" = T8."SlpCode"
    INNER JOIN INV1 INV ON T1."BaseEntry" = INV."DocEntry"
    AND T1."BaseLine" = INV."LineNum"
    INNER JOIN RDR1 RDR ON INV."BaseEntry" = RDR."DocEntry"
    AND INV."BaseLine" = RDR."LineNum"
    INNER JOIN ORDR T2 ON RDR."DocEntry" = T2."DocEntry"
WHERE
    T1."BaseType" = 13;