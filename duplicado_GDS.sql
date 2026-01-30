SELECT
  "GD" as "Tipo Documento",
  T0."DocEntry" AS "Número Doc",
  T0."DocNum" AS "Numero SAP",
  T0."BPLId" AS "Sucursal",
  T0."DocDate" as "Fecha Documento",
  T0."FolioNum" AS "Folio SII"
FROM
  ODLN T0
WHERE
  T0."FolioNum" IN (
    SELECT
      "FolioNum"
    FROM
      ODLN
    GROUP BY
      "FolioNum"
    HAVING
      COUNT(*) > 1
  )
  AND LEFT(T0."DocNum", 1) not in ('1', '2')
  and T0."FolioNum" <> 0