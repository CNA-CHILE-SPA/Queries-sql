SELECT
  'Entrada De Mercancía' AS "Tipo",
  T0."DocNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."WhsCode",
  T0."DocDate",
  T0."TaxDate",
  U."U_NAME" AS "UsuarioCreador",
  T0."Comments",
  T2."FormatCode"
FROM
  OIGN T0
  INNER JOIN IGN1 T1 ON T0."DocEntry" = T1."DocEntry"
  LEFT JOIN OUSR U ON T0."UserSign" = U."USERID"
  INNER JOIN OACT T2 ON T1."AcctCode" = T2."AcctCode"
UNION
ALL
SELECT
  'Salida De Mercancía' AS "Tipo",
  T0."DocNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."WhsCode",
  T0."DocDate",
  T0."TaxDate",
  U."U_NAME" AS "UsuarioCreador",
  T0."Comments",
  T2."FormatCode"
FROM
  OIGE T0
  INNER JOIN IGE1 T1 ON T0."DocEntry" = T1."DocEntry"
  LEFT JOIN OUSR U ON T0."UserSign" = U."USERID"
  INNER JOIN OACT T2 ON T1."AcctCode" = T2."AcctCode" -- OACT."FormatCode"