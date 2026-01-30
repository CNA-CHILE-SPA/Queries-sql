CREATE PROCEDURE SBO_SP_TransactionNotification
(
	in object_type nvarchar(30), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT
AS

--Inicio Variables Seidor
--Inicio variables Facturas de Compra
CardCode  nvarchar(20);
Folio,contadorFP1,contadorFP2,contadorFP3 , ContadorLin int;    
Indicador, FolioPref, cancelado nvarchar(2);
Duplicado nvarchar;
DOCSUBTYPE, FACTRESERVA, BLOQUEADA , NoRechazable  nvarchar(20);
--Inicio variables Orden de Fabricación
contadorOFAB1, contadorOFAB2 int;
--Inicio variables Socios de Negocios
contadorSN2, contadorSN3, contadorSN4, contadorSN5, contadorSN6, contadorSN7, contadorSN8, contadorSN9, valor, contadorSN10, contadorSN11, contadorSN12, contadorSN13, contadorSN20 int;
ruti nvarchar (20);
DV nvarchar (2);
--Inicio variables Maestro articulos
ItemName, BuyUnitMsr,  SalUnitMsr, InvntryUom nvarchar(100); 
--Inicio variables Orden de Compra
contadorOC1, contadorOC2, contadorOC3, contadorOC4, contadorOC5, contadorOC6, contadorOC7 int;
--Inicio variables Pedido de Entrada de Mercancias
contadorPEM1, contadorPEM2, contadorPEM3, contadorPEM4,folio2, cont1, cont2  int;
--Inicio variables Salida de Mercancias
contadorSM1, contadorSM2, contadorSM3, contadorSM4, contadorSM5 int;
--Inicio variables Entrada de Mercancias
contadorEM1, contadorEM2, contadorEM3, contadorEM4, NroSolicitud int;
--Inicio variables Transferencia de Stocks
contadorTF1, contadorTF2 int;
--Inicio variables Factura de Deudores
_Code, _StreetS, _CityS, _CountyS, _StreetB, _CityB, _CountyB, contadorFV1, contadorFV3 INT;
_Cancelado nvarchar(2);
contadorFV2, contadorFV4,contadorFV5 int;
Reserva nvarchar(1);
--Inicio variables Nota de Credito
contadorNC1,contadorNC2, contadorNC3 int;
--Inicio variables Listas de Materiales
contadorLT1, contadorofab3 int;
--Inicio variables Oferta de Ventas
contadorOF2, contadorOF3 int;
--Inicio variables Entrega
contadorENT1, contadorENT2, contadorENT3,contadorENT4, contadorENT5, PATENTE int;
--Inicio variables Orden de Venta
contadorOV1, contadorOV2, contadorOV3, contadorOV4, contadorOV5, contadorOV6, contadorOV8 int;
contadorOV7 nvarchar(100);
--Inicio variables Solicitud de Traslado
contadorST1, contadorST2, contadorST3 int;
--Inicio variables orden de compra borrador
contadorOCB int;
--Inicio variables pago recibido
contadorPR1, contadorPR2, contadorPR3, contadorPR4 int;
--Inicio variables Oferta de Compras
contadorOFC1, contadorOFC2, contadorOFC3, contadorOFC4 int;
--Inicio variables Solicitud de Compras
contadorSDC1, contadorSDC2, contadorSDC3, contadorSDC4, contadorSDC5 int;
--Inicio variable solicitud de despacho
contadorSD1, contadorSD2, contadorSD3 INT;

-- inicio variables ASB consultoria
zac_transportista int;
zac_valida int;
-- fin variables ASB consultoria

-- Fin Variables Seidor
CONT int;
error  int;				-- Result (0 for no error)
error_message nvarchar (200); 		-- Error string to be displayed
begin

error := 0;
error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------


--============================================================================================================
--                     1.- Validaciones Factura de Proveedores
--                         Seidor Chile 19-04-2018
--============================================================================================================
    
IF  object_type ='18' AND (transaction_type = 'A' or transaction_type = 'U') THEN  


    select ifnull(T0."FolioNum",0)    into folio      FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T0."Indicator",'0') into Indicador  FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T0."FolioPref",'0') into FolioPref  FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    SELECT T0."isIns" INTO Reserva FROM OPCH T0 WHERE T0."DocEntry" = list_of_cols_val_tab_del;
	select T0."CANCELED" into cancelado  FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del;	
	SELECT T0."CardCode" INTO CardCode FROM OPCH T0 WHERE T0."DocEntry" = list_of_cols_val_tab_del;
	SELECT COUNT(*) INTO Duplicado FROM OPCH T0 WHERE T0."CardCode" = CardCode AND IFNULL(T0."Indicator", '') = IFNULL(Indicador, '') AND T0."FolioNum" = Folio and IFNULL(T0."Indicator", '') <> 'NT' AND T0."DocEntry" <> list_of_cols_val_tab_del;
	/*SE AJUSTA ULTIMO SELECT PARA FOLIO DUPLICADO QUE HA DADO PROBLEMA DÍA 28/11/2023*/
	

    if (Indicador  <> 'NT' AND cancelado = 'N') then
      if (Folio = 0 or Indicador ='0' or folioPref ='0') then
           error := 1;
            error_message := N'Revisar Prefijo, Número de Folio y/o Indicador' ;
       end if;
    end if;       

	IF Duplicado > 0 THEN error := 1; /*SE AJUSTA LA CLAUSULA PARA QUE SEA MAYOR A 1 Y NO MAYOR A CERO 28/11/2023*/
	error_message := 'El folio de este documento ya existe';
	END IF;
	
	
	select ifnull(T0."DocSubType",'0') into DocSubType  FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T0."isIns",'0') into FactReserva  FROM OPCH T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T1."QryGroup1",'0') into NoRechazable  FROM OPCH T0 INNER JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"
      													where T0."DocEntry"=list_of_cols_val_tab_del ;    
      													
             
    select COUNT(*) into contadorlin  FROM PCH1 T0 INNER JOIN OITM T1 ON T1."ItemCode" = T0."ItemCode"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and IFNULL(T0."BaseType",'0') not in('20','18') 
                                      and T1."InvntItem"='Y';
                                      
    if  contadorlin > 0 and (DocSubType <>'DN' and FactReserva <> 'Y' and NoRechazable <>'Y')  then
            error := 1;
            error_message := N'Factura debe estar basada en Entrada de Mercaderia - Contadorlin '||TO_VARCHAR( contadorlin)
            ||' DocSubtype '||DocSubType 
            ||' Factura Reserva ' ||FactReserva
            ||' No Rechazable   ' ||NoRechazable ;
     end if;
      
      
     
--============================================================================================================
--                     1.2- Validaciones Nota de Credito de Proveedores
--                         Seidor Chile 13-01-2020
--============================================================================================================
     
ELSEIF    object_type ='19' AND (transaction_type = 'A' or transaction_type = 'U') THEN  


    select ifnull(T0."FolioNum",0)    into folio      FROM ORPC T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T0."Indicator",'0') into Indicador  FROM ORPC T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    select ifnull(T0."FolioPref",'0') into FolioPref  FROM ORPC T0 where T0."DocEntry"=list_of_cols_val_tab_del ;
    SELECT T0."isIns" INTO Reserva FROM ORPC T0 WHERE T0."DocEntry" = list_of_cols_val_tab_del;
	select T0."CANCELED" into cancelado  FROM ORPC T0 where T0."DocEntry"=list_of_cols_val_tab_del;	
	SELECT T0."CardCode" INTO CardCode FROM ORPC T0 WHERE T0."DocEntry" = list_of_cols_val_tab_del;
	SELECT COUNT(*) INTO Duplicado FROM ORPC T0 WHERE T0."CardCode" = CardCode AND IFNULL(T0."Indicator", '') = IFNULL(Indicador, '') AND T0."FolioNum" = Folio AND T0."DocEntry" <> list_of_cols_val_tab_del;
	
	

    if (Indicador  <> 'NT' AND cancelado = 'N') then
      if (Folio = 0 or Indicador ='0' or folioPref ='0') then
           error := 1;
            error_message := N'Revisar Prefijo, Número de Folio y/o Indicador - Nota de Credito' ;
       end if;
    end if;       

	IF Duplicado > 0 THEN error := 1;
	error_message := 'El folio de este documento ya existe - Nota de Credito';
	END IF;	
	
	
--============================================================================================================
--              17.-                  Validaciones Orden de Fabricación
--									- SEIDOR CHILE - 20-04-2018
--============================================================================================================
    	
	ELSEIF  object_type ='202' AND (transaction_type = 'A' or transaction_type = 'U' or transaction_type = 'L' ) AND error = 0 THEN 
     
  
      select DISTINCT COUNT(*) into contadorOFAB1 FROM OWOR T0    										
										INNER JOIN OUSR T2  ON T0."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_OF_CAB" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."Warehouse"; 
      
      select DISTINCT COUNT(*) into contadorOFAB2 FROM OWOR T0
           								INNER JOIN WOR1 T1 ON T0."DocEntry" = T1."DocEntry"    										
										INNER JOIN OUSR T2  ON T0."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_OF_DET" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T1."wareHouse"; 
       
       select DISTINCT COUNT(*) into contadorOFAB3 FROM OWOR T0
           								INNER JOIN WOR1 T1 ON T0."DocEntry" = T1."DocEntry" 								
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                        and  T0."Warehouse" <> T1."wareHouse";                                    
             
	 --select COUNT(*) into contadorOFAB1  FROM OWOR T0 
  	--								  INNER JOIN WOR1 T1 ON T0."DocEntry" = T1."DocEntry"                                      
   --									  where T0."DocEntry" = list_of_cols_val_tab_del
    --                                  and  T0."PlannedQty" > T0."CmpltQty" ;                                      
             
	
	--if  contadorOFAB1 > 0  then
    --     error := 17;
    --     error_message := N'La cantidad Planificada es mayor que la completada';
         --|| TO_VARCHAR( contadorOFAB1);
	--end if;

	if  contadorOFAB1 > 0  then
         error := 17;
         error_message := N'No está autorizado para usar esta bodega en la cabecera de la Orden de Fabricación';         
	end if;
	if  contadorOFAB2 > 0  then
         error := 17;
         error_message := N'No está autorizado para usar esta bodega en el detalle de la Orden de Fabricación';         
	end if;
	--if  contadorOFAB3 > 0  then
    --     error := 17;
    --     error_message := N'Bodega de Cabecera y de Detalle no pueden ser diferentes';         
	--end if;
	
--============================================================================================================
--              3.-                  Validaciones Maestro de SN
--									- SEIDOR CHILE - 20-04-2018
--============================================================================================================

ELSEIF  object_type ='2' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN 
    
				SELECT count (*) into contadorSN2 FROM OCRD T0 where 		   
				    IFNULL(T0."U_SEI_GNRP",'')='' AND T0."CardType" <> 'S' and T0."GroupCode"!=105
				       and T0."CardCode"=list_of_cols_val_tab_del;
				
				--SELECT count (*) into contadorSN3 FROM OCRD T0 where 		   
				   --IFNULL(T0."BankCode",'-1')='-1' AND T0."CardType" = 'S' AND T0."GroupCode" = 102
				       --and T0."CardCode"=list_of_cols_val_tab_del;
				
								
				SELECT COUNT(*) into contadorSN12 FROM OCRD T0
				WHERE T0."CardCode"=list_of_cols_val_tab_del
				AND T0."GroupCode" = 102;
							       	
				SELECT COUNT(*) into contadorSN5 FROM OCRD T0 
				WHERE  T0."CardCode"=list_of_cols_val_tab_del
				AND T0."CardType" = 'C' 				
				AND NOT EXISTS (
				SELECT 1 FROM CRD1 T1 
				WHERE T0."CardCode" = T1."CardCode" 
				AND T1."AdresType" = 'S' 
				AND IFNULL(T1."Street",'')<>''
				AND IFNULL(T1."County",'')<>''
				AND IFNULL(T1."Country",'')<>''
				AND IFNULL(T1."City",'')<>''
				AND IFNULL(T1."State",'')<>''
				AND IFNULL(T1."TaxCode",'')<>''	);
				
				SELECT COUNT(*) into contadorSN6 FROM OCRD T0 
				WHERE  T0."CardCode"=list_of_cols_val_tab_del
				AND T0."CardType" = 'C' and T0."GroupCode"!=105                         
				AND NOT EXISTS (
				SELECT 1 FROM CRD1 T1 
				WHERE T0."CardCode" = T1."CardCode" 
				AND T1."AdresType" = 'B' 
				AND IFNULL(T1."Street",'')<>''
				AND IFNULL(T1."County",'')<>''
				AND IFNULL(T1."Country",'')<>''
				AND IFNULL(T1."City",'')<>''
				AND IFNULL(T1."State",'')<>'');						
				                          
     SELECT count (*) into contadorSN9 FROM OCRD T0 where 		   
    			substring(T0."CardCode",0,1) <> 'C' 
       			and T0."CardCode"=list_of_cols_val_tab_del and T0."CardType" = 'C';  	
     
      SELECT count (*) into contadorSN10 FROM OCRD T0 where 		   
    			substring(T0."CardCode",0,1) <> 'P' 
       			and T0."CardCode"=list_of_cols_val_tab_del and T0."CardType" = 'S' and T0."GroupCode" = 101;  	
      
       SELECT count (*) into contadorSN8 FROM OCRD T0 where 		   
    			substring(T0."CardCode",0,1) <> 'H' 
       			and T0."CardCode"=list_of_cols_val_tab_del and T0."CardType" = 'S' and T0."GroupCode" = 105;  
        		       
      SELECT count (*) into contadorSN11 FROM OCRD T0 where 		   
    			substring(T0."CardCode",0,1) <> 'E' 
       			and T0."CardCode"=list_of_cols_val_tab_del and T0."CardType" = 'S' and T0."GroupCode" = 104;  
	       
	  SELECT count (*) into contadorSN13 FROM OCRD T0 
     where 	T0."CardCode"=list_of_cols_val_tab_del  and T0."GroupCode" <> 102 and T0."GroupCode" <> 103 ;
          
        
         IF
      (contadorSN13 > 0)
      THEN
      	    
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
        END IF;
        END IF;
         
         
	if (contadorSN2 > 0) then
		 error := 2;
		 error_message := N'Campo Giro es obligatorio para creación de SN Cliente';
	end if;	
	--if (contadorSN3 > 0) then
		 --error := 3;
		 --error_message := N'Debe ingresar banco para proveedores';	end if;	
		
		
	if (contadorSN6 > 0) then
		 error := 6;
		 error_message := N'Dirección de Facturación Incompleta (Calle/Numero ; Ciudad ; Comuna ; Pais; Región)';
	end if;		
	--if (contadorSN9 > 0) then
	--	 error := 7;
	--	 error_message := N'El Codigo del Cliente debe comenzar en C';
	--end if;	
	if (contadorSN10 > 0) then
		 error := 8;
		 error_message := N'El Codigo del Proveedor debe comenzar en P';
	end if;
	if (contadorSN8 > 0) then
		 error := 9;
		 error_message := N'El Codigo del Honorario debe comenzar en H';
	end if;
	--if (contadorSN8 > 0) then
	--	 error := 10;
	--	 error_message := N'El Codigo del Empleado debe comenzar en E';
	--end if;
	
        
--============================================================================================================
--              3.-                  Validaciones Maestro de Artículos
--									- SEIDOR CHILE - 15-08-2018
--============================================================================================================

ELSEIF object_type ='4' AND (transaction_type = 'A' or transaction_type = 'U') THEN 
     
 Select "ItemName"    into  ItemName FROM OITM   
where "ItemCode" =list_of_cols_val_tab_del;                                      
   if  IFNULL(ItemName,'')=''  then
           error := 11;
           error_message := N'Campo Obligatorio: Descripción' ;      
       END IF;
--============================================================================================================
--              4.-                  Validaciones Orden de Compra
--									- SEIDOR CHILE - 20-04-2018
--============================================================================================================

ELSEIF  object_type ='22' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN 
   
    
        select COUNT(*) into contadorOC3     FROM OPOR T0
  									   INNER JOIN POR1 T1 ON T0."DocEntry" = T1."DocEntry" 
   									   where T0."DocEntry"=list_of_cols_val_tab_del
                                       and  IFNULL(T1."TaxCode",'')='';
          
                                         
    select COUNT(*) into contadorOC2  FROM POR1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OPOR T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim1Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode",'')='' ;

        /*select COUNT(*) into contadorOC4  FROM POR1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OPOR T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim2Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode2",'')='' ;
                                      
        select COUNT(*) into contadorOC5 FROM POR1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OPOR T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim3Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode3",'')='' ;
        
             */                         
        select COUNT(*) into contadorOC7 FROM POR1  T0 
     								INNER JOIN OPOR T2 ON T0."DocEntry" = T2."DocEntry"
     								INNER JOIN OCRD T1 ON T2."CardCode" = T1."CardCode"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and IFNULL(T0."AgrNo",0)=0
                                      AND T1."QryGroup4" = 'Y' ; 

             if  contadorOC3 > 0  then
         error := 12;
         error_message := N'Hay una fila sin indicador de impuestos';
    end if;     
   
       if  contadorOC2 > 0  then
         error := 14;
         error_message := N'Deben indicar el Área Funcional ';
         end if; 
        --if  contadorOC4 > 0  then
         --error := 15;
         --error_message := N'Deben indicar el Tipo de Cliente';
         --end if; 
	--if  contadorOC5 > 0  then
         --error := 16;
         --error_message := N'Deben indicar el Tipo de Negocio';
        --end if; 
 
   
  --============================================================================================================
--            5.-         Validaciones Pedido de Entrada de Mercancias 
--                          Seidor Chile 20-04-2018
--============================================================================================================
        

ELSEIF  object_type ='20' AND (transaction_type = 'A' or transaction_type = 'U') THEN  

   select COUNT(*) into contadorPEM1  FROM PDN1 T0 
   										INNER JOIN OPDN T1 ON T0."DocEntry" = T1."DocEntry"
                                     where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  (IFNULL(T0."BaseType",0) <> 22 AND IFNULL(T0."BaseType",0) <> 18)  ;	
   
   select DISTINCT COUNT(*) into contadorPEM3 FROM PDN1 T0 
   										INNER JOIN OPDN T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_EM_COMPRAS" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."WhsCode";	
 cancelado:=0;                                     	      			      
select T0."CANCELED" into cancelado  FROM OPDN T0 where T0."DocEntry"=list_of_cols_val_tab_del;

      If  (contadorPEM1 > 0 AND cancelado = 'N')  then
          error := 18;
          error_message := N'Toda línea de Pedido de Entrada de Mercancias debe estar basada en una Orden de Compra' ;
      end if; 
      
       if  contadorPEM3 > 0  then
          error := 5;
          error_message := N'No está autorizado para utilizar una o más bodegas de la línea del documento' ;
      end if; 
     
  --============================================================================================================
--                     7.- Validaciones Entradas de Mercancías 
--                                 Seidor Chile 20-04-2018
--============================================================================================================
 ELSEIF object_type ='59' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN 
     contadorEM1 := 0; 
    select DISTINCT COUNT(*) into contadorEM1 FROM IGN1 T0 
   										INNER JOIN OIGN T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_EM_INV" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."WhsCode";
     

		
		if  contadorEM1 > 0  then
            error := 64;
           error_message := N'No está autorizado a usar una o mas bodegas del documento';
      end if;  
--============================================================================================================
--            9.-         Validaciones Factura de Deudores 
--                          Seidor Chile 20-04-2018
--============================================================================================================
  ELSEIF object_type ='13' AND (transaction_type = 'A' OR transaction_type = 'U' ) AND error = 0 THEN  
 
   SELECT COUNT(*) into contadorFV4 FROM OINV T0 INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
   WHERE T0."DocEntry" = list_of_cols_val_tab_del
   and T1."TaxCode" = 'IVA_EXE'
   and (T0."DocSubType" = '--' );

SELECT COUNT(*) into contadorFV5 FROM OINV T0 INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
   WHERE T0."DocEntry" = list_of_cols_val_tab_del
   and T1."TaxCode" = 'IVA'
   and (T0."DocSubType" = 'IX' OR T0."DocSubType" = 'IE'  );
   
   SELECT T0."isIns" INTO Reserva FROM OINV T0 WHERE T0."DocEntry" = list_of_cols_val_tab_del;
   SELECT "CANCELED" INTO _Cancelado FROM OINV WHERE "DocEntry" = list_of_cols_val_tab_del;
   
   SELECT DISTINCT COUNT(T1."BaseEntry") into contadorFV2 FROM OINV T0 INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
   WHERE T0."DocEntry" = list_of_cols_val_tab_del
   and T0."isIns" = 'Y'
   and IFNULL(T1."BaseEntry",0)<>0;
   
    SELECT  COUNT(*) into contadorFV1 FROM OINV T0 INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
   WHERE T0."DocEntry" = list_of_cols_val_tab_del
       and T0."isIns" = 'N' and (IFNULL(T1."BaseType",0)<>15);
	
	
	IF  _Cancelado = 'N' THEN
		SELECT 
			LENGTH(LTRIM(IFNULL("StreetS", ''))), 
			LENGTH(LTRIM(IFNULL("CityS", ''))), 
			LENGTH(LTRIM(IFNULL("CountyS", ''))), 
			LENGTH(LTRIM(IFNULL("StreetB", ''))), 
			LENGTH(LTRIM(IFNULL("CityB", ''))), 
			LENGTH(LTRIM(IFNULL("CountyB", '')))
		INTO _StreetS, _CityS, _CountyS, _StreetB, _CityB, _CountyB
		FROM INV12 T12
		INNER JOIN OINV T1 ON T12."DocEntry" = T1."DocEntry"
		where T12."DocEntry"=list_of_cols_val_tab_del AND T1."CANCELED" = 'N';
				
		
		IF _StreetB = 0 THEN
			error := 26;
	        error_message := N'Debe Ingresar Direccion de Facturacion';
		ELSEIF _CityB = 0 THEN
			error := 27;
	        error_message := N'Debe Ingresar Ciudad de Facturacion';
		ELSEIF _CountyB = 0 THEN
			error := 28;
	        error_message := N'Debe Ingresar Comuna de Facturacion';
		END IF;

		END IF;

		
	--if  contadorFV4 > 0  then
   --       error := 35;
    --      error_message := N'Hay una fila con indicador Exento. Debe usar formulario Factura Exenta. ' ;
     --     END IF;	
          
    if  contadorFV5 > 0  then
          error := 35;
          error_message := N'Hay una fila con indicador Afecto. Debe usar formulario Factura Deudores. ' ;
          END IF;

--if  contadorFV2 > 0  then
  --        error := 35;
 --         error_message := N'Las Facturas de Reserva solo pueden estar basadas en una Orden de Venta ' ;
 --        END IF;

--if  contadorFV1 > 0  then
 --         error := 35;
  --        error_message := N'Toda Factura de Deudores debe estar basada en una Entrega ' ;
  --        END IF;


   --============================================================================================================
--            10.-         Validaciones Nota de Credito
--                          Seidor Chile 20-04-2019
--============================================================================================================
 ELSEIF object_type ='14' AND (transaction_type = 'A' or transaction_type = 'U' ) AND error = 0 THEN  
 
 
  select COUNT(*) into contadorNC2  FROM ORIN T0 
   									   where T0."DocEntry"=list_of_cols_val_tab_del
                                       and  T0."SlpCode"=-1;

  SELECT "CANCELED" INTO _Cancelado FROM ORIN WHERE "DocEntry" = list_of_cols_val_tab_del;


	IF  _Cancelado = 'N' THEN
		SELECT 
			LENGTH(LTRIM(IFNULL("StreetS", ''))), 
			LENGTH(LTRIM(IFNULL("CityS", ''))), 
			LENGTH(LTRIM(IFNULL("CountyS", ''))), 
			LENGTH(LTRIM(IFNULL("StreetB", ''))), 
			LENGTH(LTRIM(IFNULL("CityB", ''))), 
			LENGTH(LTRIM(IFNULL("CountyB", '')))
		INTO _StreetS, _CityS, _CountyS, _StreetB, _CityB, _CountyB
		FROM RIN12 T12
		INNER JOIN ORIN T1 ON T12."DocEntry" = T1."DocEntry"
		where T12."DocEntry"=list_of_cols_val_tab_del AND T1."CANCELED" = 'N';
		
		IF _StreetB = 0 THEN
			error := 32;
	        error_message := N'Debe Ingresar Direccion de Facturacion';
		ELSEIF _CityB = 0 THEN
			error := 33;
	        error_message := N'Debe Ingresar Ciudad de Facturacion';
		ELSEIF _CountyB = 0 THEN
			error := 34;
	        error_message := N'Debe Ingresar Comuna de Facturacion';
		END IF;
    END IF;          
        if  contadorNC2 > 0  then
          error := 35;
          error_message := N'Vendedor es un campo obligatorio ' ;
          END IF;
          
     
--============================================================================================================
--            15.-         Validaciones Traslado
--                          Seidor Chile 08-07-2018
--============================================================================================================
 ELSEIF object_type ='67' AND (transaction_type = 'A' OR transaction_type = 'U' ) AND error = 0 THEN 
 
select DISTINCT COUNT(*) into contadorST1 FROM WTR1 T0 
   										INNER JOIN OWTR T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_TS_DESDE" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."FromWhsCod";

select DISTINCT COUNT(*) into contadorST2 FROM WTR1 T0 
   										INNER JOIN OWTR T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_TS_HASTA" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."WhsCode";
 
  select DISTINCT COUNT(*) into contadorST3 FROM OWTR T0 
   										where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T0."CardCode",'') <> 'C76474349-0';
 
 
   if  contadorST1 > 0  then
          error := 15;
          error_message := N'No está autorizado para utilizar una de las bodegas de origen' ;
          END IF;
   
      if  contadorST2 > 0  then
          error := 15;
          error_message := N'No está autorizado para utilizar una de las bodegas de destino' ;
          END IF;
          
           if  contadorST3 > 0  then
          error := 155;
          error_message := N'No es posible generar este documento con un SN diferente a CNA' ;
          END IF;
--============================================================================================================
--            13.-         Validaciones Entregas
--                          Seidor Chile 08-07-2018
--============================================================================================================
   ELSEIF object_type ='15' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN  
  
   
    select COUNT(*) into contadorENT1  FROM DLN1 T0 
   										INNER JOIN ODLN T1 ON T0."DocEntry" = T1."DocEntry"
                                     where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  (IFNULL(T0."BaseEntry",0)=0);
    
    select DISTINCT COUNT(*) into contadorENT2 FROM DLN1 T0 
   										INNER JOIN ODLN T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_EM_VENTAS" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."WhsCode";
                                      
    select COUNT(*) into contadorENT3  FROM DLN1 T0 
   										INNER JOIN ODLN T1 ON T0."DocEntry" = T1."DocEntry"
                                     where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  T1."U_SEI_OCDESC"='SI'
                                      and T1."U_SEI_ITRS" <> 6
                                      AND T1."UserSign" NOT IN (44,55);
     
        select COUNT(*) into contadorENT4  FROM DLN1 T0 
   										INNER JOIN ODLN T1 ON T0."DocEntry" = T1."DocEntry"
                                     where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  T0."WhsCode"='01';
          --select COUNT(*) into contadorENT5  FROM DLN1 T0 
   										--INNER JOIN ODLN T1 ON T0."DocEntry" = T1."DocEntry"
                                     --where T0."DocEntry"=list_of_cols_val_tab_del
                                     -- and ( IFNULL(T1."U_SEI_RTTR",'')='' OR
                                     -- IFNULL(T1."U_SEI_RTCH",'')='' OR
                                     -- IFNULL(T1."U_SEI_PTT",'')='' OR
                                     -- IFNULL(T1."U_SEI_NCHF",'')='');
     
     -- if  contadorENT1 > 0  then
      --    error := 36;
      --    error_message := N'Toda línea de Entrega debe estar basada en un documento' ;
       --   END IF;
      -- 
      
         if  contadorENT4 > 0  then
          error := 36;
          error_message := N'Debe seleccionar un almacen diferente al 01' ;
          END IF;
          
         
          if  contadorENT2 > 0  then
          error := 13;
          error_message := N'No está autorizado para utilizar alguna de las bodegas de la línea del documento' ;
          END IF;
          
          -- if  contadorENT5 > 0  then
         -- error := 36;
         -- error_message := N'Los siguientes campos son obligatorio: Rut Chofer, Rut Transportista, patente, Nombre Chofer' ;
        --  END IF;
      
      --  if  contadorENT3 > 0  then
       --   error := 36;
       --   error_message := N'Si el campo oculta descuento tiene valor SI, entonces debe cambiar el indicador de traslado a 6 .- Otros traslados no venta.' ;
       --   END IF;

 SELECT "CANCELED" INTO _Cancelado FROM ODLN WHERE "DocEntry" = list_of_cols_val_tab_del;
	IF  _Cancelado = 'N' THEN
		SELECT 
			LENGTH(LTRIM(IFNULL("StreetS", ''))), 
			LENGTH(LTRIM(IFNULL("CityS", ''))), 
			LENGTH(LTRIM(IFNULL("CountyS", ''))), 
			LENGTH(LTRIM(IFNULL("StreetB", ''))), 
			LENGTH(LTRIM(IFNULL("CityB", ''))), 
			LENGTH(LTRIM(IFNULL("CountyB", '')))
		INTO _StreetS, _CityS, _CountyS, _StreetB, _CityB, _CountyB
		FROM DLN12 T12
		INNER JOIN ODLN T1 ON T12."DocEntry" = T1."DocEntry"
		where T12."DocEntry"=list_of_cols_val_tab_del AND T1."CANCELED" = 'N';
		
		IF _StreetS = 0 THEN
			error := 37;
	        error_message := N'Debe Ingresar Direccion de Despacho';
		ELSEIF _CityS = 0 THEN
			error := 38;
	        error_message := N'Debe Ingresar Ciudad de Despacho';
		ELSEIF _CountyS = 0 THEN
			error := 39;
	        error_message := N'Debe Ingresar Comuna de Despacho';
		ELSEIF _StreetB = 0 THEN
			error := 40;
	        error_message := N'Debe Ingresar Direccion de Facturacion';
		ELSEIF _CityB = 0 THEN
			error := 41;
	        error_message := N'Debe Ingresar Ciudad de Facturacion';
		ELSEIF _CountyB = 0 THEN
			error := 42;
	        error_message := N'Debe Ingresar Comuna de Facturacion';
		END IF;

    END IF;

   --============================================================================================================
--              21.-                  Validaciones Salida de Mercancías
--									- SEIDOR CHILE - 19-11-2018
--============================================================================================================
  ELSEIF object_type ='60' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN 
     

  	select COUNT(*) into contadorSM1  FROM IGE1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OIGE T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim1Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode",'')='' ;
                                      
	select COUNT(*) into contadorSM2  FROM IGE1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OIGE T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim2Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode2",'')='' ;
                                      
	select COUNT(*) into contadorSM3  FROM IGE1  T0 
     									INNER JOIN OACT T1 ON T1."AcctCode" = T0."AcctCode"
     									INNER JOIN OIGE T2 ON T0."DocEntry" = T2."DocEntry"
                                      where T0."DocEntry"=list_of_cols_val_tab_del
                                      and T1."Dim3Relvnt" ='Y'
                                      and IFNULL(T0."OcrCode3",'')='' ;
    
      select DISTINCT COUNT(*) into contadorSM4 FROM IGE1 T0 
   										INNER JOIN OIGE T1 ON T0."DocEntry" = T1."DocEntry"
										INNER JOIN OUSR T2  ON T1."UserSign" = T2."USERID"
   										INNER JOIN "@SEI_CAB_BOD" T3 ON T2."USER_CODE" = T3."Code"
   										LEFT JOIN "@SEI_SM_INV" T4 ON T3."Code" = T4."Code"
                                        where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  IFNULL(T4."U_SEI_CBOD",'')= T0."WhsCode";
                                      
    
    if  contadorSM4 > 0  then
            error := 64;
           error_message := N'No está autorizado a usar una o mas bodegas del documento';
      end if; 
                                      
                                      
 --============================================================================================================
--                     22- Validaciones Solicitudes de despacho
--                         Seidor Chile 14-08-2020
--============================================================================================================
     
ELSEIF object_type ='SEI_SOLICITUDC' AND transaction_type = 'A' THEN  

    SELECT (COUNT("U_SEI_RDRENTRY") - COUNT(T1."DocEntry")) INTO contadorSD1
	FROM "@SEI_SOLICITUDET" T0
	LEFT OUTER JOIN "ORDR" T1 ON TO_VARCHAR(T1."DocEntry") = TO_VARCHAR(T0."U_SEI_RDRENTRY") 
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
	AND T0."U_SEI_ITEM" IS NOT NULL;	
	
	SELECT COUNT("U_SEI_DISPO") INTO contadorSD2
	FROM "@SEI_SOLICITUDET" T0
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
	AND T0."U_SEI_ITEM" IS NOT NULL
	AND "U_SEI_DISPO" = 0;  
	
	SELECT COUNT("U_SEI_CANTIDISPO") INTO contadorSD3
	FROM "@SEI_SOLICITUDET" T0
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
	AND T0."U_SEI_ITEM" IS NOT NULL
	AND TO_DOUBLE("U_SEI_CANTIDISPO") > TO_DOUBLE("U_SEI_CANTSOLICI");  

	/*
	
	IF contadorSD1 > 0 THEN 
		error := 22;
		error_message := 'La orden de venta referenciada no existe en SAP - campo U_SEI_RDRENTRY';
	END IF;	       
	
	*/                             
    
    IF contadorSD2 > 0 THEN 
		error := 22;
		error_message := 'La Cantidad disponible debe ser mayor a cero (0) - campo U_SEI_DISPO';
	END IF;	
	
	IF contadorSD3 > 0 THEN 
		error := 22;
		error_message := 'La Cantidad por fabricar debe ser menor o igual al solicitado - campo U_SEI_CANTIDISPO menor o igual a U_SEI_CANTSOLICI';
	END IF;	

   --============================================================================================================
--              23.-                  Validaciones Orden de Venta
--									- SEIDOR CHILE - 14-11-2019
--============================================================================================================
  ELSEIF object_type ='17' AND (transaction_type = 'A' or transaction_type = 'U') AND error = 0 THEN 
     
                                  
    select COUNT(*) into contadorOV1  FROM RDR1 T0 
  
                                     where T0."DocEntry"=list_of_cols_val_tab_del
                                      and  T0."WhsCode"='01';
      
         if  contadorOV1 > 0  then
          error := 39;
          error_message := N'Debe seleccionar un almacen diferente al 01' ;
          END IF;
          
          
          
       
end if;   


IF object_type = '15'  AND (transaction_type = 'A' OR transaction_type = 'U')
THEN
	CONT=0;
	SELECT
	COUNT (T0."DocEntry")
	INTO CONT
	FROM "ODLN" T0 INNER JOIN DLN1 T1 ON T1."DocEntry" = T0."DocEntry"
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
			AND T1."Quantity" > IFNULL (T1."BaseOpnQty", 0)
			AND ifnull(T1."BaseEntry",0) > 0;
	IF CONT > 0 
	THEN
		error := 81;
		error_message := 'La Cantidad a Entregar no puede exceder la cantidad pendiente';
	END IF;
END IF;

--********************************************

IF object_type = '112'  AND (transaction_type = 'A' OR transaction_type = 'U')
THEN
	CONT=0;
	SELECT
	COUNT (T0."DocEntry")
	INTO CONT
	FROM "ODRF" T0 
	INNER JOIN "DRF1" T1 ON T1."DocEntry" = T0."DocEntry"
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
			and T0."ObjType" =20
			AND T1."Quantity" > IFNULL (T1."BaseOpnQty", 0)
			AND ifnull(T1."BaseEntry",0) > 0;
	IF CONT > 0 
	THEN
		error := 82;
		error_message := 'La Cantidad a Ingresar no puede exceder la cantidad pendiente del Doc. Base';
	END IF;
END IF;

IF object_type = '20'  AND (transaction_type = 'A' OR transaction_type = 'U')
THEN
	CONT=0;
	SELECT
	COUNT (T0."DocEntry")
	INTO CONT
	FROM "OPDN" T0 INNER JOIN PDN1 T1 ON T1."DocEntry" = T0."DocEntry"
	WHERE T0."DocEntry" = list_of_cols_val_tab_del
			AND T1."Quantity" > IFNULL (T1."BaseOpnQty", 0)
			AND ifnull(T1."BaseEntry",0) > 0;
	IF CONT > 0 
	THEN
		error := 83;
		error_message := 'La Cantidad a Ingresar no puede exceder la cantidad pendiente del Doc. Base';
	END IF;
END IF;


---------------------------------------------------------------------------
-- centro costo OLDN ENTREGA
---------------------------------------------------------------------------

/*IF  object_type ='15' AND (transaction_type = 'A') AND error = 0 THEN 

   

   SELECT COUNT(*) INTO PATENTE FROM  ODLN T0 
   WHERE T0."DocEntry"=list_of_cols_val_tab_del AND IFNULL(T0."U_SEI_PTT",'')='' ;

   


IF (PATENTE >0) THEN

		 error := 1;

		 error_message := N'El campo PATENTE no puede estar vacio';

END IF;	

END IF;*/

--============================================================================================================
--                     1.- Validaciones Campos de Usuario Necesarios en la Entrega
--                         Seidor Chile 26/04/2023
--============================================================================================================
    
IF  object_type ='15' AND (transaction_type = 'A' or transaction_type = 'U') THEN  

     declare datoblentr int;
     SELECT COUNT(*) INTO datoblentr FROM  ODLN T0 
     WHERE T0."DocEntry"=list_of_cols_val_tab_del AND (IFNULL(T0."U_SEI_PTT",'')='' or IFNULL(T0."U_SEI_RTCH",'')='' OR IFNULL(T0."U_SEI_RTTR",'')='' OR IFNULL(T0."U_SEI_NCHF",'')='') ;
    IF datoblentr > 0 
	  THEN
		error := 1000;
		error_message := 'Debe completar los datos para la Entrega: Patente, Rut Chofer, Rut Transportista, Nombre del Chofer. Verifique los campos de Usuario';
	END IF;

END IF;
--============================================================================================================
--    Numero Soicitud en Entregas
--    Seidor Chile 17/07/2023
--============================================================================================================
IF  object_type ='15' AND (transaction_type = 'A' or transaction_type = 'U') THEN  

   
     SELECT COUNT(*) INTO NroSolicitud FROM  DLN1 T0 
     		WHERE T0."DocEntry"=list_of_cols_val_tab_del 
     		AND  IFNULL(T0."U_SEI_NUMEROSOLICITUD",'')='' ;
  
    IF NroSolicitud > 0 
	  THEN
		error := 1000;
		error_message := 'Toda Entrega debe tener un Nro de Solicitud, Favor validar.';
	END IF;

END IF;
--------------------------------------------------------------------------------------------
--- VALIDA ENTRADA DE INVENTARIO SIN COSTO CERO (0)
--------------------------------------------------------------------------------------------------------------------------------

cont1:=0;
cont2:=0;

 IF (object_type='59' ) AND (transaction_type ='A' or transaction_type ='U') THEN 

       SELECT COUNT(*) into cont1 FROM  IGN1 T0 
       INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode" 
       WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
       --AND (T1."ItmsGrpCod" <> '104' 
       --AND  T1."ItmsGrpCod" <> '105') 
       --AND  IFNULL(T0."BaseRef" ,'0')='0'
		AND T0."BaseType" = '-1'
       AND  T0."Price"<= 0;
       
       
        IF cont1  > 0 THEN 
      error := 1;
      error_message := 'Debe indicar Precio por Unidad,no puede ingresar articulos sin costo';
    END IF; 
   
 END IF;
       
       
--============================================================================================================
--   INICIO Validar Transportista en la entrega
--   ASB consultoria 11/06/2024
--============================================================================================================
IF  object_type ='15' AND (transaction_type = 'A' or transaction_type = 'U') THEN  

   
     SELECT COUNT(*) INTO zac_transportista FROM  ODLN T0 
            INNER JOIN OCRD T2 on T2."LicTradNum" = T0."U_SEI_RTTR"
     		WHERE T0."DocEntry"=list_of_cols_val_tab_del;
     		
    IF zac_transportista = 0 
	  THEN
		error := 2000;
		error_message := 'Debe ingresar un Rut de Transportista que exista';
	END IF;

END IF;

 --============================================================================================================
--   FIN Validar Transportista en la entrega
--   ASB consultoria 11/06/2024
--============================================================================================================



--============================================================================================================
--   INICIO Validar Seguro de Factura
--   ASB consultoria 14/07/2024
--============================================================================================================
IF  object_type ='13' AND (transaction_type = 'A' or transaction_type = 'U') THEN  

   
     SELECT COUNT(*) INTO zac_valida FROM  OINV T0
     		WHERE IFNULL(T0."U_ZA_Asegurada",'')<>''   
     		and T0."DocEntry"=list_of_cols_val_tab_del;
     		
    IF zac_valida = 0 
	  THEN
		error := 2001;
		error_message := 'Debe Validar seguro de la factura';
	END IF;

END IF;

 --============================================================================================================
--   FIN Validar Seguro de Factura
--   ASB consultoria 14/07/2024
--============================================================================================================
       
 --------------------------------------------------------------------------------------------------------------------------------

-- Select the return values
select :error, :error_message FROM dummy;

end;
