SELECT
    B."DistNumber" AS "NumeroLote",
    Q."ItemCode" AS "Articulo",
    Q."Quantity" AS "Cantidad",
    Q."WhsCode" AS "Bodega",
    B."CreateDate" AS "FechaCreacion"
FROM
    "OBTQ" Q
    INNER JOIN "OBTN" B ON B."AbsEntry" = Q."MdAbsEntry"
WHERE
    Q."ItemCode" = '[%0]'
    AND Q."WhsCode" = '[%1]'
    AND Q."Quantity" <> 0
ORDER BY
    B."CreateDate" ASC;