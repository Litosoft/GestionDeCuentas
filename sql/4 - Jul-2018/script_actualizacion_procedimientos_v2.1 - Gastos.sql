-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE REGISTROS DE GASTOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


if (object_id(N'SC_COMUN.USP_GASTO_GETMAXREGISTRO') is not null)
	drop procedure SC_COMUN.USP_GASTO_GETMAXREGISTRO
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve el número máximo de registro del formato de egreso para un órgano de servicio exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_GASTO_GETMAXREGISTRO 84

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_GASTO_GETMAXREGISTRO (@p_sid Smallint)
As
Begin
	Select	'i_max' = Isnull(max(GAST_iNUMREGISTRO),0) 
	From	SC_COMUN.SE_GASTO
	Where	GAST_sOSE_ID = @p_sid 
End
Go


if (object_id(N'SC_COMUN.USP_GASTO_GETPERSONAL') is not null)
	drop procedure SC_COMUN.USP_GASTO_GETPERSONAL
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve el número máximo de registro del formato de egreso para un órgano de servicio exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_GASTO_GETPERSONAL 42

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_GASTO_GETPERSONAL (@p_sid Smallint)
As
Begin
	Select	'sid' = OSER_sORGSER_PERSONAL_ID, 
			'nom' = concat(OSER_vAPELLIDOS, ', ', OSER_vNOMBRES) 
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL 
	Where	
			OSER_sORGANOSERVICIO_ID = @p_sid and
			OSER_cESTADO = 'A' 
			/*and OSER_sSITUACION = 1 and
			OSER_sSITUACIONLABORAL = 1*/
	Order by
			OSER_vAPELLIDOS
End
Go
