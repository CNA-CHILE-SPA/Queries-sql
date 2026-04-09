SELECT
    T1."DocEntry",
    T1."ItemCode" as "Codigo Articulo",
    T1."Dscription" as "Descripcion",
    T1."Quantity" as "Cantidad",
    T1."WhsCode" as "Bodega",
    T2."WhsName" as "Nombre Bodega"
FROM
    INV1 T1
    INNER JOIN OWHS T2 ON T1."WhsCode" = T2."WhsCode"