SELECT
  T1."DocEntry",
  T0."DocNum" AS "Primario Entrega",
  T0."FolioNum",
  T4."FolioNum" as "Folio Factura Asoc.",
  T4."DocNum" AS "DocNum_",
  --, T0."DocTime" AS "Hora de generación"
  --, T1."U_SEI_NUMEROSOLICITUD"
  T0."CardCode",
  T0."CardName",
  T0."DocStatus",
  T1."ItemCode",
  T1."Dscription",
  T1."Quantity",
  T1."WhsCode",
  T0."DocDate",
  T0."NumAtCard" --, T0."U_SEI_FOREF" 
  --,T7."U_SEI_NROSOLICITUD" AS "NRO SOL CLIENTE"
  -- ,T7."U_SEI_COMUNA"
,
  T12."CityS" -- , T7."U_SEI_CONTACTO"
  -- ,T7."U_SEI_FONO"
  -- ,T7."U_SEI_TIPOCAMION"
,
  T0."Comments" -- , T7."U_SEI_Observacion"
,
  T0."Address2" AS "Direccion de despacho",
  -- T0."U_SEI_NCHF" AS "Nombre Conductor",
  -- T0."U_SEI_RTCH" AS "RUT Conductor",
  -- T0."U_SEI_RTTR",
  -- T0."U_SEI_PTT" 
  --, T12."CountyS"
  --,T0."UserSign"
  T3."U_NAME",
  T4."DocEntry",
  T8."SlpName",
  T1."U_EXX_FE_Descripcion"
FROM
  ODLN T0
  INNER JOIN DLN1 T1 ON T0."DocEntry" = T1."DocEntry"
  INNER JOIN DLN12 T12 ON T0."DocEntry" = T12."DocEntry"
  INNER JOIN OUSR T3 ON T0."UserSign" = T3."USERID"
  LEFT JOIN OINV T4 ON T1."BaseEntry" = T4."DocEntry"
  INNER JOIN OSLP T8 ON T0."SlpCode" = T8."SlpCode" -- LEFT JOIN "@SEI_SOLICITUDET" T6 ON T1."U_SEI_NROSOL"=T6."DocEntry" AND TO_VARCHAR(T6."LineId") = TO_VARCHAR(T1."U_SEI_LINEID")
  -- LEFT JOIN "@SEI_SOLICITUDC" T7 ON T6."DocEntry"=T7."DocEntry"
ORDER BY
  T0."FolioNum" DESC