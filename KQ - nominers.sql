SELECT
  F."DocEntry" AS "Nro SAP Factura",
  F."CardCode" AS "Código Cliente",
  SN."CardName" AS "Nombre Cliente",
  SN."LicTradNum",
  F."FolioNum" AS "Folio",
  F."DocDate" AS "Fecha",
  F."DocDueDate" AS "Fecha Vencimiento",
  F."DocCur" AS "Moneda",
  F."DocRate" AS "Tasa Cambio",
  F."DocTotal" AS "Total",
  F."DocTotalSy" as "Total SY",
  F."DocTotalFC" AS "Total FC",
  F."U_EXX_FE_EstadoCes" AS "Estado Cesión",
  F."U_EXX_FE_Estado" AS "Estado",
  SN."U_EstadoLinea",
  SN."U_Cobertura",
  -- Cantidad entregada
  COALESCE(SUM(I."Quantity") - SUM(I."OpenQty"), 0) AS "Entregado",
  -- Cantidad pendiente de entrega
  COALESCE(SUM(I."OpenQty"), 0) AS "PendienteEntrega"
FROM
  OINV F
  INNER JOIN OCRD SN ON F."CardCode" = SN."CardCode"
  LEFT JOIN RIN1 RNC ON F."DocEntry" = RNC."BaseEntry"
  LEFT JOIN ORIN NC ON RNC."DocEntry" = NC."DocEntry" -- Agregar líneas de factura
  LEFT JOIN INV1 I ON I."DocEntry" = F."DocEntry"
WHERE
  F."DocDueDate" >= CURRENT_DATE
  AND F."DocDueDate" <= ADD_DAYS(CURRENT_DATE, 180)
  AND NC."DocNum" IS NULL
  AND (
    F."U_EXX_FE_EstadoCes" = 'NCE'
    OR F."U_EXX_FE_EstadoCes" IS NULL
  )
  AND (
    F."U_EXX_FE_Estado" = 'AUT'
    OR F."U_EXX_FE_Estado" = 'ACD'
  )
  AND F."PaidToDate" = 0
  AND F."BPLId" = 1
GROUP BY
  F."DocEntry",
  F."CardCode",
  SN."CardName",
  SN."LicTradNum",
  F."FolioNum",
  F."DocDate",
  F."DocDueDate",
  F."DocCur",
  F."DocRate",
  F."DocTotal",
  F."DocTotalSy",
  F."DocTotalFC",
  F."U_EXX_FE_EstadoCes",
  F."U_EXX_FE_Estado",
  SN."U_EstadoLinea",
  SN."U_Cobertura"