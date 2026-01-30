IF :object_type = '15'
   AND :transaction_type = 'A'
   AND :error = 0
THEN

    DECLARE CONT INT;

    SELECT COUNT(*)
    INTO CONT
    FROM DLN1
    WHERE "DocEntry" = :list_of_cols_val_tab_del
      AND ( "BaseType" IS NULL OR "BaseType" = -1 );

    IF :CONT > 0 THEN
        error := 1;
        error_message := 'No se permite crear Entregas con líneas sin documento base.';
    END IF;

END IF;
