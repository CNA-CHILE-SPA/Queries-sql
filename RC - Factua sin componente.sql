SELECT
  DISTINCT OINV."DocDate" AS "Fecha Factura",
  OINV."FolioNum" AS "Folio Factura",
  OINV."DocNum" AS "Número Factura SAP",
  ODLN."DocEntry" AS "Entrega DocEntry",
  ODLN."DocDate" AS "Fecha Entrega",
  ODLN."FolioNum" AS "Folio Entrega",
  ODLN."DocNum" AS "Número Entrega SAP",
  ODLN."CardCode" AS "Código Cliente",
  ODLN."CardName" AS "Nombre Cliente",
  ODLN."DocStatus" AS "Estado Entrega",
  DLN1."ItemCode" AS "Código Producto",
  DLN1."Dscription" AS "Descripción Producto",
  INV1."Quantity" AS "Cantidad Facturada",
  DLN1."Quantity" AS "Cantidad Despachada",
  DLN1."PriceBefDi",
  DLN1."WhsCode" AS "Código Bodega",
  ODLN."NumAtCard" AS "Nº Orden Compra",
  OINV."isIns" AS "Flujo"
FROM
  ODLN
  LEFT JOIN DLN1 ON ODLN."DocEntry" = DLN1."DocEntry"
  LEFT JOIN OINV ON DLN1."BaseEntry" = OINV."DocEntry"
  AND DLN1."BaseType" = 13
  LEFT JOIN INV1 ON INV1."DocEntry" = OINV."DocEntry"
  AND INV1."LineNum" = DLN1."BaseLine"