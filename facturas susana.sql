SELECT 
T0."DocEntry",
T0."FolioNum",
T0."DocDate",
T0."DocDueDate"
FROM 
OINV T0
INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
T1."ItemCode" = 'MPL008'