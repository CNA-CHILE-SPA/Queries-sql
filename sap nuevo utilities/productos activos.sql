SELECT
  T0."ItemCode",
  T0."ItemName",
  case
    T0."ValidFor"
    when 'Y' then 'Activo'
    when 'N' then 'Inactivo'
    else 'Desconocido'
  end AS "Estado"
FROM
  OITM T0