select
    T0."DocEntry",
    T0."FolioNum",
    T1."ItemCode",
    T1."Dscription",
    T1."Quantity"
from
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CardCode" = 'CN 77038897-K' --Fertiamerica
