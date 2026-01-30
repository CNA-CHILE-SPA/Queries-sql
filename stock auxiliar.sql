SELECT
  OITM."ItemCode" AS "Código",
  OITM."ItemName" AS "Descripción",
  OITW."WhsCode" AS "Código Bodega",
  OWHS."WhsName" AS "Nombre Bodega",
  OITW."OnHand" AS "Stock Actual"
FROM
  OITM
  JOIN OITW ON OITM."ItemCode" = OITW."ItemCode"
  JOIN OWHS ON OITW."WhsCode" = OWHS."WhsCode"
WHERE
  OITM."InvntItem" = 'Y'
  AND OITW."OnHand" > 0
  AND OWHS."U_TP_ALMACEN" = 'AUXILIAR'
ORDER BY
  OITM."ItemCode",
  OITW."WhsCode";