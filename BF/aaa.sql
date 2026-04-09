SELECT
    T0."CatName" AS "Query Category",
    T1."IntrnalKey" AS "Query Internal Key",
    T1."QName" AS "Query Name",
    T2."Refresh" AS "Auto Refresh",
    T2."FrceRfrsh" AS "Refresh Regularly",
    T2."ByField" AS "If Refreshed by Header Field",
    CASE
        WHEN T2."FormID" = '85' THEN 'Pick List'
        WHEN T2."FormID" = '133' THEN 'A/R Invoice'
        WHEN T2."FormID" = '134' THEN 'Business Partner Master Data'
        WHEN T2."FormID" = '139' THEN 'Order'
        WHEN T2."FormID" = '140' THEN 'Delivery'
        WHEN T2."FormID" = '141' THEN 'A/P Invoice'
        WHEN T2."FormID" = '142' THEN 'Purchase Order'
        WHEN T2."FormID" = '143' THEN 'Goods Receipt PO'
        WHEN T2."FormID" = '146' THEN 'Payment Means'
        WHEN T2."FormID" = '149' THEN 'Quotation'
        WHEN T2."FormID" = '150' THEN 'Item Master Data'
        WHEN T2."FormID" = '179' THEN 'A/R Credit Memo'
        WHEN T2."FormID" = '180' THEN 'Returns'
        WHEN T2."FormID" = '181' THEN 'A/P Credit Memo'
        WHEN T2."FormID" = '182' THEN 'Goods Returns'
        WHEN T2."FormID" = '60110' THEN 'Service Call'
        WHEN T2."FormID" = '65300' THEN 'A/R Down Payment'
        WHEN T2."FormID" = '65301' THEN 'A/P Down Payment'
        WHEN T2."FormID" = '65302' THEN 'A/R Invoice Exempt'
        WHEN T2."FormID" = '65303' THEN 'A/R Debit Memo'
        WHEN T2."FormID" = '65304' THEN 'A/R Bill'
        WHEN T2."FormID" = '65305' THEN 'A/R Exempt Bill'
        WHEN T2."FormID" = '65306' THEN 'A/P Debit Memo'
        WHEN T2."FormID" = '65307' THEN 'A/R Export Invoice'
        WHEN T2."FormID" = '65308' THEN 'A/R Down Payment Request'
        WHEN T2."FormID" = '65309' THEN 'A/P Down Payment Request'
        ELSE ' ***RESEARCH***'
    END AS "Form Description",
    T2."FormID" AS "Form ID Numb",
    T2."ItemID" AS "Area/Header Field FMS is Assigned",
    T2."ColID" AS "Column field FMS is Assigned",
    T2."FieldID" AS "Auto Refresh Field",
    T1."QString" AS "Query"
FROM
    OQCN T0
    INNER JOIN OUQR T1 ON T0."CategoryId" = T1."QCategory"
    INNER JOIN CSHS T2 ON T1."IntrnalKey" = T2."QueryId"
WHERE
    T0."CategoryId" != -2
ORDER BY
    T1."QName"