-- Flujo anticipado
SELECT
  DISTINCT OINV."FolioNum" AS "Folio Factura",
  'Reserva' as "Tipo Entrega",
  ODLN."NumAtCard" AS "Nº Orden Compra",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."DocNum" as "Primario Entrega",
  ODLN."FolioNum" AS "Folio Entrega",
  OINV."DocNum" as "Primario Factura",
  OINV."FolioNum" as "Folio Factura",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Quantity" AS "Cantidad Entregada",
  ODLN."DocDate" AS "Fecha Entrega",
  DLN1."WhsCode" AS "Código Bodega",
  OWHS."WhsName" AS "Nombre Bodega",
  -- Totales Factura (USD y Pesos)
  ODLN."VatSum" AS "IVA Factura USD",
  ODLN."DocTotal" - ODLN."VatSum" AS "Subtotal Factura USD",
  ODLN."DocTotal" AS "Total Factura USD",
  ODLN."VatSumFC" AS "IVA Factura Pesos",
  ODLN."DocTotalFC" - ODLN."VatSumFC" AS "Subtotal Factura Pesos",
  ODLN."DocTotalFC" AS "Total Factura Pesos"
FROM
  ODLN
  INNER JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  INNER JOIN OWHS ON DLN1."WhsCode" = OWHS."WhsCode"
  INNER JOIN OINV ON DLN1."BaseEntry" = OINV."DocEntry"
  AND DLN1."BaseType" = 13
WHERE
  OINV."isIns" = 'Y'
UNION
-- Flujo normal
SELECT
  DISTINCT OINV."FolioNum" AS "Folio Factura",
  'Deudor' as "Tipo Entrega",
  ODLN."NumAtCard" AS "Nº Orden Compra",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."DocNum" as "Primario Entrega",
  ODLN."FolioNum" AS "Folio Entrega",
  OINV."DocNum" as "Primario Factura",
  OINV."FolioNum" as "Folio Factura",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Quantity" AS "Cantidad Entregada",
  ODLN."DocDate" AS "Fecha Entrega",
  DLN1."WhsCode" AS "Código Bodega",
  OWHS."WhsName" AS "Nombre Bodega",
  -- Totales Factura (USD y Pesos)
  ODLN."VatSum" AS "IVA Factura USD",
  ODLN."DocTotal" - ODLN."VatSum" AS "Subtotal Factura USD",
  ODLN."DocTotal" AS "Total Factura USD",
  ODLN."VatSumFC" AS "IVA Factura Pesos",
  ODLN."DocTotalFC" - ODLN."VatSumFC" AS "Subtotal Factura Pesos",
  ODLN."DocTotalFC" AS "Total Factura Pesos"
FROM
  ODLN
  INNER JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  LEFT JOIN INV1 ON ODLN."DocEntry" = INV1."BaseEntry"
  LEFT JOIN OINV ON INV1."DocEntry" = OINV."DocEntry"
  INNER JOIN OWHS ON DLN1."WhsCode" = OWHS."WhsCode"
  -- OINV
  -- INNER JOIN INV1 ON OINV."DocEntry" = INV1."DocEntry"
  -- LEFT JOIN ODLN ON INV1."BaseEntry" = ODLN."DocEntry"
  -- INNER JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  -- INNER JOIN OWHS ON DLN1."WhsCode" = OWHS."WhsCode"
WHERE
  DLN1."BaseType" = 17