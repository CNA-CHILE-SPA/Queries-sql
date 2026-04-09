select
    *
from
    OINV T0
    INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
    T0."CardCode" = 'CN77038897-K' --Fertiamerica
LIMIT
    10;