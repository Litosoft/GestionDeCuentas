use BD_SGSE
go

If not exists (select  schema_name from information_schema.schemata where schema_name = 'SC_INTERNO')
	Exec sp_executesql N'Create Schema SC_INTERNO'
go


If Exists(Select * From sys.foreign_keys Where name = N'FK_PERMISO_MODULO' And type = 'F')
	Alter Table SC_INTERNO.AUTH_PERMISO Drop Constraint FK_PERMISO_MODULO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIOROL_USUARIO' And type = 'F')
	Alter Table SC_INTERNO.AUTH_USUARIO_ROL Drop Constraint FK_USUARIOROL_USUARIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIOROL_ROL' And type = 'F')
	Alter Table SC_INTERNO.AUTH_USUARIO_ROL Drop Constraint FK_USUARIOROL_ROL
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	ADICION TABLA PERMISOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Módulos
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_INTERNO.AUTH_MODULO') is not null)
	drop table SC_INTERNO.AUTH_MODULO
go

Create Table SC_INTERNO.AUTH_MODULO (
	MODU_sID					Smallint identity(1,1) not null,
	MODU_sPADRE_ID				Smallint not null default (0),
	
	MODU_vICONO					Varchar(40) null,
	MODU_vNOMBRE				Varchar(150) not null,
	MODU_vDESCRIPCION			Varchar(150) null,
	MODU_tORDEN					Tinyint	not null default (1),

	MODU_vCONTROLADOR			Varchar(80) null,
	MODU_vMETODO				Varchar(80) null,
	MODU_vPARAMETRO				Varchar(30) null,
	MODU_vURL					Varchar(150) null,

	MODU_bPOPUP					Bit not null default (0),
	MODU_bCLICK					Bit not null default (1),
	MODU_tSITUACION				Tinyint not null default (1),

	MODU_sUSUARIO_CREACION		Smallint	not null,
	MODU_vIP_CREACION			Varchar(15)	not null,
	MODU_dFECHA_CREACION		Datetime	not null default GetDate(),
	MODU_sUSUARIO_MODIFICACION	Smallint	null,
	MODU_vIP_MODIFICACION		Varchar(15)	null,
	MODU_dFECHA_MODIFICACION	Datetime	null,
	
	MODU_cESTADO				Char(1)		not null default 'A'
)
Go

Alter Table SC_INTERNO.AUTH_MODULO
	Add Constraint PK_MODULO Primary Key (MODU_sID);
go

Create NonClustered Index IDN_MODULO_sPADRE_ID on SC_INTERNO.AUTH_MODULO(MODU_sPADRE_ID)
go

Create NonClustered Index IDN_MODULO_tORDEN on SC_INTERNO.AUTH_MODULO(MODU_tORDEN)
go

Create NonClustered Index IDN_MODULO_cESTADO on SC_INTERNO.AUTH_MODULO(MODU_cESTADO)
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Permisos por Módulos
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
if (object_id(N'SC_INTERNO.AUTH_PERMISO') is not null)
	drop table SC_INTERNO.AUTH_PERMISO
go

Create Table SC_INTERNO.AUTH_PERMISO (
	PERM_sID					Smallint identity(1,1) not null,
	PERM_sMODULO_ID				Smallint not null default (0),
	
	PERM_tPERMISOID				Tinyint not null,
	PERM_vCONTROLADOR			Varchar(150) null,
	PERM_vMETODO				Varchar(150) null,
	
	PERM_sUSUARIO_CREACION		Smallint	not null,
	PERM_vIP_CREACION			Varchar(15)	not null,
	PERM_dFECHA_CREACION		Datetime	not null default GetDate(),
	PERM_sUSUARIO_MODIFICACION	Smallint	null,
	PERM_vIP_MODIFICACION		Varchar(15)	null,
	PERM_dFECHA_MODIFICACION	Datetime	null,
	
	PERM_cESTADO				Char(1)		not null default 'A'
)
Go

Alter Table SC_INTERNO.AUTH_PERMISO
	Add Constraint PK_PERMISO Primary Key (PERM_sID);
go

Alter Table SC_INTERNO.AUTH_PERMISO
	Add Constraint FK_PERMISO_MODULO Foreign Key (PERM_sMODULO_ID) References SC_INTERNO.AUTH_MODULO(MODU_sID)
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Roles
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
If (object_id(N'SC_INTERNO.AUTH_ROL') is not null)
	Drop Table SC_INTERNO.AUTH_ROL
go

CREATE TABLE SC_INTERNO.AUTH_ROL(
	ROL_sID						Smallint Identity(1,1) not null,
	ROL_vNOMBRE					Varchar(35) not null,
	ROL_vABREVIATURA			Varchar(10) null,
	ROL_vDESCRIPCION			Varchar(120) null,

	ROL_sUSUARIO_CREACION		Smallint	not null,
	ROL_vIP_CREACION			Varchar(15)	not null,
	ROL_dFECHA_CREACION			Datetime	not null default GetDate(),
	ROL_sUSUARIO_MODIFICACION	Smallint	null,
	ROL_vIP_MODIFICACION		Varchar(15)	null,
	ROL_dFECHA_MODIFICACION		Datetime	null,
	
	ROL_cESTADO					Char(1)		not null default 'A'
)
go

Alter Table SC_INTERNO.AUTH_ROL
	Add Constraint PK_ROL Primary Key (ROL_sID);
go

Create NonClustered Index IDN_ROL_cESTADO on SC_INTERNO.AUTH_ROL(ROL_cESTADO);
go


/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla de Usuarios
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
If (object_id(N'SC_INTERNO.AUTH_USUARIO') is not null)
	Drop Table SC_INTERNO.AUTH_USUARIO
go

Create Table SC_INTERNO.AUTH_USUARIO
( 
	USUA_sID					Smallint Identity(1,1)	not null, 
	USUA_vAPELLIDOS				Varchar(35)	null,
	USUA_vNOMBRES				Varchar(35)	null, 
	USUA_vEMAIL					Varchar(50)	not null,
	USUA_vTELEFONO				Varchar(12) null,

	USUA_vUSR					Varchar(12)	not null,
	USUA_vPWD					Varchar(44)	not null,

	USUA_dFEC_VIG_INI			DateTime	not null,
	USUA_dFEC_VIG_FIN			DateTime	not null,

	USUA_bISDOMINIO				Bit			not null default (0),
	USUA_bCAMBIO_PWD			Bit			not null default (0),
	USUA_tSITUACION				Tinyint		not null default (1),

	USUA_tROL					Tinyint		not null default 1,	-- Tipo de Rol (Autorizador, Registrador)

	USUA_sUSUARIO_CREACION		Smallint	not null,
	USUA_vIP_CREACION			Varchar(15)	not null,
	USUA_dFECHA_CREACION		Datetime	not null default GetDate(),
	USUA_sUSUARIO_MODIFICACION	Smallint	null,
	USUA_vIP_MODIFICACION		Varchar(15)	null,
	USUA_dFECHA_MODIFICACION	Datetime	null,
	USUA_cESTADO				Char(1)		not null default 'A'
)
go

Alter Table SC_INTERNO.AUTH_USUARIO
	Add Constraint PK_USUARIO Primary Key (USUA_sID);
go

Create NonClustered Index IDN_USUA_vUSR on SC_INTERNO.AUTH_USUARIO(USUA_vUSR);
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Tabla detalle Usuarios-Perfiles
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Observacion	: 
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
*/
If (object_id(N'SC_INTERNO.AUTH_USUARIO_ROL') is not null)
	Drop Table SC_INTERNO.AUTH_USUARIO_ROL
go

Create Table SC_INTERNO.AUTH_USUARIO_ROL
( 
	USRO_sUSUARIO_ID			Smallint not null,
	USRO_sROL_ID				Smallint not null,

	USRO_sUSUARIO_CREACION		Smallint	not null,
	USRO_vIP_CREACION			Varchar(15)	not null,
	USRO_dFECHA_CREACION		Datetime	not null default GetDate(),
	USRO_sUSUARIO_MODIFICACION	Smallint	null,
	USRO_vIP_MODIFICACION		Varchar(15)	null,
	USRO_dFECHA_MODIFICACION	Datetime	null,

	USRO_cESTADO				Char(1)		not null default 'A'
)
go

Alter Table SC_INTERNO.AUTH_USUARIO_ROL
	Add Constraint PK_USUARIOROL_ID Primary Key (USRO_sUSUARIO_ID, USRO_sROL_ID);
go

Create NonClustered Index IDN_USRO_cESTADO on SC_INTERNO.AUTH_USUARIO_ROL(USRO_cESTADO);
go

Alter Table SC_INTERNO.AUTH_USUARIO_ROL
	Add Constraint FK_USUARIOROL_USUARIO Foreign Key (USRO_sUSUARIO_ID) References SC_INTERNO.AUTH_USUARIO(USUA_sID)
go

Alter Table SC_INTERNO.AUTH_USUARIO_ROL
	Add Constraint FK_USUARIOROL_ROL Foreign Key (USRO_sROL_ID) References SC_INTERNO.AUTH_ROL(ROL_sID)
go
