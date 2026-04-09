select
    T0."DocEntry" as "ID",
    T0."DocNum" as "N° Primario",
    T0."DocDate" as "Fecha Emisión",
    T0."CardCode" as "Código de Cliente",
    T0."CardName" as "Nombre de Cliente",
    T0."DocTotal" as "Monto Total",
    T0."DocTotalSy" as "Monto Total CLP",
    T0."FolioNum" as "Número de Folio",
    T1."ItemCode" as "Código de Producto",
    T1."Dscription" as "Descripción",
    T1."Quantity" as "Cantidad",
    T1."WhsCode" as "Codigo Bodega"
from
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
LIMIT
    50;