SELECT
  P."CardCode" AS "Código Cliente",
  P."CardName" AS "Nombre Cliente",
  T."PymntGroup" AS "Grupo de Pago",
FROM
  OCRD P
  INNER JOIN OCTG T ON P."GroupNum" = T."GroupNum"
Where
  "CardType" = 'S'