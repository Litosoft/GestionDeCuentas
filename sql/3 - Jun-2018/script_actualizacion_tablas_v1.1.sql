
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	ACTUALIZACION DE TABLA EGRESOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

If Exists(Select * From sys.foreign_keys Where name = N'FK_GASTO_DETALLE_GASTO' And type = 'F')
	Alter Table SC_COMUN.SE_GASTO_DETALLE Drop Constraint FK_GASTO_DETALLE_GASTO
Go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla Registro de Gastos
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_GASTO') is not null)
	drop table SC_COMUN.SE_GASTO
go

Create Table SC_COMUN.SE_GASTO(
	GAST_sGASTO_ID				Smallint Identity(1,1) not null,
	GAST_dFECHA					Smallint not null,
	
	GAST_sOSE_ID				Smallint not null,
	GAST_sCTACTE_ID				Smallint not null,
	GAST_iNUMREGISTRO			Int null,
	GAST_dFECHAGASTO			Datetime not null,
	GAST_tTIPOPROVEEDOR			Tinyint not null,
	GAST_sIDPROVEEDOR			Smallint not null,
	GAST_vDETALLEGASTO			varchar(255) null,
	GAST_tFORMAPAGO				Tinyint not null,
	GAST_sIDCUENTACTE			Smallint null,
	GAST_sNUMEROCHEQUE			VarChar(25) null,
	GAST_bESCAJACHICA			bit not null default 0,

	GAST_sSITUACION				Smallint not null default 9,	-- Situacion del registro (9 ..1)
	GAST_sBLOCKHASH				Varchar(max) null,
	
	GAST_sUSUARIO_CREACION		Smallint	not null,
	GAST_vIP_CREACION			Varchar(15)	not null,
	GAST_dFECHA_CREACION		Datetime	not null default GetDate(),
	GAST_sUSUARIO_MODIFICACION	Smallint	null,
	GAST_vIP_MODIFICACION		Varchar(15)	null,
	GAST_dFECHA_MODIFICACION	Datetime	null,
	GAST_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_GASTO
	Add Constraint PK_GASTO_ID Primary Key (GAST_sGASTO_ID);
go

Create NonClustered Index IDN_GASTO_cESTADO on SC_COMUN.SE_GASTO(GAST_cESTADO)
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla Detalle del Formato de Egreso
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_GASTO_DETALLE') is not null)
	drop table SC_COMUN.SE_GASTO_DETALLE
go

Create Table SC_COMUN.SE_GASTO_DETALLE(
	GADE_sGASTODETALLE_ID		Smallint Identity(1,1) not null,
	GADE_sGASTO_ID				Smallint not null,
	
	GADE_tDESTINO_ID			Tinyint not null,
	GADE_tPROGRAMA_ID			Tinyint not null,
	GADE_sCLASIFICACION_ID		Smallint not null,
	GADE_dIMPORTE				Decimal(15,2) not null,

	GADE_sSITUACION				Smallint not null,	-- Situacion del registro (9 ..1)
	GAST_sBLOCKHASH				Varchar(max) null,
	
	GADE_sUSUARIO_CREACION		Smallint	not null,
	GADE_vIP_CREACION			Varchar(15)	not null,
	GADE_dFECHA_CREACION		Datetime	not null default GetDate(),
	GADE_sUSUARIO_MODIFICACION	Smallint	null,
	GADE_vIP_MODIFICACION		Varchar(15)	null,
	GADE_dFECHA_MODIFICACION	Datetime	null,
	GADE_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_GASTO_DETALLE
	Add Constraint PK_GASTO_DETALLE_ID Primary Key (GADE_sGASTODETALLE_ID);
go

Create NonClustered Index IDN_GASTO_DETALLE_cESTADO on SC_COMUN.SE_GASTO_DETALLE(GADE_cESTADO)
go

Alter Table SC_COMUN.SE_GASTO_DETALLE
	Add Constraint FK_GASTO_DETALLE_GASTO Foreign Key (GADE_sGASTO_ID) References SC_COMUN.SE_GASTO(GAST_sGASTO_ID)
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de proveedores del órgano de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_OSE_PROVEEDOR') is not null)
	drop table SC_COMUN.SE_OSE_PROVEEDOR
go

Create Table SC_COMUN.SE_OSE_PROVEEDOR(
	OSPR_sPROVEEDOR_ID			Smallint Identity(1,1) not null,
	OSPR_sORGANOSERVICIO_ID		Smallint not null,
	
	OSPR_vNOMBRE				Varchar(255) not null,
	OSPR_vTAG1					Varchar(35) null,
	OSPR_vTAG2					Varchar(35) null,
	OSPR_vTAG3					Varchar(35) null,
	OSPR_vTAG4					Varchar(35) null,

	OSPR_sSITUACION				Smallint not null default 9,	-- Situacion del registro (9 ..1)
	
	OSPR_sUSUARIO_CREACION		Smallint	not null,
	OSPR_vIP_CREACION			Varchar(15)	not null,
	OSPR_dFECHA_CREACION		Datetime	not null default GetDate(),
	OSPR_sUSUARIO_MODIFICACION	Smallint	null,
	OSPR_vIP_MODIFICACION		Varchar(15)	null,
	OSPR_dFECHA_MODIFICACION	Datetime	null,
	OSPR_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_OSE_PROVEEDOR
	Add Constraint PK_OSE_PROVEEDOR_ID Primary Key (OSPR_sPROVEEDOR_ID);
go

Create NonClustered Index IDN_ORGANOSERVICIO_PROVEEDOR_sOSE on SC_COMUN.SE_OSE_PROVEEDOR(OSPR_sORGANOSERVICIO_ID)
go

Create NonClustered Index IDN_ORGANOSERVICIO_PROVEEDOR_cESTADO on SC_COMUN.SE_OSE_PROVEEDOR(OSPR_cESTADO)
go

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	ACTUALIZACION DE TABLA USUARIO
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Modificación de la tabla SC_COMUN.SE_USUARIO
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
- Amplicación del campo USUA_vUSR de 12 a 26 caracteres.

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/

Alter Table SC_COMUN.SE_USUARIO
Alter Column USUA_vUSR Varchar(26)



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	TABLAS DE AUDITORIA
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


If Exists(Select * From sys.foreign_keys Where name = N'FK_AUDIDETA_AUDITORIA' And type = 'F')
	Alter Table SC_SYSTEM.SE_AUDITORIA_DETALLE Drop Constraint FK_AUDIDETA_AUDITORIA
Go



/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Auditoria - Encabezado
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
If (object_id(N'SC_SYSTEM.SE_AUDITORIA') is not null)
	Drop Table SC_SYSTEM.SE_AUDITORIA
go

Create Table SC_SYSTEM.SE_AUDITORIA
( 
	AUDI_iAUDITORIA_ID		Int Identity(1,1)	not null,	-- Id
	AUDI_iMODULO			Int					not null,   -- Id del módulo
	AUDI_vTABLA				Varchar(48)			not null,	-- Nombre de la tabla
	AUDI_vTABLA_DES			Varchar(150)		not null,	-- Descripción de la tabla
	AUDI_iEVENTO_ID			Int					not null,	-- Id del evento sobre el registro
	
	AUDI_iREGISTRO_ID		Int					not null,	-- Id del registro
	AUDI_vCAMPO				Varchar(120)		not null,	-- Campo de la tabla
	AUDI_vCAMPO_DES			Varchar(120)		not null,	-- Descripcion del campo de la tabla
	AUDI_vDATO_ANTERIOR		Varchar(max)		null,		-- Valor previo al evento
	AUDI_vDATO_NUEVO		Varchar(max)		not null,	-- Valor posterior al evento
	
	AUDI_sUSUARIO_CREACION	Smallint	not null,
	AUDI_vIP_CREACION		Varchar(15)	not null,
	AUDI_dFECHA_CREACION	Datetime	not null default GetDate()
)
Go

Alter Table SC_SYSTEM.SE_AUDITORIA
	Add Constraint Pk_iAUDITORIA_ID Primary Key (AUDI_iAUDITORIA_ID);
Go

Create NonClustered Index IDN_iEVENTO_ID on SC_SYSTEM.SE_AUDITORIA(AUDI_iEVENTO_ID);
Go

Create NonClustered Index IDN_iMODULO_ID on SC_SYSTEM.SE_AUDITORIA(AUDI_iREGISTRO_ID);
Go

Create NonClustered Index IDN_sUSUARIO_CREACION on SC_SYSTEM.SE_AUDITORIA(AUDI_sUSUARIO_CREACION);
Go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	TABLAS DE PERSONAL LOCAL - CONTRATOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL	drop Constraint FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_OSPC_OSPE' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO Drop Constraint FK_OSPC_OSPE 
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla detalle de personal local en organos de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_ORGANOSERVICIO_PERSONAL') is not null)
	drop table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
go

Create Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(
	OSER_sORGSER_PERSONAL_ID	Smallint Identity(1,1) not null,
	OSER_sORGANOSERVICIO_ID		Smallint not null,				-- Fk
	
	OSER_vAPELLIDOS				Varchar(45) not null,		
	OSER_vNOMBRES				Varchar(45) not null,
	OSER_sTIPODOCUMENTO			Smallint null,		-- Fk Parametros (DNI, CE, PAS, ..)
	OSER_vNUMERODOCUMENTO		Varchar(25) null,	-- Número de documento
	OSER_sTIPOPERSONAL			Smallint null,		-- Tipo de pesonal (1 = Diplomatico, 2. Administrativo Lima, Parametro = 5)
	OSER_dFECHANACIMIENTO		Datetime null,
	OSER_sNACIONALIDAD			Smallint null,		-- Fk Paises
	OSER_sESTADOCIVIL			Smallint null,		-- Fk Parametros (Soltero, Casado, ..)
	OSER_vEMAIL					Varchar(60) null,		
	OSER_sGENERO				Smallint null,		-- Fk Parametros (Hombre, Mujer, ..)
	OSER_bINDDISCAPACIDAD		Bit null default 0,	-- 0 : No, 1: Si
	OSER_sGRADOPROFESIONAL		Smallint null,		-- Fk Grado profesional
	OSER_sESPECIALIDAD			Smallint null,		-- Fk Especialidad
	OSER_vOBSERVACION			Varchar(max) null,
	--
	OSER_sSITUACIONLABORAL		Smallint not null,	-- Situacion (Activo, Activo (No laboral), Inactivo...
	OSER_sSITUACION				Smallint not null,	-- Situacion del registro (9 ..1)
	--
	OSER_sUSUARIO_CREACION		Smallint	not null,
	OSER_vIP_CREACION			Varchar(15)	not null,
	OSER_dFECHA_CREACION		Datetime	not null default GetDate(),
	OSER_sUSUARIO_MODIFICACION	Smallint	null,
	OSER_vIP_MODIFICACION		Varchar(15)	null,
	OSER_dFECHA_MODIFICACION	Datetime	null,
	OSER_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
	Add Constraint PK_ORGANOSERVICIO_PERSONAL Primary Key (OSER_sORGSER_PERSONAL_ID);
go

Create NonClustered Index IDN_ORGANOSERVICIO_PERSONAL_sNACIONALIDAD_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(OSER_sNACIONALIDAD)
go

Create NonClustered Index IDN_ORGANOSERVICIO_PERSONAL_sTIPOPERSONAL_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(OSER_sTIPOPERSONAL)
go

Create NonClustered Index IDN_ORGANOSERVICIO_PERSONAL_cESTADO on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(OSER_cESTADO)
go

Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
	Add Constraint FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO Foreign Key (OSER_sORGANOSERVICIO_ID) References SC_COMUN.SE_ORGANOSERVICIO(ORGA_sORGANOSERVICIO_ID)
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla detalle de contratos del personal local en organos de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO') is not null)
	drop table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO
go

Create Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO(
	OSPC_sOSP_CONTRATO_ID		Smallint Identity(1,1) not null,
	OSPC_sOSPE_PERSONAL_ID		Smallint not null,	-- Fk Personal
	OSPC_sORGANO_SERVICIO_ID	Smallint not null,	-- Fk Organo Servicio - (Desnormalizacion)
	
	OSPC_sTIPODOCUMENTO			Smallint not null, -- Tipo de documento de contratación
	OSPC_sREFERENCIA			Smallint null, -- Id de la referencia (para el caso de adendas)
	OSPC_vNUMERODOCUMENTO		Varchar(25) not null,
	OSPC_dFECHACONTRATO			Datetime null,
	OSPC_dFECHAINICIO			Datetime null,
	OSPC_dFECHATERMINO			Datetime null,	
	OSPC_bINDEFINIDO			bit not null default 1,	-- Periodo contractual 1:Indefinido
	OSPC_sCARGO					Smallint not null,	-- Cargo a desempeñar
	OSPC_sMONEDA				Smallint not null,
	OSPC_dREMUNERACION_BRUTA	Decimal(14,2) not null,
	OSPC_dFECHAINIFUNCION		Datetime null,
	OSPC_DOCUMENTOAUTOR			Varchar(25) not null,
	OSPC_DOCUMENTOAUTFECHA		Datetime not null,
	OSPC_sTIPOCONTRATO			Smallint not null,
	
	OSPC_vOBSERVACION			Varchar(max) null,

	--
	OSPC_bULTIMOCONTRATO		bit not null default 1,	-- Indicador ultimo contrato (Desnormalizacion)
	OSPC_sSITUACION				Smallint not null,		-- Sitiuacion del registro (9 ..1)
	--
	OSPC_sUSUARIO_CREACION		Smallint	not null,
	OSPC_vIP_CREACION			Varchar(15)	not null,
	OSPC_dFECHA_CREACION		Datetime	not null default GetDate(),
	OSPC_sUSUARIO_MODIFICACION	Smallint	null,
	OSPC_vIP_MODIFICACION		Varchar(15)	null,
	OSPC_dFECHA_MODIFICACION	Datetime	null,
	OSPC_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO
	Add Constraint PK_ORGA_PERS_CONT Primary Key (OSPC_sOSP_CONTRATO_ID);
go

Create NonClustered Index IDN_ORGANO_SERVICIO_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO(OSPC_sORGANO_SERVICIO_ID)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_sCARGO on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO(OSPC_sCARGO)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_PERSONAL_sMONEDA on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO(OSPC_sMONEDA)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_PERSONAL_cESTADO on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO(OSPC_cESTADO)
go

Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO
	Add Constraint FK_OSPC_OSPE Foreign Key (OSPC_sOSPE_PERSONAL_ID) References SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(OSER_sORGSER_PERSONAL_ID)
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla detalle de contratos del personal local en organos de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA') is not null)
	drop table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA
go

Create Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(
	OSPL_sOSP_PLANILLA_ID		Smallint Identity(1,1) not null,
	OSPL_sOSPC_CONTRATO_ID		Smallint not null,  -- Fk Contrato
	OSPL_sOSPE_PERSONAL_ID		Smallint not null,	-- Fk Personal
	OSPL_sORGANO_SERVICIO_ID	Smallint not null,	-- Fk Organo Servicio - (Desnormalizacion)
	
	OSPL_sTIPOCONCEPTO			Smallint not null,		-- Tipo de concepto (bono/aporte trabajador (descuento)/contribuciones (empleador))
	OSPL_vCONCEPTO				Varchar(80) not null,	-- Concepto del bono/aporte/descuento
	OSPL_bINCREMENTAL			Bit not null default 1, -- Indicador de la operación del concepto (1: incrementa, 0: resta)
	OSPL_bAFECTOAPORTES			Bit	not null default 1, -- Indicador si el concepto esta sujeto al calculo de aportes y descuentos (1), o si sólo suma a la remuneración bruta (0)
 	OSPL_bTIPOAFECTACIONPERCET	Bit not null default 1, -- Indica si el tipo de aporte/descuento se da en porcentaje (1) en caso contrario se da nominalmente (0)
	OSPL_dMONTOAFECTACION		Decimal(10,2) null,		-- Monto nominal de afectacion (si no es porcentual) (else) monto porcentual 

	OSPL_sSITUACION				Smallint not null,		-- Sitiuacion del registro (9 ..1)
	--
	OSPL_sUSUARIO_CREACION		Smallint	not null,
	OSPL_vIP_CREACION			Varchar(15)	not null,
	OSPL_dFECHA_CREACION		Datetime	not null default GetDate(),
	OSPL_sUSUARIO_MODIFICACION	Smallint	null,
	OSPL_vIP_MODIFICACION		Varchar(15)	null,
	OSPL_dFECHA_MODIFICACION	Datetime	null,
	OSPL_cESTADO				Char(1)		not null default 'A'
)	
go

Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA
	Add Constraint PK_ORGA_PERS_PLAN Primary Key (OSPL_sOSP_PLANILLA_ID);
go

Create NonClustered Index IDN_OSPC_CONTRATO_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID)
go

Create NonClustered Index IDN_OSPE_PERSONAL_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPE_PERSONAL_ID)
go

Create NonClustered Index IDN_ORGANO_SERVICIO_ID on SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sORGANO_SERVICIO_ID)
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	TABLAS DE CLASIFICADOR DE GASTO
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


If Exists(Select * From sys.foreign_keys Where name = N'Fk_CLASIFICADORITEM_CLASIFICADORGASTO ' And type = 'F')
	Alter Table SC_COMUN.SE_CLASIFICADORITEM Drop Constraint Fk_CLASIFICADORITEM_CLASIFICADORGASTO 
Go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Clasficador de Gastos
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/

if (object_id(N'SC_COMUN.SE_CLASIFICADORGASTO') is not null)
	drop table SC_COMUN.SE_CLASIFICADORGASTO
go

Create Table SC_COMUN.SE_CLASIFICADORGASTO (
	CLAS_sCLASIFICADOR_ID		Smallint Identity(1,1) not null,
	CLAS_vNOMBRE				VarChar(140) not null,
	CLAS_dDESDE					Datetime not null,
	CLAS_dHASTA					Datetime not null,
	CLAS_sSITUACION				Smallint not null default 9,
	
	CLAS_sUSUARIO_CREACION		Smallint	not null,
	CLAS_vIP_CREACION			Varchar(15)	not null,
	CLAS_dFECHA_CREACION		Datetime	not null default GetDate(),
	CLAS_sUSUARIO_MODIFICACION	Smallint	null,
	CLAS_vIP_MODIFICACION		Varchar(15)	null,
	CLAS_dFECHA_MODIFICACION	Datetime	null,
	CLAS_cESTADO				Char(1)		not null default 'A'
)	
Go

Alter Table SC_COMUN.SE_CLASIFICADORGASTO
	Add Constraint PK_CLASIFICADORGASTO Primary Key (CLAS_sCLASIFICADOR_ID);
Go

Create NonClustered Index IDN_CLASIFICADORGASTO_ESTADO on SC_COMUN.SE_CLASIFICADORGASTO(CLAS_cESTADO)
Go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Items del Clasficador de Gastos
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_CLASIFICADORITEM') is not null)
	drop table SC_COMUN.SE_CLASIFICADORITEM
go

Create Table SC_COMUN.SE_CLASIFICADORITEM (
	CLIT_sCLASIFICADORITEM_ID	Smallint Identity(1,1) not null,
	CLIT_sCLASIFICADORGASTO_ID	Smallint not null,	-- Fk
	CLIT_NOMBRE					Varchar(80) not null,
	CLIT_ABREVIATURA			Varchar(17) not null, -- Abreviatura del nombre
	CLIT_CODIGOCLASE			Varchar(11) not null, -- 
	CLIT_ITEMSUPERIOR			Int null,
	CLIT_ITEMNIVEL				Int null,
	CLIT_ITEMTIPO				Bit not null default 0, -- (0: Generica, 1:Especifica)
	CLIT_ISGRUPO				Bit not null default 0,
	CLIT_ISCAJA					Bit not null default 0, -- El item de gasto puede ser utilizado como caja chica.
	
	CLIT_sUSUARIO_CREACION		Smallint	not null,
	CLIT_vIP_CREACION			Varchar(15)	not null,
	CLIT_dFECHA_CREACION		Datetime	not null default GetDate(),
	CLIT_sUSUARIO_MODIFICACION	Smallint	null,
	CLIT_vIP_MODIFICACION		Varchar(15)	null,
	CLIT_dFECHA_MODIFICACION	Datetime	null,
	CLIT_cESTADO				Char(1)		not null default 'A'
)	
Go

Alter Table SC_COMUN.SE_CLASIFICADORITEM
	Add Constraint PK_CLASIFICADORITEM Primary Key (CLIT_sCLASIFICADORITEM_ID);
Go

Create NonClustered Index IDN_CLASIFICADORITEM_ESTADO on SC_COMUN.SE_CLASIFICADORITEM(CLIT_cESTADO)
Go

Alter Table SC_COMUN.SE_CLASIFICADORITEM
	Add Constraint Fk_CLASIFICADORITEM_CLASIFICADORGASTO Foreign Key (CLIT_sCLASIFICADORGASTO_ID)
	References	SC_COMUN.SE_CLASIFICADORGASTO
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	TABLAS DE PROGRAMAS DE POLITICA EXTERIOR
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Programa de Gasto para Política Exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/

if (object_id(N'SC_COMUN.SE_PROGRAMAGASTO') is not null)
	drop table SC_COMUN.SE_PROGRAMAGASTO
go

Create Table SC_COMUN.SE_PROGRAMAGASTO (
	PGAS_sPROGRAMAGASTO_ID		Smallint Identity(1,1) not null,
	PGAS_vNOMBRE				VarChar(140) not null,
	PGAS_dDESDE					Datetime not null,
	PGAS_dHASTA					Datetime not null,
	PGAS_sSITUACION				Smallint not null default 9,
	
	PGAS_sUSUARIO_CREACION		Smallint	not null,
	PGAS_vIP_CREACION			Varchar(15)	not null,
	PGAS_dFECHA_CREACION		Datetime	not null default GetDate(),
	PGAS_sUSUARIO_MODIFICACION	Smallint	null,
	PGAS_vIP_MODIFICACION		Varchar(15)	null,
	PGAS_dFECHA_MODIFICACION	Datetime	null,
	PGAS_cESTADO				Char(1)		not null default 'A'
)	
Go

Alter Table SC_COMUN.SE_PROGRAMAGASTO
	Add Constraint PK_PROGRAMAGASTO Primary Key (PGAS_sPROGRAMAGASTO_ID);
Go

Create NonClustered Index IDN_PROGRAMAGASTO_ESTADO on SC_COMUN.SE_PROGRAMAGASTO(PGAS_cESTADO)
Go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de programas de política exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_PROGRAMAITEM') is not null)
	drop table SC_COMUN.SE_PROGRAMAITEM
go

Create Table SC_COMUN.SE_PROGRAMAITEM
( 
	PROG_sPROGRAMAITEM_ID		Smallint Identity (1,1)	not null,	-- ID
	PROG_vNOMBRE				Varchar(100)			not null,	-- Nombre del programa
	PROG_vABREVIATURALG			Varchar(22)				not null,	-- Abreviación de la descripción del programa (LG)
	PROG_vABREVIATURASM			Varchar(22)				not null,	-- Abreviación de la descripción del programa (SM)

	PROG_sUSUARIO_CREACION		Smallint	not null,
	PROG_vIP_CREACION			Varchar(15)	not null,
	PROG_dFECHA_CREACION		Datetime	not null default GetDate(),
	PROG_sUSUARIO_MODIFICACION	Smallint	null,
	PROG_vIP_MODIFICACION		Varchar(15)	null,
	PROG_dFECHA_MODIFICACION	Datetime	null,
	PROG_cESTADO				Char(1)		not null default 'A'
)
Go

Alter Table SC_COMUN.SE_PROGRAMAITEM
	Add Constraint PK_PROGRAMAITEM Primary Key (PROG_sPROGRAMAITEM_ID);
Go

Create NonClustered Index IDN_PROGRAMAITEM on SC_COMUN.SE_PROGRAMAITEM(PROG_cESTADO)
Go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de enlace de programas, items de programas y órganos de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_COMUN.SE_PROGRAMAOSE') is not null)
	drop table SC_COMUN.SE_PROGRAMAOSE
go

Create Table SC_COMUN.SE_PROGRAMAOSE
( 
	PROS_sPROGRAMA_ID			Smallint	not null,	-- ID
	PROS_sTIPOORGANOSERVICIO	Smallint	not null,	-- Id del tipo de organo de servicio
	PROS_sPROGRAMAITEM			Smallint	not null,	-- Id del item del programa
		
	PROS_sUSUARIO_CREACION		Smallint	not null,
	PROS_vIP_CREACION			Varchar(15)	not null,
	PROS_dFECHA_CREACION		Datetime	not null default GetDate(),
	PROS_sUSUARIO_MODIFICACION	Smallint	null,
	PROS_vIP_MODIFICACION		Varchar(15)	null,
	PROS_dFECHA_MODIFICACION	Datetime	null,
	PROS_cESTADO				Char(1)		not null default 'A'
)
Go

Create Index IDA_PROGRAMAOSE_PTP on SC_COMUN.SE_PROGRAMAOSE(PROS_sPROGRAMA_ID, PROS_sTIPOORGANOSERVICIO, PROS_sPROGRAMAITEM)
Go

Create NonClustered Index IDN_PROGRAMAOSE_ESTADO on SC_COMUN.SE_PROGRAMAOSE(PROS_cESTADO)
Go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	DATA INICIAL. PARAMETROS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- select * From SC_COMUN.SE_PARAMETRO_ITEM where PAIT_sPARAMETRO_ID >= 6

-- Adicion de Pais
Insert Into SC_COMUN.SE_PAIS (PAIS_vNOMBRE, PAIS_vNOMBREOFICIAL, PAIS_vGENTILICIO, PAIS_cM49, PAIS_cISOA3, PAIS_sREGION_ID, PAIS_sUSUARIO_CREACION, PAIS_vIP_CREACION) Values ('FILIPINAS','REPÚBLICA DE FILIPINAS','FILIPINA', '608', 'PHL', 16, 1,  '::1')

/*
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_vDESCRIPCION, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'TIPOS DE SITUACION','TIPOS DE SITUACIONES PARA EL WORKFLOW DE REGISTROS', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (3, 'TIPO_PERSONAL_OSE', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'ESTADO_CIVIL', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'IDENTIDAD_GENERO', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'GRADO_PROFESIONAL', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'SITUACION_LABORAL', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'CARGO_LABORAL', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'TIPO_CONTRATO', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'CONCEPTOS_PLANILLA_OSE', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'TIPO_DOCUMENTO_IDENTIDAD', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (4, 'FORMATO_DESTINO_GASTO', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (4, 'FORMATO_FORMA_PAGO', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'ESPECIALIDAD_ESTUDIOS', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO (PARA_sPARAMETROGRUPO_ID, PARA_vNOMBRE, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION) Values (1, 'TIPO_DOC_CONTRATO', 1, '::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (6, 'PENDIENTE DE VALIDACION', '9', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (6, 'PENDIENTE DE APROBACIÓN', '8', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (6, 'APROBADO', '1', 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (6, 'CREADO', '0', 1, '::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (7,'DIPLOMATICO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (7,'ADMINISTRATIVO LIMA','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (7,'ADMINISTRATIVO LOCAL','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (7,'SERVICIO NO PERSONAL','4',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (8,'SOLTERO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (8,'CASADO','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (8,'VIUDO','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (8,'DIVORCIADO','4',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (9,'MASCULINO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (9,'FEMENINO','2',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'EDUCACIÓN PRIMARIA INCOMPLETA','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'EDUCACIÓN PRIMARIA','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'EDUCACION SECUNDARIA INCOMPLETA','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'EDUCACION SECUNDARIA','4',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'ESTUDIOS TÉCNICOS INCOMPLETOS','5',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'ESTUDIOS TÉCNICOS','6',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'UNIVERSITARIA INCOMPLETA','7',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'BACHILLER','8',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'TÍTULO PROFESIONAL Ó LICENCIATURA','9',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'MAESTRIA INCOMPLETA','10',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'MAESTRÍA','11',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'DOCTORADO INCOMPLETO','12',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (10,'DOCTORADO','13',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (11,'ACTIVO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (11,'PLAZA VACANTE','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (11,'TEMPORAL','3',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ABOGADO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ADMINISTRADOR','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ANALISTA','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'APOYO ADMINISTRATIVO','4',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'APOYO INFORMÁTICO','5',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASEO Y LIMPIEZA','6',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASESOR','7',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASESOR LEGAL','8',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTA SOCIAL','9',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE','10',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE ADMINISTRATIVO ','11',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE COMERCIAL','12',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE CONSULAR','13',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE CONTABLE','14',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE CULTURAL','15',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE EJECUTIVA','16',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE INFORMÁTICO','17',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ASISTENTE LEGAL','18',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ATENCIÓN AL PUBLICO','19',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ATENCIÓN AL PÚBLICO','20',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ATENCION EN VENTANILLA','21',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'AUXILIAR  DE SERVICIOS GENERALES','22',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'AUXILIAR ADMINISTRATIVO','23',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'AUXILIAR DE CONTABILIDAD','24',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'AUXILIAR DE OFICINA','25',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'AUXILIAR DE SERVICIOS','26',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CAJERA','27',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CHEF','28',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CHOFER','29',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'COCINERO','30',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'COCINERO CHEF','31',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CONSERJE','32',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CONSULTOR','33',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'CONTADOR','34',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'DIGITACIÓN Y ARCHIVO DE DOCUMENTOS','35',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADA DE HOGAR','36',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADA DE LIMPIEZA','37',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADO ADMINISTRATIVO','38',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADO DE SERVICIO','39',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADO OFICINISTA TRILINGÜE','40',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'EMPLEADO SERVICIOS GENERALES','41',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADA DE ASUNTOS CONSULARES','42',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO ADMINISTRATIVO','43',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE ÁREA CONTABLE Y VALIJA','44',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE ASUNTOS LEGALES','45',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE LA CAJA DE INGRESOS','46',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE LIMPIEZA','47',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE PODERES','48',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE PRENSA','49',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE RENDICIÓN DE CUENTAS','50',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ENCARGADO DE PASAPORTES Y SALVOCONDUCTOS','51',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'ESPECIALISTA EN TEMAS CULTURALES','52',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'FUNCIONARIO ADMINISTRATIVO','53',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'FUNCIONARIO CONSULAR ','54',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'GUARDIAN','55',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'INFORMACION AL PUBLICO','56',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'INFORMÁTICO','57',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'INTERPRETE','58',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'INTERPRETE - TRADUCTORA','59',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'JARDINERO','60',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'JEFE AREA','61',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'LIMPIEZA','62',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'MANTENIMIENTO','63',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'MAYORDOMO','64',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'MENSAJERO','65',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'MUCAMA','66',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'MUCAMO','67',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'OFICIAL 1RA.','68',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'OFICIAL 2DA.','69',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'OFICIAL MAYOR - SECRETARIA','70',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PASAPORTES','71',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL ADMINISTRATIVO','72',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL ADMINISTRATIVO ','73',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL DE LIMPIEZA','74',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL DE MAESTRANZA','75',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL DE MANTENIMIENTO','76',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PERSONAL DE SERVICIO','77',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'PORTERO','78',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'RECEPCIONISTA','79',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'RESPONSABLE ADMINISTRATIVO','80',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'RESPONSABLE ÁREA JURÍDICA','81',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA','82',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARÍA','83',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA ADMINISTRATIVA','84',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA DE LA EMBAJADA','85',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA DE LA SECCIÓN CONSULAR','86',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA DEL CONSUL GENERAL','87',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA DEL JEFE DE MISION','88',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA EJECUTIVA','89',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA EJECUTIVA BILINGÜE','90',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA PRINCIPAL','91',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA RECEPCIONISTA','92',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA TRADUCTORA CONTABLE','93',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA TRADUCTORA TRILINGÜE','94',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA Y ASISTENTE','95',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIA Y ASISTENTE ADMINISTRATIVA','96',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIO','97',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIO CONSULAR','98',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIO TRAMITE CONSULAR','99',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETARIO Y TÉCNICO INFORMÁTICO','100',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SECRETRIA ADMINISTRATIVA','101',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SEGURIDAD Y MANTENIMIENTO','102',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SERVICIO MANTENIMIENTO EQUIPOS INFORMÁTICOS','103',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SERVICIOS INFORMÁTICOS','104',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SERVICIOS PROFESIONALES CONTABLES','105',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'SISTEMAS','106',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TÉCNICO ADMINISTRATIVO','107',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TÉCNICO INFORMÁTICO','108',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TELEFONISTA/RECEPCION PUBLICO/MESA PARTES','109',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TRADUCTOR E INTÉRPRETE','110',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TRADUCTOR','111',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_SPARAMETRO_ID, PAIT_VTEXTO, PAIT_VVALOR, PAIT_SUSUARIO_CREACION, PAIT_VIP_CREACION) Values (12,'TRAMITADORA DE DOCUMENTOS CONSULARES','112',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (13,'LABORAL','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (13,'NO LABORAL','2',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (14,'BONO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (14,'APORTES DEL TRABAJADOR','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (14,'CONTRIBUCIONES DEL EMPLEADOR','3',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'DOCUMENTO NACIONAL DE IDENTIDAD','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'CÉDULA DE IDENTIDAD','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'CÉDULA DE CIUDADANÍA','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'TARJETA DE IDENTIDAD','4',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'REGISTRO CIVIL','5',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'CÉDULA DE EXTRANJERÍA','6',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'CARNÉ DE IDENTIDAD','7',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'DOCUMENTO ÚNICO DE IDENTIDAD','8',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'IDENTIDAD','9',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (15,'PASAPORTE','10',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (16,'CANCILLERIA','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (16,'RESIDENCIA','2',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (17,'CHEQUE GIRADO','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (17,'TRANSFERENCIA','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (17,'COMISION BANCARIA','3',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'- NINGUNA -','0',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN','1',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN DE EMPRESAS','2',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN DE EMPRESAS GASTRONOMICAS','3',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN DE NEGOCIOS','4',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACION DE RR.HH','5',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN HOTELERA','6',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN Y COMERCIO EXTERIOR','7',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN Y FINANZAS','8',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ADMINISTRACIÓN GUBERNAMENTAL','9',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'AGRONOMÍA','10',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ANÁLISIS DE SISTEMAS','11',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ARCHIVO','12',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ARQUITECTURA','13',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ARTES','14',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ARTES ESCÉNICAS ','15',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ARTES PLÁSTICAS','16',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'AUDITORÍA FINANCIERA','17',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS CONTABLES','18',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS DE LA COMPUTACIÓN','19',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS DE TERAPIA FÍSICA','20',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS POLÍTICAS','21',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS SOCIALES','22',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIAS Y LETRAS','23',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CIENCIASDE NEGOCIOS','24',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMERCIO EXTERIOR','25',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMERCIO INTERNACIONAL','26',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMPUTACIÓN E INFORMÁTICA','27',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMUNICACIÓN AUDIOVISUAL','28',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMUNICACIÓN SOCIAL','29',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COMUNICACIONES','30',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CONSTITUCIONAL Y DERECHOS HUMANOS','31',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CONSTRUCCIÓN','32',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CONTABILIDAD','33',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CONTABILIDAD ADMINISTRATIVA','34',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CONTADURÍA','35',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COOPERACIÓN INTERNACIONAL','36',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'COSMETOLOGÍA','37',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'CRIMINALÍSTICA','38',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DERECHO','39',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DERECHO COMPARADO AMERICANO','40',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DERECHO Y CIENCIAS POLÍTICAS','41',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DIPLOMACIA EUROPEA','42',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DIPLOMACIA Y CIENCIAS POLÍTICAS','43',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DISEÑO GRAFICO','44',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'DOCENCIA','45',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ECONOMÍA','46',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'EDUCACIÓN','47',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'EDUCACIÓN FÍSICA Y RECREACIÓN','48',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'EDUCACIÓN INICIAL','49',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ELECTRICIDAD','50',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ELECTRÓNICA','51',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ENFERMERÍA','52',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ESTADÍSTICA','53',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ESTUDIOS HISPANICOS','54',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ESTUDIOS LATINOAMERICANOS','55',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ESTUDIOS MILITARES','56',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'ESTUDIOS POLICIALES','57',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOLOGÍA','58',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOLOGÍA HISPÁNICA','59',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOLOGÍA IBÉRICA','60',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOLOGÍA INGLESA','61',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOSOFÍA','62',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'FILOSOFÍA, PSICOLOGÍA Y CIENCIAS SOCIALES','63',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'GASTRONOMÍA','64',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'GASTRONOMÍA Y COMERCIO','65',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'GESTION DE ORGANIZACIÓN','66',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'GESTIÓN FINANCIERA','67',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'GESTIÓN Y ALTA DIRECCIÓN','68',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'HOTELERÍA','69',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'HOTELERÍA Y TURISMO','70',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'HUMANIDADES','71',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'IDIOMAS','72',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'IDIOMAS EXTRANJEROS APLICADOS','73',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INFORMÁTICA','74',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERIA DE COMPUTACIÓN Y SISTEMAS','75',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERÍA DE SISTEMAS','76',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERÍA ECONÓMICA','77',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERIA INDUSTRIAL','78',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERÍA INFORMÁTICA','79',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERÍA QUÍMICA','80',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INGENIERO METALÚRGICO','81',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INSTALACIONES ELÉCTRICAS','82',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'INTERPRETACIÓN','83',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LENGUA ESPAÑOLA','84',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LENGUAJE Y CULTURA','85',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LENGUAS MODERNAS','86',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LICEO CLÁSICO','87',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LINGÜÍSTICA','88',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LITERATURA ESPAÑOLA','89',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'LITERATURA ITALIANA','90',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'MARKETING','91',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'MARKETING Y COMUNICACIONES','92',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'MECÁNICA','93',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'MECÁNICA AUTOMOTRIZ','94',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'MERCADOTECNIA','95',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'NEGOCIOS','96',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'NEGOCIOS INTERNACIONALES','97',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'OBSTETRICIA','98',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PANIFICADOR','99',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PEDAGOGIA','100',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PERIODISMO','101',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PERITO MERCANTIL Y CONTADOR PÚBLICO','102',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'POLÍTICA PÚBLICA','103',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PSICOLOGÍA','104',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'PUBLICIDAD CINEMATOGRÁFICA','105',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'QUÍMICA INDUSTRIAL','106',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'REDES DE COMPUTADORAS','107',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'REFRIGERACIÓN','108',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'RELACIONES INTERNACIONALES','109',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'RELACIONES PÚBLICAS','110',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'REPARACIÓN DE PC Y ADMINISTRADOR DE REDES','111',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'REPOSTERÍA','112',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'SALUD PÚBLICA','113',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'SECRETARIADO DE GERENCIA Y RELACIONES PÚBLICAS','114',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'SECRETARIADO EJECUTIVO','115',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'SOCIOECONOMIA','116',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'SOCIOLOGÍA','117',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'TEOLOGÍA','118',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'TORNO MECÁNICO','119',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'TRADUCCIÓN E INTERPRETACIÓN','120',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'TRADUCCIÓN Y CIVILIZACIÓN','121',1,'::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (18,'TURISMO','122',1,'::1')

Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_iORDEN, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (19,'CONTRATO', '1', 1, 1, '::1')
Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_iORDEN, PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION) Values (19,'ADENDA', '2', 1, 2, '::1')

*/

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	DATA INICIAL. PERSONAL LOCAL
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

/*
-- Select * From SC_COMUN.SE_ORGANOSERVICIO_PERSONAL

-- A

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'ÁNGEL','ALCALÁ SÁNCHEZ',1, CONVERT (DATETIME, '01/01/1954',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'MARCO','ANDRADE CASTILLO',1, CONVERT (DATETIME, '01/01/1971',103),20,4,'EXCEPCION DE LEY DE PRESUPUESTO AÑO 2012', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'SARA ','ASALDE GUEVARA',2, CONVERT (DATETIME, '01/01/1978',103),20,6,'REEMPLAZO DE KATHERINE VELÁSQUEZ. /', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'MARÍA','CAMPOS OROPEZA',2, CONVERT (DATETIME, '01/01/1982',103),20,6,'REEMPLAZO DE MARÍA DE JESÚS ZEVALLOS MALASPINA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'ROCIÓ','CARLOS GARCÍA',2, CONVERT (DATETIME, '01/01/1984',103),20,9,'REEMPLAZO DE LUIS GENARO VÍLCHEZ REYES', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'GABI ','CASTILLO VILLANUEVA',2, CONVERT (DATETIME, '01/01/1980',103),20,6,'REEMPLAZO DE TERESA ARANA MERINO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'GLADIS','CASTILLO VILLANUEVA',2, CONVERT (DATETIME, '01/01/1984',103),20,7,'REEMPLAZO DE HILDA PAREDES. / LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN HR N° 8-1-B/15-2015. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'ALEJANDRO ','DE LA CRUZ TORRES',1, CONVERT (DATETIME, '01/01/1970',103),20,8,'REEMPLAZO DE JORGE EDUARDO RINCÓN SALAZAR. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'CECILIA','GONZÁLEZ',2, CONVERT (DATETIME, '01/01/1983',103),13,9,'REEMPLAZO DE GINA PAOLA MUÑOZ ROSADA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'GERALDINE','GRANDA VISSO',2, CONVERT (DATETIME, '01/01/1985',103),20,9,'REEMPLAZO DE ANDREA CÁRDENAS NEIRA. /LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL CUADRO ADJUNTO AL MENSAJE C-BAIRES20151608 PARA EL PRIMER TRAMO DEL INCREMENTO LEGAL.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'LEONEL','MARTÍNEZ',1, CONVERT (DATETIME, '01/01/1979',103),13,6,'REEMPLAZO DE LA SEÑORITA ROSELLA CORALI TOLENTINO. /LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL CUADRO ADJUNTO AL MENSAJE C-BAIRES20151608 PARA EL PRIMER TRAMO DEL INCREMENTO LEGAL.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'DIANA CATALINA ','MARTÍNEZ ROBAYO',1, CONVERT (DATETIME, '01/01/1986',103),17,9,'REEMPLAZO DE NATHALI DEL ROSARIO MEJÍA TOLENTINO. / RENUNCIA PRESENTADA CON EL MENSAJE C-BAIRES20170372.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'NINA','MORALES DÍAZ',2, CONVERT (DATETIME, '01/01/1990',103),20,9,'REEMPLAZO DE AYELÉN FUSARO BÁRBARA./LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL CUADRO ADJUNTO AL MENSAJE C-BAIRES20160972 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'FERNANDO','ROMERO MANRIQUE',1, CONVERT (DATETIME, '01/01/1980',103),20,6,'REEMPLAZO DE LIS SORIANO POR RESTRUCTURACIÓN DE FUNCIONES/LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL CUADRO ADJUNTO AL MENSAJE C-BAIRES20160972 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'LIZ ','SORIANO QUISPE',2, CONVERT (DATETIME, '01/01/1986',103),20,7,'REEMPLAZO DE CONNIE ARÉVALO ORTIZ. /LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL CUADRO ADJUNTO AL MENSAJE C-BAIRES20160972 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'NÉLIDA PATRICIA','VÁSQUEZ MENDOZA',2, CONVERT (DATETIME, '01/01/1980',103),20,6,'PLAZA VACANTE DEJADA POR LA EMPLEADA JHOSSELINE ARLETTE REJAS MEJÍA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'SARA PATRICIA','ALANIA AGÜERO',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'PLAZA VACANTE DEJADA POR EL EMPLEADO LUIS GABRIEL CHAVARRÍA NIETO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (82,1,'ANGEL ABRAHAM','MAIDANA',1, CONVERT (DATETIME, '01/01/1979',103),13,4,'LA MISIÓN INFORMA QUE EL SEÑOR MAIDANA PRESTÓ SYS SERVICIOS EN ESE CONSUALDO DESDE EL 2009(VER C-BAIRES20170608)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (85,1,'LUIS ANTONIO ','JACOBO GARCÍA',1, CONVERT (DATETIME, '01/01/1966',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (85,3,'RODRIGO LEANDRO ','BARROSO VERDEJO',1, CONVERT (DATETIME, '01/01/1980',103),20,4,'CONTRATO TEMPORAL, ALMACENADO EN DOCUMENTO DE GESTIÓN. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (85,1,'VICTOR DANTE','RÍOS MORENO',1, CONVERT (DATETIME, '01/01/1993',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (84,1,'LIZ VERONICA','GUADALUPE SALCEDO',2, CONVERT (DATETIME, '01/01/1983',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (84,1,'MARÍA FERNANDA','PRUGNA',2, CONVERT (DATETIME, '01/01/1975',103),13,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (84,1,'BERNANDO ERWIN','BRANDT',1, CONVERT (DATETIME, '01/01/1980',103),20,4,'INGRESO EN REEMPLAZO DE LA EX EMPLEADA NATALI CARRIÓN SAAVEDRA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'ANGGY ','CANO QUISPE',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'ANTES, REEMPLAZA DE FORMA TERMPORAL A LA EMPLEADA RODRIGUEZSALIRROSAS, FIORELA, QUIEN SE ENCUENTRA HACIENDO USO DE SU LICNECIA POR MATERNIDAD. DESPUES, PASO A OCUPAR LA PLAZA VACANTE DEL SR. MAXILIMIANO BUSSO ( NO SE CONTRATARÁ PRERSONAL DE REEMPLAZO)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'ANTONIO ROOSVELT','CRIVILLERO RAO',1, CONVERT (DATETIME, '01/01/1953',103),20,9,'LOS MONTOS DE LAS REMUNERACIONES SE ENCUENTRAN CONFORME A LOS DATOS CONSIGNADOS EN EL DOCUMENTO ADJUNTO AL MENSAJE C-CORDOBA20130469.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'DIANA CAROLINA ','CANALES MACHADO',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'INGRESA EN REEMPLAZO DE LA SEÑORA MARÍA MOYANO, AUTORIZADO MEDIANTE EL MENSAJE OGA20157152 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'ERI ','NAKAGAMA',2, CONVERT (DATETIME, '01/01/1980',103),20,7,'CONTRATADA CON LOS RECURSOS QUE LA OFICINA CONSULAR DEJÓ DE GASTAR EN LOS ESTIPENDIOS DE 3 PASANTES CON LOS QUE CONTABA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'MILUSKA','PESCIO KURIGER',2, CONVERT (DATETIME, '01/01/1976',103),13,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'FIORELLA BEBERLY','RODRÍGUEZ SALIRROSAS',2, CONVERT (DATETIME, '01/01/1984',103),20,8,'REINGRESÓ A LABORAR LUEGO DE QUE SE AUTORIZÓ SU CONTRATACIÓN A TRAVÉS DEL MENSAJE OGA20154458 DEL 12 DE AGOSTO DE 2015/ NO REEMPLAZÓ A NADIE, SE AUTORZIÓ SU REINGRESO, LO CUAL IMPLICÓ LA CREACIÓN DE UNA NUEVA PLAZA./ SOLICITO LICENCIA POR MATERNIDAD(3 MESES) Y FUE REEMPLAZADA DURNATE DICHO PERIODO POR LA SEÑORITA ANGGY CANO QUISPE(OGA20163762)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (83,1,'PIERO CARLO','BELTRÁN ARTEAGA',1, convert (datetime, '01/01/1973',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (98,1,'ROSARIO GLADYS','BARBACHÁN CHUQUICÓNDOR',2, CONVERT(DATETIME, '01/01/1976',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (98,1,'PEDRO MAURICIO','DÍAZ RAVELO',1, CONVERT(DATETIME, '01/01/1981',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (98,1,'SARA','GÁLVEZ BERNUY',2, CONVERT(DATETIME, '01/01/1979',103),20,4,'PLAZA VACANTE DEJADA POR LA EX EMPELADA LIZARRAGA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (98,1,'MARÍA CRISTINA ','PETREL HENAO',2, CONVERT(DATETIME, '01/01/1973',103),17,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (103,1,'LILIANA DEL PILAR','BARRIENTOS DÍAZ',2, CONVERT(DATETIME, '01/01/1979',103),20,7,'INGRESO EN REEMPLAZO DE LA SEÑORA MARÍA LUISA SÁNCHEZ RAMÍREZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (103,1,'GLORIA MERCEDES','MILLFAHRT',2, CONVERT(DATETIME, '01/01/1964',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (103,1,'MARÍA LUISA','SÁNCHEZ RAMÍREZ',2, CONVERT(DATETIME, '01/01/1986',103),41,8,'PLAZA DEJADA POR YONI ISABEL JUSCAMAYTA.  SE INFORMÓ CON MENSAJE C-HAMBURGO20150417 QUE RENUNCIARÍA EN FEBRERO DEL SIGUIENTE AÑO. A PARTIR DEL 1 DE ABRIL PASO A LABORAR A TIEMPO COMPLETO EN REEMPLAZO DE LA SRA. JUDITH DOMINGO CONSTANS. Y EN REEMPLAZO DE LA PLAZA DEJADA POR LA CITADA SEÑORA SE CONTRATÓ A LA SEÑORA BARRIENTOS DÍAZ. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (103,1,'CAROLA','VERA-LOHRENZ',2, CONVERT(DATETIME, '01/01/1959',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (113,1,'MARCO ANTONIO','CONCEPCIÓN VALVERDE',1, CONVERT(DATETIME, '01/01/1980',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (113,1,'TUZIENKA JEDHYELHY ','CHENET UGARTE',2, CONVERT(DATETIME, '01/01/1991',103),20,8,'(PLAZA VACANTE) DEJADA POR LA SEÑORA CARMEN MACHADO MARCELO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (113,1,'IRIS KUKULY',' BOZA VALENZUELA DE WOLF',2, CONVERT(DATETIME, '01/01/1976',103),20,7,'OCUPA LA PLAZA VACANTE DEJADA POR LA SEÑORA FRÖHLICH Y LUEGO POR LA SRA. RAZNOVY RADEMACHER, QUIEN NO LLEGO A TRABAJAR EN ESA MISIÓN', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_SORGANOSERVICIO_ID, OSER_SSITUACIONLABORAL, OSER_VNOMBRES,  OSER_VAPELLIDOS, OSER_SGENERO, OSER_DFECHANACIMIENTO, OSER_SNACIONALIDAD, OSER_SGRADOPROFESIONAL, OSER_VOBSERVACION,  OSER_STIPOPERSONAL, OSER_SSITUACION, OSER_SUSUARIO_CREACION, OSER_VIP_CREACION) Values (113,1,'ANA LUCÍA','VERA CÉSPEDES',2, CONVERT(DATETIME, '01/01/1976',103),20,8,'', 3, 9 , 1, '::1')

-- B

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (123,1,'HELLEN SILVIA','CHANG SAM',2, CONVERT (DATETIME, '01/01/1979',103),20,9,'REEMPLAZA A LA SRA. CARMEN BAUTISTA ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (123,1,'JORGE FRANCO','RENDON BERNUI',1, CONVERT (DATETIME, '01/01/1979',103),20,9,'REEMPLAZA A LA SEÑORA VÁSQUEZ PEÑA.EN JUNIO DE 2016, INGRESA EN REEMPLAZO DE LA SRA. ISABEL CAROL PORTILLA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (86,1,'GLORIA GIOVANNA','RIMACHI ALVAREZ',2, CONVERT (DATETIME, '01/01/1969',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (86,1,'MEDALITH','BURGA MORENO',2, CONVERT (DATETIME, '01/01/1960',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (86,1,'OLGA HILDAURA','CASTRO VIVANCO',2, CONVERT (DATETIME, '01/01/1967',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (118,1,'RICARDO FELIX','VARGAS CARRANZA',2, CONVERT (DATETIME, '01/01/1976',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (118,1,'CARMEN IRENE','SALCEDO HIJAR',1, CONVERT (DATETIME, '01/01/1983',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (118,1,'BETZABEL MISHELL ','SILVA PAREDES',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'CAMBIÓ SU MODALIDAD CONTRACTUAL A TIEMPO INDEFINIDO LUEGO DE HABER CULMINADO SU CONTRATACIÓN A TÍTULO DE EXPERIENCIA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (118,1,'MARIA HELENA ','FREITAS DO NASCIMENTO',2, CONVERT (DATETIME, '01/01/1971',103),15,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (109,1,'LALINA ','ABADE GOMES',2, CONVERT (DATETIME, '01/01/1966',103),15,3,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (109,1,'GINA SORAYA ','PALOMINO TINOCO',2, CONVERT (DATETIME, '01/01/1969',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (109,1,'EDUARDO JORGE ','VITORIANO DA MATA',2, CONVERT (DATETIME, '01/01/1971',103),15,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'ALBERTO ','DE ASSIS FERRAZ',1, CONVERT (DATETIME, '01/01/1980',103),15,2,'REEMPLAZO DEL SEÑOR FLAVIO ROCHA DE ABREGU/EL MONTO REMUNERATIVO SE ENCUENTRA CONFORME A LO INDICADO EN LA HR N°8-5-F/100.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'YANINA ','ESTRADA ESPINOZA DE BOTELHO',1, CONVERT (DATETIME, '01/01/1972',103),15,9,'EL MONTO TOTAL INCLUYE LA PRORRATA DEL 13 SALARIO, DEL TERCIO DE VACACIONES, LOS ENCARGOS SOCIALES A CARGO DEL EMPLEADOR Y EL VALE MENSUAL DE TRANSPORTE./ LOS MONTOS CORRESPONDIENTES A LA REMUNERACIÓN SE ENCUENTRAN DE ACUERDO A LO INFORMADO CON MENSAJE C-RIO20140575 (NO SE PRECISÓ SALARIO NETO NI COSTO TOTAL).', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'INÉS','MARCONE DE BURLAMAQUI',2, CONVERT (DATETIME, '01/01/1975',103),20,6,'1) A LA SRA BURLAMAQUI SE LE ADEUDAN APORTACIONES SOCIALES PARA EL PERIODO LABORADO ENTRE 1984 Y SU FECHA DE INICIO DE CONTRATO. EL INFORME JURIDICO LABORAL PERTINENTE OBRA EN PODER DE CANCILLERÍA. 2)EL MONTO TOTAL INCLUYE LA PRORRATA DEL 13 SALARIO, DEL TERCIO DE VACACIONES Y LOS ENCARGOS SOCIALES A CARGO DEL EMPLEADOR./LOS MONTOS CORRESPONDIENTES A LA REMUNERACIÓN SE ENCUENTRAN DE ACUERDO A LO INFORMADO CON MENSAJE C-RIO20140575 (NO SE PRECISÓ SALARIO NETO NI COSTO TOTAL).', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'ROSA MARINA ','ROSAS MENESES',2, CONVERT (DATETIME, '01/01/1982',103),20,11,'INGRESÓ EN REEMPLAZO DE LA PLAZA DEJADA POR EL  SR. DAMONTE VENEGAS, JUAN DIEGO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'ROCIO MARGARITA','SALAZAR CANALES',1, CONVERT (DATETIME, '01/01/1966',103),20,9,'EL MONTO TOTAL INCLUYE LA PRORRATA DEL 13 SALARIO, DEL TERCIO DE VACACIONES, LOS ENCARGOS SOCIALES A CARGO DEL EMPLEADOR Y LOS VALES MENSUALES DE TRANSPORTE  Y DE ALIMENTACIÓN', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (119,1,'JULIA LUZ','SÁNCHEZ GONZÁLES',2, CONVERT (DATETIME, '01/01/1986',103),20,8,'EL MONTO TOTAL INCLUYE LA PRORRATA DEL 13 SALARIO, DEL TERCIO DE VACACIONES, LOS ENCARGOS SOCIALES A CARGO DEL EMPLEADOR Y LOS VALES MENSUALES DE TRANSPORTE  Y DE ALIMENTACIÓN', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,1,'YONY FELICITAS','MENDOZA HUILLCAIQUIPA',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,3,'MARLY ROSA','FERNANDES ',2, CONVERT (DATETIME, '01/01/1980',103),15,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,1,'JAQUELINE ','FUENTES SUÁREZ',2, CONVERT (DATETIME, '01/01/1965',103),20,4,'PLAZA DEJADA POR LORENA GEORGINA BERNUY MELLADO CON MSJ C-SANPABLO20130520', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,1,'VERA LUCIA','MENEZES FRANCO',2, CONVERT (DATETIME, '01/01/1980',103),15,8,'CON MSJ OGA20133207 (07/06/2013) SE AUTORIZÓ EL AJUSTE ASALARIAL.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,1,'AMANDA ','RICHOTTI',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (121,1,'GUILIANA','SATTUI MEJÍA',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (90,1,'FABIOLA SILVIA','COARITE FRANCO',2, CONVERT (DATETIME, '01/01/1979',103),14,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (90,1,'HUGO ARTURO','PARI QUISPE',1, CONVERT (DATETIME, '01/01/1977',103),14,5,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (90,1,'JAQUELINE ROSARIO','ROSSO LÓPEZ',2, CONVERT (DATETIME, '01/01/1975',103),14,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (89,1,'RÓMULO','CABRERA QUISPE',1, CONVERT (DATETIME, '01/01/1974',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (89,1,'ZENAIDA','ORTUÑO LAZCANO ',2, CONVERT (DATETIME, '01/01/1986',103),14,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (89,1,'CAROLA ','ROCABADO RAMÍREZ',2, CONVERT (DATETIME, '01/01/1984',103),14,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (89,1,'WILMA','CHOQUETOPA GARCÍA',2, CONVERT (DATETIME, '01/01/1980',103),14,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (91,2,'MARIA CLAUDIA PATRICIA','DE ALENCAR ROJAS',2, CONVERT (DATETIME, '01/01/1981',103),14,7,'C-LAPAZ20160524', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (91,3,'INDER MAXIMO','ÑUFLO SARMIENTO',1, CONVERT (DATETIME, '01/01/1972',103),20,4,'C-LAPAZ20160524', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (91,4,'MARIA DE LOS ANGELES','OVIEDO HERNANDEZ',2, CONVERT (DATETIME, '01/01/1974',103),14,8,'C-LAPAZ20160524', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (91,5,'BEATRIZ CLOTILDE','SEGALES SALVADOR ',2, CONVERT (DATETIME, '01/01/1959',103),14,9,'C-LAPAZ20160524', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (92,6,'SONIA','OLIVA DOMÍNGUEZ ',2, CONVERT (DATETIME, '01/01/1960',103),14,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (92,7,'EUSEBIO','ORIHUELA VACA',1, CONVERT (DATETIME, '01/01/1957',103),14,7,'', 3, 9 , 1, '::1')

-- C

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (126,1,'SUSANA','MARROU FABERÓN',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (126,1,'RODOLFO','MATOS',1, CONVERT (DATETIME, '01/01/1954',103),20,9,' SE HABÍA AUTORIZADO UN INCREMENTO HASTA 3,000.00 CON MENSAJE OGA20154983, SIN EMBARGO, NO SE IMPLEMENTÓ PORQUE NO SE MODIFICÓ LA ASIGNACIÓN ORDINARIA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (126,1,'ROSALIA','TURGEON DE TRELLES',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (112,1,'KATYA','ANGULO TORRES',2, CONVERT (DATETIME, '01/01/1968',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (112,1,'ROXANA','LÓPEZ BARRAZA',2, CONVERT (DATETIME, '01/01/1963',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (112,1,'FLAVIO ','MENDIETA MERINO',1, CONVERT (DATETIME, '01/01/1958',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (124,1,'LEONARDO ALEJANDO','CHÁVEZ SUELDO',1, CONVERT (DATETIME, '01/01/1962',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (124,1,'VERÓNIKA MILAGROS','GAMARRA GUZMÁN ',2, CONVERT (DATETIME, '11/10/2016',103),20,9,'INGRESO EN REEMPLAZO DE LA PLAZA VACANTE DEJADA POR LA SEÑORA ÁNGELA MARQUINA RUIZ ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (124,1,'CARLOS','SU CHU',1, CONVERT (DATETIME, '01/01/1963',103),20 ,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (61,1,'RICARDO ','VALERA  CHOCLOTE',1, CONVERT (DATETIME, '01/01/1980',103),20 ,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (61,1,'CARMEN','MALDONADO GIL',2, CONVERT (DATETIME, '01/01/1958',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (61,1,'WALTER','MAICELO CULQUIRRICRA',1, CONVERT (DATETIME, '01/01/1974',103),20,7,'RESTRUCTURACIÓN DE FUNCIONES: PASA A DESARROLLAR LAS FUNCIONES DE LA EX EMPLEADA ROSA ANA FLORES ESCOBEDO, A PARTIR DEL15 DE DICIEMBRE DE 2017', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (61,1,'JOSÉ LUIS','GUTIÉRREZ DELGADO',1, CONVERT (DATETIME, '01/01/1955',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (94,1,'MARITZA ELIZABETH','CRUZ ARROYO',2, CONVERT (DATETIME, '01/01/1977',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (94,1,'SUAHANS LINA','MAMANI ROMERO',2, CONVERT (DATETIME, '01/01/1985',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (94,1,'MARLENY MAGDALENA','PACHECO ORTIZ',2, CONVERT (DATETIME, '01/01/1967',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (95,1,'MIGUEL ÁNGEL','GAMBOA RIVERA',1, CONVERT (DATETIME, '01/01/1978',103),20,6,'*PLAZA DEJADA POR ESMERALDA HUANCA AGUIRRE', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (95,1,'WLADIMIR ANÍBAL ','BAZÁN ROMERO',1, CONVERT (DATETIME, '01/01/1981',103),20,6,'PLAZA DEJADA PORJASON WUN SHI HOY A PARTIR DEL 29 DE FEBRERO DE 2013 (16,463.00)/MONTO REMUNERATIVO CONFORME A LO ESTIPULADO EN ADDENDUM REMITIDO CON MENSAJE C-VALPARAISO20150174.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'ELIZABETH','HUARCAYA AROHUANCA',2, CONVERT (DATETIME, '01/01/1978',103),20,6,'LICENCIA POR MATERNIDAD- REEMPLAZO LILIAN OCROSPOMA DEL 27 DE ENERO AL 30 DE AGOSTO DE 2015. /MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,3,'KARINA JACQUELINE','FERNÁNDEZ MUÑOZ',2, CONVERT (DATETIME, '01/01/1982',103),20,7,'MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'IRMA AGRIPINA','CARDOSO BENITES',2, CONVERT (DATETIME, '01/01/1975',103),20,6,'MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'CRISTINA SOLEDAD','POZO MARTEL',2, CONVERT (DATETIME, '01/01/1960',103),20,9,'MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'MARÍA MARITZA','YOVERA VALENCIA',2, CONVERT (DATETIME, '01/01/1987',103),20,6,'* CONTRATADA BAJO RÉGIMEN LABORAL DESDE EL 01 DE ENERO DE 2013. MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'WALTER','VILELA ESPINOZA',1, CONVERT (DATETIME, '01/01/1960',103),20,6,'MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'JUAN CARLOS','RAMOS AVENDAÑO',1, CONVERT (DATETIME, '01/01/1969',103),20,4,'MEDIANTE EL MENSAJE C-SANTIAGO20160112, SE COMUNICA LA RESTRUCTURACIONES DE FUNCIONES, EN CONSECUENCIA EL SR. RAMOS AVENDAÑO OCUPA LA PLAZA DEJADA POR EL SEÑOR ZEGARRA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'LUZ MARINA','PAZ FIORI',2, CONVERT (DATETIME, '01/01/1980',103),20 ,4,'PLAZA DEJADA POR BLANCA ESTHER PÉREZ MELÉNDEZ (OGA20133174), SE DECIDIÓ DAR POR TERMINADA LA RELACIÓN LABORAL. MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'ELYANA KAHRINNA','CAVERO BAZALAR',2, CONVERT (DATETIME, '01/01/1989',103),20,7,'* PLAZA DEJADA POR VANESSA MARCELA CHICOT CASTAGNOLA (C-SANTIAGO20130836 31/08/2013). MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'GLADYS LEONOR','GARCÍA CALDERÓN',2, CONVERT (DATETIME, '01/01/1965',103),20,8,'*PLAZA DEJADA POR JUAN CARLOS GUERRERO/MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'TATIANA CAROLINA','BUSTAMANTE',2, CONVERT (DATETIME, '01/01/1987',103),20,9,'INGRESA EN REEMPLAZO DE LA SR. FIORELLA RUIZ LIMAY, QUIEN A SU VEZ REEMPLAZO A LA SRA. EDITH OSCOPOMA.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'ELIZABETH','QUÍA HUAQUISTO',2, CONVERT (DATETIME, '01/01/1980',103),20,8,'MONTO CONFORME A LO SEÑALADO EN DOCUMENTO ADJUNTO AL MENSAJE C-SANTIAGO20151130.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'BÁRBARA SCARLETT ','STUBING CERDA',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'INGRESA EN REEMPLAZO DE LA SEÑORA KARIN ANDREA VASQUEZ GUTIERREZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'SHEYLA JACQUELINE','CARRANZA MUÑOZ',2, CONVERT (DATETIME, '01/01/1980',103),20,4,'REEMPLAZO TEMPORALMENTE A LA SEÑORA OSCORPOMA,  DURANTE SU LICENCIA POR MATERNIDAD', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'MIGUEL ENRIQUE','ISMODES MALPARTIDA',1, CONVERT (DATETIME, '01/01/1980',103),20,4,'REEMPLAZA A LA SEÑORA VEGA PURIZAGA. INICIALMENTE HABÍA REEMPLAZADO TEMPORALMENTE A LA SEÑORA AROHUANCA DURANTE SU LICENCIA POR SALUD, DESDE ENERO HASTA MARZO. ULTIMA CONTRATACIÓN EN REEMPLAZO DE LA SEÑORA IVON VEGA. / A PARTIR DEL 16 DE JULIO PASO A SER CONTRATADO DE FORMA INDEFINIDO.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'CARLOS MARTÍN ','CONTRERAS  CABRERA',1, CONVERT (DATETIME, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'JAVIERA ELIZABETH ','CONTRERAS MARÍN',2, CONVERT (DATETIME, '29/02/1992',103),16,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'ROLAND','INFANZÓN VASQUEZ',2, CONVERT (DATETIME, '01/01/1979',103),16,4,'INGRESA A EFECTOS DE CUBRIR LA PLAZA VACANTE DEJADA POR EL SEÑOR FERNANDO MARCOS ÁLVAREZ MUÑOZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'PAULA ROSA','CALLE BONIFAZ',2, CONVERT (DATETIME, '01/01/1986',103),20,11,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (122,1,'WEI KANG','DAI',1, CONVERT (DATETIME, '01/01/1954',103),34,4,'NO HAY RELACIÓN DIRECTA CON EL CONSULADO, SINO CON AGENCIA SHANGHÁI FOREING AGENCY SERVICE DEPARTMENT', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (122,1,'YAO YAO ','JIANG',2, CONVERT (DATETIME, '01/01/1981',103),34,8,'NO HAY RELACIÓN DIRECTA CON EL CONSULADO, SINO CON AGENCIA SHANGHAI FOREING AGENCY SERVICE DEPARTMENT/ MONTO REMUNERATIVO CONFORME A LO INDICADO EN MENSAJE ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (122,1,'KAI','YANG',2, CONVERT (DATETIME, '01/01/1981',103),34,8,'CON MSJ C-SHANGHAI SE HA INFORMADO QUE SE HA DECIDIDO PRESCINDIR DE LOS SERVICIOS DE LA SEÑORITA YI LU EL 31 DE MAYO DE 2013.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (122,1,'YAN JUN','PAN',2, CONVERT (DATETIME, '01/01/1980',103),34,8,'NO HAY RELACIÓN DIRECTA CON EL CONSULADO, SINO CON AGENCIA SHANGHAI FOREING AGENCY SERVICE DEPARTMENT/ MONTO REMUNERATIVO CONFORME A LO INDICADO EN MENSAJE C-SHANGHAI20140325.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (104,1,'SHUILIAN (ROSIE)','WU',2, CONVERT (DATETIME, '01/01/1985',103),34,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (104,1,'JULY PIC LENG','WU MAK',2, CONVERT (DATETIME, '01/01/1980',103),34,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (104,1,'TAT CHEONG','LI',1, CONVERT (DATETIME, '01/01/1952',103),65,4,'.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (102,1,'BAOHUA','HU',2, CONVERT (DATETIME, '01/01/1978',103),34,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (102,1,'CHUYAN','OU',2, CONVERT (DATETIME, '01/01/1984',103),34,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (102,1,'XIAOJIE','CHEN',2, CONVERT (DATETIME, '01/01/1990',103),34,9,'SE HA AUTORIZADO CON MENSAJE OGA20153271 Y CON MENSAJE C-GUANGZHOU20150116 SE INFORMÓ QUE INICIARÁN FUNCIONES EL 01 DE JULIO DE 2015/ PRESENTO SU REMUNECIA VOLUNTARIA, LABORÓ HASTA EL 30 DE ABRIL DE 2017', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (102,1,'WU','JIEYI',2, CONVERT (DATETIME, '01/01/1990',103),34,9,'SE HA AUTORIZADO CON MENSAJE OGA20153271 Y CON MENSAJE C-GUANGZHOU20150116 SE INFORMÓ QUE INICIARÁN FUNCIONES EL 01 DE JULIO DE 2015', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (102,1,'YUNSHENG','CHEN',2, CONVERT (DATETIME, '01/01/1984',103),34,6,'SE HA AUTORIZADO CON MENSAJE OGA20153271 Y CON MENSAJE C-GUANGZHOU20150116 SE INFORMÓ QUE INICIARÁN FUNCIONES EL 01 DE JULIO DE 2015.', 3, 9 , 1, '::1')

-- E

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (80,1,'HENRY','LLANO MELO',1, convert (datetime, '01/01/1969',103),17,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (80,1,'BARBARA ','ALVARADO ALBA',2, convert (datetime, '01/01/1993',103),17,9,'REEMPLAZO TEMPORAL POR PERIODO VACACIONAL DE LA SEÑORA AURORA MEZA PATOW', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (80,1,'ELIZABET ADRIANA','OLIVERA CUADROS',2, convert (datetime, '01/01/1949',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (80,1,'LIZBETH PAOLA','SALINAS HERREÑO',2, convert (datetime, '01/01/1986',103),17,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (80,3,'LUCILA','RODRÍGUEZ DE ROJAS',2, convert (datetime, '23/03/1950',103),17,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (81,1,'CARMENZA','BERMEO PARRA',2, convert (datetime, '01/01/1959',103),17,6,'C-LETICIA:  CASO LETICIA REGULARIZACIÓN DE BENEFICIOS SOCIALES (MARIANELA GUEVARA, CARMENZA BERMEO, ORLANDO BETANCOURT, VICTOR RIOS)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (81,1,'VICTOR MANUEL','RÍOS CUETO',1, convert (datetime, '01/01/1971',103),20,9,'C-LETICIA:  CASO LETICIA REGULARIZACIÓN DE BENEFICIOS SOCIALES (MARIANELA GUEVARA, CARMENZA BERMEO, ORLANDO BETANCOURT, VICTOR RIOS)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (81,1,'JAN KEVIN ','ARCE CARRERA',1, convert (datetime, '01/01/1993',103),20,6,'REEMPLAZO DEL SEÑOR BETANCOURT.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (81,1,'FANNY','ORTÍZ GÓMEZ',2, convert (datetime, '01/01/1961',103),17,2,'.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (106,1,'MARÍA ELIANA PILAR','CASTRO CARPIO RIVERO',2, convert (datetime, '01/01/1977',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (106,1,'MARTHA MARÍA ANA','MÁLAGA COCHELLA DE TSIGRIS',2, convert (datetime, '01/01/1952',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (106,1,'LUISA MARÍA DE LOURDES','ROMERO SIMPSON VIUDA DE BARRETT',2, convert (datetime, '01/01/1947',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (106,1,'MARY LILY','TEJADA TRIVEÑO',2, convert (datetime, '01/01/1941',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (106,1,'ANA MARÍA','FUENTES RAMÍREZ DE ESTRADA',2, convert (datetime, '01/01/1961',103),20,6,'PERSONAL QUE TRASLADADO DEL CONSULADO DE MACARÁ A CUENCA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (135,1,'LUZ ANGÉLICA ','URREGO RÍOS',2, convert (datetime, '01/01/1964',103),20,4,'PERSONAL QUE TRASLADADO DEL CONSULADO DE MACARÁ A CUENCA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (135,1,'ENRIQUE','VALENZUELA HUARHUA',1, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (96,1,'ANALIA BEATRIZ','CAMMARATA ',2, convert (datetime, '01/01/1969',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (96,1,'CESAR AUGUSTO','RAMOS PRADO',1, convert (datetime, '01/01/1966',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (96,1,'KHALIFA ','ABDELGADIR',1, convert (datetime, '01/01/1975',103),61,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (93,1,'SUHAIL ROSANA','ALI BRICEÑO',2, convert (datetime, '01/01/1980',103),61,4,'REEMPLAZO DE LA SEÑOR PAREDES.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (62,1,'ADOLFO','DÁVILA ECHEVERRÍA',1, convert (datetime, '01/01/1974',103),20,6,'PLAZA DEJADA POR TATIANA SUÁREZ CARDEÑA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (62,1,'ROSA ','ESPINOZA VELIZ',2, convert (datetime, '01/01/1986',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (62,1,'PEDRO','FUERTES BOLAÑOS',1, convert (datetime, '01/01/1958',103),20,6,'PLAZA DEJADA POR YONI ISABEL JUSCAMAYTA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (62,1,'JOHN ','ZORRILLA MATOS',1, convert (datetime, '01/01/1969',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (69,1,'CHRISTIAMS','MALPICA FARFÁN',1, convert (datetime, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (69,1,'CLAUDIA ELENA','MEZA VALENZUELA',2, convert (datetime, '01/01/1975',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (68,1,'MERCEDES','TELLO DE VILLALOBOS',2, convert (datetime, '01/01/1949',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (68,1,'LOURDES PATRICIA','FUENTES DE VASQUEZ',2, convert (datetime, '01/01/1980',103),20,9,'INGRESA EN REEMPLAZO DEL SEÑOR UGAZ POBLETE. LA MISIÓN INFORMO QUE DURANTE EL MES DE DICIEMBRE DE 2017 DICHA EMPLEADA NO LABORÓ(C-CHICAGO20170378)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (68,1,'JOEL ','JANANPA',1, convert (datetime, '01/01/1977',103),20,7,'INGRESA EN REEMPLAZO DE SR. BEATRIZ FERNANDEZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (70,1,'CAROLINA ELIZABETH','CÉSPEDES TSUJITA',2, convert (datetime, '01/01/1980',103),20,4,'REEMPLAZA TEMPORALMENTE A LA SEÑORA ECHEVARRÍA.  * EN LA ÚLTIMA RENOVACIÓN CONTRACTUAL SE SOLCITO PRECISAR LOS MOTIVOS DEL INCREMENTO DE 200 (TOTAL 2,200.00) DÓLARES EN LA CONTRAPRESTACIÓN PERCIBIDA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (70,1,'RICARDO','IZQUIERDO CASTRO',1, convert (datetime, '01/01/1971',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (70,1,'RUBÉN FABRICIO','OLANO OLANO',1, convert (datetime, '01/01/1970',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (70,1,'DENNISS ROXANA','PUMASUPA TERÁN',2, convert (datetime, '01/01/1978',103),20,9,'* PLAZA DEJADA POR ROSARIO ISABEL TEJADA CARRANZA MEDIANTE CARTA DE RENUNCIA 16/05/13, CULMINANDO EL 31 DE MAYO DE 2013. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (73,1,'SANDRA LUCIA','BENAVIDES MONTEVERDE',2, convert (datetime, '01/01/1972',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (73,1,'MARTIN ANTONIO','SANTA CRUZ GUEVARA',1, convert (datetime, '01/01/1975',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (73,1,'KAREN ','YUPANQUI ALZAMORA',2, convert (datetime, '01/01/1968',103),20,11,'INGRESO EN REEMPLAZO DE LA EMPLEADA CATHERINE MENESES QUIROZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (74,1,'KRISTIE CYNTHIA ','GARCÍA CHÁVEZ',2, convert (datetime, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (74,1,'EDGARDO ','POPOLIZIO BARDALES',1, convert (datetime, '01/01/1963',103),20,6,'*REAJUSTE SALARIAL DE$ 200, CON MSJ OGA20141801', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (74,1,'GUISELLA LUZ','RAMIREZ RAMOS',2, convert (datetime, '01/01/1969',103),20,9,'*REAJUSTE SALARIAL DE$ 200, CON MSJ OGA20141801', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (65,1,'JOSÉ ANTONIO','CALIXTO LAURENTE',1, convert (datetime, '01/01/1974',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (65,1,'ELDON FRANCISCO','FLORES HUERTA',1, convert (datetime, '01/01/1980',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (65,1,'MILAGROS EMILIA','PUMASUPA TERÁN',2, convert (datetime, '01/01/1976',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (65,1,'JUANA ROSA ANGÉLICA','RUIZ MÁRQUEZ',2, convert (datetime, '31/08/1996',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'MARITZA MERCEDES','AGUIRRE RIBBECK ',2, convert (datetime, '01/01/1970',103),20,9,'PLAZA DEJADA POR YONI ISABEL JUSCAMAYTA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'JULIO ALEJANDRO','BERMEJO GUARDALES',1, convert (datetime, '01/01/1967',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'JAQUELINE ','SANDOVAL MUÑOZ',2, convert (datetime, '01/01/1984',103),20,8,'INGRESA EN REEMPLAZO DE LA SEÑORA MARÍA DEL CARMEN RODRIGUEZ FRÍAS', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'FERNANDO CÉSAR','GRADOS FLORES',1, convert (datetime, '01/01/1984',103),20,4,'REEMPLAZÓ AL SEÑOR DEL RISCO FLUCKER.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'LUIS HAROLD','LARA SALAZAR',1, convert (datetime, '01/01/1967',103),20,5,'*PLAZA DEJADA POR ENGELA VAL MACHT. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'RICARDO ANTONIO','LEÓN TOUZARD',1, convert (datetime, '01/01/1961',103),20,5,'PLAZA DEJADA POR YONI ISABEL JUSCAMAYTA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'ROGER ABRAHAM','MÁRQUEZ FLORES',1, convert (datetime, '01/01/1951',103),20,9,'* ENTRA EN REEMPLAZO DE MARÍA ROSA QUIROZ C-MIAMI20131592 DEL 26.11.2013', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'LUIS FERNÁN JOSÉ JULIO CÉSAR','PACHECO GONZALES',1, convert (datetime, '01/01/1979',103),20,5,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'PIO JESÚS ELARD','POLAR CASAS',1, convert (datetime, '01/01/1949',103),20,8,'REEMPLAZO DE LA SEÑORA MARÍA ANTONIETA SILVA TIRADO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'WILFREDO','SOTELO LOPEZ',1, convert (datetime, '01/01/1984',103),20,9,'*PLAZA DEJADA POR VALERY CALDERÓN CASTRO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'MERCEDES ','ALMONACID CÁRDENAS',2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'HUGO GIANCARLO','SUÁREZ ESPINOZA',1, convert (datetime, '01/01/1983',103),20,6,'PLAZA DEJADA POR YONI ISABEL JUSCAMAYTA. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (64,1,'JIMENA CECILIA','TOVAR RODRÍGUEZ',2, convert (datetime, '01/01/1986',103),20,11,'*PLAZA DEJADA POR JOSÉ RODRÍGUEZ CHACÓN', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'JORGE LUIS','ESPINOZA BENZA',1, convert (datetime, '01/01/1970',103),20,9,'*PLAZA DEJADA POR ENGELA VEN NACHT, PERO MEDIANTE EL MENSAJE C-NUEVA YORK20150417 COMUNICÓ DE SU RENUNCIA./LA MISIÓN INFORMA QUE PARA EL AÑO 2017, EL PAGO DE SEGURO MÉDICO SERÁ DE US$ 680, POR LA EDAD DEL MENCIONADO EMPLEADO(OGA20167083)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'ANA ISABEL ','CRUZ MATOS',2, convert (datetime, '01/01/1975',103),20,7,'REEMPLAZA AL SEÑOR BARDALES A PARTIR DEL 01 DE NOVIEMBRE.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'OSWALDO ENRIQUE','SOTO ZEGARRA',1, convert (datetime, '01/01/1969',103),41,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'PATRICIA IVETTE','DURAND PACHECO',2, convert (datetime, '01/01/1977',103),20,6,'SE MODIFICÓ SU RELACIÓN CONTRACTUAL Y PASÓ A REEMPLAZAR A LA EX EMPLEADA GUZMÁN MORÍ.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'MARIEL CRISTINA','REYNA VEREAU DE LEDO',2, convert (datetime, '01/01/1984',103),20,4,'REEMPLAZA A LA SEÑORA DURANTD PACHECO, QUIEN PASÓ A OCUPAR LA PLAZA QUE DEJÓ VACANTE LA SEÑORA GUZMÁN MORI.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,3,'JOSSELINE RAQUEL','RÍOS VELÁSQUEZ ',2, convert (datetime, '01/01/1984',103),20,4,'* PLAZA DEJADA MARIEL CRISTINA POR REYNA VEREAU DE LEDO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'MARÍA FERNANDA','LOZADA CRUZ',2, convert (datetime, '01/01/1987',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'HAYDEE CATALINA ','NORABUENA CASTRO',2, convert (datetime, '01/01/1962',103),20,4,'* PLAZA NO LABORAL DEJADA POR PATRICIA GIOVANNA RAMÍREZ YANAGUA, QUIEN PRESTÓ SERVICIOS HASTA DICIEMBRE 2013 SEGÚN CONTRATO.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,1,'EDUARDO ','TACTUK',1, convert (datetime, '01/01/1984',103),20,4,'BRINDA SERVICIOS DE MANTENIMIENTO ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,3,'PATRICIA LIDYA','CALENZANI FIESTAS',2, convert (datetime, '01/01/1984',103),20,9,'REEMPLAZO DE LA SEÑORA HIGA YARA, PRESTA SERVICIOS A TIEMPO PARCIAL.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (63,3,'VIOLETA ISABEL','PACHERRES  PURIZAGA',2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'MIGUEL','GUEVARA RETAMOZO',1, convert (datetime, '01/01/1977',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'ANTHOANET NELLY','YATACO CARRIÓN ',2, convert (datetime, '01/01/1975',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'MAURICIO DAVID','SAN MIGUEL LLOSA',1, convert (datetime, '01/01/1984',103),20,9,'PLAZA A MEDIO TIEMPO , DEJADA POR LA SEÑORA CHANG, QUIEN PASO A SER CONTRATADA A TIEMPO COMPLETO. INICIALMENTE, DICHA PLAZA FUE DEJADA POR EL SR. SAN MIGUEL /EL CITADO EMPLEADO LABORÓ HASTA EL  01 DE JUNIO DE 2015 CON MENSAJE C-WASHINGTON20150363', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'ENRIQUE MARTÍN ','COSTA SACO',1, convert (datetime, '01/01/1963',103),20,9,'PLAZA DEJADA POR KATIA LA  TORRE RAMOS DE SARRIA', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'MARÍA LUISA','CÓRDOVA BURGA',2, convert (datetime, '01/01/1984',103),20,6,'*PLAZA DEJADA POR MARIA YABAR POR REORGANIZACIÓN DE FUNCIONES 2014', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'ELÍSEA KARINA','SÁENZ  GARCÍA',2, convert (datetime, '01/01/1984',103),20,4,'REEMPLAZO DE SEÑORA VALERIA GARCÍA DEL CASTILLO.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'YURY LIZETH','RUBIO ',2, convert (datetime, '29/09/1991',103),20,8,'PLAZA VACANTE DEJADA POR LA SEÑORA A. CHANG ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'MARISOL','ALFONSO DE MEDINA',2, convert (datetime, '01/01/1969',103),20,9,'PLAZA DEJADA POR LORENA MELIZA CORNEJO LIMO C-LOSANGELES20130197', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'JOSÉ LUIS ','ÁNGELES QUEZADA',1, convert (datetime, '01/01/1984',103),27,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'GIANNINA CARLA ','CHIAPPE ROSENTHAL',2, convert (datetime, '01/01/1968',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'JULIA LEONOR','HUARINGA LAGOMARSINO',2, convert (datetime, '01/01/1960',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'CARLOS','VALERA MENDOZA',1, convert (datetime, '01/01/1984',103),20,8,'INGRESA EN REEMPLAZO DE LA SEÑORA AMANDA LÓPEZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'MARYCO','MUÑOZ VIGNES DE SAMMOUR',2, convert (datetime, '01/01/1954',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'ROMINA MARLI ','OTIDIANO CARMEN', 2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'SILVIA PAOLA','ROJAS BOGGIO(KOPISCHKE)',2, convert (datetime, '01/01/1972',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (72,1,'GREIDA MILI','SALAS BURNEO',2, convert (datetime, '01/01/1965',103),20,6,'PLAZA DEJADA POR EBERTH WILLIAM CASTILLO SOTOMAYOR C-LOSANGELES20130256, QUIEN PRESTARÁ SERVICIOS HASTA EL 30/04/2013.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (71,1,'MIGUEL ÁNGEL','INGA LOAYZA',1, convert (datetime, '01/01/1984',103),20,4,'PLAZA DEJADA POR AYRTON RODOLFO ACOSTA EYZAGUIRRE CON MSJ   C-SANFRANCISCO20130243', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (71,1,'ROSA GEORGINA ','GUERRERO PAZ',2, convert (datetime, '01/01/1958',103),20,9,'REEMPLAZO DE LA SEÑORA ZIMIC', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (71,1,'PAULO CÉSAR','HUERTAS FERNÁNDEZ',1, convert (datetime, '01/01/1977',103),20,9,'*REEMPLAZO DE LORENA AGUINAGA VELEZ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'MÓNICA YANNET','CANEDO TAPIA',2, convert (datetime, '01/01/1973',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'GLORIA RUTH','NIÑO DE GUZMÁN CONTRERAS',2, convert (datetime, '01/01/1959',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'MALENA ANTONIETA','SÁNCHEZ GIL',2, convert (datetime, '01/01/1975',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'FERNANDO CARLO','RÍOS LEÓN',1, convert (datetime, '01/01/1975',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'MIYANU','VILLAFANE PEREYRA',2, convert (datetime, '01/01/1979',103),20,5,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'NELLY ROCÍO','MONTOYA CUBA',2, convert (datetime, '01/01/1978',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'CÉSAR','GAYOSO VIZCARRA',1, convert (datetime, '01/01/1962',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'FERMINA ISABEL ','LLARENA VASQUEZ',2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (66,1,'EDY ALEXANDER','SAMAYOA CEBALLOS',1, convert (datetime, '01/01/1976',103),22,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (71,1,'VALERY ANTHUANETTE ','CALDERON CASTRO',2, convert (datetime, '17/09/1985',103),8,4,'PLAZA VACANTE DEJADA POR LA SEÑORA ÁNGELA MARÍA  SÁNCHEZ CATERIANO', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (67,1,'CORY MARCELA','ABANTO CABANILLAS',2, convert (datetime, '13/04/1981',103),20,9,'PLAZA VACANTE DEJADA POR EL SR. JORGE LUIS MALPARTIDA AMPUDIA', 3, 9 , 1, '::1')

-- O

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'CLAUDIA BEATRIZ','BARROS ESCUDERO',2, convert (datetime, '01/01/1974',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'INES HERMINIA','CARDENAS VÁSQUEZ',2, convert (datetime, '01/01/1976',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'GIAN MARCO','CHU SOLARI',1, convert (datetime, '01/01/1981',103),20,9,'con mensaje C-BARCELONA20170772, la Misión informó que el sr. Chu se aogio a la la reducción de la jornada laboral.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'PAOLA MAYTE','CISNEROS VIGO',2, convert (datetime, '01/01/1972',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,3,'SALVADOR RAFAEL','GARCIA MENDOZA',1, convert (datetime, '01/01/1947',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'PATRICIA ELVIRA','HUACACOLQUE AGUILAR',2, convert (datetime, '01/01/1970',103),20,6,'plaza vacante dejada por la señora Falconí Ortiz , quien  dejo de laborar el 6 de junio de 2016.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'JORGE','LUDEÑA HUAMÁN',1, convert (datetime, '01/01/1977',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'LIANA MERCEDES','MASSEY SAMANIEGO',2, convert (datetime, '01/01/1963',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'ERLITA MARISOL','PORTILLA LEÓN',2, convert (datetime, '01/01/1968',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'ROSA MARITZA','QUEVEDO BURNEO',2, convert (datetime, '01/01/1955',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'PRISCILIA ISABEL','RISCO RAGAS',2, convert (datetime, '01/01/1969',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (75,1,'GLADYS ALICIA','VALDERRAMA HORNA',2, convert (datetime, '01/01/1967',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (79,1,'CAROLINA NORKA','ALVAREZ YEPEZ',2, convert (datetime, '01/01/1980',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (79,1,'YOLANDA ANAHI ','BARRIENTOS MORENO',2, convert (datetime, '01/01/1966',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (79,1,'PAMELA KATIA MONICA ','CAMPOS CLAVARINO',2, convert (datetime, '01/01/1965',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (79,1,'MARIA CARMEN ','ROIG MARTINEZ',2, convert (datetime, '01/01/1956',103),41,9,'Su contrato pasa de temporal a definido con msj OGA20133557 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'ERIKA MARJORY','ANDIA HINOJOSA',2, convert (datetime, '01/01/1974',103),20,9,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20160414', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'ROSALIA','ARENAS DÍAZ',2, convert (datetime, '01/01/1976',103),20,8,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277./Mediante el mensaje C-MADRID informan del incremento de 49.05 euros , a efectos de cubir el pago  por el concepto de antigüedad.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'SILVIA ROSA','ARREDONDO ROSAS ',2, convert (datetime, '01/01/1976',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'EDDA SOCORRO','BARBA SOTELO ',2, convert (datetime, '01/01/1964',103),20,8,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'RINA ROSARIO','BARBA SOTELO ',2, convert (datetime, '01/01/1967',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'CARMEN DEL ROSARIO ','CONTRERAS BEJARANO',2, convert (datetime, '01/01/1965',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'CAROLINA ISABEL ','DONAYRE AYLLÓN ',2, convert (datetime, '01/01/1974',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'JOSÉ LUIS','INGA CARRILLO',1, convert (datetime, '01/01/1979',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277./Mediante el mensaje C-MADRID informan del incremento de 49.05 euros, a efectos de cubir el pago  por el concepto de antigüedad.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'MÓNICA GISELLA','MARRERO ORTIZ ',2, convert (datetime, '01/01/1972',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'MÓNICA IRINA','MELGAR PAZOS',2, convert (datetime, '01/01/1996',103),20,6,'Plaza dejada por la señora Julia Leticia Bussalleu Pastor con mensaje OGA20156773. Montos remunerativos conforme al documento adjunto al mensaje C-MADRID20151277/', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'JEAN CARLOS','RAMOS ROJAS',1, convert (datetime, '01/01/1974',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20160414', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'ERIKA MILAGROS','SANTOS CASTRO ',2, convert (datetime, '01/01/1975',103),20,6,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20160414', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'UBER PABLO','TOLEDO PALAO',1, convert (datetime, '01/01/1963',103),20,9,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277./ Mediante el mensaje C-MADRID informan del incremento de 56.63, a efectos de cubir el pago  por el concepto de antigüedad.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (77,1,'INNA','ZINCHENCHO',2, convert (datetime, '01/01/1984',103),20,4,'Montos remunerativos conforme a lo indicado en documento anexo al mensaje C-MADRID20151277.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (78,1,'MARÍA DEL CARMEN','PÉREZ CARAMÉS',2, convert (datetime, '01/01/1956',103),41,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (78,1,'CESAR MARTÍN','GAMARRA DE LA FUENTE',1, convert (datetime, '01/01/1977',103),41,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (78,1,'LUIGI','ORDINOLA MANRIQUE',1, convert (datetime, '01/01/1975',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (78,1,'ROSARIO MABEL ','SIERRA SIERRA',2, convert (datetime, '01/01/1978',103),20,9,'ingresa en reemplazo de la señora  Carmen Rosa Sierra Ruíz', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (78,1,'RENÁN ALBERTO','GARCÍA WESTPHALEN',1, convert (datetime, '01/01/1973',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (76,1,'TEONILA ','LUCANO CRISOSTOMO',2, convert (datetime, '01/01/1984',103),20,9,'El monto consignado en la Remuneración bruta/neta y Costo Total son los mismos que fueron consignados la autorización OGA20153169', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (76,1,'FANY LETICIA','PACHECO AMADO',2, convert (datetime, '01/01/1984',103),20,4,'El monto consignado en la Remuneración bruta/neta y Costo Total son los mismos que fueron consignados la autorización OGA20153169', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (76,1,'NORKA JESSICA','MATEO PALOMINO',2, convert (datetime, '01/01/1991',103),20,9,'El monto consignado en la Remuneración bruta/neta y Costo Total son los mismos que fueron consignados la autorización OGA20153169', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (116,1,'LOUBA CLETTE','GROUVEL - FORNO',2, convert (datetime, '01/01/1984',103),20,4,'Ingresa en reemplazo del sr, Francois Chotard', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (116,1,'ROXANA PILAR ','GAMARRA SÁNDIGA',2, convert (datetime, '01/01/1964',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (116,1,'KELLY MERCEDES','JUÁREZ CASTILLO',2, convert (datetime, '01/01/1983',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (116,1,'ARTURO SÍDNEY','MAURICIO VILLANUEVA',1, convert (datetime, '01/01/1984',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (116,1,'FANNY','SÁNCHEZ BERROCAL',2, convert (datetime, '01/01/1954',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'GUILLERMO','QWISTGAARD MORALES ',1, convert (datetime, '01/01/1944',103),20,7,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'MARITZA IDA','BENAVIDES ARANCIBIA ',2, convert (datetime, '01/01/1955',103),20,8,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'MYRIAM ROSA LILIANA','COLLANTES DE BRUNO ',2, convert (datetime, '01/01/1956',103),20,4,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'ISABELLA','RISI VALDETTARO ',2, convert (datetime, '01/01/1958',103),20,4,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'DIEGO ALFREDO','GIACOBETTI CROVETTI ',1, convert (datetime, '01/01/1983',103),43,7,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'MARÍA PIA','SCIANNAME',2, convert (datetime, '01/01/1983',103),43,9,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'MAGDA ESTHER','BENITES FARFÁN',1, convert (datetime, '01/01/1978',103),20,9,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'WILLY WILFREDO','CANCHANYA  MEDINA',1, convert (datetime, '01/01/1975',103),20,4,'Montos conforme al cuadro adjunto al mensaje C-ROMA20150935', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (120,1,'JAVIER ','URCIA ESCOBAR',1, convert (datetime, '01/01/1984',103),20,4,'Mediante OGA20162788, se autoriza su renovación, en base a las mismas condiciones vigente. Se esta a la espera del monto fijo de la renuneración bruta, toda vez que conforme al ultimo incremento , la remuneración total del empleao es de E 2,100.00', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (97,1,'GUILIANA PATRICIA','SANGUINETTI MARTÍNEZ',2, convert (datetime, '01/01/1957',103),20,9,'Montos remunerativos conforme al documento adjunto al mensaje C-FLORENCIA20150514.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (97,1,'EMANUELA','CONSIGLI',2, convert (datetime, '01/01/1956',103),43,6,'Montos remunerativos conforme al documento adjunto al mensaje C-FLORENCIA20150514.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (97,1,'MILAGROS','BARRIENTOS MOLLO',2, convert (datetime, '01/01/1956',103),43,8,'Montos remunerativos conforme al documento adjunto al mensaje C-FLORENCIA20150514.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (99,1,'ANA MARÍA','LEA DE LIENDO',2, convert (datetime, '01/01/1950',103),20,6,'Montos conforme al documento adjunto al mensaje C-GENOVA20150406.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (99,1,'ALESSANDRA MARÍA DEL CARMEN','MALATESTA GUEVARA',2, convert (datetime, '01/01/1984',103),20,4,'Contratada bajo la modalidad de formación laboral. Se solicita que para el 2016 pase a tener un contrato indefinido (1,607.54-bruto y 2,493.43-total)', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'RAÚL YVAN','ÁLVAREZ LIRA',1, convert (datetime, '01/01/1971',103),20,9,'* Plaza dejada por la señorita Rosa Milagros Ugáz Cortegana, quien dejó de laborar el 30/09/2013 (C-MILAN20131543 DEL 01/10/2013) / Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'ROSALÍA ','ARÉVALO VELA ',2, convert (datetime, '01/01/1957',103),20,8,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'ERIKA MIRELLA ','BRIOLO SÁNCHEZ- GUTIÉRREZ ',2, convert (datetime, '01/01/1967',103),20,9,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'CECILIA','CALVI DALLU',2, convert (datetime, '01/01/1974',103),43,9,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,3,'MIGUEL ANTONIO ','DIMAS GUEVARA',1, convert (datetime, '01/01/1976',103),20,6,'Plaza dejada por la señora Laura Gacomelli con mensaje oga20141246. Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'MIRYHAM LUISA ','ECHEVARRÍA DEZA ',2, convert (datetime, '01/01/1961',103),20,6,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'LAURA','GIACOMELLI',2, convert (datetime, '01/01/1979',103),43,9,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'MARÍA LUZ','MORALES CARRASCO ',2, convert (datetime, '01/01/1964',103),20,8,'Ingreso a laborar en abril de 1996 y se regularizo su contratación el 15 de abril de 1996. / Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,3,'DIONICIO','REPOMANTA ',1, convert (datetime, '01/01/1965',103),65,4,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,3,'MARINO JESÚS','RETAMOZO ALATA ',1, convert (datetime, '01/01/1970',103),20,9,'C-MILAN20160889: Por disposición del Tribunal de Monza, se ordena el embargo-a través de tercero-de un quinto de la retribución neta mensual del señor Marino Jesús Retamozo Alata.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'CARMEN CELIA','RODRÍGUEZ DÍAZ ',2, convert (datetime, '01/01/1965',103),20,8,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'GIUSEPPE MARCO','SARANITI TURCHETTO',1, convert (datetime, '01/01/1970',103),43,6,'Montos remunerativos conforme al documento adjunto al mensaje C-MILAN20151961.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (127,1,'ANA CECILIA','LARA VEGA DE VALLADARES ',2, convert (datetime, '01/01/1961',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (127,1,'CHRISTIAN HERNÁN','SOTO CASTRO',1, convert (datetime, '01/01/1981',103),20,4,'05/10/2017- El detalle de la Remuneración neta y costo total, se actualizarán cuando la Misión envie el cuadro detalle solicitado.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (127,1,'JOSÉ MERCEDES ','TORRES ROJAS ',1, convert (datetime, '01/01/1961',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (127,1,'WALTER MOISÉS','VALLADARES CHÁVEZ',1, convert (datetime, '01/01/1984',103),20,4,'05/10/2017- El detalle de la Remuneración neta y costo total, se actualizarán cuando la Misión envie el cuadro detalle solicitado.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (111,1,'KEVIN','NICK PRADA',1, convert (datetime, '01/01/1996',103),43,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'FRANCKLIN GROVER ','ÁVILA SÁNCHEZ ',1, convert (datetime, '01/01/1967',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'JULIUS','CANTERO CAMAYA',1, convert (datetime, '01/01/1978',103),65,8,'RENUNCIO A SU PUESTO PRIMIGENIO HASTA EL 10 DE OTUBRE DE 2017, Y LUEGO INGRESO A LABORAR EL 1  DE SETIEMBRE DE 2017', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'PEGGI ANGELA','FUJIMOTO SHIMOHIRA ',2, convert (datetime, '01/01/1966',103),20,6,'*Plaza dejada por Jngela Vhi Tacht. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'KAORI ','KUSABE (HAGA)',2, convert (datetime, '01/01/1975',103),35,11,'*Plaza dejada por Jngela Vag Tacht. ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'GERARD EDWARD','MIYASHIRO SOTELO',1, convert (datetime, '01/01/1985',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'KAORI ','SHINO(ONOSE)',2, convert (datetime, '01/01/1985',103),35,9,'Reemplazo de la señorita Minami. Mediante el mensaje C-TOKIO20161101, la Misión comunicó del cambio de la apellido de la empleada Kaori Onose, quien en adelante será Kaori Onose.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'MIDORI','OSHIRO',2, convert (datetime, '01/01/1988',103),35,9,'Reemplazó a la señora Kobayashi.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'GLORIA ISABEL ','SASAKI YONEMURA',2, convert (datetime, '01/01/1958',103),20,6,'*Plaza dejada por Yvette Hermoza de Oldenburg ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'TATIANA','SHIMAMURA ',2, convert (datetime, '01/01/1964',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (125,1,'PABLO','BLANCO SANABRIA',1, convert (datetime, '01/01/1978',103),6,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (100,1,'MARÍA MÓNICA','OSTOLAZA AGUIRRE',2, convert (datetime, '01/01/1959',103),20,6,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (100,3,'MARY ANGELICA ','JERÍ LEIGH OEKYIKER',2, convert (datetime, '01/01/1960',103),20,9,'Solo ayuda en rendición de cuenta dos días. Por cada trimestre. Se brindan autorizaciones por cada trimestre.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (100,1,'GERARD FERNANDO MAURICE ','FRIEDLI ACEVEDO',1, convert (datetime, '01/01/1982',103),20,8,'Ingresa en reemplazo de la   señora María Medrano Nimis.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (128,1,'VIVIANY ','CARVALHO SCHAFFNER',2, convert (datetime, '01/01/1981',103),15,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (128,1,'ROSARIO YOLANDA','CARRASCO POLANCO',2, convert (datetime, '01/01/1961',103),20,4,'ingresa en reemplazo de la señora Savasta', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (60,1,'FIORELLA ELISABETTA','JAUREGUI RONCAGLIOLO',2, convert (datetime, '01/01/1974',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (60,1,'GIANINA TULA','FERNÁNDEZ-DÁVILA RIVERO',2, convert (datetime, '01/01/1964',103),20,8,'Plaza dejada por el Sr. Miguel Ricardo Paniagua Gonzáles; Reajuste Salarial-2014', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (110,1,'FABIOLA','GARCIA MEZA LOPEZ',1, convert (datetime, '01/01/1971',103),10,3,'Contratada a tiempo parcial', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (110,1,'JUNIOR DANIEL','QUINTANA MALPARTIDA',1, convert (datetime, '01/01/1985',103),20,7,' documento adjunto al mensaje ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (110,1,'SERGIO','ROJAS AMAYA',1, convert (datetime, '01/01/1985',103),10,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (110,1,'NORMA ALICIA ','SANDOVAL PADILLA',2, convert (datetime, '01/01/1981',103),10,9,'Se contrato temporalmente a la señora Vanesa Macedo, a efectos de reemplazarla durante su licencia  por maternidad pre natal, mayo de 2016(con una remuneración de 7,000.00 ', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (115,1,'JAVIER EDUARDO','VARGAS AREVALO',1, convert (datetime, '01/01/1977',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (115,1,'PAOLA JAZMIN','FERNANDEZ CALDERON',1, convert (datetime, '01/01/1982',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (115,1,'SUSANA ARACELI','ORDDOÑEZ MENDOZA',2, convert (datetime, '01/01/1977',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (115,1,'LUIS FRANKLIN','SUAREZ QUIROZ',1, convert (datetime, '01/01/1981',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (88,1,'DORIS MIRIAM','MANTILLA DE RIVAS',2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (88,1,'GIOVANNA','SIANCAS ARCE',2, convert (datetime, '01/01/1973',103),20,7,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (88,1,'HANNALORE HEIDI','SCHAFFER NETTO',2, convert (datetime, '01/01/1984',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (88,1,'JUAN CARLOS ','SANCHEZ CHAVEZ',1, convert (datetime, '01/01/1973',103),20,8,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'CÉSAR ALEJANDRO','ARAGORT CRESPO',1, convert (datetime, '01/01/1976',103),22,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'SONIA MILENA','ARCINIEGAS HERNÁNDEZ ',2, convert (datetime, '01/01/1973',103),22,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'ANTONIA','FRANCISCO DE SICCHA',2, convert (datetime, '01/01/1998',103),20,2,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'YENI NATIVIDAD','GUDIEL TORRES DE VASQUEZ',2, convert (datetime, '01/01/1968',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'MARÍA REBECA','MARQUINA DE DOMADOR',2, convert (datetime, '01/01/1962',103),20,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'ROSA MELIÁ','ORTIZ GONZALES',2, convert (datetime, '01/01/1961',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'JOSÉ FRANCISCO','QUERALES DÍAZ',1, convert (datetime, '01/01/1989',103),22,9,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'LUZ AMELIA','RUIZ ANICAMA',2, convert (datetime, '01/01/1968',103),20,4,'', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'YASMÍN DANIELA','PAULICELLI ROJAS',2, convert (datetime, '01/01/1984',103),22,9,'A partir del 1 de julio tiene contrato laboral y su remuneración sera de 250 dolares', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'AÍDA BERTHA','SÁNCHEZ MARTÍNEZ',2, convert (datetime, '01/01/1958',103),20,4,'Montos remunerativos conforme a lo indicado en mensaje C-CARACAS20151350.', 3, 9 , 1, '::1')
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (OSER_sORGANOSERVICIO_ID, OSER_sSITUACIONLABORAL, OSER_vNOMBRES,  OSER_vAPELLIDOS, OSER_sGENERO, OSER_dFECHANACIMIENTO, OSER_sNACIONALIDAD, OSER_sGRADOPROFESIONAL, OSER_vOBSERVACION,  OSER_sTIPOPERSONAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION) Values (87,1,'CRISTY KELLY','ALVARDO TENA',2, convert (datetime, '01/01/1989',103),20,8,'', 3, 9 , 1, '::1')








-- SELECT * FROM SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO 
Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO 
(OSPC_sOSPE_PERSONAL_ID, OSPC_sORGANO_SERVICIO_ID, OSPC_vNUMEROCONTRATO, OSPC_bINDEFINIDO, OSPC_sCARGO, OSPC_sMONEDA, OSPC_dREMUNERACION_BRUTA, OSPC_dFECHAINIFUNCION, OSPC_DOCUMENTOAUTOR, OSPC_DOCUMENTOAUTFECHA, OSPC_sTIPOCONTRATO, OSPC_sSITUACION, OSPC_sUSUARIO_CREACION, OSPC_vIP_CREACION)
Values (1, 82, '1', 1, 2, 8, 806.80, '01/09/2013', 'OGA20170156', '01/01/2017', 1, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 1, 'BONO POR PRESENTISMO', 1, 0, 1, 14, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 2, 'SEGURIDAD SOCIAL', 0, 1, 1, 3, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 2, 'OBRA SOCIAL', 0, 1, 1, 3, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 3, 'SEGURO SOCIAL', 1, 0, 1, 28, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 3, 'OBRA SOCIAL', 1, 0, 1, 0.5, 9, 1, '::1')

Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_PLANILLA(OSPL_sOSPC_CONTRATO_ID, OSPL_sOSPE_PERSONAL_ID, OSPL_sORGANO_SERVICIO_ID, OSPL_sTIPOCONCEPTO, OSPL_vCONCEPTO, 
			OSPL_bINCREMENTAL, OSPL_bAFECTOAPORTES, OSPL_bTIPOAFECTACIONPERCET, OSPL_dMONTOAFECTACION, OSPL_sSITUACION, OSPL_sUSUARIO_CREACION, OSPL_vIP_CREACION)
Values ( 1, 1, 82, 3, 'LEY DE RIESGO DE TRABAJO', 1, 0, 1, 0.3, 9, 1, '::1')





*/

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	DATA INICIAL. CLASIFICADOR DE GASTO
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
/*
Insert Into SC_COMUN.SE_CLASIFICADORGASTO (CLAS_vNOMBRE, CLAS_dDESDE, CLAS_dHASTA, CLAS_sUSUARIO_CREACION, CLAS_vIP_CREACION) 
	Values ('CLASIFICADOR 2018', Convert(datetime,'01/01/2018', 103), Convert(datetime, '31/12/2018', 103), 1, '::1')
Go

-- SELECT * FROM SC_COMUN.SE_CLASIFICADORITEM 
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES Y SERVICIOS', 'BB.SS.', 'I.', null, 1, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ALQUILER DE INMUEBLES', 'ALQ.INMUEBLES', '1.', 1, 2, 0, 1, 1, '::1' )
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OFICINA', 'OFICINA', '1.1', 2, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'RESIDENCIA', 'RESIDENCIA', '1.2', 2, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'LEASING', 'LEASING', '1.3', 2, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTROS ARRENDAMIENTOS (CONDOMINIO)', 'OT.ARREND.(COND.)', '1.4', 2, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'REMUNERACIONES Y BENEFICIOS SOCIALES', 'REM.BENEF.SOC.', '2.', 1, 2, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'CONTRATADOS LOCALMENTE', 'CONT.LOCALMENTE', '2.1', 7, 3, 0, 1, 1, '::1' )
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'PERSONAL ADMINISTRATIVO', 'PERSONAL.ADMIN.', '2.1.1', 8, 4, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'PERSONAL DE SERVICIO', 'PERSONAL.SERV.', '2.1.2', 8, 4, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'PERSONAL DE SERVICIO LOCAL', 'PERS.SERV.LOCAL', '2.1.2.1', 10, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'PERSONAL DE SERVICIO LIMA','PERS.SERV.LIMA', '2.1.2.2', 10, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BENEFICIOS SOCIALES', 'BENEF.SOCIALES', '2.1.3', 8, 4, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BENEFICIOS SOCIALES PERSONAL LOCAL', 'BEN.SOC.PER.LOC.', '2.1.3.1', 13, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BENEFICIOS SOCIALES PERSONAL LIMA', 'BEN.SOC.PER.LIM.', '2.1.3.2', 13, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTRAS OBLIGACIONES', 'OTRAS OBLIG.', '2.1.4', 8, 4, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTRAS OBLIGACIONES SEGUN LEY LOCAL', 'OT.OBL.S.LEY LOC.', '2.1.4.1', 16, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTRAS OBLIGACIONES SEGUN LEY LIMA', 'OT.OBL.S.LEY LIM.', '2.1.4.2', 16, 5, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'SERVICIOS PÚBLICOS', 'SERVICIOS PÚBLIC.', '3.', 1, 2, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'LUZ ELÉCTRICA', 'LUZ ELÉCTRICA', '3.1', 19, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'TELÉFONO Y FAX', 'TELÉFONO Y FAX', '3.2', 19, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'AGUA Y DESAGÜE', 'AGUA Y DESAGÜE', '3.3', 19, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'CORRESPONDENCIA, VALIJA, COURRIER', 'CORRES.VAL.COURR.', '3.4', 19, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTROS SERV. PUB.(GAS RED DOMIC., CALEFACCIÓN, INTERNET, TVCABLE)', 'OTROS SERV. PUB.', '3.5', 19, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ARBITRIOS', 'ARBITRIOS', '4.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'SEGUROS', 'SEGUROS', '5.', 1, 2, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'SEGUROS PERSONALES', 'SEGUROS PERS.', '5.1', 26, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'SEGUROS NO PERSONALES', 'SEGUROS NO PERS.', '5.2', 26, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES DE CONSUMO', 'BIENES DE CONSUMO', '6.', 1, 2, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'MATERIALES DE ESCRITORIO Y SOPORTE INFORMÁTICO', 'M.ESCRIT.SOP.INF.', '6.1', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'MATERIALES ELÉCTRICOS, SANITARIOS, ASEO Y LIMPIEZA', 'M.ELÉCT.SAN.AS.L.', '6.2', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'RACIONAMIENTO', 'RACIONAMIENTO', '6.3', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'COMBUSTIBLES Y LUBRICANTES', 'COMBUSTIBLE.LUBR.', '6.4', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'IMPRESOS Y SUSCRIPCIONES', 'IMPRESOS Y SUSCR.', '6.5', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'VESTUARIO', 'VESTUARIO', '6.6', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ENSERES Y ARTÍCULOS DECORATIVOS', 'ENSERES.ART.DEC.', '6.7', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'REPUESTOS Y ACCESORIOS', 'REPUESTOS Y ACC.', '6.8', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTROS BIENES DE CONSUMO', 'OTR. BIENES CONS.', '6.9', 29, 3, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES DE DISTRIBUCIÓN GRATUITA', 'BIENES DIST.GRAT.', '7.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ALOJAMIENTO TEMPORAL', 'ALOJAMIENTO TEMP.', '8.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'VIAJES OFICIALES', 'VIAJES OFICIALES', '9.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'TRANSPORTE Y ALMACENAJE', 'TRANSPORTE Y ALM.', '10.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'CONFERENCIAS Y EXPOSICIONES', 'CONFERENCIAS EXP.', '11.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'IMPRESIONES, ENCUADERNACIÓN Y PUBLICIDAD', 'IMPRE.ENCUAD.PUB.', '12.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ALQUILER DE MUEBLES, EQUIPOS Y LOCALES', 'ALQ.MUEB.EQU.LOC.', '13.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'CONSULTORÍAS', 'CONSULTORÍAS', '14.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'PRESTACIÓN DE SERVICIOS (PERSONAS NATURALES Y JURÍDICAS)', 'PREST.SRV.(PN.PJ)', '15.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'INSTALACIÓN, REMODELACIÓN Y ACONDICIONAMIENTO', 'INSTAL.REM.ACOND.', '16.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'MANTENIMIENTO Y REPARACIÓN', 'MANTEN.REPARACIÓN', '17.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'MANTENIMIENTO MENOR 5% - INMUEBLES PROPIOS', 'MANT.MENOR I.P.', '18.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'ATENCIONES OFICIALES', 'ATENCIONES OFIC.', '19.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'SOBREGIRO Y COMISIONES BANCARIAS', 'SOBREG.COM.BANC.', '20.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'OTROS SERVICIOS', 'OTROS SERVICIOS', '21.', 1, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES DE CAPITAL (EQUIPAMIENTO Y BIENES DURADEROS)', 'BS.CAP.(EQUIP.BD)', 'II.', null, 1, 0, 1, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES INMUEBLES', 'BIENES INMUEBLES', '22.', 54, 2, 1, 0, 1, '::1')
Insert Into SC_COMUN.SE_CLASIFICADORITEM (CLIT_sCLASIFICADORGASTO_ID, CLIT_NOMBRE, CLIT_ABREVIATURA, CLIT_CODIGOCLASE, CLIT_ITEMSUPERIOR, CLIT_ITEMNIVEL, CLIT_ITEMTIPO, CLIT_ISGRUPO, CLIT_sUSUARIO_CREACION, CLIT_vIP_CREACION) Values (1, 'BIENES MUEBLES', 'BIENES MUEBLES', '24.', 54, 2, 1, 0, 1, '::1')

Insert Into SC_COMUN.SE_PROGRAMAGASTO (PGAS_vNOMBRE, PGAS_dDESDE, PGAS_dHASTA, PGAS_sUSUARIO_CREACION, PGAS_vIP_CREACION) Values ('PROGRAMAS DE GASTO 2018', Convert(datetime, '01/01/2018', 103), Convert(Datetime, '31/12/2018', 103), 1, '::1')

Insert Into SC_COMUN.SE_PROGRAMAITEM (PROG_vNOMBRE, PROG_vABREVIATURALG, PROG_vABREVIATURASM,  PROG_sUSUARIO_CREACION, PROG_vIP_CREACION) Values ('GASTOS DE FUNCIONAMIENTO','GASTOS DE FUNC. GEST.', 'G.F.', 1, '::1');
Insert Into SC_COMUN.SE_PROGRAMAITEM (PROG_vNOMBRE, PROG_vABREVIATURALG, PROG_vABREVIATURASM, PROG_sUSUARIO_CREACION, PROG_vIP_CREACION) Values ('PROGRAMA DE ASISTENCIA LEGAL HUMANITARIA Y SERVICIOS CONSULARES','PRG.AS.LEG.HUM.-SS.CC.', 'PRG.ALH.SC.', 1, '::1');

Insert Into SC_COMUN.SE_PROGRAMAOSE (PROS_sPROGRAMA_ID, PROS_sTIPOORGANOSERVICIO, PROS_sPROGRAMAITEM, PROS_sUSUARIO_CREACION, PROS_vIP_CREACION) Values (1, 1, 1, 1, '::1')
Insert Into SC_COMUN.SE_PROGRAMAOSE (PROS_sPROGRAMA_ID, PROS_sTIPOORGANOSERVICIO, PROS_sPROGRAMAITEM, PROS_sUSUARIO_CREACION, PROS_vIP_CREACION) Values (1, 2, 1, 1, '::1')
Insert Into SC_COMUN.SE_PROGRAMAOSE (PROS_sPROGRAMA_ID, PROS_sTIPOORGANOSERVICIO, PROS_sPROGRAMAITEM, PROS_sUSUARIO_CREACION, PROS_vIP_CREACION) Values (1, 2, 2, 1, '::1')


-- Actualizacion de estado en cuentas corrientes
Update	SC_COMUN.SE_CUENTACORRIENTE
Set		CUEN_tSITUACION = 9,
		CUEN_sUSUARIO_MODIFICACION = 1,
		CUEN_dFECHA_MODIFICACION = GETDATE(),
		CUEN_vIP_MODIFICACION = '::1'

*/