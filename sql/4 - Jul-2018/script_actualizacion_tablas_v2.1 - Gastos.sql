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
	GAST_sIDCHECKE				Smallint null,
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