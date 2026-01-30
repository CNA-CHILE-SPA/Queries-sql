SELECT
  T0."DocEntry" AS "Número Doc",
  T0."DocNum" AS "Numero SAP",
  T0."BPLId" AS "Sucursal",
  T0."DocDate" as "Fecha Documento",
  T0."FolioNum" AS "Folio SII"
FROM
  OINV T0
WHERE
  T0."isIns" = 'Y'
  and t0."DocSubType" = '--'
  AND T0."FolioNum" IN (
    SELECT
      "FolioNum"
    FROM
      OINV
    WHERE
      "isIns" = 'Y'
    GROUP BY
      "FolioNum"
    HAVING
      COUNT(*) > 1
  )
  AND LEFT(T0."DocNum", 1) not in ('1', '2')
UNION
ALL
SELECT
  T0."DocEntry" AS "Número Doc",
  T0."DocNum" AS "Numero SAP",
  T0."BPLId" AS "Sucursal",
  T0."DocDate" as "Fecha Documento",
  T0."FolioNum" AS "Folio SII"
FROM
  OINV T0
WHERE
  T0."isIns" = 'N'
  and t0."DocSubType" = '--'
  AND T0."FolioNum" IN (
    SELECT
      "FolioNum"
    FROM
      OINV
    WHERE
      "isIns" = 'N'
    GROUP BY
      "FolioNum"
    HAVING
      COUNT(*) > 1
  )
  AND LEFT(T0."DocNum", 1) not in ('1', '2')