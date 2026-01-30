CREATE PROCEDURE SBO_SP_PostTransactionNotice (
  in object_type nvarchar(100),
  -- SBO Object Type
  in transaction_type nchar(1),
  -- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
  in num_of_cols_in_key int,
  in list_of_key_cols_tab_del nvarchar(255),
  in list_of_cols_val_tab_del nvarchar(255)
) LANGUAGE SQLSCRIPT AS -- Return values
error int;

-- Result (0 for no error)
error_message nvarchar (200);

-- Error string to be displayed
_DocSubType nvarchar(20);

_CodigoSII nvarchar(20);

_BranchId int;

_SERIE INT;

_doc nvarchar(20);

CONT0 INT;

begin error := 0;

error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------FEX INICIO------------------
-- Factura Electronica AFECTA Y EXENTA
IF (:object_type = '13')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OINV" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('33', '34', '39')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_FACTURA_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "OINV"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  OINV
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- NOTA DEBITO ELECTRONICA
IF (:object_type = '13')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OINV" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('56')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_NOTA_DEBITO_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "OINV"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  OINV
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- NOTA CREDITO Electronica  
IF (:object_type = '14')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ORIN" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('61')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_NOTA_CREDITO_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ORIN"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  ORIN
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- NOTA CREDITO Electronica  COMPRA
IF (:object_type = '19')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ORPC" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('61')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_NOTA_CREDITO_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ORPC"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  "ORPC"
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- guia despacho entrega
IF (:object_type = '15')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ODLN" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('52')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_GUIA_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ODLN"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  ODLN
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- guia despacho (TRASLADOS)
IF (
  :object_type = '67'
  OR :object_type = 'oStockTransfer'
)
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OWTR" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T0."DocSubType" = '--'
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_GUIA_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "OWTR"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  OWTR
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

--Factura COMPRA
IF (:object_type = '18')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OPCH" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('46', '56')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN
SELECT
  T1."U_FE_TipoDte",
  T0."DocSubType",
  T0."BPLId" INTO _CodigoSII,
  _DocSubType,
  _BranchId
FROM
  "OPCH" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" in ('46', '56')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

UPDATE
  "OPCH"
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

--UPDATE "OPCH"  SET "U_EXX_FE_PdfCreado" = 'NO',"U_EXX_FE_MailEnviado"= 'NO' ,"U_EXX_FE_Estado" = 'NEN',"U_EXX_FE_CODERR" = '' ,"U_EXX_FE_DESERR" = '',"U_EXX_FE_TrackID" = '' WHERE "DocEntry" = :list_of_cols_val_tab_del;
CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  IFNULL(:_BranchId, 0)
);

END IF;

END IF;

-- guia despacho entrega
IF (:object_type = '21')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ORPD" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('52')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_GUIA_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ORPD"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  ORPD
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- Factura Electronica ANTICIPO
IF (:object_type = '203')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ODPI" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('33')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_FACTURA_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ODPI"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  ODPI
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- Factura Electronica Exportacion
IF (:object_type = '13')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OINV" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('110')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  '110' INTO _CodigoSII
FROM
  DUMMY;

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "OINV"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  OINV
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Print" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

---- Nota de debito de exportacion
IF (:object_type = '13')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "OINV" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('111')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  '111' INTO _CodigoSII
FROM
  DUMMY;

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "OINV"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  OINV
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Print" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

-- NOTA CREDITO Electronica de Exportacion 
IF (:object_type = '14')
and (:transaction_type = 'A')
and (:error = 0) THEN
SELECT
  COUNT(*) INTO _SERIE
FROM
  "ORIN" T0
  inner join "NNM1" T1 ON T0."Series" = T1."Series"
WHERE
  T0."DocEntry" = :list_of_cols_val_tab_del
  AND T1."U_FE_TipoDte" IN ('112')
  AND T1."U_FE_SeriElectr" = 'Y'
  and T1."Locked" = 'N';

IF IFNULL(:_SERIE, 0) > 0 THEN --ASIGNACION DE FOLIO
SELECT
  "TpoDTE" INTO _CodigoSII
FROM
  "FN_EXXIS_FE_NOTACREDITO_EXPORTACION_IDDOC" (:list_of_cols_val_tab_del, :object_type);

SELECT
  "BPLId",
  "DocSubType" INTO _BranchId,
  _DocSubType
from
  "ORIN"
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

UPDATE
  ORIN
SET
  "U_EXX_FE_PdfCreado" = 'NO',
  "U_EXX_FE_MailEnviado" = 'NO',
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_CODERR" = '',
  "U_EXX_FE_DESERR" = '',
  "U_EXX_FE_TrackID" = ''
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

CALL "SP_EXXIS_FE_FOLIOS" (
  :list_of_cols_val_tab_del,
  :object_type,
  :_DocSubType,
  :_CodigoSII,
  :_BranchId
);

END IF;

END IF;

--ASIGNA REFERENCIA AUTOMATICA
/*IF (:object_type ='14') and ( :transaction_type in ('A','U') and (:error = 0))
 THEN
 SELECT
 CAST(MAX(T2."U_FE_TipoDte") AS nvarchar(100)) ,
 CAST(MAX(T1."FolioNum")  AS nvarchar(100)) ,
 TO_VARCHAR(MAX(T1."DocDate"),'YYYY-MM-DD') ,
 CASE WHEN MAX(T3."DocTotal")=MAX(T1."DocTotal") THEN '1'
 WHEN MAX(T3."DocTotal")<MAX(T1."DocTotal") THEN '3' else '2' END 
 into _doc, _folio, _fecha, _codigo
 FROM RIN1 T0 
 INNER JOIN OINV T1 ON T0."BaseEntry"=T1."DocEntry" AND "T0"."BaseType"='13'
 INNER JOIN NNM1 T2 ON T1."Series"=T2."Series" 
 INNER JOIN ORIN T3 ON T0."DocEntry"=T3."DocEntry"
 WHERE T0."DocEntry" = CAST(:list_of_cols_val_tab_del AS VARCHAR(100))
 GROUP BY T1."DocEntry"
 HAVING IFNULL(MAX(T1."FolioNum"),0)>0;		
 
 UPDATE ORIN SET "U_EXX_FE_TDBSII" = _doc ,"U_EXX_FE_FOLIODB"= _folio ,"U_EXX_FE_FECHADB" = _fecha, "U_EXX_FE_CODREFDB" = _codigo WHERE "DocEntry" = :list_of_cols_val_tab_del;
 
 END IF;*/
--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-----ACTUALIZA ESTADO DE FEX CUANDO NO SE TIENE FOLIO
IF :object_type = '16'
AND (:transaction_type = 'A') THEN
UPDATE
  ORDN
SET
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_TrackID" = '',
  "U_EXX_FE_CODERR" = 'No Enviado',
  "U_EXX_FE_DESERR" = 'No Enviado'
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

END IF;

--ACTUALIZA ESTADO DE FEX CUANDO NO SE TIENE FOLIO
IF :object_type = '13'
AND (:transaction_type = 'A') THEN
UPDATE
  OINV
SET
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_TrackID" = '',
  "U_EXX_FE_CODERR" = 'No Enviado',
  "U_EXX_FE_DESERR" = 'No Enviado'
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

END IF;

--ACTUALIZA ESTADO DE FEX CUANDO NO SE TIENE FOLIO
IF :object_type = '14'
AND (:transaction_type = 'A') THEN
UPDATE
  ORIN
SET
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_TrackID" = '',
  "U_EXX_FE_CODERR" = 'No Enviado',
  "U_EXX_FE_DESERR" = 'No Enviado'
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

END IF;

--ACTUALIZA ESTADO DE FEX CUANDO NO SE TIENE FOLIO
IF :object_type = '15'
AND (:transaction_type = 'A') THEN
UPDATE
  ODLN
SET
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_TrackID" = '',
  "U_EXX_FE_CODERR" = 'No Enviado',
  "U_EXX_FE_DESERR" = 'No Enviado'
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

END IF;

--ACTUALIZA ESTADO DE FEX CUANDO NO SE TIENE FOLIO
IF :object_type = '203'
AND (:transaction_type = 'A') THEN
UPDATE
  ODPI
SET
  "U_EXX_FE_Estado" = 'NEN',
  "U_EXX_FE_TrackID" = '',
  "U_EXX_FE_CODERR" = 'No Enviado',
  "U_EXX_FE_DESERR" = 'No Enviado'
WHERE
  "DocEntry" = :list_of_cols_val_tab_del;

END IF;

-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------- CNA Servicio Asientos contables ----------------------------------------------------
call EXX_CNAFiltro(
  :object_type,
  :transaction_type,
  :num_of_cols_in_key,
  :list_of_key_cols_tab_del,
  :list_of_cols_val_tab_del
);

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- Select the return values
select
  :error,
  :error_message
FROM
  dummy;

end