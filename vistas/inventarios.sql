CREATE
OR REPLACE VIEW VW_STOCK_BODEGA_GRUPO AS
SELECT
    LEFT(T0."ItemCode", 3) AS "TipoProd2",
    T0."ItemCode",
    T1."ItemName",
    T1."ItmsGrpCod",
    T5."ItmsGrpNam",
    T5."BalInvntAc",
    T6."Segment_0" AS "Cuenta",
    T0."WhsCode",
    T2."Location",
    T2."WhsName",
    T0."OnHand",
    T0."IsCommited" AS "Comprometido",
    T0."OnOrder" AS "Pedido",
    T1."InvntryUom",
    T0."AvgPrice" AS "Costo",
    T0."AvgPrice" * T0."OnHand" AS "CostoxInv"
FROM
    OITW T0
    INNER JOIN OITM T1 ON T1."ItemCode" = T0."ItemCode"
    INNER JOIN OWHS T2 ON T0."WhsCode" = T2."WhsCode"
    LEFT JOIN OLCT T4 ON T2."Location" = T4."Code"
    INNER JOIN OITB T5 ON T1."ItmsGrpCod" = T5."ItmsGrpCod"
    LEFT JOIN OACT T6 ON T6."AcctCode" = T5."BalInvntAc"
WHERE
    T0."OnHand" > 0;