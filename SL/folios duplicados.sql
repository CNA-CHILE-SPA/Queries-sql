SELECT
    'FACTURA' as "Tipo Documento",
    T0."DocEntry" AS "Número Doc",
    T0."DocNum" AS "Numero SAP",
    T0."BPLId" AS "Sucursal",
    T0."DocDate" as "Fecha Documento",
    T0."FolioNum" AS "Folio SII"
FROM
    OINV T0
WHERE
    T0."isIns" = 'Y'
    and t0."DocSubType" = '--'
    AND T0."FolioNum" IN (
        SELECT
            "FolioNum"
        FROM
            OINV
        WHERE
            "isIns" = 'Y'
        GROUP BY
            "FolioNum"
        HAVING
            COUNT(*) > 1
    )
    AND LEFT(T0."DocNum", 1) not in ('1', '2')
UNION
ALL
SELECT
    'FACTURA' as "Tipo Documento",
    T0."DocEntry" AS "Número Doc",
    T0."DocNum" AS "Numero SAP",
    T0."BPLId" AS "Sucursal",
    T0."DocDate" as "Fecha Documento",
    T0."FolioNum" AS "Folio SII"
FROM
    OINV T0
WHERE
    T0."isIns" = 'N'
    and t0."DocSubType" = '--'
    AND T0."FolioNum" IN (
        SELECT
            "FolioNum"
        FROM
            OINV
        WHERE
            "isIns" = 'N'
        GROUP BY
            "FolioNum"
        HAVING
            COUNT(*) > 1
    )
    AND LEFT(T0."DocNum", 1) not in ('1', '2')
UNION
ALL
SELECT
    'NC' as "Tipo Documento",
    T0."DocEntry" AS "Número Doc",
    T0."DocNum" AS "Numero SAP",
    T0."BPLId" AS "Sucursal",
    T0."DocDate" as "Fecha Documento",
    T0."FolioNum" AS "Folio SII"
FROM
    ORIN T0
WHERE
    T0."FolioNum" IN (
        SELECT
            "FolioNum"
        FROM
            ORIN
        GROUP BY
            "FolioNum"
        HAVING
            COUNT(*) > 1
    )
UNION
ALL
SELECT
    'GD' as "Tipo Documento",
    T0."DocEntry" AS "Número Doc",
    T0."DocNum" AS "Numero SAP",
    T0."BPLId" AS "Sucursal",
    T0."DocDate" as "Fecha Documento",
    T0."FolioNum" AS "Folio SII"
FROM
    ODLN T0
WHERE
    T0."FolioNum" IN (
        SELECT
            "FolioNum"
        FROM
            ODLN
        GROUP BY
            "FolioNum"
        HAVING
            COUNT(*) > 1
    )
    AND LEFT(T0."DocNum", 1) not in ('1', '2')
    and T0."FolioNum" <> 0