use BD_SGSE
go


If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIO_PERFIL_USUARIO' And type = 'F')
	Alter Table SC_COMUN.SE_USUARIO_PERFIL Drop Constraint FK_USUARIO_PERFIL_USUARIO
Go

If Exists(Select * From sys.foreign_keys Where name = N'FK_REGION_CONTINENTE' And type = 'F')
	Alter Table SC_COMUN.SE_REGION Drop Constraint FK_REGION_CONTINENTE
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PAIS_REGION' And type = 'F')
	Alter Table SC_COMUN.SE_PAIS Drop Constraint FK_PAIS_REGION 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PAIS_MONEDA_PAIS' And type = 'F')
	Alter Table SC_COMUN.SE_PAIS_MONEDA	Drop Constraint FK_PAIS_MONEDA_PAIS 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PAIS_MONEDA_MONEDA' And type = 'F')
	Alter Table SC_COMUN.SE_PAIS_MONEDA	Drop Constraint FK_PAIS_MONEDA_MONEDA
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIO_PERFIL_USUARIO' And type = 'F')
	Alter Table SC_COMUN.SE_USUARIO_PERFIL Drop Constraint FK_USUARIO_PERFIL_USUARIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIO_PERFIL_PERFIL' And type = 'F')
	Alter Table SC_COMUN.SE_USUARIO_PERFIL	Drop Constraint FK_USUARIO_PERFIL_PERFIL
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIO_MOVIMIENTO_USUARIO' And type = 'F')
	Alter Table SC_COMUN.SE_USUARIO_MOVIMIENTO Drop Constraint FK_USUARIO_MOVIMIENTO_USUARIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_USUARIO_MOVIMIENTO_UNIDADORGANICA' And type = 'F')
	Alter Table SC_COMUN.SE_USUARIO_MOVIMIENTO Drop Constraint FK_USUARIO_MOVIMIENTO_UNIDADORGANICA
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ENTIDADPUBLICA_CTACTE_ENTIDAD_ID' And type = 'F')
	Alter Table SC_COMUN.SE_ENTIDADPUBLICA_CTACTE Drop Constraint FK_ENTIDADPUBLICA_CTACTE_ENTIDAD_ID
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ENTIDADPUBLICA_CTAS_MONEDA' And type = 'F')
	Alter Table SC_COMUN.SE_ENTIDADPUBLICA_CTACTE Drop Constraint FK_ENTIDADPUBLICA_CTAS_MONEDA
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_PAIS' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO Drop Constraint FK_ORGANOSERVICIO_PAIS
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_BANCO_AGENCIA_BANCO' And type = 'F')
	Alter Table SC_COMUN.SE_BANCO_AGENCIA Drop Constraint FK_BANCO_AGENCIA_BANCO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_BANCO_AGENCIA_PAIS' And type = 'F')
	Alter Table SC_COMUN.SE_BANCO_AGENCIA Drop Constraint FK_BANCO_AGENCIA_PAIS
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_CUENTACORRIENTE_MONEDA' And type = 'F')
	Alter Table SC_COMUN.SE_CUENTACORRIENTE Drop Constraint FK_CUENTACORRIENTE_MONEDA
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_CUENTACORRIENTE_BANCO' And type = 'F')
	Alter Table SC_COMUN.SE_CUENTACORRIENTE Drop Constraint FK_CUENTACORRIENTE_BANCO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_CTACTE_ORGANOSERVICIO' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_CTACTE Drop Constraint FK_ORGANOSERVICIO_CTACTE_ORGANOSERVICIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_CTACTE_CUENTACORRIENTE' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_CTACTE Drop Constraint FK_ORGANOSERVICIO_CTACTE_CUENTACORRIENTE
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL	drop Constraint FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PERFIL_MENU_PERFIL' And type = 'F')
	Alter Table SC_COMUN.SE_PERFIL_MENUITEM Drop Constraint FK_PERFIL_MENU_PERFIL 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PERFIL_MENU_MENUITEM' And type = 'F')
	Alter Table SC_COMUN.SE_PERFIL_MENUITEM Drop Constraint FK_PERFIL_MENU_MENUITEM 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PARAMETRO_PARAMETRO_GRUPO' And type = 'F')
	Alter Table SC_COMUN.SE_PARAMETRO Drop Constraint FK_PARAMETRO_PARAMETRO_GRUPO
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_PARAMETRO_ITEM_PARAMETRO' And type = 'F')
	Alter Table SC_COMUN.SE_PARAMETRO_ITEM Drop Constraint FK_PARAMETRO_ITEM_PARAMETRO 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL	Drop Constraint FK_ORGANOSERVICIO_PERSONAL_ORGANOSERVICIO 
go

If Exists(Select * From sys.foreign_keys Where name = N'FK_OSPC_OSPE' And type = 'F')
	Alter Table SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO Drop Constraint FK_OSPC_OSPE
Go