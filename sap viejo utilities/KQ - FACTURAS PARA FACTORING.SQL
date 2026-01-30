select
  f."LicTradNum",
  a."CardName",
  f."U_ZA_Estadolinea",
  f."U_ZA_Cobertura",
  a."FolioNum",
  a."U_ZA_Asegurada",
  a."DocDate",
  a."DocDueDate",
  days_between(CURRENT_DATE, a."DocDueDate") as DIASHASTA,
  CASE
    when days_between(CURRENT_DATE, a."DocDueDate") <= 30 then '15 - 30'
    when days_between(CURRENT_DATE, a."DocDueDate") <= 60 then '31 - 60'
    when days_between(CURRENT_DATE, a."DocDueDate") <= 90 then '61 - 90'
    when days_between(CURRENT_DATE, a."DocDueDate") <= 120 then '91 - 120'
    when days_between(CURRENT_DATE, a."DocDueDate") <= 150 then '121 - 150'
    else '151 - 180'
  END as RANGO,
  (
    CASE
      a."isIns"
      WHEN 'Y' THEN 'Reserva'
      ELSE 'Factura Deudor'
    END
  ) as TipoFac,
  a."DocCur",
  (1 / a."DocRate") as USD,
  a."DocTotal" as MontoTotalUSD,
  a."DocTotalFC" as MontoTotalCPL,
  E."SlpName",
  (
    CASE
      a."isIns"
      WHEN 'Y' THEN (
        select
          sum(TT."OpenQty")
        from
          INV1 TT
        where
          TT."DocEntry" = a."DocEntry"
      )
      ELSE 0
    END
  ) as PorDespachar,
  (
    CASE
      a."isIns"
      WHEN 'Y' THEN (
        CASE
          (
            select
              sum(TT."OpenQty")
            from
              INV1 TT
            where
              TT."DocEntry" = a."DocEntry"
          )
          when 0 then 'Despachado'
          ELSE (
            CASE
              (
                select
                  (sum(TT."Quantity") - sum(TT."OpenQty"))
                from
                  INV1 TT
                where
                  TT."DocEntry" = a."DocEntry"
              )
              when 0 then 'No Despachado'
              ELSE 'Despachado Parcialmente'
            END
          )
        END
      )
      ELSE 'Despachado'
    END
  ) as StatusDespa,
  (
    select
      COUNT(*)
    from
      "@ZA_GESTIONCOBROUDO" T0
    where
      T0."U_ZA_FolioNum" = a."FolioNum"
  ) as Documentada,
  (
    select
      COUNT(*)
    from
      "@ZA_GESTIONCOBROUDO" T0
      inner JOIN "@ZA_CHEQUE" T1 on T0."Code" = T1."Code"
    where
      T0."U_ZA_FolioNum" = a."FolioNum"
  ) as CHEQUE,
  (
    select
      COUNT(*)
    from
      "@ZA_GESTIONCOBROUDO" T0
      inner JOIN "@ZA_PRORROGA" T2 on T0."Code" = T2."Code"
    where
      T0."U_ZA_FolioNum" = a."FolioNum"
  ) as PRORROGA,
  (
    select
      COUNT(*)
    from
      "@ZA_GESTIONCOBROUDO" T0
      inner JOIN "@ZA_COMPROPAGO" T2 on T0."Code" = T2."Code"
    where
      T0."U_ZA_FolioNum" = a."FolioNum"
  ) as COMPROMISO_PAGO
from
  "OINV" as a
  left join "OCRD" as f on a."CardCode" = f."CardCode"
  LEFT JOIN OSLP E ON E."SlpCode" = a."SlpCode"
where
  days_between(CURRENT_DATE, a."DocDueDate") >= 15
  AND days_between(CURRENT_DATE, a."DocDueDate") <= 180
  AND a."CANCELED" = 'N'
  AND a."DocStatus" = 'O'
  AND a."PaidToDate" = 0
  AND a."Indicator" = '33'
  AND f."U_SEI_FACTORY" = 'S'
  AND (
    SELECT
      COUNT(*)
    from
      "@SEI_CEDDOC1" T0
    where
      T0."U_Folio" = a."FolioNum"
  ) = 0
  AND (
    SELECT
      COUNT(*)
    from
      "RIN1" T0
    where
      T0."BaseEntry" = a."DocEntry"
  ) = 0
  AND a."U_ZA_Clase" is null
order by
  a."DocDate"