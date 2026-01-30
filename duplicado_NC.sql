SELECT
  "NC" as "Tipo Documento",
  T0."DocEntry" AS "Número Doc",
  T0."DocNum" AS "Numero SAP",
  T0."BPLId" AS "Sucursal",
  T0."DocDate" as "Fecha Documento",
  T0."FolioNum" AS "Folio SII"
FROM
  ORIN T0
WHERE
  T0."FolioNum" IN (
    SELECT
      "FolioNum"
    FROM
      ORIN
    GROUP BY
      "FolioNum"
    HAVING
      COUNT(*) > 1
  )