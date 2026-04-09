SELECT
    case
        when T0."U_Cobertura" > 0 then 'Si'
        when ifnull(T0."U_Cobertura", 0) < 1 then 'No'
    end
FROM
    OCRD T0
WHERE
    T0."CardCode" = $[$4.0.0]