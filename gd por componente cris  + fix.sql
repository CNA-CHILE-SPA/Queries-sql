SELECT
  DISTINCT OINV."FolioNum" AS "Folio Factura",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."FolioNum" AS "Folio Entrega",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Dscription" AS "Descripción Producto",
  DLN1."Quantity" AS "Cantidad Despachada",
  INV1."Quantity" AS "Cantidad Facturada",
  COALESCE(ITT1."Code", DLN1."ItemCode") AS "Código componente",
  COALESCE(OITM."ItemName", DLN1."Dscription") AS "Descripción del artículo",
  COALESCE(ITT1."Quantity", 1) AS "Cantidad base Lista materiales",
  DLN1."Quantity" * COALESCE(ITT1."Quantity", 1) AS "Cantidad total Componente",
  DLN1."WhsCode" AS "Código Bodega",
  ODLN."DocDate" AS "Fecha Entrega",
  ODLN."NumAtCard" AS "Nº Orden Compra",
  OINV."isIns" AS "Flujo"
FROM
  ODLN
  LEFT JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  LEFT JOIN OINV ON DLN1."BaseEntry" = OINV."DocEntry"
  AND DLN1."BaseType" = 13
  LEFT JOIN INV1 ON INV1."DocEntry" = OINV."DocEntry"
  AND INV1."LineNum" = DLN1."BaseLine"
  LEFT JOIN ITT1 ON DLN1."ItemCode" = ITT1."Father"
  LEFT JOIN OITM ON ITT1."Code" = OITM."ItemCode"