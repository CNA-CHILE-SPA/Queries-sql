CREATE PROCEDURE SBO_SP_TransactionNotification
(
	in object_type nvarchar(100), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT
AS
-- Return values 1
error  int;				-- Result (0 for no1 error)
error_message nvarchar (200); 		-- Error string to be displayed

CONT0, CONT1,CONT2 INT;
ruti char (15);
valor int;
db int;
dv char (1);
FELECT	int;

begin
DECLARE CONT INT;
DECLARE EsElect NVARCHAR(1);
DECLARE _DTE NVARCHAR(3);
DECLARE DocSubType NVARCHAR(2);
DECLARE _LINEAS INT;

error := 0;
error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-------------------------- INICIO VALIDACIONES FEX ---------------------------
--FACTURA AFECTA (33) FACTURA EXENTA(34), NOTA DE DEBITO (56),BOLETA(39),

IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error =0)  
THEN
	SELECT IFNULL("U_FE_SeriElectr",'N'),T0."U_FE_TipoDte" INTO EsElect,_DTE FROM "NNM1" T0 INNER JOIN "OINV" T1 ON T0."Series"=T1."Series" WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
	IF _DTE = '33' AND EsElect='Y'
	THEN
		SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_33"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
	END IF;
	
	/*IF _DTE = '34' AND EsElect='Y'
	THEN
		SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_34"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
		
	END IF;*/
	
	IF :DocSubType = 'DN' AND EsElect='Y'
	THEN
		IF  _DTE = '56'
			THEN
			SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_56"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
		END IF;
	END IF;
	
	/*SELECT COUNT(*) INTO _LINEAS 
		FROM ODLN T0
		WHERE T0."DocEntry" IN (
			SELECT "BaseEntry" FROM INV1 WHERE "DocEntry" = :list_of_cols_val_tab_del and "BaseType" = 15
		);
	IF  _LINEAS > 35
	THEN
		error := 9898;
		error_message := N'Documento solo acepta 35 Documentos de Referencia';	
    END IF;	*/
	
	
END IF;

--VALIDACION FACTURA ANTICIPO ELECTRONICA (TIPO DTE 33)
IF :object_type = '203' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error =0)  
THEN
	SELECT "DocSubType" INTO DocSubType FROM "ODPI" WHERE "DocEntry" = :list_of_cols_val_tab_del;
	SELECT IFNULL("U_FE_SeriElectr",'N') INTO EsElect FROM "NNM1" T0 INNER JOIN "ODPI" T1 ON T0."Series"=T1."Series" WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
	IF :DocSubType = '--' AND EsElect='Y'
	THEN
		SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_33"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
	END IF;
END IF;	

--NOTA DE CREDITO
IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error =0)  
THEN
	SELECT IFNULL("U_FE_SeriElectr",'N'),T0."U_FE_TipoDte"  INTO EsElect,_DTE FROM "NNM1" T0 INNER JOIN "ORIN" T1 ON T0."Series"=T1."Series" 
	WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
		IF :EsElect = 'Y' AND _DTE = '61'
			THEN
			SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_61"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
		END IF;
END IF;	

--GUIA DESPACHO
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error =0)  
THEN
	SELECT IFNULL("U_FE_SeriElectr",'N') INTO EsElect FROM "NNM1" T0 INNER JOIN "ODLN" T1 ON T0."Series"=T1."Series" WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
		IF  :EsElect='Y'
			THEN	
			SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_52"(:object_type, :transaction_type, :list_of_cols_val_tab_del); 
		END IF;
	
	    SELECT COUNT(*) INTO _LINEAS FROM dln1 T0 WHERE T0."DocEntry" = :list_of_cols_val_tab_del and T0."Quantity" < 0.001;
	IF  _LINEAS > 0
	THEN
		error := 9898;
		error_message := N'Documento debe tener cantidad en todas sus lineas';	
    END IF;	
END IF;	

--GUIA TRASLADO
IF :object_type = '67' AND (:transaction_type = 'A' OR :transaction_type = 'U') AND (:error =0)  
THEN
	SELECT IFNULL("U_FE_SeriElectr",'N') INTO EsElect FROM "NNM1" T0 INNER JOIN "OWTR" T1 ON T0."Series"=T1."Series" WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
		IF  :EsElect='Y'
			THEN
			SELECT "ERROR","MENSAJE" INTO error,error_message FROM "E000XX00000VAL_52"(:object_type, :transaction_type, :list_of_cols_val_tab_del);
		END IF; 
END IF;


-------------------------- FIN VALIDACIONES FEX ------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-----------------
--INICIO FEX----
-----------------
-- CONTROL CAMPOS DE REFERENCIA EN NOTA DE CRÉDITO ELECTRÓNICA
-------------------------------------------------------------------------------

IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
 FELECT :=0;
 SELECT COUNT(*) INTO FELECT
 FROM "ORIN" T0 inner join "NNM1" T1 on T0."Series" = T1."Series"
 WHERE T1."U_FE_TipoDte" IN ('61','112') AND T1."U_FE_SeriElectr" = 'Y'
  AND (T0."U_EXX_FE_TDBSII" IS NULL OR T0."U_EXX_FE_FOLIODB" IS NULL OR T0."U_EXX_FE_CODREFDB" IS NULL OR T0."U_EXX_FE_FECHADB" IS NULL) 
 --AND IFNULL(T0."U_FE_FOLIOREFMASIV",'')=''
 AND T0."DocEntry" = :list_of_cols_val_tab_del;
 IF :FELECT > 0 
 THEN
  error := 664;
  error_message := 'Debe Agregar Campos de Referencia en Nota de Credito';
 END IF;
END IF;

-------------------------------------------------------------------------------------------
-- CONTROL CAMPOS DE REFERENCIA EN NOTA DE DEBITO ELECTRÓNICA
-------------------------------------------------------------------------------------------

IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 WHERE T1."U_FE_TipoDte" IN ('56','111') AND T1."U_FE_SeriElectr" = 'Y'
	  AND (T0."U_EXX_FE_TDBSII" IS NULL OR T0."U_EXX_FE_FOLIODB" IS NULL OR T0."U_EXX_FE_CODREFDB" IS NULL OR T0."U_EXX_FE_FECHADB" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Debe Agregar Campos de Referencia en Nota de Debito';
	 END IF;
END IF;

--VALIDA QUE NO SE INGRESEN DESCUENTOS EN NEGATIVO FACTURA
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT:=0;
SELECT     COUNT(*) INTO FELECT
FROM         OINV AS T0
					  inner join NNM1 T2 ON  T0."Series"=T2."Series" 
					  inner join INV1 T3 ON T0."DocEntry" = T3."DocEntry"
WHERE      T2."U_FE_SeriElectr"='Y'  AND T3."DiscPrcnt"<0  --AND T0."DocType" = 'S'
AND T0."DocEntry"=:list_of_cols_val_tab_del;
 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Existe un descuento negativo, favor revisar';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('33','34','39','110') AND T1."U_FE_SeriElectr" = 'Y'
	 AND T0."U_EXX_FE_TDBSII" <> '' AND ( T0."U_EXX_FE_FOLIODB" IS NULL OR T0."U_EXX_FE_FECHADB" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia, debe agregar tipo de documento, folio y fecha de referencia';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS 1
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('33','34','39','110') AND T1."U_FE_SeriElectr" = 'Y'
	   AND T0."U_EXX_FE_TDBSII1" <> '' AND ( T0."U_EXX_FE_FOLIODB1" IS NULL OR T0."U_EXX_FE_FECHADB1" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia, debe agregar tipo de documento 1, folio 1 y fecha de referencia 1';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS 2
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('33','34','39','110') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T0."U_EXX_FE_TDBSII2" <> '' AND ( T0."U_EXX_FE_FOLIODB2" IS NULL OR T0."U_EXX_FE_FECHADB2" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia, debe agregar tipo de documento 2, folio 2 y fecha de referencia 2';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS 3
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('33','34','39','110') AND T1."U_FE_SeriElectr" = 'Y'
	   AND T0."U_EXX_FE_TDBSII3" <> '' AND ( T0."U_EXX_FE_FOLIODB3" IS NULL OR T0."U_EXX_FE_FECHADB3" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia, debe agregar tipo de documento 3, folio 3 y fecha de referencia 3';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T0."U_EXX_FE_TDBSII" <> '' AND ( T0."U_EXX_FE_FOLIODB" IS NULL OR T0."U_EXX_FE_FECHADB" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia, debe agregar tipo de documento, folio y fecha de referencia';
	 END IF;
END IF;
--VALIDA INGRESO DE REFERENCIAS 1
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T0."U_EXX_FE_TDBSII1" <> '' AND ( T0."U_EXX_FE_FOLIODB1" IS NULL OR T0."U_EXX_FE_FECHADB1" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia 1, debe agregar tipo de documento 1, folio 1 y fecha de referencia 1';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS 2
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T0."U_EXX_FE_TDBSII2" <> '' AND ( T0."U_EXX_FE_FOLIODB2" IS NULL OR T0."U_EXX_FE_FECHADB2" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia 2, debe agregar tipo de documento 2, folio 2 y fecha de referencia 2';
	 END IF;
END IF;

--VALIDA INGRESO DE REFERENCIAS 3
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 		WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	 AND T0."U_EXX_FE_TDBSII3" <> '' AND ( T0."U_EXX_FE_FOLIODB3" IS NULL OR T0."U_EXX_FE_FECHADB3" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Si ingresa una referencia 3, debe agregar tipo de documento 3, folio 3 y fecha de referencia 3';
	 END IF;
END IF;

--VALIDA QUE NO SE INGRESEN DESCUENTOS EN NEGATIVO NOTA DE CREDITO
IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT:=0;
SELECT     COUNT(*) INTO FELECT
FROM         ORIN AS T0
					  inner join NNM1 T2 ON  T0."Series"=T2."Series" 
					  inner join RIN1 T3 ON T0."DocEntry" = T3."DocEntry"
WHERE      T2."U_FE_SeriElectr"='Y'  AND T3."DiscPrcnt"<0  --AND T0."DocType" = 'S'
AND T0."DocEntry"=:list_of_cols_val_tab_del;
 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Existe un descuento negativo, favor revisar';
	 END IF;
END IF;

--VALIDA QUE NO SE INGRESEN DESCUENTOS EN NEGATIVO GUIA DEVOLUCION
IF :object_type = '21' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT:=0;
SELECT     COUNT(*) INTO FELECT
FROM         ORPD AS T0
					  inner join NNM1 T2 ON  T0."Series"=T2."Series" 
					  inner join RPD1 T3 ON T0."DocEntry" = T3."DocEntry"
WHERE      T2."U_FE_SeriElectr"='Y'  AND T3."DiscPrcnt"<0  --AND T0."DocType" = 'S'
AND T0."DocEntry"=:list_of_cols_val_tab_del;
 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Existe un descuento negativo, favor revisar';
	 END IF;
END IF;

--VALIDA QUE NO SE INGRESEN DESCUENTOS EN NEGATIVO ENTREGA GUIA
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT:=0;
SELECT     COUNT(*) INTO FELECT
FROM         ODLN AS T0
					  inner join NNM1 T2 ON  T0."Series"=T2."Series" 
					  inner join DLN1 T3 ON T0."DocEntry" = T3."DocEntry"
WHERE      T2."U_FE_SeriElectr"='Y'  AND T3."DiscPrcnt"<0  --AND T0."DocType" = 'S'
AND T0."DocEntry"=:list_of_cols_val_tab_del;
 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Existe un descuento negativo, favor revisar';
	 END IF;
END IF;

--VALIDA LIMITE DE LINEAS FACTURA AFECTA, EXENTA, ND
IF :object_type = '13'  AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT := 0;
	SELECT
	COALESCE(COUNT (*),0)INTO FELECT
	FROM INV1 T1 INNER JOIN OINV T0 ON T0."DocEntry" = T1."DocEntry"
	inner join "NNM1" T2 on T0."Series" = T2."Series"
	WHERE T0."DocEntry" = :list_of_cols_val_tab_del and 
 	T2."U_FE_TipoDte" IN ('33','34','56','39','110','111') 
 	AND T0."SummryType" <>'I'
 	AND T2."U_FE_SeriElectr" = 'Y';
	IF :FELECT > 26	THEN
	error := 661;
	error_message := 'Cantidad de líneas excede la máxima (26)';
  END IF;
END IF;

IF :object_type = '18'  AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT := 0;
	SELECT
	COALESCE(COUNT (*),0)INTO FELECT
	FROM PCH1 T1 INNER JOIN OPCH T0 ON T0."DocEntry" = T1."DocEntry"
	inner join "NNM1" T2 on T0."Series" = T2."Series"
	WHERE T0."DocEntry" = :list_of_cols_val_tab_del and 
 	T2."U_FE_TipoDte" IN ('33','34','56','39') 
 	AND T0."SummryType" <>'I'
 	AND T2."U_FE_SeriElectr" = 'Y';
	IF :FELECT > 26	THEN
	error := 661;
	error_message := 'Cantidad de líneas excede la máxima (26)';
  END IF;
END IF;

--VALIDA LIMITE DE LINEAS NC
IF :object_type = '14'  AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT := 0;
	SELECT
	COALESCE(COUNT (*),0)INTO FELECT
	FROM RIN1 T1 INNER JOIN ORIN T0 ON T0."DocEntry" = T1."DocEntry"
	inner join "NNM1" T2 on T0."Series" = T2."Series"
	WHERE T0."DocEntry" = :list_of_cols_val_tab_del and 
 	T2."U_FE_TipoDte" IN ('61','112') 
 	AND T0."SummryType" <>'I'
 	AND T2."U_FE_SeriElectr" = 'Y';
	IF :FELECT > 26	THEN
	error := 661;
	error_message := 'Cantidad de líneas excede la máxima (26)';
  END IF;
END IF;
--VALIDA LIMITE DE LINEAS GUIA 
IF :object_type = '15'  AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	FELECT := 0;
	SELECT
	COALESCE(COUNT (*),0)INTO FELECT
	FROM DLN1 T1 INNER JOIN ODLN T0 ON T0."DocEntry" = T1."DocEntry"
	inner join "NNM1" T2 on T0."Series" = T2."Series"
	WHERE T0."DocEntry" = :list_of_cols_val_tab_del and 
 	T2."U_FE_TipoDte" IN ('52') 
 	AND T0."SummryType" <>'I'
 	AND T2."U_FE_SeriElectr" = 'Y';
	IF :FELECT > 26	THEN
	error := 661;
	error_message := 'Cantidad de líneas excede la máxima (26)';
  END IF;
END IF;

--VALIDA DESCRIPCION
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "DLN1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T2."Dscription" = '' or T2."Dscription" is null
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Falta ingresar la descripción del artículo';
	 END IF;
END IF;

--VALIDA DESCRIPCION
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "INV1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('33','56','110','34','39') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T2."Dscription" = '' or T2."Dscription" is null
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Falta ingresar la descripción del artículo';
	 END IF;
END IF;

--VALIDA DESCRIPCION
IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ORIN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "RIN1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('61','112') AND T1."U_FE_SeriElectr" = 'Y'
	  AND T2."Dscription" = '' or T2."Dscription" is null
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Falta ingresar la descripción del artículo';
	 END IF;
END IF;


-- CONTROL IVA_EXE DOCUMENTOS DE EXPORTACION  
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OINV" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "INV1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('110','111','34') AND T1."U_FE_SeriElectr" = 'Y' AND T2."TaxCode" <> 'IVA_EXE'-- and T2."Price" > 0
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'El indicador de impuestos debe ser IVA_EXE para los documentos exentos';
	 END IF;
END IF;

-- CONTROL IVA_EXE DOCUMEBTOS DE EXPORTACION  
IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ORIN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "RIN1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('112') AND T1."U_FE_SeriElectr" = 'Y' AND T2."TaxCode" <> 'IVA_EXE'-- and T2."Price" > 0
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'El indicador de impuestos debe ser IVA_EXE para los documentos exentos';
	 END IF;
END IF;

-- CONTROL DE INDICADOR
IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
	 INNER JOIN "DLN1" T2 ON T0."DocEntry" = T2."DocEntry"
 WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y' AND T2."TaxCode" = ''--and T2."Price" IS NULL
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Debe ingresar el indicador de impuestos';
	 END IF;
END IF;

-- control de documentos que no sean en CLP 110, 111, 112
-----------------------
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COALESCE(COUNT(*),0) INTO FELECT
	 FROM "OINV" T0 INNER JOIN "INV1" T1 ON T0."DocEntry"=T1."DocEntry"  
	 WHERE 
 	 (T0."DocCur" = 'CLP' OR T1."Currency" = 'CLP')
	 AND T0."Series" IN (SELECT "Series" from  "NNM1" where "U_FE_SeriElectr" = 'Y' AND 
	"U_FE_TipoDte" IN ('110','111'))
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 668;
	  error_message := 'Este Tipo de Documento NO puede ser en CLP';
	 END IF;
END IF;

IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COALESCE(COUNT(*),0) INTO FELECT
	 FROM "OINV" T0 INNER JOIN "INV1" T1 ON T0."DocEntry"=T1."DocEntry"  
	 WHERE 
	(T0."DocCur" = 'CLP' OR T1."Currency" = 'CLP')
	 AND T0."Series" IN (SELECT "Series" from  "NNM1" where "U_FE_SeriElectr" = 'Y' AND 
	"U_FE_TipoDte" IN ('112'))
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 668;
	  error_message := 'Este Tipo de Documento NO puede ser en CLP';
	 END IF;
END IF;

--VALIDA INGRESO DE INDICADOR EXENTO
IF :object_type = '13' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COALESCE(COUNT(*),0) INTO FELECT
	 FROM "OINV" T0 INNER JOIN "INV1" T1 ON T0."DocEntry"=T1."DocEntry"  
	 WHERE 
	 T1."TaxCode" = 'IVA'
	 AND T0."Series" IN (SELECT "Series" from  "NNM1" where "U_FE_SeriElectr" = 'Y' AND 
	"U_FE_TipoDte" IN ('34','110','111'))
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 668;
	  error_message := 'Este Tipo de Documento No Acepta Valore Afectos';
	 END IF;
END IF;

--VALIDA INGRESO DE INDICADOR EXENTO
IF :object_type = '14' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COALESCE(COUNT(*),0) INTO FELECT
	 FROM "OINV" T0 INNER JOIN "INV1" T1 ON T0."DocEntry"=T1."DocEntry"  
	 WHERE 
	 T1."TaxCode" = 'IVA'
	 AND T0."Series" IN (SELECT "Series" from  "NNM1" where "U_FE_SeriElectr" = 'Y' AND 
	"U_FE_TipoDte" IN ('112'))
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	IF :FELECT > 0 
	 THEN
	  error := 668;
	  error_message := 'Este Tipo de Documento No Acepta Valore Afectos';
	 END IF;
END IF;

-------------------------------------------------------------------------------------------
-- CONTROL CAMPOS DE TRANSPORTE
-------------------------------------------------------------------------------------------

IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "ODLN" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND (T0."U_EXX_FE_RUTCHOFER" IS NULL OR T0."U_EXX_FE_CHOFER" IS NULL OR T0."U_EXX_FE_RUTTRANSPORTISTA" IS NULL OR T0."U_EXX_FE_PATENTE" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Debe agregar los datos de Transporte para la guia';
	 END IF;
END IF;

IF :object_type = '67' AND (:transaction_type = 'A' OR :transaction_type = 'U')
THEN
	 FELECT:=0;
	 SELECT COUNT(*) INTO FELECT
	 FROM "OWTR" T0  inner join "NNM1" T1 on T0."Series" = T1."Series"
 WHERE T1."U_FE_TipoDte" IN ('52') AND T1."U_FE_SeriElectr" = 'Y'
	  AND (T0."U_EXX_FE_RUTCHOFER" IS NULL OR T0."U_EXX_FE_CHOFER" IS NULL OR T0."U_EXX_FE_RUTTRANSPORTISTA" IS NULL OR T0."U_EXX_FE_PATENTE" IS NULL) 
	 AND T0."DocEntry" = :list_of_cols_val_tab_del;
	 
	 IF :FELECT > 0 
	 THEN
	  error := 665;
	  error_message := 'Debe agregar los datos de Transporte para la guia';
	 END IF;
END IF;




-- Rut de transportista existe como Socio de Negocio
-- Nicolás Tapia 17.12.25

IF object_type = '15'
AND (transaction_type = 'A' OR transaction_type = 'U') THEN

    CONT := 0;

    SELECT
        COUNT(*)
    INTO CONT
    FROM
        ODLN T0
    WHERE
        T0."DocEntry" = :list_of_cols_val_tab_del
        AND NOT EXISTS (
            SELECT 1
            FROM OCRD C
            WHERE C."LicTradNum" = T0."U_EXX_FE_RUTTRANSPORTISTA"
        );

    IF CONT > 0 THEN
        error := 86;
        error_message := 'El RUT del transportista no existe como Socio de Negocio.';
    END IF;

END IF;
-----------------FIN FEX-------------------------------
--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------General---------------------
---Maestro SN / Control Dígito Verificador


-- SN
--Tipo de cultivo debe ser distinto a tipo de cultivo2
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT COUNT(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	AND T0."CardType" ='C'
	AND T0."U_TipoCultivo"=T0."U_TipoCultivo2"
	;
	
	IF :CONT0 >0
	THEN
			error := 4;
			error_message := N'El campo tipo de cultivo2 debe ser diferente de tipo de cultivo';
	END IF;
END IF;


-- SN
--Tipo de cultivo es obligatorio
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT COUNT(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	AND T0."CardType" ='C'
	AND IFNULL(T0."U_TipoCultivo",'')=''
	;
	
	IF :CONT0 >0
	THEN
			error := 4;
			error_message := N'El campo tipo de cultivo es obligatorio';
	END IF;
END IF;


IF :object_type = '2' THEN
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 

DECLARE v_CardCode   NVARCHAR(20);
DECLARE v_Lic        NVARCHAR(20);
DECLARE v_LenLic     INT;
DECLARE v_CardCodeNumPart NVARCHAR(10); -- Parte numérica del CardCode (sin letras iniciales, incluye DV)
DECLARE v_LicTradNumDigits_DV NVARCHAR(10); -- LicTradNum sin guion
DECLARE v_GroupCode INT;

        -- Obtener el Rut (LicTradNum), el CardCode y el GroupCode
        SELECT 
        T0."LicTradNum",
        T0."CardCode",
        T0."GroupCode"
        INTO v_Lic, v_CardCode, v_GroupCode
        FROM "OCRD" T0 
        WHERE T0."CardCode" = :list_of_cols_val_tab_del;

        -- === INICIO - Nueva Validación de Coherencia CardCode vs. LicTradNum (Completa) ===
---- NICOLÁS TAPIA 19.11.25
        
        -- Solo ejecutar si el socio de negocio pertenece a los grupos 100 o 105
        IF :v_GroupCode IN (100, 105, 101, 104) THEN
            
            -- 1. Extraer la parte numérica completa del CardCode (incluyendo el DV)
            -- Asumimos que el CardCode tiene 2 letras iniciales y el formato es XXXXXXX-Y.
            -- De 'PN20099218-0' a '200992180'
            v_CardCodeNumPart := REPLACE(SUBSTRING(:v_CardCode, 3), '-', ''); 

            -- 2. Extraer el LicTradNum completo, pero sin el guion.
            -- De '20099218-0' a '200992180'
            v_LicTradNumDigits_DV := REPLACE(:v_Lic, '-', ''); 

            -- 3. Comparar ambas cadenas completas
            -- Si el CardCode es 'PN20099218-0' y el LicTradNum es '20099218-K', la validación fallará aquí,
            -- porque estamos comparando '200992180' con '20099218K'. ¡Esto es correcto!
            IF :v_CardCodeNumPart <> :v_LicTradNumDigits_DV THEN
                SELECT 102 INTO error FROM DUMMY;
                SELECT N'¡ALERTA! El código del SN no coincide con el RUT completo. Verifique los dígitos y el dígito verificador. CardCode espera: ' || :v_CardCodeNumPart || ' y LicTradNum tiene: ' || :v_LicTradNumDigits_DV
                INTO error_message FROM DUMMY;
            END IF;
        END IF;
        
        -- === FIN - Nueva Validación de Coherencia CardCode vs. LicTradNum (Completa) ===

        -- RESTO DE LA VALIDACIÓN ORIGINAL (VALIDACIÓN DEL DÍGITO VERIFICADOR)
        ruti := '';
        SELECT 
        (SELECT right('0000000000' || T0."LicTradNum",10) 
        FROM "OCRD" T0 
        WHERE T0."CardCode" = :list_of_cols_val_tab_del) INTO ruti FROM DUMMY;


        valor := 0;
        IF (LENGTH(:ruti)) = 10 AND substring(:ruti, LENGTH(:ruti) - 1, 1) = '-' AND LOCATE(:ruti, '.') = 0 THEN 
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 2, 1) AS integer) * 2;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 3, 1) AS integer) * 3;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 4, 1) AS integer) * 4;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 5, 1) AS integer) * 5;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 6, 1) AS integer) * 6;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 7, 1) AS integer) * 7;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 8, 1) AS integer) * 2;
            valor := :valor + CAST(substring(:ruti, LENGTH(:ruti) - 9, 1) AS integer) * 3;
            valor := MOD(:valor,11);
            IF (:valor = 1) THEN 
                dv := 'K';
            END IF;
            IF :valor = 0 THEN 
                dv := '0';
            END IF;
            IF :valor > 1 AND :valor < 11 THEN 
                dv :=CAST( 11-:valor AS CHAR (1));
            END IF;
            IF :dv <> substring(:ruti, LENGTH(:ruti), 1) THEN 
                SELECT 101 INTO error FROM DUMMY;
                SELECT n'El Rut esta incorrecto' INTO error_message FROM DUMMY;
            END IF;
            IF ASCII(substring(:ruti, LENGTH(:ruti), 1)) = '107' THEN 
                SELECT 101 INTO error FROM DUMMY;
                SELECT n'La K del RUT debe ser con mayuscula' INTO error_message FROM DUMMY;
            END IF;
        ELSE 
            SELECT 101 INTO error FROM DUMMY;
            IF LOCATE(:ruti, '.') > 0 THEN 
                SELECT n'El Rut no debe tener puntos (.) ' INTO error_message FROM DUMMY;
            END IF;
            IF substring(:ruti, LENGTH(:ruti) - 1, 1) <> '-' THEN 
                SELECT n'El Rut debe tener  (-) ' INTO error_message FROM DUMMY;
            END IF;
            IF (LENGTH(:ruti)) <> 10 THEN 
                SELECT n'El Rut esta incompleto ' INTO error_message FROM DUMMY;
            END IF;
        END IF;

        
    END IF;
END IF;

--Nombre obligatoria 
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT length(ifnull(T0."CardName",''))
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del;
	
	IF :CONT0 < 2
	THEN
			error := '001';
			error_message := N'Debe agregar el Nombre';
	END IF;
END IF;


--Correo obligatorio
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT count(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	and T0."SlpCode" = '-1'
	and T0."CardType"='C'
	;

	
	IF :CONT0 >0 
	THEN
			error := 3;
			error_message := N'Debe ingrear el empleado del departamento de Ventas/Compras';
	END IF;
END IF;



--Giro obligatorio
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT COUNT(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	AND IFNULL(T0."Notes",'')=''
	;
	
	IF :CONT0 >0
	THEN
			error := 4;
			error_message := N'Debe ingresar el Giro';
	END IF;
END IF;

--Direccion obligatoria 
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;


	SELECT count(T0."Address")
	INTO CONT0 
	FROM CRD1 T0 
	WHERE T0."CardCode" =	list_of_cols_val_tab_del
	;
	
	IF :CONT0 = 0
	THEN
			error := 5;
			error_message := N'Debe agregar direccion';
	END IF;
END IF;

--Letra por proveedores 
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT count(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	and left(T0."CardCode",2)not in ('PN','PE','HN','HE')
	and T0."CardType" ='S';
	
	IF :CONT0 >0
	THEN
			error := '6';
			error_message := N'El codigo debe iniciar con la nomenclatura correcta (PN, PE, HN ,HE)';
	END IF;
END IF;

--Letra por clientes 
IF :object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT count(*)
	INTO CONT0 
	FROM OCRD T0 
	WHERE T0."CardCode" =list_of_cols_val_tab_del
	and left(T0."CardCode",2)not in ('CN','CE','EN')
	and T0."CardType" <>'S' and T0."GroupCode" <> 104;
	
	IF :CONT0 >0
	THEN
			error := '7';
			error_message := N'El codigo debe iniciar con la nomenclatura correcta (CN, CE)';
	END IF;
END IF;

------------------------------------Compras----------------------------------------------------------------------------------
-- costo bancario menor a 75 usd
-- Valida gasto bancario desde OBCG por SN con tope dependiente de DocCurr (USD/CLP)

IF :object_type = '24'
AND :transaction_type = 'A' THEN DECLARE v_DocEntry INT := CAST(:list_of_cols_val_tab_del AS INT);

DECLARE v_DocCurr NVARCHAR(3);

DECLARE v_BkChg DECIMAL(19, 6) := 0;

DECLARE v_Threshold DECIMAL(19, 6) := 0;

/* 1) Obtener moneda y gasto bancario DEL PAGO que se está ingresando */
SELECT
  T0."DocCurr",
  IFNULL(T0."BcgSumSy", 0) INTO v_DocCurr,
  v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

/* 2) Definir umbral según DocCurr */
IF v_DocCurr = 'USD' THEN v_Threshold := 75;

SELECT
  IFNULL(T0."BcgSum", 0) INTO v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

ELSEIF v_DocCurr = 'CLP' THEN v_Threshold := 75000;

SELECT
  IFNULL(T0."BcgSumSy", 0) INTO v_BkChg
FROM
  "ORCT" T0
WHERE
  T0."DocEntry" = v_DocEntry;

ELSE v_Threshold := 0;

v_BkChg := 0;

END IF;

/* 3) Validación */
IF v_Threshold > 0
AND v_BkChg > v_Threshold THEN error := 1;

error_message := 'Bloqueado: el gasto bancario ingresado (' || TO_NVARCHAR(ROUND(v_BkChg, 2)) || ' ' || v_DocCurr || ') excede el tope permitido de ' || TO_NVARCHAR(v_Threshold) || ' ' || v_DocCurr || '.';

END IF;

END IF;


--Entrada 
--numero de lote debe ser igual al docnum del pedido
IF :object_type = '20' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	select count(*) 
	INTO CONT0 
	from PDN1 T0
	INNER JOIN OITM T1 ON T0."ItemCode"=T1."ItemCode"
	INNER JOIN OPOR T2 ON T0."BaseEntry" = T2."DocEntry"
	where T0."DocEntry" =list_of_cols_val_tab_del
	and T1."QryGroup3"='Y'
	and cast(T2."DocNum" as nvarchar(50)) not in (select Ti."BatchNum" from OIBT Ti where Ti."BaseType"='20'and Ti."BaseEntry"=list_of_cols_val_tab_del);

	
	
	IF :CONT0 >0
	THEN
			error := '100';
			error_message := N'El codigo de lote debe ser igual al numero de pedido';
	END IF;
END IF;


-- Area Aprobadora
-- Valida que el campo Area Aprobadora esté lleno al crear una oc 

IF :object_type = '22' -- 22 = Orden de Compra
AND :transaction_type = 'A' -- A = Add (crear)
THEN  DECLARE v_Motivo NVARCHAR(100);

SELECT
  T0."U_AreaAprobadora" INTO v_Motivo
FROM
  OPOR T0
WHERE
  T0."DocEntry" = CAST(:list_of_cols_val_tab_del AS INT);

IF (
  v_Motivo IS NULL
  OR LENGTH(TRIM(v_Motivo)) = 0
) THEN error := 1;

error_message := 'Debe ingresar el area aprobadora antes de crear la Orden de Compra.';

END IF;

END IF;


--Orden de compra 
--DIM1	
IF :object_type = '22' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM POR1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  

   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 102;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   */  	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;    */  	  
	  	
END FOR;       	  	   
END IF;

--Orden de compra borrador
--DIM1	
IF :object_type = '112' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM DRF1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   INNER JOIN ODRF T2 ON T0."DocEntry"=T2."DocEntry"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
--   and  T1."InvntItem" ='N'
   and T2."ObjType"='22'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 102;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     */	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
   /* IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   */
 --------- Validador DIM3 no vacia ----------------------------	       	 
   /* IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF; */     	  
	  	
END FOR;       	  	   
END IF;




--ENTRADA DE MERCANCIA de compra 
--DIM1	
IF :object_type = '20' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM PDN1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
  -- and  T1."InvntItem" ='N'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
   /* IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 102;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF; */    	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF; */    	  
	  	
END FOR;       	  	   
END IF;

----- CHEQUEO DE CANTIDADES EN ENTRADA DE MERCANCIA -----------------------------
-- Entrega no permite ingresar cantidad mayor a la pendiente del doc.base
--- Nicolás Tapia 14.11.25


IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT = 0;

SELECT
    COUNT (T0."DocEntry") INTO CONT
FROM
    "OPDN" T0
    INNER JOIN PDN1 T1 ON T1."DocEntry" = T0."DocEntry"
WHERE
    T0."DocEntry" = list_of_cols_val_tab_del
    AND T1."Quantity" > IFNULL (T1."BaseOpnQty", 0)
    AND ifnull(T1."BaseEntry", 0) > 0;

IF CONT > 0 THEN error := 83;

error_message := 'La Cantidad a Ingresar no puede exceder la cantidad pendiente del Doc. Base';

END IF;

END IF;



-- Entrada de Mercancía debe tener prefijo 52 o 33, y numero de folio
-- Nicolás Tapia 17.12.25
IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OPDN T0
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND (
        IFNULL(T0."FolioPref", 0) NOT IN (52, 33)
        OR IFNULL(T0."FolioNum", 0) = 0
    );

IF CONT > 0 THEN error := 85;

error_message := 'La Entrada de Mercancía debe tener Prefijo 52 y Numero de Folio.';

END IF;

END IF;



-- CHEQUEO DE DOCUMENTO BASE EN ENTRADA DE MERCANCIA -----------------------------
-- No permite crear entrada de mercancía sin documento base
-- Nicolás Tapia 16-12-2025
IF object_type = '20'
AND (
    transaction_type = 'A'
    OR transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OPDN T0
    INNER JOIN PDN1 T1 ON T1."DocEntry" = T0."DocEntry"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND IFNULL(T1."BaseEntry", 0) = 0;

IF CONT > 0 THEN error := 84;

error_message := 'No se permite crear Entradas de Mercancía sin documento base (Pedido).';

END IF;

END IF;




--FACTURA de compra 
--DIM1	
IF :object_type = '18' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM PCH1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
 --  and  T1."InvntItem" ='N'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 102;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   */  	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;  */    	  
	  	
END FOR;       	  	   
END IF;



--NC de compra 
--DIM1	
IF :object_type = '19' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM RPC1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
 --  and  T1."InvntItem" ='N'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 102;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   */  	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    /*IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 104;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF; */     	  
	  	
END FOR;       	  	   
END IF;


IF :object_type = '22' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "OPOR" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			
				AND ifnull(T0."U_AreaAprobadora",'')='' and T0."DataSource" <> 'O';
			
		/*IF :CONT0 > 0
			THEN
				error := 218;
				error_message := 'Debe ingresar el Area Aprobadora';
			END IF;*/
    END IF;
END IF;



IF :object_type = '112' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ODRF" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			
				AND ifnull(T0."U_AreaAprobadora",'')='' and T0."DataSource" <> 'O';
			
		/*IF :CONT0 > 0
			THEN
				error := 218;
				error_message := 'Debe ingresar el Area Aprobadora';
			END IF;*/
    END IF;
END IF;

--Entrada
--Entrada debe tener una oc

IF :object_type = '20' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT Count(*) 
	INTO CONT0 
	FROM PDN1 T0 
	WHERE T0."BaseType" <>22
    and T0."BaseType" <>18
	AND T0."DocEntry"=list_of_cols_val_tab_del;

	
	/*IF  CONT0> 0
	THEN
			
			error := 216;
			error_message := 'Debe existir una Orden de compra previa';

	END IF;*/
END IF;




--Factura de proveedores

------------------CAMPO INDICADOR ES OBLIGATORIO PARA FAC PROVEEDORES 
IF :object_type = '18' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "OPCH" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			
				AND ifnull(T0."Indicator",'')='';
			
		IF :CONT0 > 0
			THEN
				error := 500;
				error_message := 'El campo indicador de la pestaña finanzas es obligatorio';
			END IF;
    END IF;
END IF;

--Factura de proveedores

-------------CAMPO FOLIO ES OBLIGATORIO PARA FAC PROVEEDORES 
IF :object_type = '18' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "OPCH" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			AND T0."ObjType" = :object_type
			AND T0."Indicator"<>'NL'
			AND T0."FolioNum" is null;
			
		IF :CONT0 > 0
			THEN
				error := 219;
				error_message := 'Debe ingresar el numero de folio';
			END IF;
    END IF;
END IF;


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



--NC proveedores
-------------------CAMPO INDICADOR ES OBLIGATORIO PARA FAC PROVEEDORES 
IF :object_type = '19' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ORPC" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			--AND T0."ObjType" = :object_type
			AND ifnull(T0."Indicator",'')='';

		IF :CONT0 > 0
			THEN
				error := 106;
				error_message := 'El campo indicador de la pestaña finanzas es obligatorio';
			END IF;
    END IF;
END IF;

--NC proveedores
---------------------CAMPO FOLIO ES OBLIGATORIO PARA NC PROVEEDORES 
IF :object_type = '19' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ORPC" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			AND T0."ObjType" = :object_type
			AND T0."Indicator"<>'NL'
			AND T0."FolioNum" is null;

		IF :CONT0 > 0
			THEN
				error := 107;
				error_message := 'Debe ingresar el numero de folio';
			END IF;
    END IF;
END IF;

IF :object_type = '19' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ORPC" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			AND T0."ObjType" = :object_type
			AND T0."Indicator"<>'NL'
			AND T0."FolioPref" is null;

		IF :CONT0 > 0
			THEN
				error := 210;
				error_message := 'Debe ingresar el pre-fijo del numero de folio';
			END IF;
    END IF;
END IF;

------------------------------------Fin Compras----------------------------------------------------------------------------------
------------------------------------ Produccion----------------------------------------------------------------------------------

--Orden de produccion
-- Recurso debe estar asociado alalmacen deproduccion
IF :object_type = '202' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "WOR1" T0	
			INNER JOIN OWOR T1 ON T0."DocEntry"	 = T1."DocEntry"
			INNER JOIN ORSC T2 ON T0."ItemCode" = T2."VisResCode"
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			and T0."ItemType" ='290'
			AND T2."U_ALMACEN"<> T1."Warehouse";

		IF :CONT0 > 0
			THEN
				error := 300;
				error_message := 'Hay un recurso que no corresponde al almacen de produccion';
			END IF;
    END IF;
END IF;

/*
--Orden de produccion
--Debe existir al menos un recurso para OF que no sean de tipo desmontar 
IF :object_type = '202' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
    CONT1 =0;
	SELECT COUNT(*)
		into CONT0
			FROM OWOR T0
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			and T0."Type" ='S';

		IF :CONT0 > 0
			THEN
			    
				SELECT COUNT(*)
				into CONT1
				FROM WOR1 T0 
				INNER JOIN OWOR T1 ON T0."DocEntry" = T1."DocEntry"		
				WHERE T0."DocEntry" = :list_of_cols_val_tab_del
				and T0."ItemType" ='290';
				IF :CONT1 = 0
					THEN
					error := 301;
					error_message := 'Debe ingresar al menos un recurso';
				END IF;
			END IF;
    END IF;
END IF;
*/

--Recurso
--El campo de usuario almacen es obligatorio
IF :object_type = '290' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ORSC" T0		
			WHERE T0."VisResCode" = :list_of_cols_val_tab_del
			and ifnull( T0."U_ALMACEN",'') ='';

		IF :CONT0 > 0
			THEN
				error := 302;
				error_message := 'Debe ingresar el almacen del recurso';
			END IF;
    END IF;
END IF;


--Orden de produccion
--El almacen del detalle debe ser igual al de la cabcera
--26
IF :object_type = '202' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "WOR1" T0	
			INNER JOIN OWOR T1 ON T0."DocEntry"	 = T1."DocEntry"
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			and T1."Warehouse"<> T0."wareHouse";

		IF :CONT0 > 0
			THEN
				error := 303;
				error_message := 'El almacen debe ser igual en cabecera y detalle';
			END IF;
    END IF;
END IF;
------------------------------------Fin Produccion----------------------------------------------------------------------------------
------------------------------------ Ventas----------------------------------------------------------------------------------
/*
--Orden de venta
--Campo tipo de despacho es obligatorio
IF :object_type = '17' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ORDR" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			and ifnull( T0."U_TipoDespacho",'') ='';

		IF :CONT0 > 0
			THEN
				error := 400;
				error_message := 'Debe ingresar el tipo de despacho';
			END IF;
    END IF;
END IF;
*/

--Entrega de venta
--Comentarios es obligatorio
IF :object_type = '15' THEN 
    IF :transaction_type = 'A' OR :transaction_type = 'U' THEN 
    
    CONT0 =0;
	SELECT COUNT(*)
		into CONT0
			FROM "ODLN" T0		
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del
			and ifnull( T0."Comments",'') ='';

		IF :CONT0 > 0
			THEN
				error := 401;
				error_message := 'Debe ingresar un comentario';
			END IF;
    END IF;
END IF;


/*
--OV
--DIM1	
IF :object_type = '17' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM RDR1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
 --  and  T1."InvntItem" ='N'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 402;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 403;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 404;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;      	  
	  	
END FOR;       	  	   
END IF;



--Entrega de ventas
--DIM1	
IF :object_type = '15' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM DLN1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
 --  and  T1."InvntItem" ='N'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 402;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 403;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 404;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;      	  
	  	
END FOR;       	  	   
END IF;

*/


--------------------------------VUELTO A HABILITAR 21.11.25--------------------------------------
------------------------------------------------------------------------------------------------
-- NICOLÁS TAPIA.


--Entrega de ventas
--Debe estar vinculado a una orden de ventas o factura de reserva 



IF :object_type = '15' AND (:transaction_type = 'A' OR :transaction_type = 'U') THEN
CONT0:= 0;

	SELECT Count(*) 
	INTO CONT0 
	FROM DLN1 T0 
	WHERE T0."BaseType" <>13
    and T0."BaseType" <>17
	AND T0."DocEntry"=list_of_cols_val_tab_del;

	
	IF  CONT0> 0
	THEN
			
			error := 405;
			error_message := 'Debe existir una Orden de venta o factura de reserva previa';

	END IF;
END IF;

--Facturas de ventas
--Debe estar vinculado a una orden de ventas o factura de reserva 
-- OR :transaction_type = 'U'
IF :object_type = '13' AND (:transaction_type = 'A') THEN
CONT0:= 0;

	SELECT Count(*) 
	INTO CONT0 
	FROM INV1 T0 
	INNER JOIN OINV T1 ON T0."DocEntry"=T1."DocEntry"
	WHERE T0."BaseType" <>17
    and T0."BaseType" <>15
    AND T1."DocSubType" <> 'DN'
	AND T0."DocEntry"=list_of_cols_val_tab_del;

	
	IF  CONT0> 0
	THEN
			
			error := 406;
			error_message := 'Debe existir una Orden de venta o entrega previa';

	END IF;
END IF;



IF :object_type = '14' -- Nota de crédito de clientes
AND :transaction_type = 'A'
AND :error = 0 THEN DECLARE v_count INT;

SELECT
    COUNT(*) INTO v_count
FROM
    ORIN
WHERE
    "DocEntry" = :list_of_cols_val_tab_del
    AND (
        IFNULL("U_MOTIVO_NCND", '') = ''
        OR IFNULL("U_BOD_DOC", '') = ''
    );

IF v_count > 0 THEN error := 1;

error_message := 'Debe ingresar obligatoriamente el Motivo de NC y la Bodega del Documento.';

END IF;

END IF;



---- Motivos con y sin devolucion de stock
----- Nicolás Tapia 06-01-2026


IF :object_type = '14'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN
/* Caso 1: Motivos con devolución -> todas las líneas deben ser 'N' */
IF EXISTS (
    SELECT
        1
    FROM
        "RIN1" T1
        INNER JOIN "ORIN" T0 ON T0."DocEntry" = T1."DocEntry"
    WHERE
        T1."DocEntry" = :list_of_cols_val_tab_del
        AND IFNULL(T0."U_MOTIVO_NCND", 0) IN (1, 7, 8, 16)
        AND T1."NoInvtryMv" <> 'N'
        AND T1."ItemCode" NOT LIKE 'NC%' -- �� exclusión
) THEN error := 1;

error_message := 'Para este motivo de nota de crédito, todas las líneas deben tener devolución de cantidad y ser aprobadas por gerencia de logística';

END IF;



END IF;



------------------------------------Fin Ventas----------------------------------------------------------------------------------

------------------------------------------------------------------------------
-------------------------- VALIDACIONES COMEX  --------------------------------
-------------------------------------------------------------------------------


-- Autorización de movimientos en bodegas auxiliares solo para usuarios COMEX
-- Nicolás Tapia 22-12-2025


IF :object_type = '15'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    ODLN T0
    INNER JOIN DLN1 T1 ON T1."DocEntry" = T0."DocEntry"
    INNER JOIN OWHS W ON W."WhsCode" = T1."WhsCode"
    INNER JOIN OUSR U ON U."USERID" = T0."UserSign"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND W."U_TP_ALMACEN" = 'AUXILIAR'
    AND U."USER_CODE" NOT IN ('SJIMENEZ', 'BSANCRISTOBAL');

IF CONT > 0 THEN error := 87;

error_message := 'Solo los usuarios de COMEX pueden crear guías desde bodegas AUXILIAR.';

END IF;

END IF;

IF :object_type = '67'
AND (
    :transaction_type = 'A'
    OR :transaction_type = 'U'
) THEN CONT := 0;

SELECT
    COUNT(*) INTO CONT
FROM
    OWTR T0
    INNER JOIN WTR1 T1 ON T1."DocEntry" = T0."DocEntry"
    INNER JOIN OWHS W ON W."WhsCode" = T1."FromWhsCod"
    INNER JOIN OUSR U ON U."USERID" = T0."UserSign"
WHERE
    T0."DocEntry" = :list_of_cols_val_tab_del
    AND W."U_TP_ALMACEN" = 'AUXILIAR'
    AND U."USER_CODE" NOT IN ('SJIMENEZ', 'BSANCRISTOBAL');

IF CONT > 0 THEN error := 87;

error_message := 'Solo los usuarios de COMEX pueden crear transferencias desde bodegas AUXILIAR.';

END IF;

END IF;




------------------------------------ Invnetario----------------------------------------------------------------------------------

/*
--ENTRADA DE INVENTARIO 
--Dimensiones obligatorias
IF :object_type = '59' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM IGN1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 500;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 501;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 502;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;      	  
	  	
END FOR;       	  	   
END IF;




--SALIDA DE INVENTARIO 
--Dimensiones obligatorias
IF :object_type = '60' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
   SELECT T0."LineNum"  AS NL, T0."OcrCode", T0."OcrCode2", T0."OcrCode3"
   FROM IGE1 T0  
   INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode"
   WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode",'') =''
		THEN                                                                                                                                                             
	    	error := 503;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 504;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 505;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;      	  
	  	
END FOR;       	  	   
END IF;

------------------------------------Fin Invnetario----------------------------------------------------------------------------------
------------------------------------ Finanzas----------------------------------------------------------------------------------

--Asiento contable  
--Dimensiones obligatorias
IF :object_type = '59' and ( :transaction_type = 'A' OR :transaction_type = 'U') 
THEN 
    
 DECLARE CURSOR DET_ST FOR    
    SELECT T0."Line_ID"  AS NL, T0."ProfitCode", T0."OcrCode2", T0."OcrCode3"
	FROM JDT1 T0  
	INNER JOIN OACT T1 on T0."Account" = T1."AcctCode"
    WHERE T0."DocEntry" =:list_of_cols_val_tab_del  
    and T1."ActType" <> 'N'
    and T1."Segment_0" <> '7101105001'
    and T1."Segment_0" <> '7101105002'
   order by NL;
    
 FOR CUR_LINEA AS DET_ST DO  
  
  --------- Validador DIM1 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."ProfitCode",'') =''
		THEN                                                                                                                                                             
	    	error := 600;                                                                                                                                                
       		error_message := 'Falta la localidad en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;     	  
 
--------- Validador DIM2 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode2",'') =''
		THEN                                                                                                                                                             
	    	error := 601;                                                                                                                                                
       		error_message := 'Falta la dependencia en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;   
 --------- Validador DIM3 no vacia ----------------------------	       	 
    IF ifnull(CUR_LINEA."OcrCode3",'') =''
		THEN                                                                                                                                                             
	    	error := 602;                                                                                                                                                
       		error_message := 'Falta el area en la linea '||CUR_LINEA.NL+1;
                                                                   
       	  	BREAK;                                                                                                                                                       
     END IF;      	  
	  	
END FOR;       	  	   
END IF;
------------------------------------Fin Finanzas----------------------------------------------------------------------------------
-----------------------------------duplicidad de folios---------------------------------------------------------------------------
-- Validar que no existan folios duplicados para el mismo proveedor en Entradas de Mercancías y Facturas de Proveedor


/*
IF (:object_type IN ('18', '20')) AND (:transaction_type IN ('A', 'U')) THEN

    DECLARE Folio INT;
    DECLARE Indicador NVARCHAR(10);
    DECLARE FolioPref NVARCHAR(10);
    DECLARE Cancelado NVARCHAR(1);
    DECLARE CardCode NVARCHAR(15);
    DECLARE Duplicado INT;

    -- Obtener valores del documento actual (OPCH o OPDN)
    IF :object_type = '18' THEN  -- Entrada de mercancías
        SELECT IFNULL(TO."FolioNum", 0), 
               IFNULL(TO."Indicator", ''), 
               IFNULL(TO."FolioPref", ''), 
               TO."CANCELED", 
               TO."CardCode"
        INTO Folio, Indicador, FolioPref, Cancelado, CardCode
        FROM OPDN TO
        WHERE TO."DocEntry" = :list_of_cols_val_tab_del;
    ELSE  -- Factura de proveedor
        SELECT IFNULL(TO."FolioNum", 0), 
               IFNULL(TO."Indicator", ''), 
               IFNULL(TO."FolioPref", ''), 
               TO."CANCELED", 
               TO."CardCode"
        INTO Folio, Indicador, FolioPref, Cancelado, CardCode
        FROM OPCH TO
        WHERE TO."DocEntry" = :list_of_cols_val_tab_del;
    END IF;

    -- Validar duplicados en OPCH (facturas)
    SELECT COUNT(*) INTO Duplicado
    FROM OPCH T
    WHERE T."CardCode" = CardCode
      AND IFNULL(T."Indicator", '') = IFNULL(Indicador, '')
      AND IFNULL(T."FolioPref", '') = IFNULL(FolioPref, '')
      AND T."FolioNum" = Folio
      AND T."CANCELED" = 'N'
      AND T."DocEntry" <> :list_of_cols_val_tab_del;

    -- Validar duplicados en OPDN (entradas)
    SELECT Duplicado + COUNT(*)
    INTO Duplicado
    FROM OPDN T
    WHERE T."CardCode" = CardCode
      AND IFNULL(T."Indicator", '') = IFNULL(Indicador, '')
      AND IFNULL(T."FolioPref", '') = IFNULL(FolioPref, '')
      AND T."FolioNum" = Folio
      AND T."CANCELED" = 'N'
      AND T."DocEntry" <> :list_of_cols_val_tab_del;

    -- Lanzar error si existe duplicado y no es tipo NT
    IF Duplicado > 0 AND Indicador <> 'NT' THEN
        error := 45;
        error_message := 'El folio de este documento ya existe para este proveedor.';
    END IF;

END IF;
*/
/*
--------------------------------------------------------------------------------------------------------------------------------
-- Función			: VALIDADOR FOLIO FACTURAS DE PROVEEDOR	
-- Creado por			: BM	EXXIS
-- Fecha de Creación	:30-04-2025
------
IF :object_type = '18' AND (:transaction_type = 'A' OR :transaction_type = 'U')

	THEN
	SELECT COUNT(T0."DocEntry")
	into cont
	FROM "OPCH" T0
	WHERE T0."DocEntry"=list_of_cols_val_tab_del AND T0."Indicator" <> 'NL'
		AND T0."FolioNum" IN (SELECT A0."FolioNum"
								FROM OPCH A0
								WHERE A0."CardCode" = T0."CardCode"
								AND A0."FolioPref" = T0."FolioPref"
								AND A0."DocEntry" != list_of_cols_val_tab_del);
	
	IF cont > 0
	THEN
	error := 1801;
	error_message := N' El numero de folio se repite, favor verificar ';
END IF;
END IF;
------------------------------------------------------------------------------------------------------------------------------------------------ 
-- Función			: VALIDADOR FOLIO ENTRADA DE PROVEEDOR
-- Creado por			: BM	EXXIS
-- Fecha de Creación	:30-04-2025
------
IF :object_type = '20' AND (:transaction_type = 'A' OR :transaction_type = 'U')

	THEN
	SELECT COUNT(T0."DocEntry")
	into cont
	FROM "OPDN" T0
	WHERE T0."DocEntry"=list_of_cols_val_tab_del AND IFNULL(T0."Indicator", '') <> 'NL'
		AND T0."FolioNum" IN (SELECT A0."FolioNum"
								FROM OPDN A0
								WHERE A0."CardCode" = T0."CardCode"
								AND A0."FolioPref" = T0."FolioPref"
								AND A0."DocEntry" != list_of_cols_val_tab_del
								);
	
	IF cont > 0
	THEN
	error := 2001;
	error_message := N' El numero de folio se repite, favor verificar ';
END IF;
END IF;
--------------------------------------------------------------------------------------------------------------------------------
*/
-- Select the return values
select :error, :error_message FROM dummy;

end;