-- Actualización de Procedimientos
/*
	SC_COMUN.USP_PROVEEDOR_LISTAR
	SC_COMUN.USP_PROVEEDOR_LISTAR_byID
	SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE
	SC_COMUN.USP_PROVEEDOR_INSERTAR_byOSE
	SC_COMUN.USP_PROVEEDOR_UPDATE_byOSE

*/

-- Parametros: Inicio


if (object_id(N'SC_COMUN.USP_PARAMETROITEM_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETROITEM_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de parámetros
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETROITEM_LISTAR 18, 0

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETROITEM_LISTAR (@p_idp int, @p_idd int)
as
begin
	
	if (@p_idd = 0)
		begin
			Select	'i_row' = row_number() over (order by PAIT_sPARAMETROITEM_ID),
					'i_idd' = p.PAIT_sPARAMETROITEM_ID, 
					'i_idp' = p.PAIT_sPARAMETRO_ID, 
					's_tex' = p.PAIT_vTEXTO, 
					's_val' = p.PAIT_vVALOR, 
					's_ayu' = p.PAIT_vAYUDA, 
					'i_ord' = p.PAIT_iORDEN, 
					'i_gru' = p.PAIT_bISGRUPO, 
					's_gru' = Case when (p.PAIT_bISGRUPO = 1) then 'SI' else 'NO' end
			From	
					SC_COMUN.SE_PARAMETRO_ITEM p
			Where
					p.PAIT_sPARAMETRO_ID = @p_idp and
					p.PAIT_cESTADO = 'A'
			Order by
					PAIT_vTEXTO
		end
	else
		begin
			Select	'i_idd' = p.PAIT_sPARAMETROITEM_ID, 
					'i_idp' = p.PAIT_sPARAMETRO_ID, 
					's_tex' = p.PAIT_vTEXTO, 
					's_val' = p.PAIT_vVALOR, 
					's_ayu' = p.PAIT_vAYUDA, 
					'i_ord' = p.PAIT_iORDEN, 
					'i_gru' = p.PAIT_bISGRUPO, 
					's_gru' = Case when (p.PAIT_bISGRUPO = 1) then 'SI' else 'NO' end
			From	
					SC_COMUN.SE_PARAMETRO_ITEM p
			Where
					p.PAIT_sPARAMETROITEM_ID = @p_idd and
					p.PAIT_cESTADO = 'A'
		end
end
go



-- Parametros: Fin



-- Personal Local: Inicio

if (object_id(N'SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_byID') is not null)
	drop procedure SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_byID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la informacion de una persona local en ose
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_byID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_byID (
	@p_sid		Smallint
)
As
Begin
	Select	'i_per_sid' = OSER_sORGSER_PERSONAL_ID, 
			'i_ose_sid' = OSER_sORGANOSERVICIO_ID,
			's_per_ape' = OSER_vAPELLIDOS, 
			's_per_nom' = OSER_vNOMBRES, 
			'i_tdc_sid' = OSER_sTIPODOCUMENTO, 
			's_tdc_num' = OSER_vNUMERODOCUMENTO, 
			's_tpe_sid' = OSER_sTIPOPERSONAL,
			's_per_fnc' = Convert(varchar(10), OSER_dFECHANACIMIENTO, 103), 
			's_lug_sid' = OSER_tLUGAR,
			's_per_nac' = OSER_sNACIONALIDAD, 
			's_per_civ' = OSER_sESTADOCIVIL, 
			's_per_mai' = OSER_vEMAIL,
			'i_gen_sid' = OSER_sGENERO, 
			'i_dis_sid' = OSER_bINDDISCAPACIDAD, 
			'i_gra_sid' = OSER_sGRADOPROFESIONAL, 
			'i_esp_sid' = OSER_sESPECIALIDAD, 
			's_per_obs' = OSER_vOBSERVACION, 
			's_per_ini' = Convert(Varchar(10), OSER_dFECHAINIFUNCION, 103),
			's_lab_sid' = OSER_sSITUACIONLABORAL, 
			's_reg_sid' = OSER_sSITUACION, 

			'i_usr' = isnull(op.OSER_sUSUARIO_CREACION, OSER_sUSUARIO_MODIFICACION),
			's_usr' = Concat(us.USUA_vAPELLIDOS, ', ',  USUA_vNOMBRES),
			's_fcr' = Convert(varchar(10), isnull(OSER_dFECHA_CREACION, OSER_dFECHA_MODIFICACION), 103) 
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
			Inner Join SC_COMUN.SE_USUARIO us on (us.USUA_sUSUARIO_ID = Isnull(op.OSER_sUSUARIO_MODIFICACION, op.OSER_sUSUARIO_CREACION))
	Where	
			op.OSER_sORGSER_PERSONAL_ID = @p_sid and
			op.OSER_cESTADO = 'A'
End
go

Select * From SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
-- Personal Local: Fin


if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR_BYPERSONAL') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR_BYPERSONAL
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas al organo de servicio del personal local
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del Personal Local

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR_BYPERSONAL 44

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MONEDA_LISTAR_BYPERSONAL(
	@p_sid		int
)
As
Begin
	Declare @const_situacion_laboral_activa int = 1;

	Select	'i_sid' = mn.MONE_sMONEDA_ID,
			's_nom' = concat(mn.MONE_vNOMBRE, ' (', mn.MONE_cISO4217, ')')
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL p 
			Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = p.OSER_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PAIS_MONEDA pm on (pm.PAMO_sPAIS_ID = os.ORGA_sPAIS_ID and pm.PAMO_cESTADO = 'A')
			Inner Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = pm.PAMO_sMONEDA_ID and pm.PAMO_cESTADO = 'A')
	Where	
			p.OSER_sORGSER_PERSONAL_ID = @p_sid and 
			p.OSER_sSITUACIONLABORAL = @const_situacion_laboral_activa and 
			OSER_cESTADO = 'A'
End
Go

---


if (object_id(N'SC_COMUN.USP_PROVEEDOR_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista total de proveedores
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_LISTAR
As
Begin
	
	Select	'i_prosid' = OSPR_sPROVEEDOR_ID,
			'i_osesid' = OSPR_sORGANOSERVICIO_ID,

			's_denomi' = OSPR_vDENOMINACION,
			'i_protip' = OSPR_tTIPOPROV,
			'i_prodoc' = OSPR_tTIPODOC,
			's_prondc' = OSPR_vNUMERODOCUMENTO,
			's_protel' = OSPR_vTELEFONO,
			's_promai' = OSPR_vEMAIL,
			's_prodir' = OSPR_vDIRECCION,
			's_proobs' = OSPR_vOBSERVACION,

			'i_prosit' = OSPR_sSITUACION,
	
			'i_proucr' = OSPR_sUSUARIO_CREACION,
			's_proicr' = OSPR_vIP_CREACION,
			's_profcr' = Convert(Varchar(10),OSPR_dFECHA_CREACION, 103),
			'i_proumd' = OSPR_sUSUARIO_MODIFICACION,
			's_proimd' = OSPR_vIP_MODIFICACION,
			's_profmd' = Convert(Varchar(10),OSPR_dFECHA_MODIFICACION,103),
			'i_proest' = OSPR_cESTADO
	From	
			SC_COMUN.SE_OSE_PROVEEDOR
	Where	
			OSPR_cESTADO = 'A'
End
go


if (object_id(N'SC_COMUN.USP_PROVEEDOR_LISTAR_byID') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byID
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de proveedores para un órgano de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_LISTAR_byID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byID(@p_sid		int)
As
Begin
	
	Select	'i_prosid' = OSPR_sPROVEEDOR_ID,
			'i_osesid' = OSPR_sORGANOSERVICIO_ID,

			's_denomi' = OSPR_vDENOMINACION,
			'i_protip' = OSPR_tTIPOPROV,
			'i_prodoc' = OSPR_tTIPODOC,
			's_prondc' = OSPR_vNUMERODOCUMENTO,
			's_protel' = OSPR_vTELEFONO,
			's_promai' = OSPR_vEMAIL,
			's_prodir' = OSPR_vDIRECCION,
			's_proobs' = OSPR_vOBSERVACION,

			'i_prosit' = OSPR_sSITUACION,
	
			'i_proucr' = OSPR_sUSUARIO_CREACION,
			's_proicr' = OSPR_vIP_CREACION,
			's_profcr' = Convert(Varchar(10),OSPR_dFECHA_CREACION, 103),
			'i_proumd' = OSPR_sUSUARIO_MODIFICACION,
			's_proimd' = OSPR_vIP_MODIFICACION,
			's_profmd' = Convert(Varchar(10),OSPR_dFECHA_MODIFICACION,103),
			'i_proest' = OSPR_cESTADO
	From	
			SC_COMUN.SE_OSE_PROVEEDOR
	Where	
			OSPR_sPROVEEDOR_ID = @p_sid and
			OSPR_cESTADO = 'A'
End
go

if (object_id(N'SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de proveedores para un órgano de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE(@p_sid		int)
As
Begin
	
	Select	'i_prosid' = OSPR_sPROVEEDOR_ID,
			'i_osesid' = OSPR_sORGANOSERVICIO_ID,

			's_denomi' = OSPR_vDENOMINACION,
			'i_protip' = OSPR_tTIPOPROV,
			'i_prodoc' = OSPR_tTIPODOC,
			's_prondc' = OSPR_vNUMERODOCUMENTO,
			's_protel' = OSPR_vTELEFONO,
			's_promai' = OSPR_vEMAIL,
			's_prodir' = OSPR_vDIRECCION,
			's_proobs' = OSPR_vOBSERVACION,

			'i_prosit' = OSPR_sSITUACION,
	
			'i_proucr' = OSPR_sUSUARIO_CREACION,
			's_proicr' = OSPR_vIP_CREACION,
			's_profcr' = Convert(Varchar(10),OSPR_dFECHA_CREACION, 103),
			'i_proumd' = OSPR_sUSUARIO_MODIFICACION,
			's_proimd' = OSPR_vIP_MODIFICACION,
			's_profmd' = Convert(Varchar(10),OSPR_dFECHA_MODIFICACION,103),
			'i_proest' = OSPR_cESTADO
	From	
			SC_COMUN.SE_OSE_PROVEEDOR
	Where	
			OSPR_sORGANOSERVICIO_ID = @p_sid and
			OSPR_cESTADO = 'A'
End
go



if (object_id(N'SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE_toDT') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE_toDT
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de proveedores para un órgano de servicio para el control DataTable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE_toDT 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE_toDT(
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_page_flt		int,
	@p_rows_totl	int output	
)As
Begin
	If (@p_page_flt = 0)
		begin
			Select 1
		end
	Else
		Begin
			Select	'i_prosid' = OSPR_sPROVEEDOR_ID,
					's_denomi' = OSPR_vDENOMINACION,
					'i_protip' = OSPR_tTIPOPROV,
					's_protel' = OSPR_vTELEFONO,
					's_promai' = OSPR_vEMAIL
			From	
					SC_COMUN.SE_OSE_PROVEEDOR
					/*Inner Join 
			Where	
					OSPR_sORGANOSERVICIO_ID = @p_page_flt and
					OSPR_cESTADO = 'A' and
					(
						OSPR_vDENOMINACION Like '%' + @p_page_search + '%' or

					)*/
					
		End
End
go



if (object_id(N'SC_COMUN.USP_PROVEEDOR_INSERTAR_byOSE') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_INSERTAR_byOSE
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Inserta un registro de proveedor
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_INSERTAR_byOSE 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_INSERTAR_byOSE(
	@p_osesid	smallint, 
	@p_proden	varchar(160),
	@p_protip	tinyint,
	@p_protdo	tinyint,
	@p_prondc	varchar(35),
	@p_protel	varchar(35),
	@p_promai	varchar(35),
	@p_prodir	varchar(128),
	@p_proobs	varchar(255),
	@p_prosit	smallint,
	
	@p_usr		smallint,
	@p_ipc		varchar(15)
)As
Begin
	
	declare @l_cant		int,
			
			@l_id		int,
			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	Select	@l_cant = count(1) 
	From	SC_COMUN.SE_OSE_PROVEEDOR 
	Where	OSPR_sORGANOSERVICIO_ID = @p_osesid and 
			OSPR_vDENOMINACION = @p_proden and 
			OSPR_cESTADO = 'A'

	if (@l_cant > 0)
		begin
			set @l_mensaje	= 'Ya existe un proveedor con ese nombre y/o razón social.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
	else
		begin
			-- 
			begin transaction
				Insert Into SC_COMUN.SE_OSE_PROVEEDOR (
					OSPR_sORGANOSERVICIO_ID, OSPR_vDENOMINACION, OSPR_tTIPOPROV, OSPR_tTIPODOC, OSPR_vNUMERODOCUMENTO,
					OSPR_vTELEFONO, OSPR_vEMAIL, OSPR_vDIRECCION, OSPR_vOBSERVACION, OSPR_sSITUACION,
					OSPR_sUSUARIO_CREACION, OSPR_vIP_CREACION
				)
				Values (
					@p_osesid, @p_proden, @p_protip, @p_protdo, @p_prondc,
					@p_protel, @p_promai, @p_prodir, @p_proobs, @p_prosit,
					@p_usr, @p_ipc
				)

				set	@l_id = scope_identity();
				set @l_mensaje	= 'Se agrego el Órgano de Servicio Exterior.'
				set @l_status	= 1;
				set @l_bs_tipo	= 1;
			commit;
			--
		end
	end
go


if (object_id(N'SC_COMUN.USP_PROVEEDOR_UPDATE_byOSE') is not null)
	drop procedure SC_COMUN.USP_PROVEEDOR_UPDATE_byOSE
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Actualiza los datos de un proveedor
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROVEEDOR_UPDATE_byOSE 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_UPDATE_byOSE(
	@p_prosid	smallint,
	@p_osesid	smallint, 
	@p_proden	varchar(160),
	@p_protip	tinyint,
	@p_protdo	tinyint,
	@p_prondc	varchar(35),
	@p_protel	varchar(35),
	@p_promai	varchar(35),
	@p_prodir	varchar(128),
	@p_proobs	varchar(255),
	@p_prosit	smallint,
	@p_proest	char(1),
	
	@p_usr		smallint,
	@p_ipc		varchar(15)
)As
Begin
	
	declare @l_cant		int,
			@l_id		int,
			@l_proden	varchar(160),

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	Select	@l_proden = OSPR_vDENOMINACION
	From	SC_COMUN.SE_OSE_PROVEEDOR 
	Where	OSPR_sORGANOSERVICIO_ID = @p_osesid and 
			OSPR_cESTADO = 'A'

	if (@l_proden = @p_proden)
		begin
			set @l_mensaje	= 'Ya existe un proveedor con ese nombre / razón social en el Órgano de Servicio.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
	else
		begin
			-- 
			Update	SC_COMUN.SE_OSE_PROVEEDOR 
			Set	
				OSPR_vDENOMINACION = @p_proden, 
				OSPR_tTIPOPROV = @p_protip, 
				OSPR_tTIPODOC = @p_protdo, 
				OSPR_vNUMERODOCUMENTO = @p_prondc,
				OSPR_vTELEFONO = @p_protel, 
				OSPR_vEMAIL = @p_promai, 
				OSPR_vDIRECCION = @p_prodir, 
				OSPR_vOBSERVACION = @p_proobs, 
				OSPR_cESTADO = @p_proest,
				
				OSPR_sUSUARIO_MODIFICACION = @p_usr, 
				OSPR_vIP_MODIFICACION = @p_ipc,
				OSPR_dFECHA_MODIFICACION = getdate()
			Where
				OSPR_sPROVEEDOR_ID = @p_prosid
		end
	end
go


if (object_id(N'SC_COMUN.USP_PERSONAL_LISTAR_toDT') is not null)
	drop procedure SC_COMUN.USP_PERSONAL_LISTAR_toDT
go
/*
Sistema		: Sistema Integrado de Rendicion de Cuentas
Objetivo	: Devuelve el personal local en misión hacia un dataTable
Creado por	: Victor Neyra
Fecha		: 
Parametros	: 
	@p_page_nmber	Número de página
	@p_page_rows	Cantidad de registros por página
	@p_page_search	Buscador
	@p_page_sort	Orden
	@p_page_dir		Dirección del orden
	@p_page_flt		Filtro (0: Administrador, !0: Identificador de la misión)
	@p_rows_totl	Total de registros
	
Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_PERSONAL_LISTAR_toDT 0, 6, '', 0, 'asc', 0, @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_PERSONAL_LISTAR_toDT (
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_page_flt		int,
	@p_rows_totl	int output	
)
As
Begin
	Declare @Tipo_deMision				int = 1,
			@Tipo_dePersonalOSE			int = 7,
			@Tipo_deGradoProfesional	int = 10,
			@Tipo_deSituacionLaboral	int = 11,
			@Tipo_deSituacionRegistro	int = 6,

			@Estado_Registro			char(1) = 'A';

	if (@p_page_flt = 0)
		--# Vista del administrador local en lima.
		begin
			Select	@p_rows_totl = Count(1)
			From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Where	OSER_cESTADO = @Estado_Registro

			Select	'i_row' = row_number() over (order by OSER_sORGSER_PERSONAL_ID),
					's_per_sid' = OSER_sORGSER_PERSONAL_ID, 
					
					's_per_pai' = pa.PAIS_vNOMBRE,
					's_ose_tip' = tm.PAIT_vTEXTO,
					's_ose_abr' = os.ORGA_vABREVIATURA,
					's_sit_lab' = sl.PAIT_vTEXTO,

					's_per_ape' = Concat(OSER_vAPELLIDOS,', ', OSER_vNOMBRES),
					's_sue_bas' = 0,
					's_sue_mon' = '',
					
					'i_sit_est' = op.OSER_sSITUACION,
					's_sit_est' = sr.PAIT_vTEXTO
			From	
					SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
					Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = op.OSER_sORGANOSERVICIO_ID and os.ORGA_tSITUACION = 3 and os.ORGA_cESTADO = @Estado_Registro)
					Inner Join SC_COMUN.SE_PAIS pa on (pa.PAIS_sPAIS_ID = os.ORGA_sPAIS_ID and pa.PAIS_cESTADO = @Estado_Registro)
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM tm on (tm.PAIT_sPARAMETRO_ID = @Tipo_deMision and tm.PAIT_vVALOR = os.ORGA_tTIPO and tm.PAIT_cESTADO = @Estado_Registro)
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sl on (sl.PAIT_sPARAMETRO_ID = @Tipo_deSituacionLaboral and sl.PAIT_vVALOR = op.OSER_sSITUACIONLABORAL and sl.PAIT_cESTADO = @Estado_Registro)
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sr on (sr.PAIT_sPARAMETRO_ID = @Tipo_deSituacionRegistro and sr.PAIT_vVALOR = op.OSER_sSITUACION and sr.PAIT_cESTADO = @Estado_Registro)
			Where	
					op.OSER_cESTADO = @Estado_Registro and (
					(pa.PAIS_vNOMBRE Like '%' + @p_page_search + '%') or
					(tm.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(os.ORGA_vABREVIATURA like '%' + @p_page_search + '%') or
					(sl.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(OSER_vAPELLIDOS like '%' + @p_page_search + '%'))
			Order by
					case when @p_page_sort = 0 and @p_page_dir = 'asc' then op.OSER_sORGSER_PERSONAL_ID end,
					case when @p_page_sort = 0 and @p_page_dir = 'desc' then op.OSER_sORGSER_PERSONAL_ID end desc,

					case when @p_page_sort = 1 and @p_page_dir = 'asc' then pa.PAIS_vNOMBRE end,
					case when @p_page_sort = 1 and @p_page_dir = 'desc' then pa.PAIS_vNOMBRE end desc,

					case when @p_page_sort = 2 and @p_page_dir = 'asc' then tm.PAIT_vTEXTO end,
					case when @p_page_sort = 2 and @p_page_dir = 'desc' then tm.PAIT_vTEXTO end desc,

					case when @p_page_sort = 3 and @p_page_dir = 'asc' then os.ORGA_vABREVIATURA end,
					case when @p_page_sort = 3 and @p_page_dir = 'desc' then os.ORGA_vABREVIATURA end desc,

					case when @p_page_sort = 4 and @p_page_dir = 'asc' then sl.PAIT_vTEXTO end,
					case when @p_page_sort = 4 and @p_page_dir = 'desc' then sl.PAIT_vTEXTO end desc,

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then OSER_vAPELLIDOS end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then OSER_vAPELLIDOS end desc

			OFFSET
					(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY

		end
	else
		--# con filtro
		begin
			begin
			Select	@p_rows_totl = Count(1)
			From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Where	OSER_sORGANOSERVICIO_ID = @p_page_flt and
					OSER_cESTADO = 'A'

			Select	'i_row' = row_number() over (order by OSER_sORGSER_PERSONAL_ID),
					's_per_sid' = OSER_sORGSER_PERSONAL_ID, 
					's_ose_abr' = os.ORGA_vABREVIATURA,
					's_per_ape' = OSER_vAPELLIDOS, 
					's_per_nom' = OSER_vNOMBRES, 
					's_per_tpo' = tp.PAIT_vTEXTO,
					's_per_gra' = gp.PAIT_vTEXTO,
					's_sit_lab' = sl.PAIT_vTEXTO,
					
					'i_sit_est' = op.OSER_sSITUACION,
					's_sit_est' = sr.PAIT_vTEXTO,

					'i_usr' = isnull(op.OSER_sUSUARIO_CREACION, OSER_sUSUARIO_MODIFICACION),
					's_ipu' = isnull(op.OSER_vIP_CREACION, OSER_vIP_MODIFICACION),
					's_fcr' = Convert(varchar(10), isnull(OSER_dFECHA_CREACION, OSER_dFECHA_MODIFICACION), 103) 
			From	
					SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
					Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (
						os.ORGA_sORGANOSERVICIO_ID = op.OSER_sORGANOSERVICIO_ID and 
						os.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM tp on (tp.PAIT_sPARAMETRO_ID = 7 and tp.PAIT_vVALOR = op.OSER_sTIPOPERSONAL and tp.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM gp on (gp.PAIT_sPARAMETRO_ID = 10 and gp.PAIT_vVALOR = op.OSER_sGRADOPROFESIONAL and gp.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sl on (sl.PAIT_sPARAMETRO_ID = 11 and sl.PAIT_vVALOR = op.OSER_sSITUACIONLABORAL and sl.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sr on (sr.PAIT_sPARAMETRO_ID = 6 and sr.PAIT_vVALOR = op.OSER_sSITUACION and sr.PAIT_cESTADO = 'A')
			Where	
					op.OSER_sORGANOSERVICIO_ID = @p_page_flt and
					op.OSER_cESTADO = 'A' and (
					(os.ORGA_vABREVIATURA Like '%' + @p_page_search + '%') or
					(op.OSER_vAPELLIDOS like '%' + @p_page_search + '%') or
					(tp.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(gp.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(sr.PAIT_vTEXTO like '%' + @p_page_search + '%'))

			Order by
					case when @p_page_sort = 0 and @p_page_dir = 'asc' then op.OSER_sORGSER_PERSONAL_ID end,
					case when @p_page_sort = 0 and @p_page_dir = 'desc' then op.OSER_sORGSER_PERSONAL_ID end desc,

					case when @p_page_sort = 1 and @p_page_dir = 'asc' then op.OSER_vAPELLIDOS end,
					case when @p_page_sort = 1 and @p_page_dir = 'desc' then op.OSER_vAPELLIDOS end desc,

					case when @p_page_sort = 4 and @p_page_dir = 'asc' then gp.PAIT_vTEXTO end,
					case when @p_page_sort = 4 and @p_page_dir = 'desc' then gp.PAIT_vTEXTO end desc,

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then sr.PAIT_vTEXTO end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then sr.PAIT_vTEXTO end desc
			OFFSET
					(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY

		end
	end

End
go

-- Depuraciones

/*
exec SC_COMUN.USP_PROVEEDOR_LISTAR
go

exec SC_COMUN.USP_PROVEEDOR_LISTAR_byID 1
go

exec SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE 1
go
*/


Declare @v_total_registros Int
	exec SC_COMUN.USP_PERSONAL_LISTAR_toDT 0, 6, '', 0, 'asc', 0, @v_total_registros out
	Select @v_total_registros
	go