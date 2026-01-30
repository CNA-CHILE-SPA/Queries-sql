SELECT
    *
FROM
    (
        SELECT
            OP."DocNum" AS "OC_Numero",
            OP."DocEntry" AS "OC_DocEntry",
            OPL."LineNum" AS "OC_Linea",
            OP."CardCode" AS "Proveedor",
            OP."CardName" AS "Nombre Proveedor",
            IFNULL (
                (
                    SELECT
                        MIN(PD."DocNum")
                    FROM
                        PDN1 PDL
                        INNER JOIN OPDN PD ON PD."DocEntry" = PDL."DocEntry"
                    WHERE
                        PDL."BaseType" = 22 -- OC
                        AND PD."CANCELED" = 'N'
                        AND PDL."BaseEntry" = OPL."DocEntry"
                        AND PDL."BaseLine" = OPL."LineNum"
                ),
                NULL
            ) AS "EM_Numero",
            OPL."ItemCode" AS "Código Artículo",
            OPL."Dscription" AS "Descripción",
            OPL."Quantity" AS "Cantidad Pedida",
            /* Aquí la subconsulta va “dentro” y usa la línea base */
            IFNULL (
                (
                    SELECT
                        SUM(PDL."Quantity")
                    FROM
                        PDN1 PDL
                        INNER JOIN OPDN PD ON PD."DocEntry" = PDL."DocEntry"
                    WHERE
                        PDL."BaseType" = 22 -- OC
                        AND PD."CANCELED" = 'N'
                        AND PDL."BaseEntry" = OPL."DocEntry" -- misma OC
                        AND PDL."BaseLine" = OPL."LineNum" -- misma línea
                ),
                0
            ) AS "Cantidad Recepcionada",
            (
                OPL."Quantity" - IFNULL (
                    (
                        SELECT
                            SUM(PDL."Quantity")
                        FROM
                            PDN1 PDL
                            INNER JOIN OPDN PD ON PD."DocEntry" = PDL."DocEntry"
                        WHERE
                            PDL."BaseType" = 22
                            AND PD."CANCELED" = 'N'
                            AND PDL."BaseEntry" = OPL."DocEntry"
                            AND PDL."BaseLine" = OPL."LineNum"
                    ),
                    0
                )
            ) AS "Diferencia"
        FROM
            OPOR OP
            INNER JOIN POR1 OPL ON OP."DocEntry" = OPL."DocEntry"
        ORDER BY
            OP."DocNum",
            OPL."LineNum"
    ) X
WHERE
    X."Diferencia" < 0