
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
	exec SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE 8

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE (@p_sid Smallint)
As
Begin
	
	Select	'i_sid' = OSPR_sPROVEEDOR_ID, 
			's_pro' = OSPR_vDENOMINACION 
	From	
			SC_COMUN.SE_OSE_PROVEEDOR
	Where	
			OSPR_sORGANOSERVICIO_ID = @p_sid and
			OSPR_cESTADO = 'A'
	order by
			OSPR_vDENOMINACION
End
go



if (object_id(N'SC_COMUN.USP_CTACTE_LISTAR_byUSR') is not null)
	drop procedure SC_COMUN.USP_CTACTE_LISTAR_byUSR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de cuentas corrientes según el órgano de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_CTACTE_LISTAR_byUSR 2

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_CTACTE_LISTAR_byUSR (@p_sid Smallint)
as
begin
	Declare	@param_tipo_destino int = 3

	SELECT	'i_ctasid' = ctacte.CUEN_sCUENTACORRIENTE_ID,
			's_ctanum' = ctacte.CUEN_vNUMEROCUENTA, 
			'i_monsid' = ctacte.CUEN_sMONEDA_ID, 
			's_moniso' = mn.MONE_cISO4217, 
			'i_monasg' = mn.MONE_bASIGNACION, 
			's_detcta' = pit.PAIT_vTEXTO,
			's_resumn' = concat(mn.MONE_cISO4217,' - ',ctacte.CUEN_vNUMEROCUENTA, ' - ', pit.PAIT_vTEXTO)

	FROM	
			SC_COMUN.SE_USUARIO us
			Inner Join SC_COMUN.SE_USUARIO_MOVIMIENTO usm on (usm.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and usm.USMO_bULTIMA_DOC = 1 and USMO_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE octa on (octa.ORCT_sORGANOSERVICIO_ID = usm.USMO_sORGANOSERVICIO_ID and octa.ORCT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_CUENTACORRIENTE ctacte on (ctacte.CUEN_sCUENTACORRIENTE_ID = octa.ORCT_sCUENTACORRIENTE_ID and ctacte.CUEN_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pit on (pit.PAIT_sPARAMETRO_ID = @param_tipo_destino and pit.PAIT_vVALOR = ctacte.CUEN_tDESTINO and pit.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = ctacte.CUEN_sMONEDA_ID and mn.MONE_cESTADO = 'A')
	WHERE	
			USUA_sUSUARIO_ID = @p_sid AND
			USUA_tSITUACION = 1 and
			USUA_cESTADO = 'A'
end
go




-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE PARAMETROS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


if (object_id(N'SC_COMUN.USP_PARAMETROITEMS_LISTAR_byGRUPO') is not null)
	drop procedure SC_COMUN.USP_PARAMETROITEMS_LISTAR_byGRUPO
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de parámetros segun el texto de grupo
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETROITEMS_LISTAR_byGRUPO 'IDENTIDAD_GENERO'

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETROITEMS_LISTAR_byGRUPO (@p_grupo varchar(35))
as
begin
	
	Select	's_tex' = PT.PAIT_vTEXTO, 
			's_val' = PT.PAIT_vVALOR 
	From	
			SC_COMUN.SE_PARAMETRO_ITEM pt
			Inner Join SC_COMUN.SE_PARAMETRO pm on (pm.PARA_sPARAMETRO_ID = pt.PAIT_sPARAMETRO_ID)
	Where
			pm.PARA_vNOMBRE =  @p_grupo and
			pt.PAIT_cESTADO = 'A'
	Order by 
			pt.PAIT_iORDEN, pt.PAIT_vTEXTO
end
go



if (object_id(N'SC_COMUN.USP_PARAMETRO_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETRO_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de parámetros
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETRO_LISTAR 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETRO_LISTAR (@p_sid int)
as
begin
	
	if (@p_sid = 0)
		begin
			Select	'i_row' = row_number() over (order by pm.PARA_sPARAMETRO_ID),
					'i_sid' = pm.PARA_sPARAMETRO_ID,
					's_nom' = pm.PARA_vNOMBRE,
					'i_grp' = pg.PAGR_sPARAMETROGRUPO_ID,
					's_grp' = pg.PAGR_vNOMBRE,
					's_gds' = pg.PAGR_vDESCRIPCION,
					's_des' = pm.PARA_vDESCRIPCION,
		
					'i_est' = pm.PARA_cESTADO
			From		
					SC_COMUN.SE_PARAMETRO pm
					Inner Join SC_COMUN.SE_PARAMETRO_GRUPO pg on (pg.PAGR_sPARAMETROGRUPO_ID = pm.PARA_sPARAMETROGRUPO_ID and pg.PAGR_cESTADO = 'A')
			Where
					pm.PARA_cESTADO = 'A'
		end
	else
		begin
			Select	'i_sid' = pm.PARA_sPARAMETRO_ID,
					's_nom' = pm.PARA_vNOMBRE,
					'i_grp' = pg.PAGR_sPARAMETROGRUPO_ID,
					's_grp' = pg.PAGR_vNOMBRE,
					's_gds' = pg.PAGR_vDESCRIPCION,
					's_des' = pm.PARA_vDESCRIPCION,
		
					'i_est' = pm.PARA_cESTADO
			From		
					SC_COMUN.SE_PARAMETRO pm
					Inner Join SC_COMUN.SE_PARAMETRO_GRUPO pg on (pg.PAGR_sPARAMETROGRUPO_ID = pm.PARA_sPARAMETROGRUPO_ID and pg.PAGR_cESTADO = 'A')
			Where
					pm.PARA_sPARAMETRO_ID = @p_sid and
					pm.PARA_cESTADO = 'A'
		end
end
go


if (object_id(N'SC_COMUN.USP_PARAMETRO_GRABAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETRO_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba/Actualiza los datos de un parámetro
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETRO_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETRO_GRABAR(
	@p_id	int,
	@p_nom	varchar(35),
	@p_grp	int,
	@p_des	varchar(255),
	
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,
			@l_id	int,
			@l_nom	varchar(35),

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1
			
	-- Comprobando si el id existe
	select @l_cant = count(1) from SC_COMUN.SE_PARAMETRO where PARA_sPARAMETRO_ID = @p_id

	if (@l_cant = 0)
		begin 
			-- No existe, comprobando si el nombre ya existe
			select @l_cant = count(1) from SC_COMUN.SE_PARAMETRO where PARA_vNOMBRE = @p_nom
			if (@l_cant = 0)
				begin
					Begin Transaction
						Insert Into SC_COMUN.SE_PARAMETRO (PARA_vNOMBRE, PARA_sPARAMETROGRUPO_ID, PARA_vDESCRIPCION, PARA_sUSUARIO_CREACION, PARA_vIP_CREACION)
						Values (@p_nom, @p_grp, @p_des, @p_usr, @p_ipc)

						set	@l_id = SCOPE_IDENTITY();
						set @l_mensaje	= 'Se agrego el parámetro.'
						set @l_status	= 1;
						set @l_bs_tipo	= 1;
					Commit;
				end
			else
				begin
						set	@l_id = @p_id;
						set @l_mensaje	= 'Ya existe un parámetro con el mismo nombre. No se agregó el parámetro.'
						set @l_status	= 0;
						set @l_bs_tipo	= 4;
				end
		end
	else
		begin
			-- Si el id existe, es una actualización
			-- comprobando si se repetirían los datos
			select @l_cant = count(1) from SC_COMUN.SE_PARAMETRO where (PARA_sPARAMETRO_ID <> @p_id and PARA_vNOMBRE = @p_nom) 
			if (@l_cant = 0)
				begin
					-- No existe un nombre igual 
					Update	SC_COMUN.SE_PARAMETRO
					set		PARA_vNOMBRE = @p_nom,
							PARA_sPARAMETROGRUPO_ID = @p_grp,
							PARA_vDESCRIPCION = @p_des,
							PARA_sUSUARIO_MODIFICACION = @p_usr,
							PARA_vIP_MODIFICACION = @p_ipc,
							PARA_dFECHA_MODIFICACION = getdate()
					Where	
							PARA_sPARAMETRO_ID = @p_id
					
					set	@l_id = @p_id;
					set @l_mensaje	= 'Se actualizó el parámetro.'
					set @l_status	= 1;
					set @l_bs_tipo	= 1;
				end
			else
				begin
					set	@l_id = @p_id;
					set @l_mensaje	= 'Ya existe un parámetro con el mismo nombre. No se actualizó el parámetro.'
					set @l_status	= 1;
					set @l_bs_tipo	= 4;
				end
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
Go


if (object_id(N'SC_COMUN.USP_PARAMETRO_ELIMINAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETRO_ELIMINAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Elimina un parametro.
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETRO_ELIMINAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETRO_ELIMINAR(
	@p_id	int,
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,
			@l_id	int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	-- Busca si hay un detalle asociado
	Select @l_cant = count(1) From SC_COMUN.SE_PARAMETRO Where PARA_sPARAMETRO_ID = @p_id and PARA_cESTADO = 'A'
	if (@l_cant = 0)
		begin
			Update	SC_COMUN.SE_PARAMETRO
			Set		PARA_cESTADO = 'I',
					PARA_sUSUARIO_MODIFICACION = @p_usr,
					PARA_vIP_MODIFICACION = @p_ipc,
					PARA_dFECHA_MODIFICACION = getdate()
			Where	
					PARA_sPARAMETRO_ID = @p_id

			set	@l_id = @p_id
			set @l_mensaje	= 'El registro fue eliminado.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			set	@l_id = @p_id
			set @l_mensaje	= 'El registro tiene detalles vinculados, elimine primero los detalles vinculados. No se eliminó el registro.'
			set @l_status	= 1;
			set @l_bs_tipo	= 3;
		end
	

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
Go


if (object_id(N'SC_COMUN.USP_PARAMETROITEM_GRABAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETROITEM_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Inserta un item de parametro.
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETROITEM_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETROITEM_GRABAR(
	@p_id	int,
	@p_idp	int,
	@p_tex	varchar(50),
	@p_val	varchar(50),
	@p_ayu	varchar(255),
	@p_ord	int,
	@p_grp	bit,
	
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	
	declare @l_cant int,
			@l_id	int,
			@l_nom	varchar(35),

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	if (@p_id = 0)
		-- Si es nuevo
		begin 
			-- No existe, comprobando si el nombre ya existe
			select @l_cant = count(1) from SC_COMUN.SE_PARAMETRO_ITEM where PAIT_sPARAMETRO_ID = @p_idp and (PAIT_vTEXTO = @p_tex or PAIT_vVALOR = @p_val) 
			if (@l_cant = 0)
				begin
					Begin Transaction
						Insert Into SC_COMUN.SE_PARAMETRO_ITEM (PAIT_sPARAMETRO_ID, PAIT_vTEXTO, PAIT_vVALOR, PAIT_vAYUDA, PAIT_iORDEN, PAIT_bISGRUPO, 
															PAIT_sUSUARIO_CREACION, PAIT_vIP_CREACION)
						Values (@p_idp, @p_tex, @p_val, @p_ayu, @p_ord, @p_grp, @p_usr, @p_ipc)

						set	@l_id = SCOPE_IDENTITY();
						set @l_mensaje	= 'Se agrego el nuevo elemento para el parámetro.'
						set @l_status	= 1;
						set @l_bs_tipo	= 1;
					Commit;
				end
			else
				begin
						set	@l_id = @p_id;
						set @l_mensaje	= 'Ya existe un elemento con el mismo Texto ó Valor. No se agregaron los datos.'
						set @l_status	= 0;
						set @l_bs_tipo	= 2;
				end
		end
	else
		begin
			-- Si el id existe, es una actualización
			-- comprobando si se repetirían los datos

			Declare @l_old_text varchar(50),
					@l_old_val varchar(50)

			-- No existe un nombre igual 
			Update	SC_COMUN.SE_PARAMETRO_ITEM
			set		PAIT_sPARAMETRO_ID = @p_idp,
					PAIT_vTEXTO = @p_tex,
					PAIT_vVALOR = @p_val,
					PAIT_vAYUDA = @p_ayu,
					PAIT_iORDEN = @p_ord,
					PAIT_bISGRUPO = @p_grp,
							
					PAIT_sUSUARIO_MODIFICACION = @p_usr,
					PAIT_vIP_MODIFICACION = @p_ipc,
					PAIT_dFECHA_MODIFICACION = getdate()
			Where	
					PAIT_sPARAMETROITEM_ID = @p_id
					
			set	@l_id = @p_id;
			set @l_mensaje	= 'Se actualizó el elemento.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
Go


if (object_id(N'SC_COMUN.USP_PARAMETROITEM_ELIMINAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETROITEM_ELIMINAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Elimina un item de parametro.
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETROITEM_ELIMINAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_PARAMETROITEM_ELIMINAR(
	@p_idd	int,
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,
			@l_id	int,
			@l_nom	varchar(35),

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	-- Comprobando si el id existe
	-- ToDo: Chekear las dependencias
	select @l_cant = count(1) from SC_COMUN.SE_PARAMETRO_ITEM where PAIT_sPARAMETROITEM_ID = @p_idd

	if (@l_cant = 1)
		begin 
			-- Si existe, 
			Begin Transaction
				
				Update	SC_COMUN.SE_PARAMETRO_ITEM 
				set		PAIT_cESTADO = 'I',
						
						PAIT_sUSUARIO_MODIFICACION = @p_usr,
						PAIT_vIP_MODIFICACION = @p_ipc,
						PAIT_dFECHA_MODIFICACION = getdate()
				where	
						PAIT_sPARAMETROITEM_ID = @p_idd
			Commit;
			
			set @l_mensaje	= 'El registro fué eliminado.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			-- si no existe
			set @l_mensaje	= 'El registro no existe.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
	
	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE CUENTAS BANCARIAS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


if (object_id(N'SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS') is not null)
	drop procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba los datos de una cuenta corriente desde el organo de servicio exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec 

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/	
Create Procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS (
	@p_sid		int,
	@p_mnd		smallint,
    @p_bic		varchar(11),
    @p_rib		varchar(23),

    @p_abi		varchar(9),
    @p_ini		varchar(10),
	@p_doc		varchar(18),

	@p_cta		varchar(34),
    @p_des		tinyint,
    @p_iba		varchar(30),
    @p_cbu		varchar(22),
    @p_cab		varchar(5),
    @p_fin		varchar(10),
    @p_fdo		varchar(10),

    @p_age		smallint,
    @p_rut		tinyint,
    @p_aba		varchar(9),
    @p_bsb		varchar(6),

    @p_apo		smallint,
    @p_obs		varchar(255),

	@p_ben		varchar(35),
	@p_di1		varchar(35),
    @p_di2		varchar(35),
    @p_di3		varchar(35),

	@p_usr		smallint,
	@p_ipc		varchar(15)
)
As
Begin
	Declare	@l_cant		int,
			@l_Id		int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1,

			@c_cuenta_asignacion	tinyint = 1,
			@c_cuenta_beneficios	tinyint = 2,
			@c_cuenta_confirmada	tinyint = 9

	-- Actualizar cuenta: comprueba que el numero de cuenta sea unico
	Select	@l_cant = count(1)			
	From	SC_COMUN.SE_CUENTACORRIENTE cta
	Where
			cta.CUEN_sCUENTACORRIENTE_ID <> @p_sid and
			cta.CUEN_vNUMEROCUENTA = @p_cta and
			cta.CUEN_cESTADO = 'A'

	if (@l_cant = 0) 
		begin
			-- Si el numero de cuenta no existe, obtiene el destino actual de la cuenta
			Declare @l_des tinyint;
			select	@l_des = CUEN_tDESTINO from SC_COMUN.SE_CUENTACORRIENTE cta where cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and cta.CUEN_cESTADO = 'A'

			-- comprueba si el destino de la cuenta es el mismo
			if (@l_des = @p_des)
				begin
					
					-- El destino no ha variado, actualiza la cuenta
					Update	SC_COMUN.SE_CUENTACORRIENTE
					Set		CUEN_sMONEDA_ID = @p_mnd,
							CUEN_vSWIFT = @p_bic,
							CUEN_vRIB = @p_rib,
							CUEN_vABI = @p_abi, 
							CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
							CUEN_vDOCAUTORIZACION = @p_doc,
							CUEN_vNUMEROCUENTA = @p_cta,
							CUEN_vIBAN = @p_iba,
							CUEN_vCBU = @p_cbu,
							CUEN_vCAB = @p_cab,
							CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
							CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
							CUEN_sBANCO_AGENCIA_ID = @p_age,
							CUEN_tCODIGORUTEO = @p_rut,
							CUEN_vABA = @p_aba,
							CUEN_vBSB = @p_bsb,
							CUEN_sAPODERADO_ID = @p_apo,
							CUEN_vOBSERVACION = @p_obs,
							CUEN_tSITUACION = @c_cuenta_confirmada,
							CUEN_vBENEFNOMBRE = @p_ben,
							CUEN_vBENEFDOMICILIO1 = @p_di1,
							CUEN_vBENEFDOMICILIO2 = @p_di2,
							CUEN_vBENEFDOMICILIO3 = @p_di3,

							CUEN_sUSUARIO_MODIFICACION = @p_usr,
							CUEN_vIP_MODIFICACION = @p_ipc,
							CUEN_dFECHA_MODIFICACION = GetDate()
					Where
							CUEN_sCUENTACORRIENTE_ID = @p_sid and
							CUEN_cESTADO = 'A'

					set	@l_Id		= @p_sid;
					set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.';
					set @l_status	= 1;
					set @l_bs_tipo	= 1;

				end
			else
				begin
					-- El destino ha variado
					-- comprueba si es una cuenta restringida
					if (@p_des = @c_cuenta_asignacion or @p_des = @c_cuenta_beneficios) 
						begin
							-- es una cuenta restringida
							-- comprueba si es cuenta de asignación
							if (@p_des = @c_cuenta_asignacion) 
								begin
									-- comprueba si la cuenta actual es de asignación
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
									Where
											cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and
											cta.CUEN_tDESTINO = @c_cuenta_asignacion and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0) 
										begin
											-- No tiene cuenta de asignacion
											-- Actualiza cuenta

											Update	SC_COMUN.SE_CUENTACORRIENTE
											Set		CUEN_sMONEDA_ID = @p_mnd,
													CUEN_vSWIFT = @p_bic,
													CUEN_vRIB = @p_rib,
													CUEN_vABI = @p_abi, 
													CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
													CUEN_vDOCAUTORIZACION = @p_doc,
													CUEN_vNUMEROCUENTA = @p_cta,
													CUEN_tDESTINO = @p_des,
													CUEN_vIBAN = @p_iba,
													CUEN_vCBU = @p_cbu,
													CUEN_vCAB = @p_cab,
													CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
													CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
													CUEN_sBANCO_AGENCIA_ID = @p_age,
													CUEN_tCODIGORUTEO = @p_rut,
													CUEN_vABA = @p_aba,
													CUEN_vBSB = @p_bsb,
													CUEN_sAPODERADO_ID = @p_apo,
													CUEN_vOBSERVACION = @p_obs,
													CUEN_tSITUACION = @c_cuenta_confirmada,

													CUEN_vBENEFNOMBRE = @p_ben,
													CUEN_vBENEFDOMICILIO1 = @p_di1,
													CUEN_vBENEFDOMICILIO2 = @p_di2,
													CUEN_vBENEFDOMICILIO3 = @p_di3,

													CUEN_sUSUARIO_MODIFICACION = @p_usr,
													CUEN_vIP_MODIFICACION = @p_ipc,
													CUEN_dFECHA_MODIFICACION = GetDate()
											Where
													CUEN_sCUENTACORRIENTE_ID = @p_sid and
													CUEN_cESTADO = 'A'

											set @l_Id		= @p_sid;
											set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;
										end
									else
										begin
											-- Ya tiene una cuenta de asignacion
											set @l_Id		= 0;
											set @l_mensaje	= 'Lo sentimos, sólo se permite una cuenta de asignación. Sin embargo, según el Art. 22 del Reglamento N°422'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end
							else
								begin
									--	el destino es beneficios
									--  comprueba si tiene cuenta de beneficios
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
									Where
											cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and
											cta.CUEN_tDESTINO = @c_cuenta_beneficios and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0)
										begin
											-- no tiene cuenta de beneficios
											-- actualiza todo menos plantilla
											Update	SC_COMUN.SE_CUENTACORRIENTE
											Set		CUEN_sMONEDA_ID = @p_mnd,
													CUEN_vSWIFT = @p_bic,
													CUEN_vRIB = @p_rib,
													CUEN_vABI = @p_abi, 
													CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
													CUEN_vDOCAUTORIZACION = @p_doc,
													CUEN_vNUMEROCUENTA = @p_cta,
													CUEN_tDESTINO = @p_des,
													CUEN_vIBAN = @p_iba,
													CUEN_vCBU = @p_cbu,
													CUEN_vCAB = @p_cab,
													CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
													CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
													CUEN_sBANCO_AGENCIA_ID = @p_age,
													CUEN_tCODIGORUTEO = @p_rut,
													CUEN_vABA = @p_aba,
													CUEN_vBSB = @p_bsb,
													CUEN_sAPODERADO_ID = @p_apo,
													CUEN_vOBSERVACION = @p_obs,
													CUEN_tSITUACION = @c_cuenta_confirmada,

													CUEN_vBENEFNOMBRE = @p_ben,
													CUEN_vBENEFDOMICILIO1 = @p_di1,
													CUEN_vBENEFDOMICILIO2 = @p_di2,
													CUEN_vBENEFDOMICILIO3 = @p_di3,

													CUEN_sUSUARIO_MODIFICACION = @p_usr,
													CUEN_vIP_MODIFICACION = @p_ipc,
													CUEN_dFECHA_MODIFICACION = GetDate()
											Where
													CUEN_sCUENTACORRIENTE_ID = @p_sid and
													CUEN_cESTADO = 'A'
											
											set @l_Id		= @p_sid;
											set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;

										end
									else
										begin
											-- Ya tiene una cuenta de beneficios sociales
											set @l_Id		= 0;
											set @l_mensaje	= 'Ya existe una cuenta de beneficios sociales para el Órgano de Servicio seleccionado.'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end


						end
					else
						begin
							-- no es cuenta restringida
							-- actualiza los datos

							Update	SC_COMUN.SE_CUENTACORRIENTE
							Set		CUEN_sMONEDA_ID = @p_mnd,
									CUEN_vSWIFT = @p_bic,
									CUEN_vRIB = @p_rib,
									CUEN_vABI = @p_abi, 
									CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
									CUEN_vDOCAUTORIZACION = @p_doc,
									CUEN_vNUMEROCUENTA = @p_cta,
									CUEN_tDESTINO = @p_des,
									CUEN_vIBAN = @p_iba,
									CUEN_vCBU = @p_cbu,
									CUEN_vCAB = @p_cab,
									CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
									CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
									CUEN_sBANCO_AGENCIA_ID = @p_age,
									CUEN_tCODIGORUTEO = @p_rut,
									CUEN_vABA = @p_aba,
									CUEN_vBSB = @p_bsb,
									CUEN_sAPODERADO_ID = @p_apo,
									CUEN_vOBSERVACION = @p_obs,
									CUEN_tSITUACION = @c_cuenta_confirmada,

									CUEN_vBENEFNOMBRE = @p_ben,
									CUEN_vBENEFDOMICILIO1 = @p_di1,
									CUEN_vBENEFDOMICILIO2 = @p_di2,
									CUEN_vBENEFDOMICILIO3 = @p_di3,

									CUEN_sUSUARIO_MODIFICACION = @p_usr,
									CUEN_vIP_MODIFICACION = @p_ipc,
									CUEN_dFECHA_MODIFICACION = GetDate()
							Where
									CUEN_sCUENTACORRIENTE_ID = @p_sid and
									CUEN_cESTADO = 'A'

							set	@l_Id		= @p_sid;
							set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
							set @l_status	= 1;
							set @l_bs_tipo	= 1;
						end
				end
		end
	else
		begin
			-- la cuenta ya existe en otro organo de servicio
			-- para vincular a otro Organo de Servicio debe hacerse por otra interfaz
			set @l_Id = 0;
			set @l_mensaje	= 'El numero de cuenta esta vinculado a otro Organo de Servicio.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
		
	

	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo

End
Go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	AUDITORIA
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


if (object_id(N'SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR') is not null)
	drop procedure SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de auditoria del registro por módulo y usuario
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec	SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR 1, 7, 144
	
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/	
Create Procedure SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR (
	@p_mod	Int,
	@p_sid	Int,
	@p_usr	Int
)
As
Begin
	Declare @c_evento_actualizacion int = 2;
	
	-- Select Modulo y Usuario
	Select	
			's_fec' = FORMAT(AUDI_dFECHA_CREACION, 'dd/MM/yyyy hh:mm tt'),
			's_usr' = CONCAT(Us.USUA_vAPELLIDOS,',',Us.USUA_vNOMBRES),
			's_cam' = AUDI_vCAMPO_DES, 
			's_old' = Case AUDI_vDATO_ANTERIOR
						When '' Then '{ Vacio }'
						else  AUDI_vDATO_ANTERIOR end,
			's_new' = AUDI_vDATO_NUEVO,
			's_all' = CONCAT(
						FORMAT(AUDI_dFECHA_CREACION, 'dd/MM/yyyy hh:mm tt'), ' ', 
						CONCAT(Us.USUA_vAPELLIDOS,',',Us.USUA_vNOMBRES), ' cambió ',
						AUDI_vCAMPO_DES, ' de ',
						Case AUDI_vDATO_ANTERIOR
							When '' Then '{ Vacio }'
							Else  AUDI_vDATO_ANTERIOR End, ' a ',
						AUDI_vDATO_NUEVO)
	From	
			SC_SYSTEM.SE_AUDITORIA Au
			Inner Join SC_COMUN.SE_USUARIO Us on (Us.USUA_sUSUARIO_ID = Au.AUDI_sUSUARIO_CREACION)
	Where	
			AUDI_iMODULO = @p_mod and
			AUDI_iEVENTO_ID = @c_evento_actualizacion and
			AUDI_iREGISTRO_ID = @p_sid 
			-- and AUDI_sUSUARIO_CREACION = @p_usr
	order by
			AUDI_dFECHA_CREACION desc
End
go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	DISPARADORES
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

If (object_id('SC_COMUN.TRG_CUENTACORRIENTE_ACTUALIZAR') is not null)
Begin
      Drop Trigger SC_COMUN.TRG_CUENTACORRIENTE_ACTUALIZAR
End
go

Create Trigger SC_COMUN.TRG_CUENTACORRIENTE_ACTUALIZAR 
On SC_COMUN.SE_CUENTACORRIENTE 
For Update
As
Begin

	IF (update(CUEN_vNUMEROCUENTA))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vNUMEROCUENTA', 'NÚMERO DE CUENTA', d.CUEN_vNUMEROCUENTA, i.CUEN_vNUMEROCUENTA, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vNUMEROCUENTA <> i.CUEN_vNUMEROCUENTA)

	IF (update(CUEN_sMONEDA_ID))
		Begin
			Declare @l_moneda_old varchar(3),
					@l_moneda_new varchar(3)

			Set @l_moneda_old = (Select Top 1 mn.MONE_cISO4217 From SC_COMUN.SE_MONEDA mn Inner Join deleted d on (d.CUEN_sMONEDA_ID = mn.MONE_sMONEDA_ID))
			Set @l_moneda_new = (Select Top 1 mn.MONE_cISO4217 From SC_COMUN.SE_MONEDA mn Inner Join inserted i on (i.CUEN_sMONEDA_ID = mn.MONE_sMONEDA_ID))

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_sMONEDA_ID', 'MONEDA', @l_moneda_old, @l_moneda_new, 
					i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_sMONEDA_ID <> i.CUEN_sMONEDA_ID)
		End

	IF (update(CUEN_sBANCO_AGENCIA_ID))
		Begin
			Declare @l_agencia_old varchar(72),
					@l_agencia_new varchar(72)

			Set @l_agencia_old = (
				Select	Top 1 CONCAT(bc.BANC_vNOMBRE,'-',ba.BAAG_vNOMBREAGENCIA) 
				From	SC_COMUN.SE_BANCO_AGENCIA ba 
					Inner Join deleted d on (d.CUEN_sBANCO_AGENCIA_ID = ba.BAAG_sBANCOAGENCIA_ID)
					Inner Join SC_COMUN.SE_BANCO bc on (bc.BANC_sBANCO_ID = ba.BAAG_sBANCO_ID)
				Where	
					ba.BAAG_sBANCOAGENCIA_ID = CUEN_sBANCO_AGENCIA_ID)
					
			Set @l_agencia_new = (
				Select	Top 1 CONCAT(bc.BANC_vNOMBRE,'-',ba.BAAG_vNOMBREAGENCIA) 
				From	SC_COMUN.SE_BANCO_AGENCIA ba 
					Inner Join inserted i on (i.CUEN_sBANCO_AGENCIA_ID = ba.BAAG_sBANCOAGENCIA_ID)
					Inner Join SC_COMUN.SE_BANCO bc on (bc.BANC_sBANCO_ID = ba.BAAG_sBANCO_ID)
				Where	
					ba.BAAG_sBANCOAGENCIA_ID = CUEN_sBANCO_AGENCIA_ID)

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_sBANCO_AGENCIA_ID', 'BANCO-AGENCIA', @l_agencia_old, @l_agencia_new, 
					i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_sBANCO_AGENCIA_ID <> i.CUEN_sBANCO_AGENCIA_ID)
		End

	
	IF (update(CUEN_vIBAN))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vIBAN', 'NÚMERO DE IBAN', d.CUEN_vIBAN, i.CUEN_vIBAN, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vIBAN <> i.CUEN_vIBAN)
	
	IF (update(CUEN_vSWIFT))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vSWIFT', 'NÚMERO DE SWIFT', d.CUEN_vSWIFT, i.CUEN_vSWIFT, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vSWIFT <> i.CUEN_vSWIFT)

	IF (update(CUEN_vABA))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vABA', 'NÚMERO DE ABA', d.CUEN_vABA, i.CUEN_vABA, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vABA <> i.CUEN_vABA)

	IF (update(CUEN_vRIB))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vRIB', 'NÚMERO DE RIB', d.CUEN_vRIB, i.CUEN_vRIB, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vRIB <> i.CUEN_vRIB)

	IF (update(CUEN_vCBU))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vCBU', 'NÚMERO DE CBU', d.CUEN_vCBU, i.CUEN_vCBU, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vCBU <> i.CUEN_vCBU)

	IF (update(CUEN_vBSB))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vBSB', 'NÚMERO DE BSB', d.CUEN_vBSB, i.CUEN_vBSB, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vBSB <> i.CUEN_vBSB)

	IF (update(CUEN_vABI))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vABI', 'NÚMERO DE ABI', d.CUEN_vABI, i.CUEN_vABI, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vABI <> i.CUEN_vABI)

	IF (update(CUEN_vCAB))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vCAB', 'NÚMERO DE CAB', d.CUEN_vCAB, i.CUEN_vCAB, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vCAB <> i.CUEN_vCAB)

	IF (update(CUEN_tDESTINO))
		Begin
			Declare @l_des_old	varchar(50),
					@l_des_new	varchar(50),
					@c_param_tipo_destino int = 3

			Set	@l_des_old = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join deleted d on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_destino and d.CUEN_tDESTINO = pa.PAIT_vVALOR))
			Set	@l_des_new = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join inserted i on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_destino and i.CUEN_tDESTINO = pa.PAIT_vVALOR))

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_tDESTINO', 'DESTINO DE CUENTA', @l_des_old, @l_des_new, 
					i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_tDESTINO <> i.CUEN_tDESTINO)
		End

	IF (update(CUEN_dFECHAAPERTURA))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_dFECHAAPERTURA', 'FECHA DE APERTURA', convert(datetime, d.CUEN_dFECHAAPERTURA, 103), convert(datetime, i.CUEN_dFECHAAPERTURA, 103), 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_dFECHAAPERTURA <> i.CUEN_dFECHAAPERTURA)
	
	IF (update(CUEN_dFECHACIERRE))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_dFECHACIERRE', 'FECHA DE CIERRE', convert(datetime, d.CUEN_dFECHACIERRE, 103), convert(datetime, i.CUEN_dFECHACIERRE,103),
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_dFECHACIERRE <> i.CUEN_dFECHACIERRE)
	
	IF (update(CUEN_vDOCAUTORIZACION))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vDOCAUTORIZACION', 'DOCUMENTO DE AUTORIZACIÓN', d.CUEN_vDOCAUTORIZACION, i.CUEN_vDOCAUTORIZACION, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vDOCAUTORIZACION <> i.CUEN_vDOCAUTORIZACION)

	IF (update(CUEN_dDOCFECHA))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_dDOCFECHA', 'FECHA DE AUTORIZACIÓN', Convert(datetime, d.CUEN_dDOCFECHA, 103), Convert(datetime, i.CUEN_dDOCFECHA, 103),
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_dDOCFECHA <> i.CUEN_dDOCFECHA)

	IF (update(CUEN_vOBSERVACION))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vOBSERVACION', 'OBSERVACIONES', d.CUEN_vOBSERVACION, i.CUEN_vOBSERVACION, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vOBSERVACION <> i.CUEN_vOBSERVACION)

	IF (update(CUEN_vBENEFNOMBRE))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_vBENEFNOMBRE', 'BENEFICIARIO', d.CUEN_vBENEFNOMBRE, i.CUEN_vBENEFNOMBRE, 
				i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_vBENEFNOMBRE <> i.CUEN_vBENEFNOMBRE)

	IF (update(CUEN_tSITUACION))
		Begin
			Declare @l_sit_old	varchar(50),
					@l_sit_new	varchar(50),
					@c_param_tipo_situacion int = 6

			Set	@l_sit_old = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join deleted d on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_situacion and d.CUEN_tSITUACION = pa.PAIT_vVALOR))
			Set	@l_sit_new = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join inserted i on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_situacion and i.CUEN_tSITUACION = pa.PAIT_vVALOR))
		
			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	1, 'SE_CUENTACORRIENTE', 'CUENTAS CORRIENTES', 2, d.CUEN_sCUENTACORRIENTE_ID, 'CUEN_tSITUACION', 'SITUACION', @l_sit_old, @l_sit_new, 
					i.CUEN_sUSUARIO_MODIFICACION, i.CUEN_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.CUEN_sCUENTACORRIENTE_ID = d.CUEN_sCUENTACORRIENTE_ID and d.CUEN_tSITUACION <> i.CUEN_tSITUACION)
		End
End
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	ACTUALIZACIONES
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de una cuenta corriente para su edición
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id de la cuenta corriente (0: Todos, [1..n] Id de la Cuenta)

Ejecutar	: 
	exec SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID 177

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID (
	@p_sid		int  
)
As
Begin
	Declare	@paramItem_DestinoCuenta int = 3,
			@paramItem_CodigoRuteo int = 4

	Select	'i_ctasid' = CUEN_sCUENTACORRIENTE_ID, 
			'i_osesid' = ORCT_sORGANOSERVICIO_ID,
			's_oseabr' = Org.ORGA_vABREVIATURA,
			's_ctanum' = CUEN_vNUMEROCUENTA, 
			'i_mndsid' = CUEN_sMONEDA_ID,
			's_mndnom' = Mon.MONE_vNOMBRE,
			'i_bansid' = CUEN_sBANCO_AGENCIA_ID, 
			's_bannom' = CONCAT(Ban.BANC_vNOMBRE,' - ',BAAG_vNOMBREAGENCIA),
			'i_rutsid' = CUEN_tCODIGORUTEO, 
			's_rutnom' = Rut.PAIT_vTEXTO,
			's_ctaiba' = CUEN_vIBAN, 
			's_ctaswi' = CUEN_vSWIFT, 
			's_ctaaba' = CUEN_vABA, 
			's_ctarib' = CUEN_vRIB, 
			's_ctacbu' = CUEN_vCBU, 
			's_ctabsb' = CUEN_vBSB, 
			's_ctaabi' = CUEN_vABI, 
			's_ctacab' = CUEN_vCAB, 
			'i_ctades' = CUEN_tDESTINO, 
			's_ctades' = Dst.PAIT_vTEXTO,
			'i_ctacom' = CUEN_bESCOMPARTIDA, 
			's_ctaini' = case when isnull(CUEN_dFECHAAPERTURA,'19000101') = '19000101' Then ''
							Else Convert(varchar(10), CUEN_dFECHAAPERTURA, 103) end,
			's_ctafin' = case when isnull(CUEN_dFECHACIERRE,'19000101') = '19000101' Then '' 
							Else Convert(varchar(10), CUEN_dFECHACIERRE, 103) end,
			'i_aposid' = CUEN_sAPODERADO_ID, 
			's_ctadnu' = CUEN_vDOCAUTORIZACION, 
			's_ctadfe' = case when isnull(CUEN_dDOCFECHA,'19000101') = '19000101' Then ''
							Else Convert(varchar(10), CUEN_dDOCFECHA, 103) end, 
			's_ctaobs' = CUEN_vOBSERVACION, 
			'i_ctasit' = CUEN_tSITUACION,
					
			's_bennom' = CUEN_vBENEFNOMBRE,
			's_bendo1' = CUEN_vBENEFDOMICILIO1,
			's_bendo2' = CUEN_vBENEFDOMICILIO2,
			's_bendo3' = CUEN_vBENEFDOMICILIO3,
			
			's_plaent' = IsNull(Tem.TRTE_sENTIDAD_ID, 0),
			's_placta' = IsNull(Tem.TRTE_sCTAORIGEN_ID, 0),
			's_plades' = IsNull(Tem.TRTE_sTIPOCTADES_ID, 0),
			's_plaage' = IsNull(Tem.TRTE_sAGENCIAINT_ID, 0),
			's_pladat' = Tem.TRTE_vDATOAGENCIA,
			's_plamru' = IsNull(Tem.TRTE_sRUTEOMET_ID,0),
			's_plarut' = Tem.TRTE_vRUTEOCOD,
			's_plasub' = IsNull(Tem.TRTE_sSUBSIDIARIA_ID,0),
			
			'i_audtus' = IsNull(cta.CUEN_sUSUARIO_MODIFICACION, cta.CUEN_sUSUARIO_CREACION),
			's_audtus' = Concat(USUA_vAPELLIDOS, ' ', USUA_vNOMBRES),
			's_audtfe' = IsNull(cta.CUEN_dFECHA_MODIFICACION, cta.CUEN_dFECHA_CREACION)
	From	
			SC_COMUN.SE_CUENTACORRIENTE Cta
			Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and Det.ORCT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO Org On (Org.ORGA_sORGANOSERVICIO_ID = det.ORCT_sORGANOSERVICIO_ID and Org.ORGA_cESTADO = 'A')
			Inner Join SC_COMUN.SE_MONEDA Mon on (Mon.MONE_sMONEDA_ID = Cta.CUEN_sMONEDA_ID and Mon.MONE_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM Dst on (Dst.PAIT_sPARAMETRO_ID = @paramItem_DestinoCuenta and Dst.PAIT_vVALOR = CUEN_tDESTINO and Dst.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM Rut on (Rut.PAIT_sPARAMETRO_ID = @paramItem_CodigoRuteo and Rut.PAIT_vVALOR = CUEN_tCODIGORUTEO and Rut.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_BANCO_AGENCIA Age on (Age.BAAG_sBANCOAGENCIA_ID = Cta.CUEN_sBANCO_AGENCIA_ID and Age.BAAG_cESTADO = 'A')
			Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and ban.BANC_cESTADO = 'A')
			Inner Join SC_COMUN.SE_USUARIO Usr On (Usr.USUA_sUSUARIO_ID = IsNull(cta.CUEN_sUSUARIO_MODIFICACION, cta.CUEN_sUSUARIO_CREACION))
			Left Join SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE Tem on (Tem.TRTE_sCTACTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and Tem.TRTE_cESTADO = 'A')
	Where
			CUEN_sCUENTACORRIENTE_ID = @p_sid and
			Cta.CUEN_cESTADO = 'A'
End
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PERSONAL LOCAL
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

if (object_id(N'SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve el personal directivo del Organo de Servicio especificado para un control selector
			  Personal directivo :1-Diplomatico, 2-Administrativo Lima
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_TOSELECT 60

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_TOSELECT (
	@p_ose		Smallint
)
As
Begin
	if (@p_ose = 0)
		begin
			Select	'i_persid' = OSER_sORGSER_PERSONAL_ID,
					's_pernom' = Concat(OSER_vAPELLIDOS,', ',OSER_vNOMBRES)
			From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Where
					OSER_sTIPOPERSONAL in (1,2) and
					OSER_cESTADO = 'A'
			Order by
					OSER_vAPELLIDOS
		end
	else
		begin
			Select	'i_persid' = OSER_sORGSER_PERSONAL_ID,  
					's_pernom' = Concat(OSER_vAPELLIDOS,', ',OSER_vNOMBRES)
			From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Where
					OSER_sORGANOSERVICIO_ID = @p_ose and
					OSER_sTIPOPERSONAL in (1,2) and
					OSER_cESTADO = 'A'
			Order by
					OSER_vAPELLIDOS
		end
	End
Go

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
	@p_page_flt		Filtro
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
	@p_page_ose		int,
	@p_rows_totl	int output	
)
As
Begin

	if (@p_page_flt = 0)
		--# sin filtro
		begin
			Select	@p_rows_totl = Count(1)
			From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Where	OSER_cESTADO = 'A'

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
					Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = op.OSER_sORGANOSERVICIO_ID and os.ORGA_tSITUACION = 3 and os.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM tp on (tp.PAIT_sPARAMETRO_ID = 7 and tp.PAIT_vVALOR = op.OSER_sTIPOPERSONAL and tp.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM gp on (gp.PAIT_sPARAMETRO_ID = 10 and gp.PAIT_vVALOR = op.OSER_sGRADOPROFESIONAL and gp.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sl on (sl.PAIT_sPARAMETRO_ID = 11 and sl.PAIT_vVALOR = op.OSER_sSITUACIONLABORAL and sl.PAIT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sr on (sr.PAIT_sPARAMETRO_ID = 6 and sr.PAIT_vVALOR = op.OSER_sSITUACION and sr.PAIT_cESTADO = 'A')
			Where	
					op.OSER_cESTADO = 'A' and (
					(os.ORGA_vABREVIATURA Like '%' + @p_page_search + '%') or
					(op.OSER_vAPELLIDOS like '%' + @p_page_search + '%') or
					(tp.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(gp.PAIT_vTEXTO like '%' + @p_page_search + '%') or
					(sr.PAIT_vTEXTO like '%' + @p_page_search + '%'))
			Order by
					case when @p_page_sort = 0 and @p_page_dir = 'asc' then op.OSER_sORGSER_PERSONAL_ID end,
					case when @p_page_sort = 0 and @p_page_dir = 'desc' then op.OSER_sORGSER_PERSONAL_ID end desc,

					case when @p_page_sort = 2 and @p_page_dir = 'asc' then op.OSER_vAPELLIDOS end,
					case when @p_page_sort = 2 and @p_page_dir = 'desc' then op.OSER_vAPELLIDOS end desc,

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then gp.PAIT_vTEXTO end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then gp.PAIT_vTEXTO end desc

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
Go


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
			's_per_nac' = OSER_sNACIONALIDAD, 
			's_per_civ' = OSER_sESTADOCIVIL, 
			's_per_mai' = OSER_vEMAIL,
			'i_gen_sid' = OSER_sGENERO, 
			'i_dis_sid' = OSER_bINDDISCAPACIDAD, 
			'i_gra_sid' = OSER_sGRADOPROFESIONAL, 
			'i_esp_sid' = OSER_sESPECIALIDAD, 
			's_per_obs' = OSER_vOBSERVACION, 
			's_lab_sid' = OSER_sSITUACIONLABORAL, 
			's_reg_sid' = OSER_sSITUACION, 

			'i_con_tdc' = OSPC_sTIPODOCUMENTO,
			'i_con_ref' = OSPC_sREFERENCIA,
			's_con_num' = pc.OSPC_vNUMERODOCUMENTO,
			's_con_fec' = Convert(varchar(10), OSPC_dFECHACONTRATO, 103),
			's_con_ini' = Convert(varchar(10), OSPC_dFECHAINICIO, 103),
			's_con_fin' = Convert(varchar(10), OSPC_dFECHATERMINO, 103),
			'i_con_tie' = OSPC_bINDEFINIDO,
			'i_car_sid' = OSPC_sCARGO,
			'i_mon_sid' = OSPC_sMONEDA,
			'n_con_rem' = OSPC_dREMUNERACION_BRUTA,
			's_con_ifn' = Convert(varchar(10), OSPC_dFECHAINIFUNCION, 103),
			's_con_dau' = OSPC_DOCUMENTOAUTOR,
			's_con_dfe' = Convert(varchar(10), OSPC_DOCUMENTOAUTFECHA, 103),
			'i_con_tco' = OSPC_sTIPOCONTRATO,
			's_con_obs' = OSPC_vOBSERVACION,
			'i_con_uco' = OSPC_bULTIMOCONTRATO,
			'i_con_sit' = OSPC_sSITUACION,

			'i_usr' = isnull(op.OSER_sUSUARIO_CREACION, OSER_sUSUARIO_MODIFICACION),
			's_usr' = Concat(us.USUA_vAPELLIDOS, ', ',  USUA_vNOMBRES),
			's_ipu' = isnull(op.OSER_vIP_CREACION, OSER_vIP_MODIFICACION),
			's_fcr' = Convert(varchar(10), isnull(OSER_dFECHA_CREACION, OSER_dFECHA_MODIFICACION), 103) 
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
			Left Join SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO pc on (pc.OSPC_sOSPE_PERSONAL_ID = op.OSER_sORGSER_PERSONAL_ID and OSPC_bULTIMOCONTRATO = 1 and pc.OSPC_cESTADO = 'A')
			Inner Join SC_COMUN.SE_USUARIO us on (us.USUA_sUSUARIO_ID = Isnull(op.OSER_sUSUARIO_MODIFICACION, op.OSER_sUSUARIO_CREACION))
	Where	
			op.OSER_sORGSER_PERSONAL_ID = @p_sid and
			op.OSER_cESTADO = 'A'
End
go


if (object_id(N'SC_COMUN.USP_ORGSER_PERSONAL_PLANILLA_byID') is not null)
	drop procedure SC_COMUN.USP_ORGSER_PERSONAL_PLANILLA_byID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la informacion de aportes y descuentos de un trabajador de OSE en base a su id de contrato
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_PERSONAL_PLANILLA_byID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_PERSONAL_PLANILLA_byID (
	@p_sid		Smallint
)
As
Begin
	Select	'i_sid' = pp.OSPL_sOSP_PLANILLA_ID, 
			'i_con' = pp.OSPL_sTIPOCONCEPTO, 
			's_con' = tc.PAIT_vTEXTO,
			's_des' = pp.OSPL_vCONCEPTO, 
			's_inc' = case pp.OSPL_bINCREMENTAL
				when 1 then 'INCREMENTO'
				else 'DEDUCCIÓN' end,
			's_afe' = case pp.OSPL_bAFECTOAPORTES
				when 0 then 'NO AFECTO'
				else 'AFECTO' end,
			's_tpo' = case pp.OSPL_bTIPOAFECTACIONPERCET
				when 1 then 'PORCENTUAL'
				else 'NOMINAL' end,

			'i_mon' = pp.OSPL_dMONTOAFECTACION, 

			'i_sit' = pp.OSPL_sSITUACION, 
			'i_cru' = pp.OSPL_sUSUARIO_CREACION, 
			's_cri' = pp.OSPL_vIP_CREACION, 
			's_crf' = convert(varchar(10), pp.OSPL_dFECHA_CREACION, 103)
	From	
			[SC_COMUN].[SE_ORGANOSERVICIO_PERSONAL_PLANILLA] pp
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM tc on (tc.PAIT_sPARAMETRO_ID = 14 and tc.PAIT_vVALOR = pp.OSPL_sTIPOCONCEPTO and tc.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO cc on (cc.OSPC_sOSP_CONTRATO_ID = pp.OSPL_sOSPC_CONTRATO_ID and cc.OSPC_bULTIMOCONTRATO = 1 and OSPC_cESTADO = 'A')
	Where
			pp.OSPL_sOSPC_CONTRATO_ID = @p_sid and
			pp.OSPL_cESTADO = 'A'
End
go


if (object_id(N'SC_COMUN.USP_PERSONAL_GRABAR') is not null)
	drop procedure SC_COMUN.USP_PERSONAL_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Inserta un empleado local
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PERSONAL_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERSONAL_GRABAR(
	@p_sid	int,
	@p_ido	int,

	@p_ape	varchar(45),
	@p_nom	varchar(45),
	@p_fna	varchar(10),

	@p_gen	smallint,
	@p_dis	bit,
	@p_nac	smallint,

	@p_tdc	int,			-- Tipo documento
	@p_ndc	varchar(25),	-- Numero documento
	@p_mai	varchar(60),

	@p_ecv	smallint,
	@p_grd	smallint,
	@p_esp	smallint,
	@p_tps	smallint,

	@p_obs	varchar(max),
	@p_sla	smallint,
	@p_sit	smallint,

	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
As
Begin
	Declare	@l_cant		int,
			@l_Id		int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1,

			@c_situacion_laboral_activa int = 1

	if (@p_sid = 0)
		begin
			-- Empleado nuevo # Comprueba que el empleado no exista
			Select @l_cant = Count(1) From SC_COMUN.SE_ORGANOSERVICIO_PERSONAL Where OSER_vAPELLIDOS = @p_ape and OSER_vNOMBRES = @p_nom and OSER_sSITUACIONLABORAL = @c_situacion_laboral_activa and OSER_cESTADO = 'A'

			if (@l_cant = 0)
				begin
					-- No existe # inserta el registro
					begin transaction
						Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL (
								OSER_sORGANOSERVICIO_ID, OSER_vAPELLIDOS, OSER_vNOMBRES, OSER_dFECHANACIMIENTO, 
								OSER_sGENERO, OSER_bINDDISCAPACIDAD, OSER_sNACIONALIDAD, 
								OSER_sTIPODOCUMENTO,OSER_vNUMERODOCUMENTO,OSER_vEMAIL,
								OSER_sESTADOCIVIL, OSER_sGRADOPROFESIONAL, OSER_sESPECIALIDAD, OSER_sTIPOPERSONAL, 
								OSER_sSITUACIONLABORAL, OSER_sSITUACION, 
								OSER_sUSUARIO_CREACION, OSER_vIP_CREACION)
						Values (
								@p_ido, @p_ape, @p_nom, convert(datetime, @p_fna, 103), 
								@p_gen, @p_dis, @p_nac, 
								@p_tdc, @p_ndc, @p_mai,
								@p_ecv, @p_grd, @p_esp, @p_tps,
								@p_sla, @p_sit,
								@p_usr, @p_ipc)
						set	@l_Id = scope_identity();
					commit;
					set @l_Id		= @l_Id;
					set @l_mensaje	= 'Se grabaron los datos del nuevo personal local.'
					set @l_status	= 1;
					set @l_bs_tipo	= 1;
				end
			else
				begin
					-- El empleado ya existe
					set @l_Id		= 0;
					set @l_mensaje	= 'El personal local ya existe en la base de datos en situacion laboral activo.'
					set @l_status	= 1;
					set @l_bs_tipo	= 1;
				end
		end
	else
		begin
			-- Actualización de datos
			Update	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL
			Set		OSER_sORGANOSERVICIO_ID = @p_ido,
					OSER_vAPELLIDOS = @p_ape, 
					OSER_vNOMBRES = @p_nom,
					OSER_dFECHANACIMIENTO = convert(datetime, @p_fna, 103),
					OSER_sGENERO = @p_gen,
					OSER_bINDDISCAPACIDAD = @p_dis,
					OSER_sNACIONALIDAD = @p_nac,
					OSER_sTIPODOCUMENTO = @p_tdc,
					OSER_vNUMERODOCUMENTO = @p_ndc,
					OSER_vEMAIL = @p_mai,
					OSER_sESTADOCIVIL = @p_ecv,
					OSER_sGRADOPROFESIONAL = @p_grd,
					OSER_sESPECIALIDAD = @p_esp,
					OSER_sTIPOPERSONAL = @p_tps,
					OSER_sSITUACIONLABORAL = @p_sla,
					OSER_sSITUACION = @p_sit,
					OSER_vOBSERVACION = @p_obs,
					OSER_sUSUARIO_MODIFICACION = @p_usr,
					OSER_vIP_MODIFICACION = @p_ipc,
					OSER_dFECHA_MODIFICACION = getdate()
			Where
					OSER_sORGSER_PERSONAL_ID = @p_sid

			set @l_Id		= 0;
			set @l_mensaje	= 'Se actualizaron los datos del personal local.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end 
go


If (object_id('SC_COMUN.TRG_PERSONAL_ACTUALIZAR') is not null)
Begin
      Drop Trigger SC_COMUN.TRG_PERSONAL_ACTUALIZAR
End
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Desencadenante de actualización de datos de Personal Local
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec	SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR 1, 7, 144
	
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/	
Create Trigger SC_COMUN.TRG_PERSONAL_ACTUALIZAR 
On SC_COMUN.SE_ORGANOSERVICIO_PERSONAL 
For Update
As
Begin

	IF (update(OSER_sORGANOSERVICIO_ID))
		Begin
			Declare @l_ose_old varchar(50),
					@l_ose_new varchar(50)

			Select	@l_ose_old = ORGA_vABREVIATURA
			From	SC_COMUN.SE_ORGANOSERVICIO Ose
					Inner Join deleted d on (d.OSER_sORGANOSERVICIO_ID = ose.ORGA_sORGANOSERVICIO_ID)

			Select	@l_ose_new = ORGA_vABREVIATURA
			From	SC_COMUN.SE_ORGANOSERVICIO Ose
					Inner Join inserted i on (i.OSER_sORGANOSERVICIO_ID = ose.ORGA_sORGANOSERVICIO_ID)

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sORGANOSERVICIO_ID', 'ORGANO DE SERVICIO', @l_ose_old, @l_ose_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sORGANOSERVICIO_ID <> i.OSER_sORGANOSERVICIO_ID)
		
		End

	IF (update(OSER_vAPELLIDOS))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_vAPELLIDOS', 'APELLIDOS', d.OSER_vAPELLIDOS, i.OSER_vAPELLIDOS, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_vAPELLIDOS <> i.OSER_vAPELLIDOS)

	IF (update(OSER_vNOMBRES))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_vNOMBRES', 'NOMBRES', d.OSER_vNOMBRES, i.OSER_vNOMBRES, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_vNOMBRES <> i.OSER_vNOMBRES)

	IF (update(OSER_sTIPODOCUMENTO))
		Begin
			Declare @l_tipodoc_old varchar(50),
					@l_tipodoc_new varchar(50)

			SELECT	@l_tipodoc_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sTIPODOCUMENTO = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'TIPO_DOCUMENTO_IDENTIDAD' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_tipodoc_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sTIPODOCUMENTO = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'TIPO_DOCUMENTO_IDENTIDAD' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sTIPODOCUMENTO', 'TIPO DOCUMENTO IDENTIDAD', @l_tipodoc_old, @l_tipodoc_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sTIPODOCUMENTO <> i.OSER_sTIPODOCUMENTO)
		End

	IF (update(OSER_vNUMERODOCUMENTO))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_vNUMERODOCUMENTO', 'NUMERO DOCUMENTO IDENTIDAD', d.OSER_vNUMERODOCUMENTO, i.OSER_vNUMERODOCUMENTO, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_vNUMERODOCUMENTO <> i.OSER_vNUMERODOCUMENTO)

	
	IF (update(OSER_sTIPOPERSONAL))
		Begin
			Declare @l_tipoper_old varchar(50),
					@l_tipoper_new varchar(50)

			SELECT	@l_tipoper_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sTIPOPERSONAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'TIPO_PERSONAL_OSE' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_tipoper_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sTIPOPERSONAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'TIPO_PERSONAL_OSE' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sTIPOPERSONAL', 'TIPO DE PERSONAL', @l_tipoper_old, @l_tipoper_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sTIPOPERSONAL <> i.OSER_sTIPOPERSONAL)
		End

	IF (update(OSER_dFECHANACIMIENTO))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_dFECHANACIMIENTO', 'FECHA DE NACIMIENTO', convert(varchar(10), d.OSER_dFECHANACIMIENTO, 103), convert(varchar(10), i.OSER_dFECHANACIMIENTO, 103), 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_dFECHANACIMIENTO <> i.OSER_dFECHANACIMIENTO)

	IF (update(OSER_sNACIONALIDAD))
		Begin
			Declare @l_nacionalidad_old varchar(50),
					@l_nacionalidad_new varchar(50)

			SELECT	@l_nacionalidad_old = ps.PAIS_vGENTILICIO
			FROM	SC_COMUN.SE_PAIS ps
					Inner Join  deleted d on (d.OSER_sNACIONALIDAD = ps.PAIS_sPAIS_ID)

			SELECT	@l_nacionalidad_new = ps.PAIS_vGENTILICIO
			FROM	SC_COMUN.SE_PAIS ps
					Inner Join  inserted i on (i.OSER_sNACIONALIDAD = ps.PAIS_sPAIS_ID)

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sNACIONALIDAD', 'NACIONALIDAD', @l_nacionalidad_old, @l_nacionalidad_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sNACIONALIDAD <> i.OSER_sNACIONALIDAD)
		End
		
	IF (update(OSER_sESTADOCIVIL))
		Begin
			Declare @l_ecivil_old varchar(50),
					@l_ecivil_new varchar(50)

			SELECT	@l_ecivil_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sESTADOCIVIL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'ESTADO_CIVIL' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_ecivil_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sESTADOCIVIL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'ESTADO_CIVIL' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sESTADOCIVIL', 'ESTADO CIVIL', @l_ecivil_old, @l_ecivil_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sESTADOCIVIL <> i.OSER_sESTADOCIVIL)
		End
		
	IF (update(OSER_vEMAIL))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_vEMAIL', 'EMAIL', d.OSER_vEMAIL, i.OSER_vEMAIL, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_vEMAIL <> i.OSER_vEMAIL)

	IF (update(OSER_sGENERO))
		Begin
			Declare @l_genero_old varchar(50),
					@l_genero_new varchar(50)

			SELECT	@l_genero_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sGENERO = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'IDENTIDAD_GENERO' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_genero_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sGENERO = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'IDENTIDAD_GENERO' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sGENERO', 'GENERO', @l_genero_old, @l_genero_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sGENERO <> i.OSER_sGENERO)
		End

	IF (update(OSER_bINDDISCAPACIDAD))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_bINDDISCAPACIDAD', 'DISCAPACIDAD', CASE d.OSER_bINDDISCAPACIDAD WHEN 0 THEN 'NO' ELSE 'SI' END, CASE i.OSER_bINDDISCAPACIDAD WHEN 0 THEN 'NO' ELSE 'SI' END, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_bINDDISCAPACIDAD <> i.OSER_bINDDISCAPACIDAD)
	

	IF (update(OSER_sGRADOPROFESIONAL))
		Begin
			Declare @l_grado_old varchar(50),
					@l_grado_new varchar(50)

			SELECT	@l_grado_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sGRADOPROFESIONAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'GRADO_PROFESIONAL' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_grado_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sGRADOPROFESIONAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'GRADO_PROFESIONAL' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sGRADOPROFESIONAL', 'GRADO PROFESIONAL', @l_grado_old, @l_grado_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sGRADOPROFESIONAL <> i.OSER_sGRADOPROFESIONAL)
		End

	IF (update(OSER_sESPECIALIDAD))
		Begin
			Declare @l_esp_old varchar(50),
					@l_esp_new varchar(50)

			SELECT	@l_esp_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sESPECIALIDAD = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'ESPECIALIDAD_ESTUDIOS' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_esp_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sESPECIALIDAD = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'ESPECIALIDAD_ESTUDIOS' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sESPECIALIDAD', 'ESPECIALIDAD', @l_esp_old, @l_esp_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sESPECIALIDAD <> i.OSER_sESPECIALIDAD)
		End


	IF (update(OSER_vOBSERVACION))
		Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
					AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
		Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
				'OSER_vOBSERVACION', 'OBSERVACION', d.OSER_vOBSERVACION, i.OSER_vOBSERVACION, 
				i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
		From	deleted d 
				Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_vOBSERVACION <> i.OSER_vOBSERVACION)

	IF (update(OSER_sSITUACIONLABORAL))
		Begin
			Declare @l_sitlab_old varchar(50),
					@l_sitlab_new varchar(50)

			SELECT	@l_sitlab_old = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  deleted d on (d.OSER_sSITUACIONLABORAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'SITUACION_LABORAL' and
					pm.PARA_cESTADO = 'A'

			SELECT	@l_sitlab_new = it.PAIT_vTEXTO
			FROM	[SC_COMUN].[SE_PARAMETRO]  pm
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] it on (it.PAIT_sPARAMETRO_ID = pm.PARA_sPARAMETRO_ID)
					Inner Join  inserted i on (i.OSER_sSITUACIONLABORAL = it.PAIT_vVALOR)
			WHERE	
					pm.PARA_vNOMBRE = 'SITUACION_LABORAL' and
					pm.PARA_cESTADO = 'A'

			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, 
						AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sSITUACIONLABORAL', 'SITUACION LABORAL', @l_sitlab_old, @l_sitlab_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sSITUACIONLABORAL <> i.OSER_sSITUACIONLABORAL)
		End


	IF (update(OSER_sSITUACION))
		Begin
			Declare @l_sit_old	varchar(50),
					@l_sit_new	varchar(50),
					@c_param_tipo_situacion int = 6

			Set	@l_sit_old = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join deleted d on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_situacion and d.OSER_sSITUACION = pa.PAIT_vVALOR))
			Set	@l_sit_new = (Select Top 1 pa.PAIT_vTEXTO From SC_COMUN.SE_PARAMETRO_ITEM pa Inner Join inserted i on (pa.PAIT_sPARAMETRO_ID = @c_param_tipo_situacion and i.OSER_sSITUACION = pa.PAIT_vVALOR))
		
			Insert Into SC_SYSTEM.SE_AUDITORIA (AUDI_iMODULO, AUDI_vTABLA, AUDI_vTABLA_DES, AUDI_iEVENTO_ID, AUDI_iREGISTRO_ID, AUDI_vCAMPO, AUDI_vCAMPO_DES, AUDI_vDATO_ANTERIOR, AUDI_vDATO_NUEVO, AUDI_sUSUARIO_CREACION, AUDI_vIP_CREACION) 
			Select	2, 'SE_ORGANOSERVICIO_PERSONAL', 'PERSONAL LOCAL', 2, d.OSER_sORGSER_PERSONAL_ID, 
					'OSER_sSITUACION', 'SITUACION', @l_sit_old, @l_sit_new, 
					i.OSER_sUSUARIO_MODIFICACION, i.OSER_vIP_MODIFICACION
			From	deleted d 
					Inner Join inserted i on (i.OSER_sORGSER_PERSONAL_ID = d.OSER_sORGSER_PERSONAL_ID and d.OSER_sSITUACION <> i.OSER_sSITUACION)
		End
End
go


if (object_id(N'SC_REPORTES.USP_PERSONAL_EXPORTAR') is not null)
	drop procedure SC_REPORTES.USP_PERSONAL_EXPORTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve todos los registros para el reporte de personal local en Excel
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_REPORTES.USP_PERSONAL_EXPORTAR 0

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_REPORTES.USP_PERSONAL_EXPORTAR(
	@p_sid	smallint
)
As
Begin
	if (@p_sid =0)
		begin
			Select	'oseabr' = os.ORGA_vABREVIATURA,
					'perape' = OSER_vAPELLIDOS, 
					'pernom' = OSER_vNOMBRES, 
					'doctip' = IsNull(td.PAIT_vTEXTO, 'NO ESPECIFICADO'), 
					'docnum' = OSER_vNUMERODOCUMENTO, 
					'pertip' = tp.PAIT_vTEXTO,
					'pernac' = Convert(varchar(10), OSER_dFECHANACIMIENTO, 103), 
					'pergen' = ps.PAIS_vGENTILICIO, 
					'perciv' = ec.PAIT_vTEXTO, 
					'permai' = OSER_vEMAIL,
					'pergen' = ge.PAIT_vTEXTO, 
					'perdis' = case when OSER_bINDDISCAPACIDAD = 0 then 'NO' else 'SI' end, 
					'pergra' = gp.PAIT_vTEXTO, 
					'peresp' = IsNull(es.PAIT_vTEXTO,'NO ESPECIFICADO'),
					'perobs' = OSER_vOBSERVACION, 
					'persit' = sl.PAIT_vTEXTO, 
					'perreg' = st.PAIT_vTEXTO
			From	
					SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
					Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = op.OSER_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM td on (td.PAIT_sPARAMETRO_ID = 15 and td.PAIT_vVALOR = OSER_sTIPODOCUMENTO and td.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM tp on (tp.PAIT_sPARAMETRO_ID = 7 and tp.PAIT_vVALOR = OSER_sTIPOPERSONAL and tp.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = OSER_sNACIONALIDAD and ps.PAIS_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM ec on (ec.PAIT_sPARAMETRO_ID = 8 and ec.PAIT_vVALOR = OSER_sESTADOCIVIL and ec.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM ge on (ge.PAIT_sPARAMETRO_ID = 9 and ge.PAIT_vVALOR = OSER_sGENERO and ge.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM gp on (gp.PAIT_sPARAMETRO_ID = 10 and gp.PAIT_vVALOR = OSER_sGRADOPROFESIONAL and gp.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM es on (es.PAIT_sPARAMETRO_ID = 18 and es.PAIT_vVALOR = OSER_sESPECIALIDAD and es.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM sl on (sl.PAIT_sPARAMETRO_ID = 11 and sl.PAIT_vVALOR = OSER_sSITUACIONLABORAL and sl.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM st on (st.PAIT_sPARAMETRO_ID = 6 and st.PAIT_vVALOR = OSER_sSITUACION and st.PAIT_cESTADO = 'A')
			Where	
					op.OSER_cESTADO = 'A'
		end
	else
		begin
			Select	'oseabr' = os.ORGA_vABREVIATURA,
					'perape' = OSER_vAPELLIDOS, 
					'pernom' = OSER_vNOMBRES, 
					'doctip' = IsNull(td.PAIT_vTEXTO, 'NO ESPECIFICADO'), 
					'docnum' = OSER_vNUMERODOCUMENTO, 
					'pertip' = tp.PAIT_vTEXTO,
					'pernac' = Convert(varchar(10), OSER_dFECHANACIMIENTO, 103), 
					'pergen' = ps.PAIS_vGENTILICIO, 
					'perciv' = ec.PAIT_vTEXTO, 
					'permai' = OSER_vEMAIL,
					'pergen' = ge.PAIT_vTEXTO, 
					'perdis' = case when OSER_bINDDISCAPACIDAD = 0 then 'NO' else 'SI' end, 
					'pergra' = gp.PAIT_vTEXTO, 
					'peresp' = IsNull(es.PAIT_vTEXTO,'NO ESPECIFICADO'),
					'perobs' = OSER_vOBSERVACION, 
					'persit' = sl.PAIT_vTEXTO, 
					'perreg' = st.PAIT_vTEXTO
			From	
					SC_COMUN.SE_ORGANOSERVICIO_PERSONAL op
					Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = op.OSER_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM td on (td.PAIT_sPARAMETRO_ID = 15 and td.PAIT_vVALOR = OSER_sTIPODOCUMENTO and td.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM tp on (tp.PAIT_sPARAMETRO_ID = 7 and tp.PAIT_vVALOR = OSER_sTIPOPERSONAL and tp.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = OSER_sNACIONALIDAD and ps.PAIS_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM ec on (ec.PAIT_sPARAMETRO_ID = 8 and ec.PAIT_vVALOR = OSER_sESTADOCIVIL and ec.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM ge on (ge.PAIT_sPARAMETRO_ID = 9 and ge.PAIT_vVALOR = OSER_sGENERO and ge.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM gp on (gp.PAIT_sPARAMETRO_ID = 10 and gp.PAIT_vVALOR = OSER_sGRADOPROFESIONAL and gp.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM es on (es.PAIT_sPARAMETRO_ID = 18 and es.PAIT_vVALOR = OSER_sESPECIALIDAD and es.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM sl on (sl.PAIT_sPARAMETRO_ID = 11 and sl.PAIT_vVALOR = OSER_sSITUACIONLABORAL and sl.PAIT_cESTADO = 'A')
					Left Join SC_COMUN.SE_PARAMETRO_ITEM st on (st.PAIT_sPARAMETRO_ID = 6 and st.PAIT_vVALOR = OSER_sSITUACION and st.PAIT_cESTADO = 'A')
			Where	
					op.OSER_sORGANOSERVICIO_ID = @p_sid and
					op.OSER_cESTADO = 'A'

		end
End
Go


if (object_id(N'SC_COMUN.USP_PERSONAL_GRABAR_CONTRATO') is not null)
	drop procedure SC_COMUN.USP_PERSONAL_GRABAR_CONTRATO
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Inserta o actualiza un contrato
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PERSONAL_GRABAR_CONTRATO

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERSONAL_GRABAR_CONTRATO(
	@p_sid			Smallint,
	@p_per_sid		Smallint,
	@p_ose_sid		Smallint,
	@p_con_tip		Smallint,
	@p_con_ref		Smallint,

	@p_con_num		Varchar(25),
	@p_con_fec		Varchar(10),
	@p_con_ini		varchar(10),
	@p_con_fin		varchar(10),
	
	@p_con_ind		bit,
	
	@p_con_car		Smallint,
	@p_con_mon		Smallint,
	
	@p_con_rem		Decimal(14,2),
	@p_con_fun		Varchar(10),
	@p_con_aut		Varchar(25),
	@p_con_autfec	Varchar(10),
	@p_con_tco		Smallint,
	@p_con_obs		Varchar(max),
	--
	@p_con_sit		Smallint,
	--
	@p_usr			varchar(12),
	@p_ipc			varchar(15)
)
As
Begin
	Declare	@l_cant		int,
			@l_Id		int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1,

			@c_situacion_laboral_activa int = 1
	
	-- Sólo insertar datos datos, si ya existe actualizar
	-- next release: Adicionar adenda.
	Select @l_cant = Count(1)	From	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO 
								Where	OSPC_sOSPE_PERSONAL_ID = @p_per_sid and OSPC_cESTADO = 'A'
	
	if (@p_sid = 0)
		begin
			-- Inserta un nuevo contrato/adenda
			begin transaction
				Insert Into SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO (
					OSPC_sOSPE_PERSONAL_ID, 
					OSPC_sORGANO_SERVICIO_ID, 
					OSPC_sTIPODOCUMENTO, 
					OSPC_sREFERENCIA, 
					OSPC_vNUMERODOCUMENTO,
					OSPC_dFECHACONTRATO,
					OSPC_dFECHAINICIO,
					OSPC_dFECHATERMINO,
					OSPC_bINDEFINIDO,

					OSPC_sCARGO,
					OSPC_sMONEDA,
					OSPC_dREMUNERACION_BRUTA,
					OSPC_dFECHAINIFUNCION,
					OSPC_DOCUMENTOAUTOR,
					OSPC_DOCUMENTOAUTFECHA,
					OSPC_sTIPOCONTRATO,
					OSPC_vOBSERVACION,
					OSPC_sSITUACION,
					OSPC_sUSUARIO_CREACION,
					OSPC_vIP_CREACION) 
				Values 
				(
					@p_per_sid, @p_ose_sid, @p_con_tip, @p_con_ref, @p_con_num, convert(datetime,@p_con_fec, 103), 
					convert(datetime, @p_con_ini, 103), convert(datetime, @p_con_fin, 103), @p_con_ind,
					@p_con_car, @p_con_mon, @p_con_rem, convert(datetime, @p_con_fun, 103), @p_con_aut, convert(datetime, @p_con_autfec, 103), @p_con_tco,
					@p_con_obs,
					@p_con_sit, @p_usr, @p_ipc
				)
				set	@l_Id = scope_identity();
			commit;

			set @l_Id		= @l_Id;
			set @l_mensaje	= 'Se grabaron los datos del nuevo personal local.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			-- actualiza el contrato adenda
			Update	SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO
			Set		OSPC_sOSPE_PERSONAL_ID = @p_per_sid,
					OSPC_sORGANO_SERVICIO_ID = @p_ose_sid, 
					OSPC_sTIPODOCUMENTO = @p_con_tip, 
					OSPC_sREFERENCIA = @p_con_ref, 
					OSPC_vNUMERODOCUMENTO = @p_con_num,
					OSPC_dFECHACONTRATO = convert(datetime, @p_con_fec, 103),
					OSPC_dFECHAINICIO = convert(datetime, @p_con_ini, 103),
					OSPC_dFECHATERMINO = convert(datetime, @p_con_fin, 103),
					OSPC_bINDEFINIDO = @p_con_ind,

					OSPC_sCARGO = @p_con_car,
					OSPC_sMONEDA = @p_con_mon,
					OSPC_dREMUNERACION_BRUTA = @p_con_rem,
					OSPC_dFECHAINIFUNCION = convert(datetime, @p_con_fun, 103),
					OSPC_DOCUMENTOAUTOR = @p_con_aut,
					OSPC_DOCUMENTOAUTFECHA = convert(datetime, @p_con_autfec, 103),
					OSPC_sTIPOCONTRATO = @p_con_tco,
					OSPC_vOBSERVACION = @p_con_obs,
					OSPC_sSITUACION = @p_con_sit,
					OSPC_sUSUARIO_MODIFICACION = @p_usr,
					OSPC_vIP_MODIFICACION = @p_ipc
			Where	
					OSPC_sOSP_CONTRATO_ID = @p_sid

			set @l_Id		= 0;
			set @l_mensaje	= 'Se actualizaron los datos del personal local.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;

		end
	
	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end 
go


if (object_id(N'SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BYID') is not null)
	drop procedure SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Lista simple de contratos y adendas de un trabajador
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BYID(
	@p_sid	int
)
As
Begin

	Select	'i_con_sid' = OSPC_sOSP_CONTRATO_ID,
			'i_per_sid' = OSPC_sOSPE_PERSONAL_ID, 
			'i_ose_sid' = OSPC_sORGANO_SERVICIO_ID, 
			'i_con_tipdoc' = OSPC_sTIPODOCUMENTO, 
			'i_con_docref' = OSPC_sREFERENCIA, 
			's_con_num' = OSPC_vNUMERODOCUMENTO,
			's_con_feccon' = convert(varchar(10), OSPC_dFECHACONTRATO, 103),
			's_con_fecini' = convert(varchar(10), OSPC_dFECHAINICIO, 103),
			's_con_fecfin' = convert(varchar(10), OSPC_dFECHATERMINO, 103),
			's_con_ind' = OSPC_bINDEFINIDO,
			's_con_car' = OSPC_sCARGO,
			's_con_mon' = OSPC_sMONEDA,
			'i_con_rem' = OSPC_dREMUNERACION_BRUTA,
			's_con_fecfun' = convert(varchar(10), OSPC_dFECHAINIFUNCION, 103),
			's_con_docaut' = OSPC_DOCUMENTOAUTOR,
			's_con_fecaut' = convert(varchar(10), OSPC_DOCUMENTOAUTFECHA, 103),
			'i_con_tip' = OSPC_sTIPOCONTRATO,
			's_con_obs' = OSPC_vOBSERVACION,
			'i_con_sit' = OSPC_sSITUACION
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO
	Where
			OSPC_sOSP_CONTRATO_ID = @p_sid and
			OSPC_cESTADO = 'A'
End
Go


if (object_id(N'SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BASE') is not null)
	drop procedure SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BASE
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Lista simple de contratos y adendas de un trabajador
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BASE 40

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BASE(
	@p_sid_per	int
)
As
Begin
	Select	'i_sid' = con.OSPC_sOSP_CONTRATO_ID, 
			's_con' = Concat(
				p.PAIT_vTEXTO, ' ', 
				RIGHT('00000'+CAST(con.OSPC_vNUMERODOCUMENTO AS VARCHAR(3)),5), '-', 
				Convert(varchar(10), con.OSPC_dFECHACONTRATO, 103))
	From	
			SC_COMUN.SE_ORGANOSERVICIO_PERSONAL_CONTRATO con
			Inner Join (
				Select	pit.PAIT_vVALOR, pit.PAIT_vTEXTO 
				From	SC_COMUN.SE_PARAMETRO par
						Inner Join SC_COMUN.SE_PARAMETRO_ITEM  pit on (pit.PAIT_sPARAMETRO_ID = par.PARA_sPARAMETRO_ID and pit.PAIT_cESTADO = 'A')
				Where	
						par.PARA_vNOMBRE = 'TIPO_DOC_CONTRATO'
			) p on (p.PAIT_vVALOR = con.OSPC_sTIPODOCUMENTO) 
	Where 
			OSPC_sOSPE_PERSONAL_ID = @p_sid_per
End
go

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	CLASIFICADOR DE GASTOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

if (object_id(N'SC_COMUN.USP_CLASIFICADORITEM_LISTAR') is not null)
	drop procedure SC_COMUN.USP_CLASIFICADORITEM_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los items del clasificador de gastos vigente
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_CLASIFICADORITEM_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_CLASIFICADORITEM_LISTAR
As
Begin
	Select	'i_sid' = ci.CLIT_sCLASIFICADORITEM_ID, 
			'i_cid' = ci.CLIT_sCLASIFICADORGASTO_ID, 
			's_nom' = ci.CLIT_NOMBRE, 
			's_cls' = ci.CLIT_CODIGOCLASE, 
			'i_isp' = ci.CLIT_ITEMSUPERIOR, 
			'i_niv' = ci.CLIT_ITEMNIVEL, 
			'i_tpo' = ci.CLIT_ITEMTIPO, 
			'i_grp' = ci.CLIT_ISGRUPO, 
			'i_cch' = ci.CLIT_ISCAJA
	From	
			SC_COMUN.SE_CLASIFICADORITEM ci
			Inner Join SC_COMUN.SE_CLASIFICADORGASTO cg on (cg.CLAS_sCLASIFICADOR_ID = ci.CLIT_sCLASIFICADORGASTO_ID and cg.CLAS_dDESDE < getdate() and getdate() < cg.CLAS_dHASTA and cg.CLAS_cESTADO = 'A')
	Where	
			ci.CLIT_cESTADO = 'A'
End
Go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROGRAMAS DE POLÍTICA EXTERIOR
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


if (object_id(N'SC_COMUN.USP_PROGRAMAITEM_LISTAR_byOSE') is not null)
	drop procedure SC_COMUN.USP_PROGRAMAITEM_LISTAR_byOSE
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve programas de política exterior según el tipo de órgano de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PROGRAMAITEM_LISTAR_byOSE 2

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_PROGRAMAITEM_LISTAR_byOSE (@p_sid int)
As
begin
	Select	'i_sid' = PROG_sPROGRAMAITEM_ID, 
			's_nom' = pit.PROG_vNOMBRE, 
			's_abr' = pit.PROG_vABREVIATURALG
	From	
			SC_COMUN.SE_PROGRAMAOSE pose
			Inner Join SC_COMUN.SE_PROGRAMAITEM pit on (pit.PROG_sPROGRAMAITEM_ID = pose.PROS_sPROGRAMAITEM and pit.PROG_cESTADO = 'A')
	Where	
			PROS_sTIPOORGANOSERVICIO = @p_sid and 
			PROS_cESTADO = 'A'
End
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	ACTUALIZACION DE CUENTAS CORRIENTES 
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

if (object_id(N'SC_COMUN.USP_CUENTACORRIENTE_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_CUENTACORRIENTE_LISTAR_TODT
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de cuentas corrientes para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_page_nmber	Número de página
	@p_page_rows	Cantidad de registros por página
	@p_page_search	Buscador
	@p_page_sort	Orden
	@p_page_dir		Dirección del orden
	@p_page_flt		Filtro
	@p_rows_totl	Total de registros

Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_CUENTACORRIENTE_LISTAR_TODT 0, 5, '', 0, 'asc', 0, @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_CUENTACORRIENTE_LISTAR_TODT (
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
	Declare @paramItem_DestinoCuenta int = 3; -- Desde Interno.ParametroItem [Parametro = 3]
	
	if (@p_page_flt = 0)
		begin
			-- sin filtro
			Select	@p_rows_totl = Count(1)
			From	SC_COMUN.SE_CUENTACORRIENTE
			Where	CUEN_cESTADO = 'A'

			Select	'i_ctarow' = row_number() over (order by CUEN_sCUENTACORRIENTE_ID),
					'i_ctasid' = CUEN_sCUENTACORRIENTE_ID, 
					's_osenom' = Ose.ORGA_vABREVIATURA,
					's_ctanro' = CUEN_vNUMEROCUENTA, 
					's_ctaiso' = Mnd.MONE_cISO4217,
					's_bannom' = Concat(Ban.BANC_vNOMBRE,'-',Age.BAAG_vNOMBREAGENCIA),
					's_ctacom' = Case When cta.CUEN_bESCOMPARTIDA = 0 Then 'NO' Else 'SI' end,
					'i_ctasit' = cta.CUEN_tSITUACION,
					's_ctasit' = sr.PAIT_vTEXTO
			From	
					SC_COMUN.SE_CUENTACORRIENTE Cta
					Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and Det.ORCT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_ORGANOSERVICIO Ose on (Ose.ORGA_sORGANOSERVICIO_ID = Det.ORCT_sORGANOSERVICIO_ID and Ose.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_MONEDA Mnd on (Mnd.MONE_sMONEDA_ID = Cta.CUEN_sMONEDA_ID and Mnd.MONE_cESTADO = 'A')
		
					Inner Join SC_COMUN.SE_BANCO_AGENCIA Age on (Age.BAAG_sBANCOAGENCIA_ID = Cta.CUEN_sBANCO_AGENCIA_ID and Age.BAAG_cESTADO = 'A')
					Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and Ban.BANC_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sr on (sr.PAIT_sPARAMETRO_ID = 6 and sr.PAIT_vVALOR = cta.CUEN_tSITUACION and sr.PAIT_cESTADO = 'A')
			Where
					CUEN_cESTADO = 'A' and (
					(Ose.ORGA_vABREVIATURA Like '%' + @p_page_search + '%') or
					(Cta.CUEN_vNUMEROCUENTA like '%' + @p_page_search + '%') or
					(Mnd.MONE_cISO4217 like '%' + @p_page_search + '%') or
					(Ban.BANC_vNOMBRE like '%' + @p_page_search + '%'))

			Order by
					case when @p_page_sort = 0 and @p_page_dir = 'asc' then Cta.CUEN_sCUENTACORRIENTE_ID end,
					case when @p_page_sort = 0 and @p_page_dir = 'desc' then Cta.CUEN_sCUENTACORRIENTE_ID end desc,
			
					case when @p_page_sort = 1 and @p_page_dir = 'asc' then Ose.ORGA_vABREVIATURA end,
					case when @p_page_sort = 1 and @p_page_dir = 'desc' then Ose.ORGA_vABREVIATURA end desc,

					case when @p_page_sort = 2 and @p_page_dir = 'asc' then Cta.CUEN_vNUMEROCUENTA end,
					case when @p_page_sort = 2 and @p_page_dir = 'desc' then Cta.CUEN_vNUMEROCUENTA end desc,

					case when @p_page_sort = 3 and @p_page_dir = 'asc' then Mnd.MONE_cISO4217 end,
					case when @p_page_sort = 3 and @p_page_dir = 'desc' then Mnd.MONE_cISO4217 end desc,

					case when @p_page_sort = 4 and @p_page_dir = 'asc' then Ban.BANC_vNOMBRE end,
					case when @p_page_sort = 4 and @p_page_dir = 'desc' then Ban.BANC_vNOMBRE end desc,

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then Cta.CUEN_tSITUACION end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then Cta.CUEN_tSITUACION end desc

			OFFSET
					(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY

		end
	else
		begin
			-- con filtro
			Select	@p_rows_totl = Count(1)
			From	SC_COMUN.SE_CUENTACORRIENTE Cta
					Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (
						Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and 
						Det.ORCT_sORGANOSERVICIO_ID = @p_page_flt  and 
						Det.ORCT_cESTADO = 'A')
			Where	
					CUEN_cESTADO = 'A'

			Select	'i_ctarow' = row_number() over (order by CUEN_sCUENTACORRIENTE_ID),
					'i_ctasid' = CUEN_sCUENTACORRIENTE_ID, 
					's_osenom' = Ose.ORGA_vABREVIATURA,
					's_ctanro' = CUEN_vNUMEROCUENTA, 
					's_ctaiso' = Mnd.MONE_cISO4217,
					's_bannom' = Concat(Ban.BANC_vNOMBRE,'-',Age.BAAG_vNOMBREAGENCIA),
					's_ctacom' = Case When cta.CUEN_bESCOMPARTIDA = 0 Then 'NO' Else 'SI' end,
					'i_ctasit' = CUEN_tSITUACION,
					's_ctasit' = sr.PAIT_vTEXTO
			From	
					SC_COMUN.SE_CUENTACORRIENTE Cta
					Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (
						Det.ORCT_sORGANOSERVICIO_ID = @p_page_flt and
						Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and Det.ORCT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_ORGANOSERVICIO Ose on (Ose.ORGA_sORGANOSERVICIO_ID = Det.ORCT_sORGANOSERVICIO_ID and Ose.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_MONEDA Mnd on (Mnd.MONE_sMONEDA_ID = Cta.CUEN_sMONEDA_ID and Mnd.MONE_cESTADO = 'A')
		
					Inner Join SC_COMUN.SE_BANCO_AGENCIA Age on (Age.BAAG_sBANCOAGENCIA_ID = Cta.CUEN_sBANCO_AGENCIA_ID and Age.BAAG_cESTADO = 'A')
					Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and Ban.BANC_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM sr on (sr.PAIT_sPARAMETRO_ID = 6 and sr.PAIT_vVALOR = cta.CUEN_tSITUACION and sr.PAIT_cESTADO = 'A')
			Where
					CUEN_cESTADO = 'A' and (
					(Ose.ORGA_vABREVIATURA Like '%' + @p_page_search + '%') or
					(Cta.CUEN_vNUMEROCUENTA like '%' + @p_page_search + '%') or
					(Mnd.MONE_cISO4217 like '%' + @p_page_search + '%') or
					(Ban.BANC_vNOMBRE like '%' + @p_page_search + '%'))

			Order by
					case when @p_page_sort = 0 and @p_page_dir = 'asc' then Cta.CUEN_sCUENTACORRIENTE_ID end,
					case when @p_page_sort = 0 and @p_page_dir = 'desc' then Cta.CUEN_sCUENTACORRIENTE_ID end desc,
			
					case when @p_page_sort = 1 and @p_page_dir = 'asc' then Ose.ORGA_vABREVIATURA end,
					case when @p_page_sort = 1 and @p_page_dir = 'desc' then Ose.ORGA_vABREVIATURA end desc,

					case when @p_page_sort = 2 and @p_page_dir = 'asc' then Cta.CUEN_vNUMEROCUENTA end,
					case when @p_page_sort = 2 and @p_page_dir = 'desc' then Cta.CUEN_vNUMEROCUENTA end desc,

					case when @p_page_sort = 3 and @p_page_dir = 'asc' then Mnd.MONE_cISO4217 end,
					case when @p_page_sort = 3 and @p_page_dir = 'desc' then Mnd.MONE_cISO4217 end desc,

					case when @p_page_sort = 4 and @p_page_dir = 'asc' then Ban.BANC_vNOMBRE end,
					case when @p_page_sort = 4 and @p_page_dir = 'desc' then Ban.BANC_vNOMBRE end desc,

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then Cta.CUEN_tSITUACION end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then Cta.CUEN_tSITUACION end desc

			OFFSET
					(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
		End
End
Go

if (object_id(N'SC_COMUN.USP_CUENTACORRIENTE_GRABAR') is not null)
	drop procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba los datos de una cuenta corriente
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec 

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/	
Create Procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAR (
	@p_sid		int,
	@p_ose		int,
	@p_mnd		smallint,
    @p_bic		varchar(11),
    @p_rib		varchar(23),

    @p_abi		varchar(9),
    @p_ini		varchar(10),
	@p_doc		varchar(18),

	@p_cta		varchar(34),
    @p_des		tinyint,
    @p_iba		varchar(30),
    @p_cbu		varchar(22),
    @p_cab		varchar(5),
    @p_fin		varchar(10),
    @p_fdo		varchar(10),

    @p_age		smallint,
    @p_rut		tinyint,
    @p_aba		varchar(9),
    @p_bsb		varchar(6),

    @p_apo		smallint,
    @p_obs		varchar(255),
	@p_sit		smallint,

	@p_ben		varchar(35),
	@p_di1		varchar(35),
    @p_di2		varchar(35),
    @p_di3		varchar(35),

	@p_ent		smallint,
    @p_ctp		smallint,
    @p_dep		smallint,
    @p_agp		smallint,
    @p_dap		varchar(35),
    @p_mru		smallint,
    @p_rup		varchar(11),
    @p_bep		smallint,
	

	@p_usr		smallint,
	@p_ipc		varchar(15)
)
As
Begin
	Declare	@l_cant		int,
			@l_Id		int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1,

			@c_cuenta_asignacion	tinyint = 1,
			@c_cuenta_beneficios	tinyint = 2

	if (@p_sid = 0)
		begin
			-- nueva cuenta
			-- comprueba que el numero de cuenta no exista
			Select	@l_cant = count(1)	From SC_COMUN.SE_CUENTACORRIENTE ct Where ct.CUEN_vNUMEROCUENTA = @p_cta and ct.CUEN_cESTADO = 'A'

			if (@l_cant = 0)
				begin
					-- comprobando el destino de la cuenta
					-- si es una cuenta restringida
					if (@p_des = @c_cuenta_asignacion or @p_des = @c_cuenta_beneficios) 
						begin
							-- El destino es cuenta restringida 
							-- comprueba si es cuenta de asignación
							if (@p_des = @c_cuenta_asignacion) 
								begin
									-- comprueba que el organo de servicio tiene cuenta de asignacion
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
											Inner Join  SC_COMUN.SE_ORGANOSERVICIO_CTACTE det on (
												det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_sORGANOSERVICIO_ID = @p_ose and det.ORCT_cESTADO = 'A')
									Where
											(cta.CUEN_tDESTINO = @c_cuenta_asignacion) and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0) 
										begin
											-- No tiene cuenta de asignacion
											-- El organo de servicio no tiene cuenta de asignacion
											-- Inserta todo
											begin transaction
												Insert Into [SC_COMUN].[SE_CUENTACORRIENTE] (
													CUEN_sMONEDA_ID,
													CUEN_vSWIFT,
													CUEN_vRIB,
													CUEN_vABI, 
													CUEN_dFECHAAPERTURA,
													CUEN_vDOCAUTORIZACION,
													CUEN_vNUMEROCUENTA,
													CUEN_tDESTINO,
													CUEN_vIBAN,
													CUEN_vCBU,
													CUEN_vCAB,
													CUEN_dFECHACIERRE,
													CUEN_dDOCFECHA,
													CUEN_sBANCO_AGENCIA_ID,
													CUEN_tCODIGORUTEO,
													CUEN_vABA,
													CUEN_vBSB,
													CUEN_sAPODERADO_ID,
													CUEN_vOBSERVACION,
													CUEN_tSITUACION,
													
													CUEN_vBENEFNOMBRE,
													CUEN_vBENEFDOMICILIO1,
													CUEN_vBENEFDOMICILIO2,
													CUEN_vBENEFDOMICILIO3,

													CUEN_sUSUARIO_CREACION,
													CUEN_vIP_CREACION
												)
												values (
													@p_mnd,
													@p_bic,
													@p_rib,
													@p_abi,
													Convert(datetime,@p_ini,103),
													@p_doc,

													@p_cta,
													@p_des,
													@p_iba,
													@p_cbu,
													@p_cab,
													Convert(datetime,@p_fin,103),
													Convert(datetime,@p_fdo,103),
													@p_age,
													@p_rut,
													@p_aba,
													@p_bsb,

													@p_apo,
													@p_obs,
													@p_sit,

													@p_ben,
													@p_di1,
													@p_di2,
													@p_di3,
													
													@p_usr,
													@p_ipc
												)
												set	@l_Id = scope_identity();
											commit;

											-- asocia la cuenta al organo de servicio
											Insert Into SC_COMUN.SE_ORGANOSERVICIO_CTACTE (
												ORCT_sORGANOSERVICIO_ID,
												ORCT_sCUENTACORRIENTE_ID,
												ORCT_bESPROPIETARIO,
												ORCT_sUSUARIO_CREACION,
												ORCT_vIP_CREACION
											)
											Values(
												@p_ose,
												@l_Id,
												0,
												@p_usr,
												@p_ipc
											)

											-- graba los detalles en la plantilla
											Insert Into SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE (
												TRTE_sCTACTE_ID,
												TRTE_sENTIDAD_ID,
												TRTE_sCTAORIGEN_ID,
												TRTE_sTIPOCTADES_ID,
												TRTE_sAGENCIAINT_ID,
												TRTE_vDATOAGENCIA,
												TRTE_sRUTEOMET_ID,
												TRTE_vRUTEOCOD,
												TRTE_sSUBSIDIARIA_ID,
												TRTE_sUSUARIO_CREACION,
												TRTE_vIP_CREACION
											)
											values(
												@l_Id,
												@p_ent,
												@p_ctp,
												@p_dep,
												@p_agp,
												@p_dap,
												@p_mru,
												@p_rup,
												@p_bep,
												@p_usr,
												@p_ipc
											)

											set @l_Id		= @l_Id;
											set @l_mensaje	= 'Se grabo satisfactoriamente la nueva cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;
										end
									else
										begin
											-- Ya tiene una cuenta de asignacion
											set @l_Id		= 0;
											set @l_mensaje	= 'Ya existe una cuenta de asignación para el Órgano de Servicio seleccionado.'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end
							else
								begin
									--	el destino es beneficios
									--  comprueba si tiene cuenta de beneficios
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
											Inner Join  SC_COMUN.SE_ORGANOSERVICIO_CTACTE det on (
												det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_sORGANOSERVICIO_ID = @p_ose and det.ORCT_cESTADO = 'A')
									Where
											(cta.CUEN_tDESTINO = @c_cuenta_beneficios) and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0)
										begin
											-- no tiene cuenta de beneficios
											-- Inserta todo menos plantilla
											begin transaction
												Insert Into [SC_COMUN].[SE_CUENTACORRIENTE] (
													CUEN_sMONEDA_ID,
													CUEN_vSWIFT,
													CUEN_vRIB,
													CUEN_vABI, 
													CUEN_dFECHAAPERTURA,
													CUEN_vDOCAUTORIZACION,
													CUEN_vNUMEROCUENTA,
													CUEN_tDESTINO,
													CUEN_vIBAN,
													CUEN_vCBU,
													CUEN_vCAB,
													CUEN_dFECHACIERRE,
													CUEN_dDOCFECHA,
													CUEN_sBANCO_AGENCIA_ID,
													CUEN_tCODIGORUTEO,
													CUEN_vABA,
													CUEN_vBSB,
													CUEN_sAPODERADO_ID,
													CUEN_vOBSERVACION,
													CUEN_tSITUACION,
													CUEN_sUSUARIO_CREACION,
													CUEN_vIP_CREACION
												)
												values (
													@p_mnd,
													@p_bic,
													@p_rib,
													@p_abi,
													Convert(datetime,@p_ini,103),
													@p_doc,

													@p_cta,
													@p_des,
													@p_iba,
													@p_cbu,
													@p_cab,
													Convert(datetime,@p_fin,103),
													Convert(datetime,@p_fdo,103),
													@p_age,
													@p_rut,
													@p_aba,
													@p_bsb,

													@p_apo,
													@p_obs,
													@p_sit,
													@p_usr,
													@p_ipc
												)
												set	@l_Id = scope_identity();
											commit;

											-- asocia la cuenta al organo de servicio
											Insert Into SC_COMUN.SE_ORGANOSERVICIO_CTACTE (
												ORCT_sORGANOSERVICIO_ID,
												ORCT_sCUENTACORRIENTE_ID,
												ORCT_bESPROPIETARIO,
												ORCT_sUSUARIO_CREACION,
												ORCT_vIP_CREACION
											)
											Values(
												@p_ose,
												@l_Id,
												0,
												@p_usr,
												@p_ipc
											)

											set @l_Id		= @l_Id;
											set @l_mensaje	= 'Se grabo satisfactoriamente la nueva cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;

										end
									else
										begin
											-- Ya tiene una cuenta de beneficios sociales
											set @l_Id		= 0;
											set @l_mensaje	= 'Ya existe una cuenta de beneficios sociales para el Órgano de Servicio seleccionado.'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end
						end
					else
						begin
							-- Es otro tipo de cuenta
							-- Inserta todo menos plantilla (plantilla solo se usa para asignacion)

							begin transaction
								Insert Into [SC_COMUN].[SE_CUENTACORRIENTE] (
									CUEN_sMONEDA_ID,
									CUEN_vSWIFT,
									CUEN_vRIB,
									CUEN_vABI, 
									CUEN_dFECHAAPERTURA,
									CUEN_vDOCAUTORIZACION,
									CUEN_vNUMEROCUENTA,
									CUEN_tDESTINO,
									CUEN_vIBAN,
									CUEN_vCBU,
									CUEN_vCAB,
									CUEN_dFECHACIERRE,
									CUEN_dDOCFECHA,
									CUEN_sBANCO_AGENCIA_ID,
									CUEN_tCODIGORUTEO,
									CUEN_vABA,
									CUEN_vBSB,
									CUEN_sAPODERADO_ID,
									CUEN_vOBSERVACION,
									CUEN_tSITUACION,
									
									CUEN_vBENEFNOMBRE,
									CUEN_vBENEFDOMICILIO1,
									CUEN_vBENEFDOMICILIO2,
									CUEN_vBENEFDOMICILIO3,

									CUEN_sUSUARIO_CREACION,
									CUEN_vIP_CREACION
								)
								values (
									@p_mnd,
									@p_bic,
									@p_rib,
									@p_abi,
									Convert(datetime,@p_ini,103),
									@p_doc,

									@p_cta,
									@p_des,
									@p_iba,
									@p_cbu,
									@p_cab,
									Convert(datetime,@p_fin,103),
									Convert(datetime,@p_fdo,103),
									@p_age,
									@p_rut,
									@p_aba,
									@p_bsb,

									@p_apo,
									@p_obs,
									@p_sit,

									@p_ben,
									@p_di1,
									@p_di2,
									@p_di3,

									@p_usr,
									@p_ipc
								)
								set	@l_Id = scope_identity();
							commit;

							-- asocia la cuenta al organo de servicio
							Insert Into SC_COMUN.SE_ORGANOSERVICIO_CTACTE (
								ORCT_sORGANOSERVICIO_ID,
								ORCT_sCUENTACORRIENTE_ID,
								ORCT_bESPROPIETARIO,
								ORCT_sUSUARIO_CREACION,
								ORCT_vIP_CREACION
							)
							Values(
								@p_ose,
								@l_Id,
								0,
								@p_usr,
								@p_ipc
							)

							set @l_Id		= @l_Id;
							set @l_mensaje	= 'Se grabo satisfactoriamente la nueva cuenta.'
							set @l_status	= 1;
							set @l_bs_tipo	= 1;

						end
				end
			else
				begin 
					-- el numero de cuenta ya existe
					-- para vincular a otro Organo de Servicio debe hacerse por otra interfaz
					set @l_Id = 0;
					set @l_mensaje	= 'El numero de cuenta esta vinculado a otro Organo de Servicio.'
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
		end
	else
		begin
			-- actualizar cuenta
			-- comprueba que el numero de cuenta no exista en otro órgano de servicio exterior
			Select	@l_cant = count(1)			
			From	SC_COMUN.SE_CUENTACORRIENTE cta
					Inner Join  SC_COMUN.SE_ORGANOSERVICIO_CTACTE det on (
								det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_sORGANOSERVICIO_ID <> @p_ose and det.ORCT_cESTADO = 'A')
			where
					cta.CUEN_vNUMEROCUENTA = @p_cta and
					cta.CUEN_cESTADO = 'A'

			if (@l_cant = 0) 
				begin
					Declare @l_des tinyint;

					-- obtiene el destino actual de la cuenta
					select @l_des = CUEN_tDESTINO from SC_COMUN.SE_CUENTACORRIENTE cta where cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and cta.CUEN_cESTADO = 'A'

					-- comprueba si el destino de la cuenta es el mismo
					if (@l_des = @p_des)
						begin
							-- El destino no ha variado, actualiza la cuenta
							Update	SC_COMUN.SE_CUENTACORRIENTE
							Set		CUEN_sMONEDA_ID = @p_mnd,
									CUEN_vSWIFT = @p_bic,
									CUEN_vRIB = @p_rib,
									CUEN_vABI = @p_abi, 
									CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
									CUEN_vDOCAUTORIZACION = @p_doc,
									CUEN_vNUMEROCUENTA = @p_cta,
									CUEN_vIBAN = @p_iba,
									CUEN_vCBU = @p_cbu,
									CUEN_vCAB = @p_cab,
									CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
									CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
									CUEN_sBANCO_AGENCIA_ID = @p_age,
									CUEN_tCODIGORUTEO = @p_rut,
									CUEN_vABA = @p_aba,
									CUEN_vBSB = @p_bsb,
									CUEN_sAPODERADO_ID = @p_apo,
									CUEN_vOBSERVACION = @p_obs,
									CUEN_tSITUACION = @p_sit,
									CUEN_vBENEFNOMBRE = @p_ben,
									CUEN_vBENEFDOMICILIO1 = @p_di1,
									CUEN_vBENEFDOMICILIO2 = @p_di2,
									CUEN_vBENEFDOMICILIO3 = @p_di3,

									CUEN_sUSUARIO_MODIFICACION = @p_usr,
									CUEN_vIP_MODIFICACION = @p_ipc,
									CUEN_dFECHA_MODIFICACION = GetDate()
							Where
									CUEN_sCUENTACORRIENTE_ID = @p_sid and
									CUEN_cESTADO = 'A'

							-- si es una cuenta de asignación tambien actualiza la plantilla
							if (@p_des = @c_cuenta_asignacion)
								begin
									-- comprueba si la cuenta tiene una plantilla de transferencia
									-- como es asignación consulta si tiene plantilla, 
									Select @l_cant = Count(1) From SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE Where TRTE_sCTACTE_ID = @p_sid and TRTE_cESTADO = 'A'

									if (@l_cant = 0)
										begin
											-- no tiene plantilla, adiciona una plantilla
											Insert Into SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE (
												TRTE_sCTACTE_ID,
												TRTE_sENTIDAD_ID,
												TRTE_sCTAORIGEN_ID,
												TRTE_sTIPOCTADES_ID,
												TRTE_sAGENCIAINT_ID,
												TRTE_vDATOAGENCIA,
												TRTE_sRUTEOMET_ID,
												TRTE_vRUTEOCOD,
												TRTE_sSUBSIDIARIA_ID,
												TRTE_sUSUARIO_CREACION,
												TRTE_vIP_CREACION
											)
											values(
												@p_sid,
												@p_ent,
												@p_ctp,
												@p_dep,
												@p_agp,
												@p_dap,
												@p_mru,
												@p_rup,
												@p_bep,
												@p_usr,
												@p_ipc
											)
										end
									else
										begin
											-- tiene una plantilla, la actualiza
											Update	SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE 
											Set		
													TRTE_sENTIDAD_ID = @p_ent,
													TRTE_sCTAORIGEN_ID = @p_ctp,
													TRTE_sTIPOCTADES_ID = @p_dep,
													TRTE_sAGENCIAINT_ID = @p_agp,
													TRTE_vDATOAGENCIA = @p_dap,
													TRTE_sRUTEOMET_ID = @p_mru,
													TRTE_vRUTEOCOD = @p_rup,
													TRTE_sSUBSIDIARIA_ID = @p_bep,
													TRTE_sUSUARIO_MODIFICACION = @p_usr,
													TRTE_vIP_MODIFICACION = @p_ipc,
													TRTE_dFECHA_MODIFICACION = getdate()
											Where
													TRTE_sCTACTE_ID = @p_sid and
													TRTE_cESTADO = 'A'
										end
								end

							set	@l_Id		= @p_sid;
							set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.';
							set @l_status	= 1;
							set @l_bs_tipo	= 1;

						end
					else
						begin
							-- El destino ha variado
							-- comprueba si es una cuenta restringida
							if (@p_des = @c_cuenta_asignacion or @p_des = @c_cuenta_beneficios) 
								begin
									-- es una cuenta restringida
									-- comprueba si es cuenta de asignación
									if (@p_des = @c_cuenta_asignacion) 
										begin
											-- comprueba que el organo de servicio tiene cuenta de asignacion
											Select	@l_cant = count(1)			
											From	SC_COMUN.SE_CUENTACORRIENTE cta
													Inner Join  SC_COMUN.SE_ORGANOSERVICIO_CTACTE det on (
														det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_sORGANOSERVICIO_ID = @p_ose and det.ORCT_cESTADO = 'A')
											Where
													cta.CUEN_tDESTINO = @c_cuenta_asignacion and
													cta.CUEN_cESTADO = 'A'

											if (@l_cant = 0) 
												begin
													-- No tiene cuenta de asignacion
													-- El organo de servicio no tiene cuenta de asignacion
													-- Actualiza cuenta

													Update	SC_COMUN.SE_CUENTACORRIENTE
													Set		CUEN_sMONEDA_ID = @p_mnd,
															CUEN_vSWIFT = @p_bic,
															CUEN_vRIB = @p_rib,
															CUEN_vABI = @p_abi, 
															CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
															CUEN_vDOCAUTORIZACION = @p_doc,
															CUEN_vNUMEROCUENTA = @p_cta,
															CUEN_tDESTINO = @p_des,
															CUEN_vIBAN = @p_iba,
															CUEN_vCBU = @p_cbu,
															CUEN_vCAB = @p_cab,
															CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
															CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
															CUEN_sBANCO_AGENCIA_ID = @p_age,
															CUEN_tCODIGORUTEO = @p_rut,
															CUEN_vABA = @p_aba,
															CUEN_vBSB = @p_bsb,
															CUEN_sAPODERADO_ID = @p_apo,
															CUEN_vOBSERVACION = @p_obs,
															CUEN_tSITUACION = @p_sit,

															CUEN_vBENEFNOMBRE = @p_ben,
															CUEN_vBENEFDOMICILIO1 = @p_di1,
															CUEN_vBENEFDOMICILIO2 = @p_di2,
															CUEN_vBENEFDOMICILIO3 = @p_di3,

															CUEN_sUSUARIO_MODIFICACION = @p_usr,
															CUEN_vIP_MODIFICACION = @p_ipc,
															CUEN_dFECHA_MODIFICACION = GetDate()
													Where
															CUEN_sCUENTACORRIENTE_ID = @p_sid and
															CUEN_cESTADO = 'A'

													-- como es asignación consulta si tiene plantilla, 
													Select @l_cant = Count(1) From SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE Where TRTE_sCTACTE_ID = @p_sid and TRTE_cESTADO = 'A'

													if (@l_cant = 0)
														begin
															-- no tiene plantilla, adiciona una plantilla
															Insert Into SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE (
																TRTE_sCTACTE_ID,
																TRTE_sENTIDAD_ID,
																TRTE_sCTAORIGEN_ID,
																TRTE_sTIPOCTADES_ID,
																TRTE_sAGENCIAINT_ID,
																TRTE_vDATOAGENCIA,
																TRTE_sRUTEOMET_ID,
																TRTE_vRUTEOCOD,
																TRTE_sSUBSIDIARIA_ID,
																TRTE_sUSUARIO_CREACION,
																TRTE_vIP_CREACION
															)
															values(
																@p_sid,
																@p_ent,
																@p_ctp,
																@p_dep,
																@p_agp,
																@p_dap,
																@p_mru,
																@p_rup,
																@p_bep,
																@p_usr,
																@p_ipc
															)
														end
													else
														begin
															-- tiene una plantilla, la actualiza
															Update	SC_ASIGNACION.SE_TRANSFERENCIA_TEMPLATE 
															Set		
																	TRTE_sENTIDAD_ID = @p_ent,
																	TRTE_sCTAORIGEN_ID = @p_ctp,
																	TRTE_sTIPOCTADES_ID = @p_dep,
																	TRTE_sAGENCIAINT_ID = @p_agp,
																	TRTE_vDATOAGENCIA = @p_dap,
																	TRTE_sRUTEOMET_ID = @p_mru,
																	TRTE_vRUTEOCOD = @p_rup,
																	TRTE_sSUBSIDIARIA_ID = @p_bep,
																	TRTE_sUSUARIO_MODIFICACION = @p_usr,
																	TRTE_vIP_MODIFICACION = @p_ipc,
																	TRTE_dFECHA_MODIFICACION = getdate()
															Where
																	TRTE_sCTACTE_ID = @p_sid and
																	TRTE_cESTADO = 'A'
														end

													set @l_Id		= @p_sid;
													set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
													set @l_status	= 1;
													set @l_bs_tipo	= 1;
												end
											else
												begin
													-- Ya tiene una cuenta de asignacion
													set @l_Id		= 0;
													set @l_mensaje	= 'Ya existe una cuenta de asignación para el Órgano de Servicio seleccionado.'
													set @l_status	= 0;
													set @l_bs_tipo	= 4;
												end
										end
									else
										begin
											--	el destino es beneficios
											--  comprueba si tiene cuenta de beneficios
											Select	@l_cant = count(1)			
											From	SC_COMUN.SE_CUENTACORRIENTE cta
													Inner Join  SC_COMUN.SE_ORGANOSERVICIO_CTACTE det on (
														det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_sORGANOSERVICIO_ID = @p_ose and det.ORCT_cESTADO = 'A')
											Where
													cta.CUEN_tDESTINO = @c_cuenta_beneficios and
													cta.CUEN_cESTADO = 'A'

											if (@l_cant = 0)
												begin
													-- no tiene cuenta de beneficios
													-- actualiza todo menos plantilla
													Update	SC_COMUN.SE_CUENTACORRIENTE
													Set		CUEN_sMONEDA_ID = @p_mnd,
															CUEN_vSWIFT = @p_bic,
															CUEN_vRIB = @p_rib,
															CUEN_vABI = @p_abi, 
															CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
															CUEN_vDOCAUTORIZACION = @p_doc,
															CUEN_vNUMEROCUENTA = @p_cta,
															CUEN_tDESTINO = @p_des,
															CUEN_vIBAN = @p_iba,
															CUEN_vCBU = @p_cbu,
															CUEN_vCAB = @p_cab,
															CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
															CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
															CUEN_sBANCO_AGENCIA_ID = @p_age,
															CUEN_tCODIGORUTEO = @p_rut,
															CUEN_vABA = @p_aba,
															CUEN_vBSB = @p_bsb,
															CUEN_sAPODERADO_ID = @p_apo,
															CUEN_vOBSERVACION = @p_obs,
															CUEN_tSITUACION = @p_sit,

															CUEN_vBENEFNOMBRE = @p_ben,
															CUEN_vBENEFDOMICILIO1 = @p_di1,
															CUEN_vBENEFDOMICILIO2 = @p_di2,
															CUEN_vBENEFDOMICILIO3 = @p_di3,

															CUEN_sUSUARIO_MODIFICACION = @p_usr,
															CUEN_vIP_MODIFICACION = @p_ipc,
															CUEN_dFECHA_MODIFICACION = GetDate()
													Where
															CUEN_sCUENTACORRIENTE_ID = @p_sid and
															CUEN_cESTADO = 'A'
											
													set @l_Id		= @p_sid;
													set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
													set @l_status	= 1;
													set @l_bs_tipo	= 1;

												end
											else
												begin
													-- Ya tiene una cuenta de beneficios sociales
													set @l_Id		= 0;
													set @l_mensaje	= 'Ya existe una cuenta de beneficios sociales para el Órgano de Servicio seleccionado.'
													set @l_status	= 0;
													set @l_bs_tipo	= 4;
												end
										end


								end
							else
								begin
									-- no es cuenta restringida
									-- actualiza los datos

									Update	SC_COMUN.SE_CUENTACORRIENTE
									Set		CUEN_sMONEDA_ID = @p_mnd,
											CUEN_vSWIFT = @p_bic,
											CUEN_vRIB = @p_rib,
											CUEN_vABI = @p_abi, 
											CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
											CUEN_vDOCAUTORIZACION = @p_doc,
											CUEN_vNUMEROCUENTA = @p_cta,
											CUEN_tDESTINO = @p_des,
											CUEN_vIBAN = @p_iba,
											CUEN_vCBU = @p_cbu,
											CUEN_vCAB = @p_cab,
											CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
											CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
											CUEN_sBANCO_AGENCIA_ID = @p_age,
											CUEN_tCODIGORUTEO = @p_rut,
											CUEN_vABA = @p_aba,
											CUEN_vBSB = @p_bsb,
											CUEN_sAPODERADO_ID = @p_apo,
											CUEN_vOBSERVACION = @p_obs,
											CUEN_tSITUACION = @p_sit,

											CUEN_vBENEFNOMBRE = @p_ben,
											CUEN_vBENEFDOMICILIO1 = @p_di1,
											CUEN_vBENEFDOMICILIO2 = @p_di2,
											CUEN_vBENEFDOMICILIO3 = @p_di3,

											CUEN_sUSUARIO_MODIFICACION = @p_usr,
											CUEN_vIP_MODIFICACION = @p_ipc,
											CUEN_dFECHA_MODIFICACION = GetDate()
									Where
											CUEN_sCUENTACORRIENTE_ID = @p_sid and
											CUEN_cESTADO = 'A'

									set	@l_Id		= @p_sid;
									set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
									set @l_status	= 1;
									set @l_bs_tipo	= 1;
								end
						end
				end
			else
				begin
					-- la cuenta ya existe en otro organo de servicio
					-- para vincular a otro Organo de Servicio debe hacerse por otra interfaz
					set @l_Id = 0;
					set @l_mensaje	= 'El numero de cuenta esta vinculado a otro Organo de Servicio.'
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
		end
	

	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo

End
Go


if (object_id(N'SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS') is not null)
	drop procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba los datos de una cuenta corriente desde el organo de servicio exterior
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec 

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/	
Create Procedure SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS (
	@p_sid		int,
	@p_mnd		smallint,
    @p_bic		varchar(11),
    @p_rib		varchar(23),

    @p_abi		varchar(9),
    @p_ini		varchar(10),
	@p_doc		varchar(18),

	@p_cta		varchar(34),
    @p_des		tinyint,
    @p_iba		varchar(30),
    @p_cbu		varchar(22),
    @p_cab		varchar(5),
    @p_fin		varchar(10),
    @p_fdo		varchar(10),

    @p_age		smallint,
    @p_rut		tinyint,
    @p_aba		varchar(9),
    @p_bsb		varchar(6),

    @p_apo		smallint,
    @p_obs		varchar(255),
	@p_sit		smallint,

	@p_ben		varchar(35),
	@p_di1		varchar(35),
    @p_di2		varchar(35),
    @p_di3		varchar(35),

	@p_usr		smallint,
	@p_ipc		varchar(15)
)
As
Begin
	Declare	@l_cant		int,
			@l_Id		int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1,

			@c_cuenta_asignacion	tinyint = 1,
			@c_cuenta_beneficios	tinyint = 2,
			@c_cuenta_confirmada	tinyint = 9

	-- Actualizar cuenta: comprueba que el numero de cuenta sea unico
	Select	@l_cant = count(1)			
	From	SC_COMUN.SE_CUENTACORRIENTE cta
	Where
			cta.CUEN_sCUENTACORRIENTE_ID <> @p_sid and
			cta.CUEN_vNUMEROCUENTA = @p_cta and
			cta.CUEN_cESTADO = 'A'

	if (@l_cant = 0) 
		begin
			-- Si el numero de cuenta no existe, obtiene el destino actual de la cuenta
			Declare @l_des tinyint;
			select	@l_des = CUEN_tDESTINO from SC_COMUN.SE_CUENTACORRIENTE cta where cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and cta.CUEN_cESTADO = 'A'

			-- comprueba si el destino de la cuenta es el mismo
			if (@l_des = @p_des)
				begin
					
					-- El destino no ha variado, actualiza la cuenta
					Update	SC_COMUN.SE_CUENTACORRIENTE
					Set		CUEN_sMONEDA_ID = @p_mnd,
							CUEN_vSWIFT = @p_bic,
							CUEN_vRIB = @p_rib,
							CUEN_vABI = @p_abi, 
							CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
							CUEN_vDOCAUTORIZACION = @p_doc,
							CUEN_vNUMEROCUENTA = @p_cta,
							CUEN_vIBAN = @p_iba,
							CUEN_vCBU = @p_cbu,
							CUEN_vCAB = @p_cab,
							CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
							CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
							CUEN_sBANCO_AGENCIA_ID = @p_age,
							CUEN_tCODIGORUTEO = @p_rut,
							CUEN_vABA = @p_aba,
							CUEN_vBSB = @p_bsb,
							CUEN_sAPODERADO_ID = @p_apo,
							CUEN_vOBSERVACION = @p_obs,
							CUEN_tSITUACION = @p_sit,
							CUEN_vBENEFNOMBRE = @p_ben,
							CUEN_vBENEFDOMICILIO1 = @p_di1,
							CUEN_vBENEFDOMICILIO2 = @p_di2,
							CUEN_vBENEFDOMICILIO3 = @p_di3,

							CUEN_sUSUARIO_MODIFICACION = @p_usr,
							CUEN_vIP_MODIFICACION = @p_ipc,
							CUEN_dFECHA_MODIFICACION = GetDate()
					Where
							CUEN_sCUENTACORRIENTE_ID = @p_sid and
							CUEN_cESTADO = 'A'

					set	@l_Id		= @p_sid;
					set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.';
					set @l_status	= 1;
					set @l_bs_tipo	= 1;

				end
			else
				begin
					-- El destino ha variado
					-- comprueba si es una cuenta restringida
					if (@p_des = @c_cuenta_asignacion or @p_des = @c_cuenta_beneficios) 
						begin
							-- es una cuenta restringida
							-- comprueba si es cuenta de asignación
							if (@p_des = @c_cuenta_asignacion) 
								begin
									-- comprueba si la cuenta actual es de asignación
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
									Where
											cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and
											cta.CUEN_tDESTINO = @c_cuenta_asignacion and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0) 
										begin
											-- No tiene cuenta de asignacion
											-- Actualiza cuenta

											Update	SC_COMUN.SE_CUENTACORRIENTE
											Set		CUEN_sMONEDA_ID = @p_mnd,
													CUEN_vSWIFT = @p_bic,
													CUEN_vRIB = @p_rib,
													CUEN_vABI = @p_abi, 
													CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
													CUEN_vDOCAUTORIZACION = @p_doc,
													CUEN_vNUMEROCUENTA = @p_cta,
													CUEN_tDESTINO = @p_des,
													CUEN_vIBAN = @p_iba,
													CUEN_vCBU = @p_cbu,
													CUEN_vCAB = @p_cab,
													CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
													CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
													CUEN_sBANCO_AGENCIA_ID = @p_age,
													CUEN_tCODIGORUTEO = @p_rut,
													CUEN_vABA = @p_aba,
													CUEN_vBSB = @p_bsb,
													CUEN_sAPODERADO_ID = @p_apo,
													CUEN_vOBSERVACION = @p_obs,
													CUEN_tSITUACION = @p_sit,

													CUEN_vBENEFNOMBRE = @p_ben,
													CUEN_vBENEFDOMICILIO1 = @p_di1,
													CUEN_vBENEFDOMICILIO2 = @p_di2,
													CUEN_vBENEFDOMICILIO3 = @p_di3,

													CUEN_sUSUARIO_MODIFICACION = @p_usr,
													CUEN_vIP_MODIFICACION = @p_ipc,
													CUEN_dFECHA_MODIFICACION = GetDate()
											Where
													CUEN_sCUENTACORRIENTE_ID = @p_sid and
													CUEN_cESTADO = 'A'

											set @l_Id		= @p_sid;
											set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;
										end
									else
										begin
											-- Ya tiene una cuenta de asignacion
											set @l_Id		= 0;
											set @l_mensaje	= 'Lo sentimos, sólo se permite una cuenta de asignación. Sin embargo, según el Art. 22 del Reglamento N°422'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end
							else
								begin
									--	el destino es beneficios
									--  comprueba si tiene cuenta de beneficios
									Select	@l_cant = count(1)			
									From	SC_COMUN.SE_CUENTACORRIENTE cta
									Where
											cta.CUEN_sCUENTACORRIENTE_ID = @p_sid and
											cta.CUEN_tDESTINO = @c_cuenta_beneficios and
											cta.CUEN_cESTADO = 'A'

									if (@l_cant = 0)
										begin
											-- no tiene cuenta de beneficios
											-- actualiza todo menos plantilla
											Update	SC_COMUN.SE_CUENTACORRIENTE
											Set		CUEN_sMONEDA_ID = @p_mnd,
													CUEN_vSWIFT = @p_bic,
													CUEN_vRIB = @p_rib,
													CUEN_vABI = @p_abi, 
													CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
													CUEN_vDOCAUTORIZACION = @p_doc,
													CUEN_vNUMEROCUENTA = @p_cta,
													CUEN_tDESTINO = @p_des,
													CUEN_vIBAN = @p_iba,
													CUEN_vCBU = @p_cbu,
													CUEN_vCAB = @p_cab,
													CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
													CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
													CUEN_sBANCO_AGENCIA_ID = @p_age,
													CUEN_tCODIGORUTEO = @p_rut,
													CUEN_vABA = @p_aba,
													CUEN_vBSB = @p_bsb,
													CUEN_sAPODERADO_ID = @p_apo,
													CUEN_vOBSERVACION = @p_obs,
													CUEN_tSITUACION = @p_sit,

													CUEN_vBENEFNOMBRE = @p_ben,
													CUEN_vBENEFDOMICILIO1 = @p_di1,
													CUEN_vBENEFDOMICILIO2 = @p_di2,
													CUEN_vBENEFDOMICILIO3 = @p_di3,

													CUEN_sUSUARIO_MODIFICACION = @p_usr,
													CUEN_vIP_MODIFICACION = @p_ipc,
													CUEN_dFECHA_MODIFICACION = GetDate()
											Where
													CUEN_sCUENTACORRIENTE_ID = @p_sid and
													CUEN_cESTADO = 'A'
											
											set @l_Id		= @p_sid;
											set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
											set @l_status	= 1;
											set @l_bs_tipo	= 1;

										end
									else
										begin
											-- Ya tiene una cuenta de beneficios sociales
											set @l_Id		= 0;
											set @l_mensaje	= 'Ya existe una cuenta de beneficios sociales para el Órgano de Servicio seleccionado.'
											set @l_status	= 0;
											set @l_bs_tipo	= 4;
										end
								end


						end
					else
						begin
							-- no es cuenta restringida
							-- actualiza los datos

							Update	SC_COMUN.SE_CUENTACORRIENTE
							Set		CUEN_sMONEDA_ID = @p_mnd,
									CUEN_vSWIFT = @p_bic,
									CUEN_vRIB = @p_rib,
									CUEN_vABI = @p_abi, 
									CUEN_dFECHAAPERTURA = Convert(datetime,@p_ini,103),
									CUEN_vDOCAUTORIZACION = @p_doc,
									CUEN_vNUMEROCUENTA = @p_cta,
									CUEN_tDESTINO = @p_des,
									CUEN_vIBAN = @p_iba,
									CUEN_vCBU = @p_cbu,
									CUEN_vCAB = @p_cab,
									CUEN_dFECHACIERRE = Convert(datetime,@p_fin,103),
									CUEN_dDOCFECHA = Convert(datetime,@p_fdo,103),
									CUEN_sBANCO_AGENCIA_ID = @p_age,
									CUEN_tCODIGORUTEO = @p_rut,
									CUEN_vABA = @p_aba,
									CUEN_vBSB = @p_bsb,
									CUEN_sAPODERADO_ID = @p_apo,
									CUEN_vOBSERVACION = @p_obs,
									CUEN_tSITUACION = @p_sit,

									CUEN_vBENEFNOMBRE = @p_ben,
									CUEN_vBENEFDOMICILIO1 = @p_di1,
									CUEN_vBENEFDOMICILIO2 = @p_di2,
									CUEN_vBENEFDOMICILIO3 = @p_di3,

									CUEN_sUSUARIO_MODIFICACION = @p_usr,
									CUEN_vIP_MODIFICACION = @p_ipc,
									CUEN_dFECHA_MODIFICACION = GetDate()
							Where
									CUEN_sCUENTACORRIENTE_ID = @p_sid and
									CUEN_cESTADO = 'A'

							set	@l_Id		= @p_sid;
							set @l_mensaje	= 'Se actualizó satisfactoriamente la cuenta.'
							set @l_status	= 1;
							set @l_bs_tipo	= 1;
						end
				end
		end
	else
		begin
			-- la cuenta ya existe en otro organo de servicio
			-- para vincular a otro Organo de Servicio debe hacerse por otra interfaz
			set @l_Id = 0;
			set @l_mensaje	= 'El numero de cuenta esta vinculado a otro Organo de Servicio.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
		
	

	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo

End
Go


if (object_id(N'SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR') is not null)
	drop procedure SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve todos los registros para el reporte de BancoAgencias en Excel
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR(
	@p_sid	smallint
)
As
Begin
	if (@p_sid =0)
		begin
			Select	'oseabr' = ose.ORGA_vABREVIATURA,
					'ctanum' = cta.CUEN_vNUMEROCUENTA,
					'ctamon' = mnd.MONE_cISO4217,
					'ctaban' = concat(ban.BANC_vNOMBRE, ' - ', age.BAAG_vNOMBREAGENCIA),
					'ctaswi' = concat(rut.PAIT_vTEXTO,cta.CUEN_vSWIFT),
					'ctaiba' = cta.CUEN_vIBAN,
					'ctaaba' = cta.CUEN_vABA,
					'ctarib' = cta.CUEN_vRIB,
					'ctacbu' = cta.CUEN_vCBU,
					'ctabsb' = cta.CUEN_vBSB,
					'ctaabi' = cta.CUEN_vABI,
					'ctacab' = cta.CUEN_vCAB,
					'ctades' = dst.PAIT_vTEXTO,
					'ctaini' = Convert(varchar(10), cta.CUEN_dFECHAAPERTURA, 103),
					'ctafin' = Convert(varchar(10), cta.CUEN_dFECHACIERRE, 103),
					'ctaapo' = concat(per.OSER_vNOMBRES, ' ', per.OSER_vAPELLIDOS),
					'ctaaut' = cta.CUEN_vDOCAUTORIZACION,
					'ctafec' = Convert(varchar(10), cta.CUEN_dDOCFECHA, 103),
					'ctaobs' = cta.CUEN_vOBSERVACION,
		
					'bennom' = cta.CUEN_vBENEFNOMBRE, 
					'bendi1' = cta.CUEN_vBENEFDOMICILIO1,
					'bendi2' = cta.CUEN_vBENEFDOMICILIO2,
					'bendi3' = cta.CUEN_vBENEFDOMICILIO3,

					'placta' = T.s_cta,
					'plades' = T.s_des,
					'plabco' = T.s_bco,
					'plarut' = T.s_rut
			from	
					[SC_COMUN].[SE_CUENTACORRIENTE]  cta
					Inner Join [SC_COMUN].[SE_ORGANOSERVICIO_CTACTE] det on (det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and det.ORCT_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_ORGANOSERVICIO] ose on (ose.ORGA_sORGANOSERVICIO_ID = det.ORCT_sORGANOSERVICIO_ID and ose.ORGA_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_MONEDA] mnd on (mnd.MONE_sMONEDA_ID = cta.CUEN_sMONEDA_ID and mnd.MONE_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_BANCO_AGENCIA] age on (age.BAAG_sBANCOAGENCIA_ID = cta.CUEN_sBANCO_AGENCIA_ID and age.BAAG_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_BANCO] ban on (ban.BANC_sBANCO_ID = age.BAAG_sBANCO_ID and ban.BANC_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] rut on (rut.PAIT_sPARAMETRO_ID = 4 and rut.PAIT_vVALOR = cta.CUEN_tCODIGORUTEO and rut.PAIT_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] dst on (dst.PAIT_sPARAMETRO_ID = 3 and dst.PAIT_vVALOR = cta.CUEN_tDESTINO and dst.PAIT_cESTADO = 'A')
					Left Join [SC_COMUN].[SE_ORGANOSERVICIO_PERSONAL] per on (per.OSER_sORGANOSERVICIO_ID = ose.ORGA_sORGANOSERVICIO_ID and cta.CUEN_sAPODERADO_ID = per.OSER_sORGSER_PERSONAL_ID and per.OSER_cESTADO = 'A')
					Left Join (
						Select	TRTE_sCTACTE_ID,
								concat(ct.ENCT_vNUMCTA,'-',mn.MONE_cISO4217) 's_cta',
								ds.PAIT_vTEXTO 's_des',
								CONCAT(ba.BANC_vNOMBRE,' - ',ag.BAAG_vNOMBREAGENCIA) 's_bco',
								concat(ru.PAIT_vTEXTO,TRTE_vRUTEOCOD) 's_rut'
						From	
								[SC_ASIGNACION].[SE_TRANSFERENCIA_TEMPLATE] tem
								left Join [SC_COMUN].[SE_ENTIDADPUBLICA] ent on (ent.ENTI_sENTIDAD_ID = tem.TRTE_sTRANSTEMP_ID and ent.ENTI_cESTADO = 'A')
								left Join [SC_COMUN].[SE_ENTIDADPUBLICA_CTACTE] ct on (ct.ENCT_sENTIDADPUBLICA_CTACTE_ID = tem.TRTE_sCTAORIGEN_ID and ct.ENCT_cESTADO = 'A')
								left Join [SC_COMUN].[SE_MONEDA] mn on (mn.MONE_sMONEDA_ID = ct.ENCT_sMONEDA_ID and mn.MONE_cESTADO = 'A')
								left Join [SC_COMUN].[SE_PARAMETRO_ITEM] ds on (ds.PAIT_sPARAMETRO_ID = 5 and ds.PAIT_vVALOR = tem.TRTE_sTIPOCTADES_ID and ds.PAIT_cESTADO = 'A')
								left Join [SC_COMUN].[SE_BANCO_AGENCIA] ag on (ag.BAAG_sBANCOAGENCIA_ID = tem.TRTE_sAGENCIAINT_ID and ag.BAAG_cESTADO = 'A')
								left Join [SC_COMUN].[SE_BANCO] ba on (ba.BANC_sBANCO_ID = ag.BAAG_sBANCO_ID and ba.BANC_cESTADO = 'A')
								left Join [SC_COMUN].[SE_PARAMETRO_ITEM] ru on (ru.PAIT_sPARAMETRO_ID = 4 and ru.PAIT_vVALOR = tem.TRTE_sRUTEOMET_ID and ru.PAIT_cESTADO = 'A')
					) T on (T.TRTE_sCTACTE_ID = cta.CUEN_sCUENTACORRIENTE_ID)
			where	
					cta.CUEN_cESTADO = 'A'
		end
	else
		begin
			Select	'oseabr' = ose.ORGA_vABREVIATURA,
					'ctanum' = cta.CUEN_vNUMEROCUENTA,
					'ctamon' = mnd.MONE_cISO4217,
					'ctaban' = concat(ban.BANC_vNOMBRE, ' - ', age.BAAG_vNOMBREAGENCIA),
					'ctaswi' = concat(rut.PAIT_vTEXTO,cta.CUEN_vSWIFT),
					'ctaiba' = cta.CUEN_vIBAN,
					'ctaaba' = cta.CUEN_vABA,
					'ctarib' = cta.CUEN_vRIB,
					'ctacbu' = cta.CUEN_vCBU,
					'ctabsb' = cta.CUEN_vBSB,
					'ctaabi' = cta.CUEN_vABI,
					'ctacab' = cta.CUEN_vCAB,
					'ctades' = dst.PAIT_vTEXTO,
					'ctaini' = Convert(varchar(10), cta.CUEN_dFECHAAPERTURA, 103),
					'ctafin' = Convert(varchar(10), cta.CUEN_dFECHACIERRE, 103),
					'ctaapo' = concat(per.OSER_vNOMBRES, ' ', per.OSER_vAPELLIDOS),
					'ctaaut' = cta.CUEN_vDOCAUTORIZACION,
					'ctafec' = Convert(varchar(10), cta.CUEN_dDOCFECHA, 103),
					'ctaobs' = cta.CUEN_vOBSERVACION,
		
					'bennom' = cta.CUEN_vBENEFNOMBRE, 
					'bendi1' = cta.CUEN_vBENEFDOMICILIO1,
					'bendi2' = cta.CUEN_vBENEFDOMICILIO2,
					'bendi3' = cta.CUEN_vBENEFDOMICILIO3,

					'placta' = T.s_cta,
					'plades' = T.s_des,
					'plabco' = T.s_bco,
					'plarut' = T.s_rut
			from	
					[SC_COMUN].[SE_CUENTACORRIENTE]  cta
					Inner Join [SC_COMUN].[SE_ORGANOSERVICIO_CTACTE] det on (det.ORCT_sCUENTACORRIENTE_ID = cta.CUEN_sCUENTACORRIENTE_ID and 
						det.ORCT_sORGANOSERVICIO_ID = @p_sid and
						det.ORCT_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_ORGANOSERVICIO] ose on (ose.ORGA_sORGANOSERVICIO_ID = det.ORCT_sORGANOSERVICIO_ID and ose.ORGA_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_MONEDA] mnd on (mnd.MONE_sMONEDA_ID = cta.CUEN_sMONEDA_ID and mnd.MONE_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_BANCO_AGENCIA] age on (age.BAAG_sBANCOAGENCIA_ID = cta.CUEN_sBANCO_AGENCIA_ID and age.BAAG_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_BANCO] ban on (ban.BANC_sBANCO_ID = age.BAAG_sBANCO_ID and ban.BANC_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] rut on (rut.PAIT_sPARAMETRO_ID = 4 and rut.PAIT_vVALOR = cta.CUEN_tCODIGORUTEO and rut.PAIT_cESTADO = 'A')
					Inner Join [SC_COMUN].[SE_PARAMETRO_ITEM] dst on (dst.PAIT_sPARAMETRO_ID = 3 and dst.PAIT_vVALOR = cta.CUEN_tDESTINO and dst.PAIT_cESTADO = 'A')
					Left Join [SC_COMUN].[SE_ORGANOSERVICIO_PERSONAL] per on (per.OSER_sORGANOSERVICIO_ID = ose.ORGA_sORGANOSERVICIO_ID and cta.CUEN_sAPODERADO_ID = per.OSER_sORGSER_PERSONAL_ID and per.OSER_cESTADO = 'A')
					Left Join (
						Select	TRTE_sCTACTE_ID,
								concat(ct.ENCT_vNUMCTA,'-',mn.MONE_cISO4217) 's_cta',
								ds.PAIT_vTEXTO 's_des',
								CONCAT(ba.BANC_vNOMBRE,' - ',ag.BAAG_vNOMBREAGENCIA) 's_bco',
								concat(ru.PAIT_vTEXTO,TRTE_vRUTEOCOD) 's_rut'
						From	
								[SC_ASIGNACION].[SE_TRANSFERENCIA_TEMPLATE] tem
								left Join [SC_COMUN].[SE_ENTIDADPUBLICA] ent on (ent.ENTI_sENTIDAD_ID = tem.TRTE_sTRANSTEMP_ID and ent.ENTI_cESTADO = 'A')
								left Join [SC_COMUN].[SE_ENTIDADPUBLICA_CTACTE] ct on (ct.ENCT_sENTIDADPUBLICA_CTACTE_ID = tem.TRTE_sCTAORIGEN_ID and ct.ENCT_cESTADO = 'A')
								left Join [SC_COMUN].[SE_MONEDA] mn on (mn.MONE_sMONEDA_ID = ct.ENCT_sMONEDA_ID and mn.MONE_cESTADO = 'A')
								left Join [SC_COMUN].[SE_PARAMETRO_ITEM] ds on (ds.PAIT_sPARAMETRO_ID = 5 and ds.PAIT_vVALOR = tem.TRTE_sTIPOCTADES_ID and ds.PAIT_cESTADO = 'A')
								left Join [SC_COMUN].[SE_BANCO_AGENCIA] ag on (ag.BAAG_sBANCOAGENCIA_ID = tem.TRTE_sAGENCIAINT_ID and ag.BAAG_cESTADO = 'A')
								left Join [SC_COMUN].[SE_BANCO] ba on (ba.BANC_sBANCO_ID = ag.BAAG_sBANCO_ID and ba.BANC_cESTADO = 'A')
								left Join [SC_COMUN].[SE_PARAMETRO_ITEM] ru on (ru.PAIT_sPARAMETRO_ID = 4 and ru.PAIT_vVALOR = tem.TRTE_sRUTEOMET_ID and ru.PAIT_cESTADO = 'A')
					) T on (T.TRTE_sCTACTE_ID = cta.CUEN_sCUENTACORRIENTE_ID)
			where	
					cta.CUEN_cESTADO = 'A'

		end
End
Go
	
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE USUARIO
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_USUARIO_LOGIN') is not null)
	drop procedure SC_COMUN.USP_USUARIO_LOGIN
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Logueo de usuarios
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_USUARIO_LOGIN 'VNEYRAT','aWzdPayrTfA='
	exec  SC_COMUN.USP_USUARIO_LOGIN 'USER_DEMO','NGsB6iKFgrY='

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create Procedure SC_COMUN.USP_USUARIO_LOGIN
(
	@p_usr	varchar(50),
	@p_pwd	varchar(44)
)
As
Begin
	Declare @l_cant int,
			@l_id	int
			
	
	-- Comprobando que el usuario exista y este activo
	Select @l_cant = count(1) From SC_COMUN.SE_USUARIO Where USUA_vUSR = @p_usr and USUA_cESTADO = 'A'
	if (@l_cant > 0)
		begin
			-- existe
			-- comprobando si es usuario de dominio
			Select @l_cant = count(1) From SC_COMUN.SE_USUARIO Where USUA_vUSR = @p_usr and USUA_bISDOMINIO = 1 and USUA_cESTADO = 'A'
			if (@l_cant > 0)
				begin
					-- es usuario de dominio
					-- no valida la contraseña
					-- Comprobando la cantidad de perfiles del usuario
					Select	@l_cant = count(1)  
					From	SC_COMUN.SE_USUARIO_PERFIL up
							Inner Join SC_COMUN.SE_USUARIO us on (us.USUA_sUSUARIO_ID = up.USPE_sUSUARIO_ID and us.USUA_vUSR = @p_usr and us.USUA_cESTADO = 'A')
					Where	
							up.USPE_cESTADO = 'A'

					If (@l_cant = 1)
						begin
							select	'i_pernum'	= 1, 
									'i_usucid' = us.USUA_sUSUARIO_ID, 
									's_usuape' = us.USUA_vAPELLIDOS + ' ' + us.USUA_vNOMBRES, 
									'i_usucpw' = USUA_bCAMBIO_PWD,
									'i_usudom' = USUA_bISDOMINIO,

									'i_undcid' = uo.UNID_sUNIDADORGANICA_ID,
									's_undnom' = uo.UNID_vNOMBRE,

									'i_osecid' = um.USMO_sORGANOSERVICIO_ID,
									's_oseabr' = os.ORGA_vABREVIATURA,
									's_osenom' = os.ORGA_vNOMBRE,

									'i_paicid' = ps.PAIS_sPAIS_ID, 
									's_painom' = ps.PAIS_vNOMBRE,

									'i_percid' = pe.PERF_sPERFIL_ID,
									's_pernom' = pe.PERF_vNOMBRE,

									'i_rolbas' = us.USUA_tROL,

									'i_qrysts'	= 1
							from 
									SC_COMUN.SE_USUARIO us
									Inner Join SC_COMUN.SE_USUARIO_PERFIL up on (up.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and up.USPE_cESTADO = 'A')
									Inner Join SC_COMUN.SE_PERFIL pe on (pe.PERF_sPERFIL_ID = up.USPE_sPERFIL_ID and pe.PERF_cESTADO = 'A')
									Inner Join SC_COMUN.SE_USUARIO_MOVIMIENTO um on (um.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and um.USMO_bULTIMA_DOC = 1 and um.USMO_cESTADO = 'A')
									Inner Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = um.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
									Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = um.USMO_sPAIS_ID and ps.PAIS_cESTADO = 'A')
									Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = um.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
							where
									us.USUA_vUSR = @p_usr and
									us.USUA_cESTADO = 'A' 
						end
					else
						begin
							-- Si tiene mas de un perfil, el perfil lo lee en otra ventana. Retorna sólo info del usuario, y en "i_estado" la cantidad de perfiles
							if @l_cant > 1 
								begin
									select	'i_pernum'	= @l_cant, 
											'i_usucid' = us.USUA_sUSUARIO_ID, 
											's_usuape' = us.USUA_vAPELLIDOS + ' ' + us.USUA_vNOMBRES, 
											'i_usucpw' = USUA_bCAMBIO_PWD,
											'i_usudom' = USUA_bISDOMINIO,

											'i_undcid' = uo.UNID_sUNIDADORGANICA_ID,
											's_undnom' = uo.UNID_vNOMBRE,

											'i_osecid' = um.USMO_sORGANOSERVICIO_ID,
											's_oseabr' = os.ORGA_vABREVIATURA,
											's_osenom' = os.ORGA_vNOMBRE,

											'i_paicid' = ps.PAIS_sPAIS_ID, 
											's_painom' = ps.PAIS_vNOMBRE,

											'i_percid' = pe.PERF_sPERFIL_ID,
											's_pernom' = pe.PERF_vNOMBRE,
											'i_rolbas' = us.USUA_tROL,

											'i_qrysts'	= 1
									from 
											SC_COMUN.SE_USUARIO us
											Inner Join SC_COMUN.SE_USUARIO_PERFIL up on (up.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and up.USPE_cESTADO = 'A')
											Inner Join SC_COMUN.SE_PERFIL pe on (pe.PERF_sPERFIL_ID = up.USPE_sPERFIL_ID and pe.PERF_cESTADO = 'A')
											Inner Join SC_COMUN.SE_USUARIO_MOVIMIENTO um on (um.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and um.USMO_bULTIMA_DOC = 1 and um.USMO_cESTADO = 'A')
											Inner Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = um.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
											Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = um.USMO_sPAIS_ID and ps.PAIS_cESTADO = 'A')
											Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = um.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
									where
											us.USUA_vUSR = @p_usr and
											us.USUA_cESTADO = 'A' 
								end
							else
								begin
									-- Si no tiene ningun perfil, error
									Select	'i_qrysts'	= 0, 
											'i_qrytpo'	= 4,
											's_qrymsg' = 'El usuario no cuenta con un perfil asignado. Consulte con el administrador'
								end
										
						end
				end
			else
				begin
					-- no es usuario de dominio
					-- valida la contraseña
					Select @l_cant = count(1) From SC_COMUN.SE_USUARIO Where USUA_vUSR = @p_usr and USUA_vPWD = @p_pwd and USUA_bISDOMINIO = 0 and USUA_cESTADO = 'A' 
					if (@l_cant > 0)
						begin
							-- la contraseña es correcta
							-- Comprobando la cantidad de perfiles del usuario
							Select	@l_cant = count(1)  
							From	SC_COMUN.SE_USUARIO_PERFIL up
									Inner Join SC_COMUN.SE_USUARIO us on (us.USUA_sUSUARIO_ID = up.USPE_sUSUARIO_ID and us.USUA_vUSR = @p_usr and us.USUA_cESTADO = 'A')
							Where	
									up.USPE_cESTADO = 'A'

							If (@l_cant = 1)
								begin
									select	'i_pernum'	= 1, 
											'i_usucid' = us.USUA_sUSUARIO_ID, 
											's_usuape' = us.USUA_vAPELLIDOS + ' ' + us.USUA_vNOMBRES, 
											'i_usucpw' = USUA_bCAMBIO_PWD,
											'i_usudom' = USUA_bISDOMINIO,

											'i_undcid' = uo.UNID_sUNIDADORGANICA_ID,
											's_undnom' = uo.UNID_vNOMBRE,

											'i_osecid' = um.USMO_sORGANOSERVICIO_ID,
											's_oseabr' = os.ORGA_vABREVIATURA,
											's_osenom' = os.ORGA_vNOMBRE,

											'i_paicid' = ps.PAIS_sPAIS_ID, 
											's_painom' = ps.PAIS_vNOMBRE,

											'i_percid' = pe.PERF_sPERFIL_ID,
											's_pernom' = pe.PERF_vNOMBRE,
											'i_rolbas' = us.USUA_tROL,

											'i_qrysts'	= 1
									from 
											SC_COMUN.SE_USUARIO us
											Inner Join SC_COMUN.SE_USUARIO_PERFIL up on (up.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and up.USPE_cESTADO = 'A')
											Inner Join SC_COMUN.SE_PERFIL pe on (pe.PERF_sPERFIL_ID = up.USPE_sPERFIL_ID and pe.PERF_cESTADO = 'A')
											Inner Join SC_COMUN.SE_USUARIO_MOVIMIENTO um on (um.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and um.USMO_bULTIMA_DOC = 1 and um.USMO_cESTADO = 'A')
											Inner Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = um.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
											Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = um.USMO_sPAIS_ID and ps.PAIS_cESTADO = 'A')
											Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = um.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
									where
											us.USUA_vUSR = @p_usr and
											us.USUA_cESTADO = 'A' 
								end
							else
								begin
									-- Si tiene mas de un perfil, el perfil lo lee en otra ventana. Retorna sólo info del usuario, y en "i_estado" la cantidad de perfiles
									if @l_cant > 1 
										begin
											select	'i_pernum'	= @l_cant, 
													'i_usucid' = us.USUA_sUSUARIO_ID, 
													's_usuape' = us.USUA_vAPELLIDOS + ' ' + us.USUA_vNOMBRES, 
													'i_usucpw' = USUA_bCAMBIO_PWD,
													'i_usudom' = USUA_bISDOMINIO,

													'i_undcid' = uo.UNID_sUNIDADORGANICA_ID,
													's_undnom' = uo.UNID_vNOMBRE,

													'i_osecid' = um.USMO_sORGANOSERVICIO_ID,
													's_oseabr' = os.ORGA_vABREVIATURA,
													's_osenom' = os.ORGA_vNOMBRE,

													'i_paicid' = ps.PAIS_sPAIS_ID, 
													's_painom' = ps.PAIS_vNOMBRE,

													'i_percid' = pe.PERF_sPERFIL_ID,
													's_pernom' = pe.PERF_vNOMBRE,
													'i_rolbas' = us.USUA_tROL,

													'i_qrysts'	= 1
											from 
													SC_COMUN.SE_USUARIO us
													Inner Join SC_COMUN.SE_USUARIO_PERFIL up on (up.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and up.USPE_cESTADO = 'A')
													Inner Join SC_COMUN.SE_PERFIL pe on (pe.PERF_sPERFIL_ID = up.USPE_sPERFIL_ID and pe.PERF_cESTADO = 'A')
													Inner Join SC_COMUN.SE_USUARIO_MOVIMIENTO um on (um.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and um.USMO_bULTIMA_DOC = 1 and um.USMO_cESTADO = 'A')
													Inner Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = um.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
													Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = um.USMO_sPAIS_ID and ps.PAIS_cESTADO = 'A')
													Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = um.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
											where
													us.USUA_vUSR = @p_usr and
													us.USUA_cESTADO = 'A' 
										end
									else
										begin
											-- Si no tiene ningun perfil, error
											Select	'i_qrysts'	= 0, 
													'i_qrytpo'	= 4,
													's_qrymsg' = 'El usuario no cuenta con un perfil asignado. Consulte con el administrador'
										end
										
								end


						end
					else
						begin
							-- la contraseña es incorrecta
							Select	'i_qrysts'	= 0, 
									'i_qrytpo'	= 4,
									's_qrymsg' = 'La contraseña no es correcta'
						end
				end
			

		end
	else
		begin
			-- no existe
			Select	'i_qrysts'	= 0, 
					'i_qrytpo'	= 4,
					's_qrymsg' = 'El usuario no ha sido registrado en la aplicación, o no se encuentra activo.'
		end
end
go





-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE MONEDAS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR_SELECT_BYOSE') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR_SELECT_BYOSE
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas a un organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR_SELECT_BYOSE 136

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_MONEDA_LISTAR_SELECT_BYOSE (
	@p_ose		Smallint
)
As
Begin
	Declare @paramItem_RegistroAprobado Int = 3

	if (@p_ose = 0)
		begin
			Select	'i_sid' = Mnd.MONE_sMONEDA_ID, 
					's_nom' = Mnd.MONE_vNOMBRE,
					's_iso' = Mnd.MONE_cISO4217
			From	
					SC_COMUN.SE_MONEDA Mnd 
			Where	
					Mnd.MONE_cESTADO = 'A'
			Order by
					Mnd.MONE_bASIGNACION desc, Mnd.MONE_vNOMBRE
		end
	else
		begin
			Select	'i_sid' = Mnd.MONE_sMONEDA_ID, 
					's_nom' = Mnd.MONE_vNOMBRE,
					's_iso' = Mnd.MONE_cISO4217
			From	
					SC_COMUN.SE_ORGANOSERVICIO Ose
					Inner Join SC_COMUN.SE_PAIS_MONEDA Pmo on (Pmo.PAMO_sPAIS_ID = Ose.ORGA_sPAIS_ID and Ose.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_MONEDA Mnd on (Mnd.MONE_sMONEDA_ID = Pmo.PAMO_sMONEDA_ID and Mnd.MONE_cESTADO = 'A')
			Where	
					Ose.ORGA_sORGANOSERVICIO_ID = @p_ose and
					Ose.ORGA_tSITUACION = @paramItem_RegistroAprobado and
					Ose.ORGA_cESTADO = 'A'
			Order by
					Mnd.MONE_bASIGNACION desc
		end
End
go


if (object_id(N'SC_REPORTES.USP_BANCO_EXPORTAR_BANCOMISION') is not null)
	drop procedure SC_REPORTES.USP_BANCO_EXPORTAR_BANCOMISION
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve todos los registros para el reporte de BancoAgencias en Excel
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_REPORTES.USP_BANCO_EXPORTAR_BANCOMISION
Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_REPORTES.USP_BANCO_EXPORTAR_BANCOMISION
As
Begin
	-- Tabla Parametros: Tipo de Agencia Bancaria para Transferencias 
	Declare	@P_TIPO_AGENCIA_BANCARIA int = 2
	
	Select	's_ban' = ba.BANC_vNOMBRE,
			's_age' = ag.BAAG_vNOMBREAGENCIA, 
			's_do1' = ag.BAAG_vDOMICILIO1, 
			's_do2' = ag.BAAG_vDOMICILIO2, 
			's_tip' = pa.PAIT_vTEXTO,
			's_pai' = ps.PAIS_vNOMBRE,
			's_cta' = ct.CUEN_vNUMEROCUENTA,
			's_ose' = os.ORGA_vABREVIATURA,
			's_sit' = Case ct.CUEN_tSITUACION 
						When 9 Then 'PENDIENTE VALIDACION OSE' 
						When 8 Then 'PENDIENTE VALIDACION ASE' 
						When 1 Then 'REGISTRO APROBADO'
					  End
	From	
			SC_COMUN.SE_BANCO ba
			Inner Join SC_COMUN.SE_BANCO_AGENCIA ag on (ag.BAAG_sBANCO_ID = ba.BANC_sBANCO_ID and ag.BAAG_tSITUACION = 1 and ag.BAAG_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pa on (pa.PAIT_sPARAMETRO_ID = 2 and pa.PAIT_vVALOR = ag.BAAG_tTIPO and pa.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = ag.BAAG_sPAIS_ID and ps.PAIS_cESTADO = 'A')
			Left Join SC_COMUN.SE_CUENTACORRIENTE ct on (ct.CUEN_sBANCO_AGENCIA_ID = ag.BAAG_sBANCOAGENCIA_ID and ct.CUEN_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE dct on (dct.ORCT_sCUENTACORRIENTE_ID = ct.CUEN_sCUENTACORRIENTE_ID and dct.ORCT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = dct.ORCT_sORGANOSERVICIO_ID and os.ORGA_tSITUACION = 3 and os.ORGA_cESTADO = 'A')
	Where
			ba.BANC_tSITUACION = 1 and
			ba.BANC_cESTADO = 'A' 
	Order by
			ba.BANC_vNOMBRE, ag.BAAG_vNOMBREAGENCIA
End
Go
