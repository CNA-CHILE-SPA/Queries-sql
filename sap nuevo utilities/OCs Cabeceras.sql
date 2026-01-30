SELECT
  F."DocNum" AS "Folio Factura",
  F."DocDate" AS "Fecha Factura",
  F."DocDueDate" AS "Fecha Vencimiento",
  F."TaxDate" AS "Fecha Impuesto",
  F."CardCode" AS "Código Cliente",
  F."NumAtCard" AS "Nº Orden Compra",
  F."DocCur" AS "Moneda",
  F."Comments" AS "Comentarios",
  F."FolioPref" AS "Prefijo Folio",
  F."FolioNum" AS "Número Folio"
FROM
  OPOR F