SELECT
  T0."DocNum",
  T0."FolioNum",
  T0."CardCode",
  T0."CardName",
  T0."DocDate",
  T0."DocCur",
  T0."DocTotal",
  T0."DocTotalFC",
  T0."U_EXX_FE_FechaCes",
  T0."U_EXX_FE_RutCes",
  T1."CardName" AS "Razon Social Cesionario"
FROM
  OINV T0
  INNER JOIN OCRD T1 ON T0."U_EXX_FE_RutCes" = T1."LicTradNum"
WHERE
  T0."U_EXX_FE_EstadoCes" = 'AUT'