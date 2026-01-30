-- Flujo anticipado
SELECT
  OINV."FolioNum" AS "Folio Factura",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."FolioNum" AS "Folio Entrega",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Dscription" AS "Descripción Producto",
  DLN1."Quantity" AS "Cantidad Producto",
  COALESCE(ITT1."Code", DLN1."ItemCode") AS "Código componente",
  COALESCE(OITM."ItemName", DLN1."Dscription") AS "Descripción del artículo",
  COALESCE(ITT1."Quantity", 1) AS "Cantidad base Lista materiales",
  DLN1."Quantity" * COALESCE(ITT1."Quantity", 1) AS "Cantidad total Componente",
  DLN1."WhsCode" AS "Código Bodega",
  ODLN."DocDate" AS "Fecha Entrega",
  ODLN."NumAtCard" AS "Nº Orden Compra"
FROM
  ODLN
  INNER JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  LEFT JOIN OINV ON DLN1."BaseEntry" = OINV."DocEntry"
  AND DLN1."BaseType" = 13
  INNER JOIN INV1 ON OINV."DocEntry" = INV1."DocEntry"
  INNER JOIN ITT1 ON DLN1."ItemCode" = ITT1."Father"
  INNER JOIN OITM ON ITT1."Code" = OITM."ItemCode"
WHERE
  OINV."isIns" = 'Y' -- Para flujo anticipado
UNION
-- Flujo normal
SELECT
  OINV."FolioNum" AS "Folio Factura",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."FolioNum" AS "Folio Entrega",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Dscription" AS "Descripción Producto",
  DLN1."Quantity" AS "Cantidad Producto",
  COALESCE(ITT1."Code", DLN1."ItemCode") AS "Código componente",
  COALESCE(OITM."ItemName", DLN1."Dscription") AS "Descripción del artículo",
  COALESCE(ITT1."Quantity", 1) AS "Cantidad base Lista materiales",
  DLN1."Quantity" * COALESCE(ITT1."Quantity", 1) AS "Cantidad total Componente",
  DLN1."WhsCode" AS "Código Bodega",
  ODLN."DocDate" AS "Fecha Entrega",
  ODLN."NumAtCard" AS "Nº Orden Compra"
FROM
  ODLN
  LEFT JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  LEFT JOIN OINV ON DLN1."BaseEntry" = OINV."DocEntry"
  AND DLN1."BaseType" = 13
  LEFT JOIN INV1 ON OINV."DocEntry" = INV1."DocEntry"
  LEFT JOIN ITT1 ON DLN1."ItemCode" = ITT1."Father"
  LEFT JOIN OITM ON ITT1."Code" = OITM."ItemCode"
WHERE
  OINV."isIns" = 'N' -- Para flujo normal