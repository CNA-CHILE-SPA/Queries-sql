SELECT
  DISTINCT O."DocEntry" AS "OrdenVenta",
  O."DocNum" AS "NumeroOrden",
  O."CardCode" AS "CodigoCliente",
  O."CardName" AS "NombreCliente",
  O."DocDate" AS "FechaOrden",
  O."DocDueDate" AS "FechaVencimiento",
  O."TaxDate" AS "FechaImpuesto",
  O."NumAtCard" AS "NumeroReferencia",
  D."LineNum" AS "NumeroLinea",
  D."ItemCode" AS "CodigoArticulo",
  D."Dscription" AS "DescripcionArticulo",
  D."Quantity" AS "Cantidad",
  O."DocCur" as "Moneda",
  O."DocRate" AS "TasaCambio",
  D."Price" AS "PrecioUnitario",
  D."LineTotal" AS "TotalLinea USD",
  D."TotalSumSy" AS "TotalLinea CLP"
FROM
  OINV F
  INNER JOIN ORDR O ON F."NumAtCard" = O."NumAtCard"
  INNER JOIN RDR1 D ON O."DocEntry" = D."DocEntry"
WHERE
  F."isIns" = 'N'
ORDER BY
  O."DocEntry"