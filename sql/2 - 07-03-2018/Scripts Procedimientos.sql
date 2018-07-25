use BD_SGSE
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE PARAMETROS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


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


		
	-- Actualizar cuenta
	-- comprueba que el numero de cuenta sea unico
	Select	@l_cant = count(1)			
	From	SC_COMUN.SE_CUENTACORRIENTE cta
	Where
			cta.CUEN_sCUENTACORRIENTE_ID <> @p_sid and
			cta.CUEN_vNUMEROCUENTA = @p_cta and
			cta.CUEN_cESTADO = 'A'

	if (@l_cant = 0) 
		begin
			-- Si el numero de cuenta no existe
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
--	TABLAS DE AUDITORIA
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


If (object_id(N'SC_SYSTEM.SYS_AUDITORIA') is not null)
	Drop Table SC_SYSTEM.SYS_AUDITORIA
go

Create Table SC_SYSTEM.SYS_AUDITORIA
( 
	SYS_iAUDITORIA_ID			Int Identity(1,1)	not null,			-- Id
	SYS_iEVENTO_ID				Int					not null,			-- Id del evento sobre el módulo
	SYS_iMODULO_ID				Int					not null,			-- Id del módulo
	
	SYS_sUSUARIO_CREACION		Smallint			not null,
	SYS_dFECHA_CREACION			datetime			not null default GetDate(),
	
)
Go

Alter Table SC_SYSTEM.[SYS_AUDITORIA]
	Add Constraint Pk_SYS_iAUDITORIA_ID Primary Key (SYS_iAUDITORIA_ID);
Go

Create NonClustered Index IDN_SYS_iEVENTO_ID on SC_SYSTEM.[SYS_AUDITORIA](SYS_iEVENTO_ID);
Go

Create NonClustered Index IDN_SYS_iMODULO_ID on SC_SYSTEM.[SYS_AUDITORIA](SYS_iMODULO_ID);
Go

Create NonClustered Index IDN_SYS_sUSUARIO_CREACION on [SC_SYSTEM].[SYS_AUDITORIA](SYS_sUSUARIO_CREACION);
Go