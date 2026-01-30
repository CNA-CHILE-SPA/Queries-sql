SELECT
  'CNA' AS "Empresa",
  T0."CardCode",
  T0."CardName",
  T2."DocDate" as "Fecha de Orden",
  T0."NumAtCard" as "Nº Orden Compra",
  T0."DocNum" as "Nº SAP Factura",
  T0."DocDate" as "Fecha de Factura",
  T0."FolioPref",
  T0."FolioNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity" as "Cantidad Total Facturada",
  T1."PriceBefDi",
  T1."OpenQty" as "Cantidad pendiente despacho",
  T1."OpenCreQty",
  T1."PriceBefDi" * T1."OpenQty" AS "Total pendiente",
  T1."unitMsr",
  T3."WhsName"
FROM
  OINV T0
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN ORDR T2 ON T0."NumAtCard" = T2."NumAtCard"
  INNER JOIN OWHS T3 ON T1."WhsCode" = T3."WhsCode"
WHERE
  T1."OpenQty" > 0
  and (
    t0."DocNum" LIKE '3%'
    or t0."DocNum" LIKE '1%'
  )
UNION
ALL
SELECT
  'FA' AS "Empresa",
  T0."CardCode",
  T0."CardName",
  T2."DocDate" as "Fecha de Orden",
  T0."NumAtCard" as "Nº Orden Compra",
  T0."DocNum" as "Nº SAP Factura",
  T0."DocDate" as "Fecha de Factura",
  T0."FolioPref",
  T0."FolioNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity" as "Cantidad Total Facturada",
  T1."PriceBefDi",
  T1."OpenQty" as "Cantidad pendiente despacho",
  T1."OpenCreQty",
  T1."PriceBefDi" * T1."OpenQty" AS "Total pendiente",
  T1."unitMsr",
  T3."WhsName"
FROM
  OINV T0
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN ORDR T2 ON T0."NumAtCard" = T2."NumAtCard"
  INNER JOIN OWHS T3 ON T1."WhsCode" = T3."WhsCode"
WHERE
  T1."OpenQty" > 0
  and (
    t0."DocNum" LIKE '4%'
    or t0."DocNum" LIKE '2%'
  )