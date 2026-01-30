SELECT
  T0."BPLId",
  T0."DocEntry",
  T1."BaseRef",
  CASE
    T1."BaseType"
    WHEN '13' THEN 'FacturaReserva'
    WHEN '17' THEN 'OrdendeVenta'
    ELSE 'Otro'
  END as Base,
  T0."FolioPref",
  T0."FolioNum",
  T0."DocDate",
  T0."DocNum",
  T0."Address2",
  T2."StreetS",
  T2."BlockS",
  T2."CityS",
  T2."StateS",
  T2."StateS",
  T2."CountryS",
  T2."StreetNoS",
  T0."CANCELED",
  T0."CardCode",
  T0."CardName",
  T0."NumAtCard",
  -- T0."U_EXX_FE_RUTCHOFER",
  -- T0."U_EXX_FE_CHOFER",
  -- T0."U_EXX_FE_RUTTRANSPORTISTA",
  -- T0."U_EXX_FE_PATENTE",
  T0."Comments",
  T1."LineNum",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."Price",
  T1."Currency",
  T1."LineTotal",
  T1."TotalFrgn",
  T1."WhsCode",
  T3."U_NAME"
FROM
  ODLN T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN DLN12 T2 ON T0."DocEntry" = T2."DocEntry"
  INNER JOIN OUSR T3 ON T0."UserSign" = T3."USERID"