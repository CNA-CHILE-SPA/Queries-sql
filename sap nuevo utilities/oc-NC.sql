SELECT
  NC."DocEntry" AS "DocEntry",
  NC."DocNum" AS "Numero documento",
  Nc."NumAtCard" AS "Nº Orden Compra",
  D."ItemCode" AS "Codigo producto",
  D."Dscription" AS "Descripcion producto",
  D."Quantity" AS "Cantidad",
  NC."DocType" AS "Tipo documento"
FROM
  ORIN NC
  INNER JOIN RIN1 D ON NC."DocEntry" = D."DocEntry"
WHERE
  NC."DocType" = 'I' -- Tipo de documento de nota de crédito