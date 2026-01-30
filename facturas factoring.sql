SELECT
    F."DocEntry" AS "Nro SAP Factura",
    F."DocNum",
    F."CardCode" AS "Código Cliente",
    SN."CardName" AS "Nombre Cliente",
    F."FolioNum" AS "Folio",
    F."DocDate" AS "Fecha",
    F."DocDueDate" AS "Fecha Vencimiento",
    F."DocCur" AS "Moneda",
    F."DocRate" AS "Tasa Cambio",
    F."DocTotal" AS "Total",
    F."DocTotalSy" AS "Total SY",
    F."DocTotalFC" AS "Total FC",
    F."U_EXX_FE_EstadoCes" AS "Estado Cesión",
    F."U_EXX_FE_FechaCes" AS "Fecha Cesión",
    F."U_EXX_FE_Estado" AS "Estado",
    SN."U_EstadoLinea",
    SN."U_Cobertura",
    -- Cantidad entregada
    COALESCE(SUM(I."Quantity") - SUM(I."OpenQty"), 0) AS "Entregado",
    -- Cantidad pendiente de entrega
    COALESCE(SUM(I."OpenQty"), 0) AS "PendienteEntrega",
    F."PaidToDate" AS "Total Pagado",
    NC."FolioNum" as "Nota de Crédito Asociada"
FROM
    OINV F
    INNER JOIN OCRD SN ON F."CardCode" = SN."CardCode"
    LEFT JOIN INV1 I ON I."DocEntry" = F."DocEntry"
    LEFT JOIN RIN1 RNC ON F."DocEntry" = RNC."BaseEntry"
    LEFT JOIN ORIN NC ON RNC."DocEntry" = NC."DocEntry"
where
    F."BPLId" = 1
GROUP BY
    F."DocEntry",
    F."DocNum",
    F."CardCode",
    SN."CardName",
    F."FolioNum",
    F."DocDate",
    F."DocDueDate",
    F."DocCur",
    F."DocRate",
    F."DocTotal",
    F."DocTotalSy",
    F."DocTotalFC",
    F."U_EXX_FE_EstadoCes",
    F."U_EXX_FE_FechaCes",
    F."U_EXX_FE_Estado",
    SN."U_EstadoLinea",
    SN."U_Cobertura",
    F."PaidToDate",
    NC."FolioNum"