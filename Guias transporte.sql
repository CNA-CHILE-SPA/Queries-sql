SELECT
  T3."DocEntry",
  T4."DocNum" AS "Primario Entrega",
  T0."NumAtCard" AS "N° OC",
  T4."DocNum" as "Priamrio Guia",
  T4."FolioNum" as "Folio GD",
  T2."FolioNum" as "Folio Factura Asoc.",
  T0."CardCode",
  T0."CardName",
  T3."ItemCode",
  T3."Dscription",
  T3."Quantity",
  T3."WhsCode",
  T4."DocDate",
  T12."BlockS" as "Comuna",
  T4."Comments",
  T4."Address2" AS "Direccion de despacho",
  T4."U_EXX_FE_CHOFER" AS "Nombre Conductor",
  T4."U_EXX_FE_RUTCHOFER" AS "RUT Conductor",
  T4."U_EXX_FE_RUTTRANSPORTISTA" AS "RUT Transportista",
  T4."U_EXX_FE_PATENTE" AS "Patente",
  T2."DocNum" as "N° Primario Factura",
  CASE
    T3."BaseType"
    WHEN '15' THEN 'Cancel'
    WHEN '13' THEN 'Desp. Reserva'
    WHEN '17' THEN 'Entrega Pedido'
    ELSE 'Sin Ref'
  END as BaseRef,
  T5."U_NAME"
FROM
  ORDR T0
  INNER JOIN INV1 T1 ON T0."DocEntry" = T1."BaseEntry"
  INNER JOIN OINV T2 ON T1."DocEntry" = T2."DocEntry"
  INNER JOIN DLN1 T3 ON T2."DocEntry" = T3."BaseEntry"
  AND T1."LineNum" = T3."BaseLine"
  INNER JOIN ODLN T4 ON T3."DocEntry" = T4."DocEntry"
  INNER JOIN DLN12 T12 ON T4."DocEntry" = T12."DocEntry"
  INNER JOIN OUSR T5 ON T4."UserSign" = T5."USERID"
WHERE
  T2."isIns" = 'Y'
UNION
ALL
SELECT
  T4."DocEntry",
  T4."DocNum" AS "Primario Entrega",
  T0."NumAtCard" AS "N° OC",
  T4."DocNum" as "Priamrio Guia",
  T4."FolioNum" as "Folio GD",
  T2."FolioNum" as "Folio Factura Asoc.",
  T0."CardCode",
  T0."CardName",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."WhsCode",
  T4."DocDate",
  T12."BlockS" as "Comuna",
  T4."Comments",
  T4."Address2" AS "Direccion de despacho",
  T4."U_EXX_FE_CHOFER" AS "Nombre Conductor",
  T4."U_EXX_FE_RUTCHOFER" AS "RUT Conductor",
  T4."U_EXX_FE_RUTTRANSPORTISTA" AS "RUT Transportista",
  T4."U_EXX_FE_PATENTE" AS "Patente",
  T2."DocNum" as "N° Primario Factura",
  CASE
    T1."BaseType"
    WHEN '15' THEN 'Cancel'
    WHEN '13' THEN 'Desp. Reserva'
    WHEN '17' THEN 'Entrega Pedido'
    ELSE 'Sin Ref'
  END as BaseRef,
  T3."U_NAME"
FROM
  ORDR T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."BaseEntry"
  INNER JOIN ODLN T4 ON T1."DocEntry" = T4."DocEntry"
  INNER JOIN INV1 T5 ON T4."DocEntry" = T5."BaseEntry"
  AND T1."LineNum" = T5."BaseLine"
  INNER JOIN OINV T2 ON T5."DocEntry" = T2."DocEntry"
  INNER JOIN DLN12 T12 ON T4."DocEntry" = T12."DocEntry"
  INNER JOIN OUSR T3 ON T4."UserSign" = T3."USERID"
WHERE
  T2."isIns" = 'N'
UNION
ALL
SELECT
  d."DocEntry",
  d."DocNum" AS "Primario Entrega",
  d."NumAtCard" AS "N° OC",
  d."DocNum" as "Priamrio Guia",
  d."FolioNum" as "Folio GD",
  CAST(NULL AS INTEGER) AS "Folio Factura Asoc.",
  d."CardCode",
  d."CardName",
  l."ItemCode",
  l."Dscription",
  l."Quantity",
  l."WhsCode",
  d."DocDate",
  t12."BlockS" as "Comuna",
  d."Comments",
  d."Address2" AS "Direccion de despacho",
  d."U_EXX_FE_CHOFER" AS "Nombre Conductor",
  d."U_EXX_FE_RUTCHOFER" AS "RUT Conductor",
  d."U_EXX_FE_RUTTRANSPORTISTA" AS "RUT Transportista",
  d."U_EXX_FE_PATENTE" AS "Patente",
  CAST(NULL AS INTEGER) AS "N° Primario Factura",
  CAST(NULL AS NVARCHAR(50)) AS "BaseRef",
  u."U_NAME"
FROM
  ODLN d
  JOIN "DLN1" l ON l."DocEntry" = d."DocEntry"
  JOIN "DLN12" t12 ON d."DocEntry" = t12."DocEntry"
  JOIN "OUSR" u ON d."UserSign" = u."USERID" -- Anti-join contra facturas de DEUDORES (OINV.isIns='N')
  LEFT JOIN (
    SELECT
      DISTINCT i1."BaseEntry"
    FROM
      "INV1" i1
      JOIN "OINV" i ON i."DocEntry" = i1."DocEntry"
    WHERE
      i1."BaseType" = 15 -- 15 = Entrega (ODLN)
      AND i."isIns" = 'N'
      AND i."CANCELED" = 'N'
  ) fd ON fd."BaseEntry" = d."DocEntry" -- Anti-join contra facturas de RESERVA (OINV.isIns='Y')
  LEFT JOIN (
    SELECT
      DISTINCT l2."DocEntry"
    FROM
      "DLN1" l2
      JOIN "OINV" i2 ON i2."DocEntry" = l2."BaseEntry"
    WHERE
      l2."BaseType" = 13 -- 13 = Factura (reserva) como base de la entrega
      AND i2."isIns" = 'Y'
      AND i2."CANCELED" = 'N'
  ) fr ON fr."DocEntry" = d."DocEntry"
WHERE
  fd."BaseEntry" IS NULL -- no tiene factura de deudores
  AND fr."DocEntry" IS NULL -- ni factura de reserva
ORDER BY
  "Folio GD"