SELECT
  DISTINCT O."DocNum" AS "Nro Doc",
  O."DocDate" AS "Fecha Doc",
  O."DocDueDate" AS "Fecha Vencimiento",
  O."TaxDate" AS "Fecha Impuesto",
  O."CardCode" AS "Código Cliente",
  O."NumAtCard" AS "Nº Orden Compra",
  O."DocCur" AS "Moneda",
  O."Comments" AS "Comentarios",
  O."FolioPref" AS "Prefijo Folio",
  O."FolioNum" AS "Número Folio"
FROM
  OINV F
  INNER JOIN ORDR O ON F."NumAtCard" = O."NumAtCard"
WHERE
  F."isIns" = 'N'