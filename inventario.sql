SELECT
    LEFT(T0."ItemCode", 3) as TipoProd2,
    T0."ItemCode",
    T1."ItemName",
    T1."ItmsGrpCod",
    T5."ItmsGrpNam",
    T5."BalInvntAc",
    (
        SELECT
            "Segment_0"
        FROM
            OACT
        WHERE
            "AcctCode" = T5."BalInvntAc"
    ) as CUENTA,
    T0."WhsCode",
    T2."Location",
    T2."WhsName",
    T0."OnHand",
    T0."IsCommited" as "Comprometido",
    T0."OnOrder" as "Pedido",
    T1."InvntryUom",
    T0."AvgPrice" as Costo,
    T0."AvgPrice" * T0."OnHand" as CostoxInv
from
    OITW T0
    inner join OITM T1 on T1."ItemCode" = T0."ItemCode"
    INNER JOIN OWHS T2 ON T0."WhsCode" = T2."WhsCode"
    LEFT JOIN "OLCT" T4 ON T2."Location" = T4."Code"
    INNER JOIN OITB T5 ON T1."ItmsGrpCod" = T5."ItmsGrpCod"
where
    T0."OnHand" > 0