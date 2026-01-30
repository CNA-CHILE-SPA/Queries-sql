----------------- CAMPO OBLIGATORIO PARA FAC PROVEEDORES PREFIJO 
IF :object_type = '18' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "OPCH" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			AND T0."ObjType" = :object_type
				AND T0."Indicator"<>'NL'
			AND T0."FolioPref" is null;
			
		IF :CONT0 > 0
			THEN
				error := 220;
				error_message := 'Debe ingresar el pre-fijo del numero de folio';
			END IF;
    END IF;
END IF;

--------------------------------------------------------------------------------------------------------------------------------
-- VALIDACIÓN DE FOLIO DUPLICADO EN FACTURAS DE PROVEEDOR
-- Creado por: [Tu Nombre]
-- Fecha: 18/11/2025
-- Descripción: Valida que no existan folios duplicados para el mismo proveedor
--------------------------------------------------------------------------------------------------------------------------------

IF :object_type = '18' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error = 0)
THEN
    DECLARE v_CardCode NVARCHAR(15);
    DECLARE v_FolioPref NVARCHAR(10);
    DECLARE v_FolioNum INT;
    DECLARE v_Indicator NVARCHAR(10);
    DECLARE v_Duplicados INT;

    -- Obtener datos del documento actual
    SELECT 
        T0."CardCode",
        IFNULL(T0."FolioPref", ''),
        IFNULL(T0."FolioNum", 0),
        IFNULL(T0."Indicator", '')
    INTO 
        v_CardCode,
        v_FolioPref,
        v_FolioNum,
        v_Indicator
    FROM OPCH T0
    WHERE T0."DocEntry" = :list_of_cols_val_tab_del;

    -- Solo validar si el indicador NO es 'NL' y tiene folio
    IF v_Indicator <> 'NL' AND v_FolioNum > 0 THEN
        
        v_Duplicados := 0;

        -- Buscar duplicados en OPCH (otras facturas del mismo proveedor)
        SELECT COUNT(*) INTO v_Duplicados
        FROM OPCH T0
        WHERE T0."CardCode" = v_CardCode
          AND IFNULL(T0."FolioPref", '') = v_FolioPref
          AND T0."FolioNum" = v_FolioNum
          AND IFNULL(T0."Indicator", '') = v_Indicator
          AND T0."CANCELED" = 'N'
          AND T0."DocEntry" <> :list_of_cols_val_tab_del;

        -- Si hay duplicados, generar error
        IF v_Duplicados > 0 THEN
            error := 1801;
            error_message := 'FOLIO DUPLICADO: El folio ' || v_FolioPref || '-' || 
                            CAST(v_FolioNum AS NVARCHAR(10)) || 
                            ' ya existe para el proveedor ' || v_CardCode || 
                            '. No se permite la duplicidad de folios.';
        END IF;

    END IF;

END IF;

--------------------------------------------------------------------------------------------------------------------------------
-- FIN VALIDACIÓN DE FOLIO DUPLICADO
--------------------------------------------------------------------------------------------------------------------------------

--Factura de proveedores
--Debe existir una Entrada
IF :object_type = '18' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT Count(*) 
	INTO CONT0 
	FROM PCH1 T0 
	INNER JOIN OPCH T1 ON T0."DocEntry" = T1."DocEntry" 
	INNER JOIN OCRD T2 ON T1."CardCode" = T2."CardCode"
	WHERE T0."BaseType" <>20
	and T0."BaseType" <>22
	AND T0."DocEntry"=list_of_cols_val_tab_del
	and T2."QryGroup5" ='N';

	
	/*IF  CONT0> 0
	THEN
			
			error := 104;
			error_message := 'Debe existir una Entrada u Orden de compra previa';

	END IF;*/
END IF;