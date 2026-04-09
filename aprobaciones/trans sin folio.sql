SELECT
    CASE
        WHEN $ [OWTR."Series"] in ('27') THEN 'True'
        else 'False'
    end
FROM
    DUMMY