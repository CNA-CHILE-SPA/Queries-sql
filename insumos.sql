SELECT
  T0."Code" AS "Codigos",
  T0."Name",
  T1."Code" AS "Código Insumo",
  T1."ItemName",
  T1."Quantity" AS "Dosificación",
  T2."InvntryUom" AS "Unidad de Medida"
FROM
  OITT T0
  LEFT JOIN ITT1 T1 ON T0."Code" = T1."Father"
  LEFT JOIN OITM T2 ON T1."Code" = T2."ItemCode"
WHERE
  T0."Code" NOT IN (
    SELECT
      T0."Code"
    FROM
      OITT T0
      LEFT JOIN ITT1 T1 ON T0."Code" = T1."Father"
      LEFT JOIN OITM T2 ON T1."Code" = T2."ItemCode"
    WHERE
      T2."validFor" = 'N'
  )