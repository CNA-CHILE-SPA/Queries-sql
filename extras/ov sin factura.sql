SELECT
    DISTINCT ov."DocEntry" AS OV_DocEntry,
    CASE
        ov."BPLId"
        WHEN 1 THEN 'CNA'
        WHEN 2 THEN 'FA'
        ELSE 'Otra Sucursal'
    END AS "Sucursal",
    ov."DocNum" AS OV_DocNum,
    ov."NumAtCard" AS OV_NumAtCard,
    ov."DocDate" AS OV_Fecha,
    ov."CardCode" AS Cliente_Codigo,
    ov."CardName" AS Cliente_Nombre,
    ov."DocStatus" AS Estado_OV,
    ov."DocTotal" AS "total USD",
    ov."DocTotalSy" AS "total Pesos",
    ovl."LineNum" AS Linea,
    ovl."ItemCode" AS Codigo_Item,
    ovl."Dscription" AS Nombre_Item,
    ovl."Quantity" AS Cantidad_Total,
    ovl."OpenQty" AS Cantidad_Pendiente,
    ovl."LineTotal" AS Total_Linea
FROM
    "ORDR" ov
    JOIN "RDR1" ovl ON ov."DocEntry" = ovl."DocEntry"
WHERE
    ovl."OpenQty" = ovl."Quantity" -- Cantidad pendiente igual a cantidad original = Sin facturar
    AND ov."CANCELED" = 'N' -- Excluir OV canceladas (opcional)
    AND ov."DocStatus" = 'O' -- Solo OV abiertas
ORDER BY
    ov."DocDate" DESC,
    ov."DocNum" DESC,
    ovl."LineNum" ASC;