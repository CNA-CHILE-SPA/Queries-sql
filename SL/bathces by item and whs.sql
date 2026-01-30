SELECT
    B." DistNumber " AS " NumeroLote ",
    Q." ItemCode " AS " Articulo ",
    Q." Quantity " AS " Cantidad ",
    Q." WhsCode " AS " Bodega ",
    B." CreateDate " AS " FechaCreacion "
FROM
    " OBTQ " Q
    JOIN " OBTN " B ON B." AbsEntry " = Q." MdAbsEntry "
WHERE
    Q." ItemCode " = :itemCode Q." WhsCode " = :whsCode
    AND Q." Quantity " <> 0
ORDER BY
    Q." WhsCode ",
    B." DistNumber"