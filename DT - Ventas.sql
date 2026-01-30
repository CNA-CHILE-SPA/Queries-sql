--- FACTURAS --
SELECT
  T0."DocEntry",
  CASE
    T0."DocSubType"
    WHEN 'IX' THEN 'FACTURA EXPORTACION'
    WHEN 'DN' THEN 'Nota de Débito'
    WHEN 'IE' THEN 'FACTURA EXENTA'
    WHEN '--' THEN CASE
      T0."isIns"
      WHEN 'Y' THEN 'Factura de Reserva'
      WHEN 'N' THEN 'Facturas de Deudores'
    END
  END AS "Tipo",
  T0."DocNum",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T0."DocDate" AS "Fecha Contabilización",
  T0."DocDueDate" AS "Fecha Vencimiento",
  T0."TaxDate" AS "Fecha Documento",
  T0."FolioPref" AS "Prefijo",
  T0."FolioNum" AS "Folio SII",
  T2."PymntGroup" AS "Condición de Pago",
  T1."ItemCode" AS "Código Producto",
  T1."Dscription" AS "Descripción",
  T3."InvntryUom" AS "Unidad de Medida",
  T1."Quantity" AS "Cantidad",
  T1."Price" AS "Precio Unitario",
  T1."Currency" AS "Moneda Línea",
  T1."TotalFrgn" AS "Línea Antes de Impuesto CLP",
  T1."LineTotal" AS "Línea Antes de Impuesto USD",
  T1."VatSumFrgn" AS "IVA Línea CLP",
  T1."VatSumSy" AS "IVA Línea USD",
  T1."GTotalFC" AS "TOTAL Línea CLP",
  T1."GTotalSC" AS "TOTAL Línea USD",
  T0."DocCur" AS "Moneda",
  T0."DocRate" AS "Tasa de Cambio",
  T0."DocTotal" / 1.19 AS "Total Antes de Impuesto Documento USD",
  T0."DocTotalFC" / 1.19 AS "Total Antes de Impuesto Documento CLP",
  T0."VatSum" AS "IVA Documento USD",
  T0."VatSumFC" AS "IVA Documento CLP",
  T0."DocTotal" AS "Total Documento USD",
  T0."DocTotalFC" AS "Total Documento CLP",
  T0."U_EXX_FE_TDBSII" as "Tipo Documento Base SII",
  T0."U_EXX_FE_FOLIODB" AS "Folio Documento Base SII",
  T0."U_EXX_FE_FECHADB" AS "Fecha Documento Base SII"
FROM
  OINV T0
  INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum"
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OITM T3 ON T1."ItemCode" = T3."ItemCode"
WHERE
  T0."DocSubType" != 'IB' -- NOTAS CREDITO --
UNION
ALL
SELECT
  T0."DocEntry",
  'Nota de Crédito' AS "Tipo",
  T0."DocNum",
  T0."CardCode" AS "Codigo Cliente",
  T0."CardName" AS "Razón Social",
  T0."DocDate" AS "Fecha Contabilización",
  T0."DocDueDate" AS "Fecha Vencimiento",
  T0."TaxDate" AS "Fecha Documento",
  T0."FolioPref" AS "Prefijo",
  T0."FolioNum" AS "Folio SII",
  T2."PymntGroup" AS "Condición de Pago",
  T1."ItemCode" AS "Código Producto",
  T1."Dscription" AS "Descripción",
  T3."InvntryUom" AS "Unidad de Medida",
  T1."Quantity" AS "Cantidad",
  T1."Price" AS "Precio Unitario",
  T1."Currency" AS "Moneda Línea",
  T1."TotalFrgn" AS "Línea Antes de Impuesto CLP",
  T1."LineTotal" AS "Línea Antes de Impuesto USD",
  T1."VatSumFrgn" AS "IVA Línea CLP",
  T1."VatSumSy" AS "IVA Línea USD",
  T1."GTotalFC" AS "TOTAL Línea CLP",
  T1."GTotalSC" AS "TOTAL Línea USD",
  T0."DocCur" AS "Moneda",
  T0."DocRate" AS "Tasa de Cambio",
  T0."DocTotal" / 1.19 AS "Total Antes de Impuesto Documento USD",
  T0."DocTotalFC" / 1.19 AS "Total Antes de Impuesto Documento CLP",
  T0."VatSum" AS "IVA Documento USD",
  T0."VatSumFC" AS "IVA Documento CLP",
  T0."DocTotal" AS "Total Documento USD",
  T0."DocTotalFC" AS "Total Documento CLP",
  T0."U_EXX_FE_TDBSII" as "Tipo Documento Base SII",
  T0."U_EXX_FE_FOLIODB" AS "Folio Documento Base SII",
  T0."U_EXX_FE_FECHADB" AS "Fecha Documento Base SII"
FROM
  ORIN T0
  INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum"
  INNER JOIN RIN1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN OITM T3 ON T1."ItemCode" = T3."ItemCode"