SELECT
    CASE
        T0."isIns"
        WHEN 'Y' THEN 'Factura de Reserva'
        WHEN 'N' THEN 'Facturas de Deudores'
    END AS "Tipo",
    T0."DocNum",
    T0."Indicator" AS " Indicador",
    T0."FolioNum" AS "Folio SII",
    CASE
        T0."CANCELED"
        WHEN 'Y' THEN 'CANCELADO'
        WHEN 'C' THEN 'CANCELADO'
        WHEN 'N' THEN 'VIGENTE'
    END AS "Documento Cancelado",
    CASE
        T0."DocStatus"
        WHEN 'O' THEN 'Abierta'
        ELSE 'Cerrada'
    END AS "Estado",
    MONTH(T0."DocDate") AS "Mes Contabilización",
    YEAR(T0."DocDate") AS "Año Contabilización",
    T0."DocDate" AS " Fecha Contabilización",
    T0."DocDueDate" AS " Fecha Vencimiento",
    T0."TaxDate" As " Fecha Documento",
    T0."NumAtCard" AS "Nro OC",
    T0."U_EXX_FE_FOLIODB" AS "Nro OC2",
    T0."U_EXX_FE_TDBSII",
    T0."U_EXX_FE_FOLIODB",
    T0."U_EXX_FE_FECHADB",
    T0."U_EXX_FE_TDBSII1",
    T0."U_EXX_FE_FOLIODB1",
    T0."U_EXX_FE_FECHADB1",
    T9."PymntGroup" AS " Condición de Pago",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T4."GroupName" As " Grupo de Cliente",
    T3."SlpName" As "Vendedor",
    T5."ItemCode" AS " Producto",
    T6."ItemName" AS "Descripción",
    T7."ItmsGrpNam" AS "Grupo",
    T5."OcrCode" AS "Dimensión 1",
    T5."OcrCode2" As "Dimensión 2",
    T5."OcrCode3" AS "Dimensión 3",
    T5."OcrCode4" As "Dimensión 4",
    T5."Quantity" As " Cantidad",
    T5."unitMsr" AS "Unidad de Medida",
    T5."PriceBefDi" AS "Precio Antes Descuento",
    T5."DiscPrcnt" AS "Porcentaje de Descuento",
    T5."Price" AS "Precio tras descuento",
    T5."Currency" As "Moneda",
    T5."StockPrice" AS "Costo Unitario",
    T5."Quantity" * T5."StockPrice" AS "Costo Total",
    T5."LineTotal" As "Total Neto",
    T5."TotalSumSy" as "Total NetoCLP",
    T0."ExtraDays" as "Dias Pago"
FROM
    OINV T0
    INNER JOIN OUSR T1 ON T0."UserSign" = T1."USERID"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
    INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
    INNER JOIN INV1 T5 ON T0."DocEntry" = T5."DocEntry"
    INNER JOIN OITM T6 ON T5."ItemCode" = T6."ItemCode"
    INNER JOIN OITB T7 ON T6."ItmsGrpCod" = T7."ItmsGrpCod"
    INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
    T0."CANCELED" = 'N'
    AND T0."DocType" = 'I'
    and T0."DocNum" LIKE '4%'
UNION
ALL
SELECT
    CASE
        T0."isIns"
        WHEN 'Y' THEN 'Factura de Reserva'
        WHEN 'N' THEN 'Facturas de Deudores'
    END AS "Tipo",
    T0."DocNum",
    T0."Indicator" AS " Indicador",
    T0."FolioNum" AS "Folio SII",
    CASE
        T0."CANCELED"
        WHEN 'Y' THEN 'CANCELADO'
        WHEN 'C' THEN 'CANCELADO'
        WHEN 'N' THEN 'VIGENTE'
    END AS "Documento Cancelado",
    CASE
        T0."DocStatus"
        WHEN 'O' THEN 'Abierta'
        ELSE 'Cerrada'
    END AS "Estado",
    MONTH(T0."DocDate") AS "Mes Contabilización",
    YEAR(T0."DocDate") AS "Año Contabilización",
    T0."DocDate" AS " Fecha Contabilización",
    T0."DocDueDate" AS " Fecha Vencimiento",
    T0."TaxDate" As " Fecha Documento",
    T0."NumAtCard" AS "Nro OC",
    T0."U_EXX_FE_FOLIODB" AS "Nro OC2",
    T0."U_EXX_FE_TDBSII",
    T0."U_EXX_FE_FOLIODB",
    T0."U_EXX_FE_FECHADB",
    T0."U_EXX_FE_TDBSII1",
    T0."U_EXX_FE_FOLIODB1",
    T0."U_EXX_FE_FECHADB1",
    T9."PymntGroup" AS " Condición de Pago",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T4."GroupName" As " Grupo de Cliente",
    T3."SlpName" As "Vendedor",
    null,
    T5."Dscription" AS "Descripción",
    null,
    T5."OcrCode" AS "Dimensión 1",
    T5."OcrCode2" As "Dimensión 2",
    T5."OcrCode3" AS "Dimensión 3",
    T5."OcrCode4" As "Dimensión 4",
    T5."Quantity" As " Cantidad",
    T5."unitMsr" AS "Unidad de Medida",
    T5."PriceBefDi" AS "Precio Antes Descuento",
    T5."DiscPrcnt" AS "Porcentaje de Descuento",
    T5."Price" AS "Precio tras descuento",
    T5."Currency" As "Moneda",
    T5."StockPrice" AS "Costo Unitario",
    T5."Quantity" * T5."StockPrice" AS "Costo Total",
    T5."LineTotal" As "Total Neto",
    T5."TotalSumSy" as "Total NetoCLP",
    T0."ExtraDays" as "Dias Pago"
FROM
    OINV T0
    INNER JOIN OUSR T1 ON T0."UserSign" = T1."USERID"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
    INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
    INNER JOIN INV1 T5 ON T0."DocEntry" = T5."DocEntry"
    INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
    T0."CANCELED" = 'N'
    AND T0."DocType" = 'S'
    and T0."DocNum" LIKE '4%'
UNION
ALL
SELECT
    'Notas de Credito Articulos',
    T0."DocNum",
    T0."Indicator" AS " Indicador",
    T0."FolioNum" AS "Folio SII",
    CASE
        T0."CANCELED"
        WHEN 'Y' THEN 'CANCELADO'
        WHEN 'C' THEN 'CANCELADO'
        WHEN 'N' THEN 'VIGENTE'
    END AS "Documento Cancelado",
    CASE
        T0."DocStatus"
        WHEN 'O' THEN 'Abierta'
        ELSE 'Cerrada'
    END AS "Estado",
    MONTH(T0."DocDate") AS "Mes Contabilización",
    YEAR(T0."DocDate") AS "Año Contabilización",
    T0."DocDate" AS " Fecha Contabilización",
    T0."DocDueDate" AS " Fecha Vencimiento",
    T0."TaxDate" As " Fecha Documento",
    T0."NumAtCard" AS "Nro OC",
    T0."U_EXX_FE_FOLIODB" AS "Nro OC2",
    T0."U_EXX_FE_TDBSII",
    T0."U_EXX_FE_FOLIODB",
    T0."U_EXX_FE_FECHADB",
    T0."U_EXX_FE_TDBSII1",
    T0."U_EXX_FE_FOLIODB1",
    T0."U_EXX_FE_FECHADB1",
    T9."PymntGroup" AS " Condición de Pago",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T4."GroupName" As " Grupo de Cliente",
    T3."SlpName" As "Vendedor",
    T5."ItemCode" AS " Producto",
    T6."ItemName" AS "Descripción",
    T7."ItmsGrpNam" AS "Grupo",
    T5."OcrCode" AS "Dimensión 1",
    T5."OcrCode2" As "Dimensión 2",
    T5."OcrCode3" AS "Dimensión 3",
    T5."OcrCode4" As "Dimensión 4",
    - T5."Quantity" As " Cantidad",
    T5."unitMsr" AS "Unidad de Medida",
    - T5."PriceBefDi" AS "Precio Antes Descuento",
    - T5."DiscPrcnt" AS "Porcentaje de Descuento",
    - T5."Price" AS "Precio tras descuento",
    T5."Currency" As "Moneda",
    - T5."StockPrice" AS "Costo Unitario",
    - T5."Quantity" * T5."StockPrice" AS "Costo Total",
    - T5."LineTotal" As "Total Neto",
    T5."TotalSumSy" as "Total NetoCLP",
    T0."ExtraDays" as "Dias Pago"
FROM
    ORIN T0
    INNER JOIN OUSR T1 ON T0."UserSign" = T1."USERID"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
    INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
    INNER JOIN RIN1 T5 ON T0."DocEntry" = T5."DocEntry"
    INNER JOIN OITM T6 ON T5."ItemCode" = T6."ItemCode"
    INNER JOIN OITB T7 ON T6."ItmsGrpCod" = T7."ItmsGrpCod"
    INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
    T0."CANCELED" = 'N'
    AND T0."DocType" = 'I'
    and T0."DocNum" LIKE '4%'
UNION
ALL
SELECT
    'Notas de Credito Servicio',
    T0."DocNum",
    T0."Indicator" AS " Indicador",
    T0."FolioNum" AS "Folio SII",
    CASE
        T0."CANCELED"
        WHEN 'Y' THEN 'CANCELADO'
        WHEN 'C' THEN 'CANCELADO'
        WHEN 'N' THEN 'VIGENTE'
    END AS "Documento Cancelado",
    CASE
        T0."DocStatus"
        WHEN 'O' THEN 'Abierta'
        ELSE 'Cerrada'
    END AS "Estado",
    MONTH(T0."DocDate") AS "Mes Contabilización",
    YEAR(T0."DocDate") AS "Año Contabilización",
    T0."DocDate" AS " Fecha Contabilización",
    T0."DocDueDate" AS " Fecha Vencimiento",
    T0."TaxDate" As " Fecha Documento",
    T0."NumAtCard" AS "Nro OC",
    T0."U_EXX_FE_FOLIODB" AS "Nro OC2",
    T0."U_EXX_FE_TDBSII",
    T0."U_EXX_FE_FOLIODB",
    T0."U_EXX_FE_FECHADB",
    T0."U_EXX_FE_TDBSII1",
    T0."U_EXX_FE_FOLIODB1",
    T0."U_EXX_FE_FECHADB1",
    T9."PymntGroup" AS " Condición de Pago",
    T0."CardCode" AS "Codigo Cliente",
    T0."CardName" AS "Razón Social",
    T4."GroupName" As " Grupo de Cliente",
    T3."SlpName" As "Vendedor",
    null,
    T5."Dscription",
    null,
    T5."OcrCode" AS "Dimensión 1",
    T5."OcrCode2" As "Dimensión 2",
    T5."OcrCode3" AS "Dimensión 3",
    T5."OcrCode4" As "Dimensión 4",
    - T5."Quantity" As " Cantidad",
    T5."unitMsr" AS "Unidad de Medida",
    - T5."PriceBefDi" AS "Precio Antes Descuento",
    - T5."DiscPrcnt" AS "Porcentaje de Descuento",
    - T5."Price" AS "Precio tras descuento",
    T5."Currency" As "Moneda",
    - T5."StockPrice" AS "Costo Unitario",
    - T5."Quantity" * T5."StockPrice" AS "Costo Total",
    - T5."LineTotal" As "Total Neto",
    T5."TotalSumSy" as "Total NetoCLP",
    T0."ExtraDays" as "Dias Pago"
FROM
    ORIN T0
    INNER JOIN OUSR T1 ON T0."UserSign" = T1."USERID"
    INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
    INNER JOIN OSLP T3 ON T0."SlpCode" = T3."SlpCode"
    INNER JOIN OCRG T4 ON T2."GroupCode" = T4."GroupCode"
    INNER JOIN RIN1 T5 ON T0."DocEntry" = T5."DocEntry"
    INNER JOIN OCTG T9 ON T0."GroupNum" = T9."GroupNum"
WHERE
    T0."CANCELED" = 'N'
    AND T0."DocType" = 'S'
    and T0."DocNum" LIKE '4%'