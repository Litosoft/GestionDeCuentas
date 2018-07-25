-- Redefinicion de tabla Personal Local

if (object_id(N'SC_COMUN.TEMPO_PERSONAL') is not null)
	drop table SC_COMUN.TEMPO_PERSONAL
go

Select * Into SC_COMUN.TEMPO_PERSONAL From [SC_COMUN].[SE_ORGANOSERVICIO_PERSONAL] 
Go

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
	OSER_tLUGAR					Tinyint null,		-- Lugar (Cancilleria, Sección Consular, Residencia)
	OSER_sNACIONALIDAD			Smallint null,		-- Fk Paises
	OSER_sESTADOCIVIL			Smallint null,		-- Fk Parametros (Soltero, Casado, ..)
	OSER_vEMAIL					Varchar(60) null,		
	OSER_sGENERO				Smallint null,		-- Fk Parametros (Hombre, Mujer, ..)
	OSER_bINDDISCAPACIDAD		Bit null default 0,	-- 0 : No, 1: Si
	OSER_sGRADOPROFESIONAL		Smallint null,		-- Fk Grado profesional
	OSER_sESPECIALIDAD			Smallint null,		-- Fk Especialidad
	OSER_vOBSERVACION			Varchar(max) null,
	OSER_dFECHAINIFUNCION		Datetime null,		-- Fecha de inicio de funciones
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

Insert	Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
Select	OSER_sORGANOSERVICIO_ID, OSER_vAPELLIDOS, OSER_vNOMBRES, OSER_sTIPODOCUMENTO, OSER_vNUMERODOCUMENTO, OSER_sTIPOPERSONAL, OSER_dFECHANACIMIENTO, null, OSER_sNACIONALIDAD, OSER_sESTADOCIVIL, OSER_vEMAIL, OSER_sGENERO, OSER_bINDDISCAPACIDAD, OSER_sGRADOPROFESIONAL, OSER_sESPECIALIDAD, OSER_vOBSERVACION, null, OSER_sSITUACIONLABORAL, OSER_sSITUACION, OSER_sUSUARIO_CREACION, OSER_vIP_CREACION, OSER_dFECHA_CREACION, OSER_sUSUARIO_MODIFICACION, OSER_vIP_MODIFICACION, OSER_dFECHA_MODIFICACION, OSER_cESTADO
From	SC_COMUN.TEMPO_PERSONAL
Go

-- : Fin de redefinicion de tabla







-- Actualización de Tablas
/*
	SC_COMUN.SE_OSE_PROVEEDOR

*/


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
	
	OSPR_vDENOMINACION			Varchar(160) not null,
	OSPR_tTIPOPROV				Tinyint null,		-- Tipo de Proveedor
	OSPR_tTIPODOC				Tinyint null,
	OSPR_vNUMERODOCUMENTO		Varchar(35) null,
	OSPR_vTELEFONO				Varchar(64) null,
	OSPR_vEMAIL					Varchar(64) null,
	OSPR_vDIRECCION				Varchar(128) null,
	OSPR_vOBSERVACION			Varchar(255) null,

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

/* Contratos de Personal Local */

If Exists(Select * From sys.foreign_keys Where name = N'FK_OSPC_OSPE' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO Drop Constraint FK_OSPC_OSPE 
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

if (object_id(N'SC_COMUN.SE_OSE_PERSONAL_CONTRATO') is not null)
	drop table SC_COMUN.SE_OSE_PERSONAL_CONTRATO
go

Create Table SC_COMUN.SE_OSE_PERSONAL_CONTRATO(
	OSPC_sOSP_CONTRATO_ID		Smallint Identity(1,1) not null,
	OSPC_sOSPE_PERSONAL_ID		Smallint not null,		-- Fk Personal
	OSPC_sORGANO_SERVICIO_ID	Smallint not null,		-- Fk Organo Servicio - (Desnormalizacion)
	
	OSPC_sTIPODOCUMENTO			Smallint not null,		-- Tipo de documento de contratación
	OSPC_sREFERENCIA			Smallint null,			-- Id del contrato de referencia (para el caso de adendas)
	OSPC_vNUMERODOCUMENTO		Varchar(25) not null,
	OSPC_dFECHAINICIO			Datetime null,
	OSPC_dFECHATERMINO			Datetime null,	
	OSPC_bINDEFINIDO			bit not null default 1,	-- Periodo contractual 1:Indefinido
	OSPC_sCARGO					Smallint not null,		-- Cargo a desempeñar
	OSPC_vFUNCIONES				Varchar(255) null,		-- Descripcion de funciones
	OSPC_sMONEDA				Smallint not null,
	OSPC_dREMUNERACION_BRUTA	Decimal(14,2) not null,
	OSPC_dFECHAINIFUNCION		Datetime null,			-- Desnormalizacion
	OSPC_vDOCUMENTOAUTOR		Varchar(25) not null,	
	OSPC_tTIPOCONTRATO			Tinyint not null,		-- Tipo de contrato
	OSPC_tMODALIDAD				Tinyint not null,		-- Modalidad (Determinado, Indeterminado, No registra)
	
	OSPC_vOBSERVACION			Varchar(max) null,
	OSPC_vNOMBREFILE			Varchar(255) null,		-- Nombre del documento digital

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

Alter Table SC_COMUN.SE_OSE_PERSONAL_CONTRATO
	Add Constraint PK_OSE_PERS_CONT Primary Key (OSPC_sOSP_CONTRATO_ID);
go

Create NonClustered Index IDN_ORGANO_SERVICIO_ID on SC_COMUN.SE_OSE_PERSONAL_CONTRATO(OSPC_sORGANO_SERVICIO_ID)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_sCARGO on SC_COMUN.SE_OSE_PERSONAL_CONTRATO(OSPC_sCARGO)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_PERSONAL_sMONEDA on SC_COMUN.SE_OSE_PERSONAL_CONTRATO(OSPC_sMONEDA)
go

Create NonClustered Index IDN_ORGA_PERS_CONT_PERSONAL_cESTADO on SC_COMUN.SE_OSE_PERSONAL_CONTRATO(OSPC_cESTADO)
go

Alter Table SC_COMUN.SE_OSE_PERSONAL_CONTRATO
	Add Constraint FK_OSPC_OSPE Foreign Key (OSPC_sOSPE_PERSONAL_ID) References SC_COMUN.SE_ORGANOSERVICIO_PERSONAL(OSER_sORGSER_PERSONAL_ID)
go

