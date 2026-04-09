SELECT
    T0."DocEntry" as "ID",
    T0."DocNum" as "N° Primario",
    T0."DocDate" as "Fecha Emisión",
    T0."CardCode" as "Código de Cliente",
    T0."CardName" as "Nombre de Cliente",
    T0."DocTotal" as "Monto Total",
    T0."DocTotalSy" as "Monto Total CLP",
    T0."FolioNum" as "Número de Folio"
FROM
    OINV T0