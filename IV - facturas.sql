SELECT
  F."DocEntry" AS "Nro SAP Factura",
  F."DocNum" AS "Nro Factura",
  F."CardCode" AS "Código Cliente",
  F."CardName" AS "Nombre Cliente",
  F."FolioNum" AS "Folio",
  F."DocDate" AS "Fecha",
  CASE
    WHEN F."BPLId" = 1 THEN 'CNA'
    WHEN F."BPLId" = 2 THEN 'FA'
    ELSE NULL
  END AS "Sucursal",
  DET."LineNum" AS "Nro Línea",
  DET."ItemCode" AS "Código Producto",
  DET."Dscription" AS "Descripción Producto",
  DET."Quantity" AS "Cantidad",
  SL."SlpName" AS "Vendedor"
FROM
  OINV F
  INNER JOIN INV1 DET ON F."DocEntry" = DET."DocEntry"
  INNER JOIN OSLP SL ON F."SlpCode" = SL."SlpCode"
ORDER BY
  F."DocEntry"