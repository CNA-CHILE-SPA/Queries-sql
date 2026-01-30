SELECT
  F."DocNum" AS "Nro Factura",
  F."DocDate" AS "Fecha",
  F."DocDueDate" AS "Fecha Vencimiento",
  F."TaxDate" AS "Fecha Impuesto",
  F."CardCode" AS "Código Cliente",
  F."NumAtCard" AS "Número de Documento",
  F."DocCur" as "Moneda",
  F."Comments" AS "Comentarios",
  F."FolioPref" AS "Prefijo Folio",
  F."FolioNum" AS "Folio entrega",
  T."FolioNum" AS "Folio Factura Asociada"
FROM
  ODLN F
  INNER JOIN DLN1 I ON F."DocEntry" = I."DocEntry"
  INNER JOIN OINV T ON I."BaseEntry" = T."DocEntry"
WHERE
  T."isIns" = 'Y'