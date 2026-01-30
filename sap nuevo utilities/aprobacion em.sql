SELECT 
    CASE 
        WHEN IFNULL(CAST($[OPDN."DocTotalSy".0.0] AS DECIMAL(19,6)), 0) > 2000000
        AND $[OPDN."CardCode".0.0] like 'CN%'
        THEN 'True'
        ELSE 'False'
    END
FROM DUMMY;