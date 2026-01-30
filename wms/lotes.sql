SELECT
    B."DistNumber" AS "NumeroLote",
    Q."ItemCode" AS "Articulo",
    Q."Quantity" AS "Cantidad",
    Q."WhsCode" AS "Bodega",
    COALESCE(B."CreateDate", B."InDate") AS "FechaCreacion"
FROM
    "OBTQ" Q
    JOIN "OBTN" B ON B."AbsEntry" = Q."MdAbsEntry"
WHERE
    Q."Quantity" <> 0