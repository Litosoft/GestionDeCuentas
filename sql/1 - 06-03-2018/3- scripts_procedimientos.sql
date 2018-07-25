use BD_SGSE
go



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
	exec  SC_COMUN.USP_USUARIO_LOGIN 'VNEYRAT','aas'
	exec  SC_COMUN.USP_USUARIO_LOGIN 'L-ACRA','Aq3ze45M2wU='

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

									'i_paicid' = ps.PAIS_sPAIS_ID, 
									's_painom' = ps.PAIS_vNOMBRE,

									'i_percid' = pe.PERF_sPERFIL_ID,
									's_pernom' = pe.PERF_vNOMBRE,

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

											'i_paicid' = ps.PAIS_sPAIS_ID, 
											's_painom' = ps.PAIS_vNOMBRE,

											'i_percid' = pe.PERF_sPERFIL_ID,
											's_pernom' = pe.PERF_vNOMBRE,

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

											'i_paicid' = ps.PAIS_sPAIS_ID, 
											's_painom' = ps.PAIS_vNOMBRE,

											'i_percid' = pe.PERF_sPERFIL_ID,
											's_pernom' = pe.PERF_vNOMBRE,

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

													'i_paicid' = ps.PAIS_sPAIS_ID, 
													's_painom' = ps.PAIS_vNOMBRE,

													'i_percid' = pe.PERF_sPERFIL_ID,
													's_pernom' = pe.PERF_vNOMBRE,

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



if (object_id(N'SC_COMUN.USP_USUARIO_LISTAR_toDT') is not null)
	drop procedure SC_COMUN.USP_USUARIO_LISTAR_toDT
go
/*
Sistema		: Qernel
Objetivo	: Devuelve los usuarios hacia un dataTable
Creado por	: Victor Neyra
Fecha		: 
Parametros	: Ninguno
Ejecutar	: 
	Declare @p_page_nmber	int = 0,
			@p_page_rows	int = 10,
			@p_page_search	varchar(36) = '',
			@p_page_sort	int = 0,
			@p_page_dir		varchar(4) = 'asc',
			@p_rows_totl	int;	

	exec SC_COMUN.USP_USUARIO_LISTAR_toDT @p_page_nmber, @p_page_rows, @p_page_search, @p_page_sort, @p_page_dir, @p_rows_totl OUTPUT
	select	@p_rows_totl

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_USUARIO_LISTAR_toDT (
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin
	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_USUARIO

	select	'i_usurow' = row_number() over (order by us.USUA_sUSUARIO_ID),
			'i_usucid' = us.USUA_sUSUARIO_ID, 
			's_usuape' = us.USUA_vAPELLIDOS + ' ' + us.USUA_vNOMBRES,
			's_usulan' = us.USUA_vUSR, 
			's_undabr' = uo.UNID_vABREVIATURA,
			's_oseabr' = os.ORGA_vABREVIATURA,
			's_usrfin' = Convert(Varchar(10), us.USUA_dFEC_VIG_FIN, 103),
			's_pernom' = substring(Perfiles, 2, len(Perfiles)),
			's_usuest' = us.USUA_cESTADO
	from 
			SC_COMUN.SE_USUARIO us
			Left Join SC_COMUN.SE_USUARIO_MOVIMIENTO um on (um.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and um.USMO_bULTIMA_DOC = 1 and um.USMO_cESTADO = 'A')
			Left Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = um.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
			Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = um.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')
	
	Cross Apply (
			Select	', ' + pf.PERF_vNOMBRE 
			From	SC_COMUN.SE_USUARIO_PERFIL dp 
					Left Join SC_COMUN.SE_PERFIL pf on (pf.PERF_sPERFIL_ID = dp.USPE_sPERFIL_ID and pf.PERF_cESTADO = 'A')
			Where
					dp.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and dp.USPE_cESTADO = 'A'
			FOR XML PATH('')) D (Perfiles)
			
	Where
			(us.USUA_vAPELLIDOS Like '%' + @p_page_search + '%') or
			(us.USUA_vNOMBRES Like '%' + @p_page_search + '%') or
			(us.USUA_vUSR Like '%' + @p_page_search + '%') or
			(Perfiles Like '%' + @p_page_search + '%') or
			(uo.UNID_vABREVIATURA Like '%' + @p_page_search + '%') or
			(os.ORGA_vABREVIATURA Like '%' + @p_page_search + '%')
	
	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then us.USUA_sUSUARIO_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then us.USUA_sUSUARIO_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then us.USUA_vAPELLIDOS end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then us.USUA_vAPELLIDOS end desc,

			case when @p_page_sort = 2 and @p_page_dir = 'asc' then us.USUA_vUSR end,
			case when @p_page_sort = 2 and @p_page_dir = 'desc' then us.USUA_vUSR end desc,

			case when @p_page_sort = 3 and @p_page_dir = 'asc' then us.USUA_vUSR end,
			case when @p_page_sort = 3 and @p_page_dir = 'desc' then us.USUA_vUSR end desc

	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
go



if (object_id(N'SC_COMUN.USP_USUARIO_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_USUARIO_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos del usuario por su ID
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_USUARIO_LISTAR_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_USUARIO_LISTAR_BYID(
	@p_idu	int
)
as
begin
	Select	'i_usrsid' = us.USUA_sUSUARIO_ID,
			's_usrape' = us.USUA_vAPELLIDOS, 
			's_usrnom' = us.USUA_vNOMBRES, 
			's_usrema' = us.USUA_vEMAIL, 
			's_usrtel' = us.USUA_vTELEFONO,
			's_usrlan' = us.USUA_vUSR, 
			's_usrpwd' = us.USUA_vPWD, 
			's_usrini' = Convert(Varchar(10), us.USUA_dFEC_VIG_INI, 103), 
			's_usrfin' = Convert(Varchar(10), us.USUA_dFEC_VIG_FIN, 103),
					
			'i_unisid' = uo.UNID_sUNIDADORGANICA_ID,
			'i_osesid' = Isnull(os.ORGA_sORGANOSERVICIO_ID, 0),
			'i_paisid' = ps.PAIS_sPAIS_ID,
					
			'i_usrdom' = us.USUA_bISDOMINIO,
			'i_usrchg' = us.USUA_bCAMBIO_PWD, 
			'i_usrrol' = us.USUA_tROL,
			'i_usrest' = case when us.USUA_cESTADO = 'A' then 1 else 0 end
	From	
			SC_COMUN.SE_USUARIO us
			Left Join SC_COMUN.SE_USUARIO_MOVIMIENTO uu on (uu.USMO_sUSUARIO_ID = us.USUA_sUSUARIO_ID and uu.USMO_bULTIMA_DOC = 1 and uu.USMO_cESTADO = 'A')
			Left Join SC_COMUN.SE_UNIDADORGANICA uo on (uo.UNID_sUNIDADORGANICA_ID = uu.USMO_sUNIDADORGANICA_ID and uo.UNID_cESTADO = 'A')
			Left Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = uu.USMO_sPAIS_ID and ps.PAIS_cESTADO = 'A')
			Left Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = uu.USMO_sORGANOSERVICIO_ID and os.ORGA_cESTADO = 'A')

			Left Join SC_COMUN.SE_USUARIO_PERFIL dp on (dp.USPE_sUSUARIO_ID = us.USUA_sUSUARIO_ID and dp.USPE_cESTADO = 'A')
			Left Join SC_COMUN.SE_PERFIL pf on (pf.PERF_sPERFIL_ID = dp.USPE_sPERFIL_ID and pf.PERF_cESTADO = 'A')
	Where
			us.USUA_sUSUARIO_ID = @p_idu
end
go


if (object_id(N'SC_COMUN.USP_USUARIO_GRABAR') is not null)
	drop procedure SC_COMUN.USP_USUARIO_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba un usuario
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_USUARIO_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_USUARIO_GRABAR(
	@p_idu	int,
	@p_ape	varchar(35),
	@p_nom	varchar(35),
	@p_mai	varchar(50),
	@p_tel	varchar(12),
	@p_lan	varchar(12),
	@p_pwd	varchar(44),
	@p_ini	varchar(10),
	@p_fin	varchar(10),
	
	@p_und	int,
	@p_pai	int,
	@p_ose	int,
	@p_rol	int,
	
	@p_dom	int,
	@p_chg	int,
	@p_sts	char(1),
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
As
Begin
	declare @l_cant int,
			@l_id	int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1
	
	if (@p_idu = 0)
		begin
			-- Inserta
			begin transaction
				Insert Into  SC_COMUN.SE_USUARIO (
					USUA_vAPELLIDOS, USUA_vNOMBRES, USUA_vEMAIL, USUA_vTELEFONO, 
					USUA_vUSR, USUA_vPWD, 
					USUA_dFEC_VIG_INI, 
					USUA_dFEC_VIG_FIN, 
					USUA_bISDOMINIO, USUA_bCAMBIO_PWD, USUA_tROL, 
					USUA_sUSUARIO_CREACION, USUA_vIP_CREACION, USUA_cESTADO)
				Values (
					@p_ape, @p_nom, @p_mai, @p_tel,
					@p_lan, @p_pwd, 
					Convert(datetime,@p_ini,103),
					Convert(datetime,@p_fin,103),
					@p_dom, @p_chg, @p_rol,
					@p_usr, @p_ipc,
					@p_sts
				);

				set	@l_Id = scope_identity();
			commit;

			-- Inserta la Ubicación
			Insert Into SC_COMUN.SE_USUARIO_MOVIMIENTO (USMO_sUSUARIO_ID, USMO_sUNIDADORGANICA_ID, USMO_sORGANOSERVICIO_ID, USMO_sPAIS_ID, USMO_dFEC_VIG_INI, USMO_dFEC_VIG_FIN, USMO_sUSUARIO_CREACION, USMO_vIP_CREACION)  
				Values (@l_Id, @p_und, @p_ose, @p_pai, Convert(datetime,@p_ini,103), Convert(datetime,@p_fin,103), @p_usr, @p_ipc)

			set @l_mensaje	= 'Se agrego el usuario.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			-- Update
			Update	SC_COMUN.SE_USUARIO
			set		USUA_vAPELLIDOS = @p_ape,
					USUA_vNOMBRES = @p_nom,
					USUA_vEMAIL = @p_mai,
					USUA_vTELEFONO = @p_tel,
					USUA_vUSR = @p_lan,
					USUA_vPWD = @p_pwd,
					USUA_dFEC_VIG_INI = Convert(datetime,@p_ini,103),
					USUA_dFEC_VIG_FIN = Convert(datetime,@p_fin,103),
					USUA_bISDOMINIO = @p_dom,
					USUA_bCAMBIO_PWD = @p_chg,
					USUA_tROL = @p_rol,
					USUA_sUSUARIO_MODIFICACION = @p_usr,
					USUA_vIP_MODIFICACION = @p_ipc,
					USUA_dFECHA_MODIFICACION = getdate(),
					USUA_cESTADO = @p_sts
			where
					USUA_sUSUARIO_ID = @p_idu
			
			-- Comprueba si el usuario tiene una ubicacion o movimiento activo
			Select @l_cant = Count(1) From SC_COMUN.SE_USUARIO_MOVIMIENTO Where USMO_sUSUARIO_ID = @p_idu and USMO_bULTIMA_DOC = 1 and USMO_cESTADO = 'A'
			if (@l_cant > 0) 
				begin
					-- Si tiene movimiento comprueba si hubo cambios en Unidad, OSE o Pais
					Declare @l_unidad int, @l_ose int, @l_pais int

					Select	@l_unidad = USMO_sUNIDADORGANICA_ID, @l_ose = USMO_sORGANOSERVICIO_ID, @l_pais = USMO_sPAIS_ID
					From	SC_COMUN.SE_USUARIO_MOVIMIENTO 
					Where	USMO_sUSUARIO_ID = @p_idu and
							USMO_bULTIMA_DOC = 1 and 
							USMO_cESTADO = 'A'

					If (@l_unidad != @p_und or @l_ose != @p_ose or @l_pais != @p_pai)
						Begin
							-- Si algo ha cambiado, pasa el registro anterior al histórico
							Update	SC_COMUN.SE_USUARIO_MOVIMIENTO
							Set		USMO_bULTIMA_DOC = 0
							Where	USMO_sUSUARIO_ID = @p_idu

							Insert Into SC_COMUN.SE_USUARIO_MOVIMIENTO (USMO_sUSUARIO_ID, USMO_sUNIDADORGANICA_ID, USMO_sPAIS_ID, USMO_sORGANOSERVICIO_ID, USMO_dFEC_VIG_INI, USMO_dFEC_VIG_FIN, USMO_sUSUARIO_CREACION, USMO_vIP_CREACION)
							Values (@p_idu, @p_und, @p_pai, @p_ose, Convert(datetime,@p_ini,103), Convert(datetime,@p_fin,103), @p_usr, @p_ipc)
						End
					Else
						Begin
							-- sino, actualiza la vigencia
							Update	SC_COMUN.SE_USUARIO_MOVIMIENTO
							Set		USMO_dFEC_VIG_INI = Convert(datetime,@p_ini,103), 
									USMO_dFEC_VIG_FIN = Convert(datetime,@p_fin,103),
									USMO_sUSUARIO_MODIFICACION = @p_usr,
									USMO_vIP_MODIFICACION = @p_ipc,
									USMO_dFECHA_MODIFICACION = getdate()
							Where
									USMO_sUSUARIO_ID = @p_idu
						End
				end
			else
				begin
					-- No tiene movimiento. Inserta
					Insert Into SC_COMUN.SE_USUARIO_MOVIMIENTO (USMO_sUSUARIO_ID, USMO_sUNIDADORGANICA_ID, USMO_sPAIS_ID, USMO_sORGANOSERVICIO_ID, USMO_dFEC_VIG_INI, USMO_dFEC_VIG_FIN, USMO_sUSUARIO_CREACION, USMO_vIP_CREACION)
					Values (@p_idu, @p_und, @p_pai, @p_ose, Convert(datetime,@p_ini,103), Convert(datetime,@p_fin,103), @p_usr, @p_ipc)
				end

			-- Inhabilitar todos los perfiles asociados
			Update	SC_COMUN.SE_USUARIO_PERFIL
			Set		USPE_cESTADO = 'I',
					USPE_sUSUARIO_MODIFICACION = @p_usr,
					USPE_vIP_MODIFICACION = @p_ipc,
					USPE_dFECHA_MODIFICACION = getdate()
			Where	
					USPE_sUSUARIO_ID = @p_idu
			
			-- Mensajes
			set	@l_Id = @p_idu;
			set @l_mensaje	= 'Se actualizaron los datos del usuario.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	
	select	'i_id' = @l_Id,
			's_msg'	= @l_mensaje,
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
End
go



if (object_id(N'SC_COMUN.USP_USUARIO_GRABARPERFIL') is not null)
	drop procedure SC_COMUN.USP_USUARIO_GRABARPERFIL
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba el perfil asociado a un usuario
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_USUARIO_GRABARPERFIL

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_USUARIO_GRABARPERFIL(
	@p_idu	int,
	@p_idp	int,
	
	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int
		
	Select @l_cant = Count(1) From SC_COMUN.SE_USUARIO_PERFIL where USPE_sUSUARIO_ID = @p_idu and USPE_sPERFIL_ID = @p_idp and USPE_cESTADO = 'I'
	if (@l_cant > 0)
		begin
			Update	SC_COMUN.SE_USUARIO_PERFIL
			Set		USPE_cESTADO = 'A',
					USPE_sUSUARIO_MODIFICACION = @p_usr,
					USPE_vIP_MODIFICACION = @p_ipc,
					USPE_dFECHA_MODIFICACION = getdate()

			Where	USPE_sUSUARIO_ID = @p_idu and
					USPE_sPERFIL_ID = @p_idp
		end
	else
		begin
			Insert Into SC_COMUN.SE_USUARIO_PERFIL(USPE_sPERFIL_ID, USPE_sUSUARIO_ID, USPE_sUSUARIO_CREACION, USPE_vIP_CREACION, USPE_dFECHA_CREACION)
			Values (@p_idp, @p_idu, @p_usr, @p_ipc, getdate())
		end
end
go


if (object_id(N'SC_COMUN.USP_USUARIO_GRABARSOL') is not null)
	drop procedure SC_COMUN.USP_USUARIO_GRABARSOL
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba una solicitud de usuario
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_USUARIO_GRABARSOL

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_USUARIO_GRABARSOL(
	@p_ape	varchar(35),
	@p_nom	varchar(35),
	@p_mai	varchar(50),
	@p_lan	varchar(12),
	@p_pas	varchar(44),
	@p_ose	int,
	
	@p_usr	smallint,
	@p_ipc	varchar(15)
)
As
Begin
	declare @l_cant int,
			@l_id	int,
			@l_pai	int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	declare @l_situacion	tinyint = 9,
			@l_unidadorg	int = 17
			
	
	Select @l_cant = Count(1) From SC_COMUN.SE_USUARIO Where USUA_vEMAIL = @p_mai
	if (@l_cant = 0) 
		begin
			-- No se encuentra
			begin transaction
				Insert Into SC_COMUN.SE_USUARIO (
							USUA_vAPELLIDOS, USUA_vNOMBRES, USUA_vEMAIL, 
							USUA_vUSR, USUA_vPWD,
							USUA_dFEC_VIG_INI, USUA_dFEC_VIG_FIN,
							USUA_tSITUACION, 
							USUA_sUSUARIO_CREACION, USUA_vIP_CREACION, USUA_cESTADO)
					Values (
							@p_ape, @p_nom, @p_mai, 
							@p_lan, @p_pas, 
							Convert(datetime,getdate(),103), Convert(datetime,getdate(),103),
							@l_situacion, 
							@p_usr, @p_ipc, 'I');
				set	@l_Id = scope_identity();
			commit;

			-- Pais
			Select	@l_pai = Ose.ORGA_sPAIS_ID
			From	SC_COMUN.SE_ORGANOSERVICIO Ose
			Where	Ose.ORGA_sORGANOSERVICIO_ID = @p_ose;



			Insert Into SC_COMUN.SE_USUARIO_MOVIMIENTO (USMO_sUSUARIO_ID, USMO_sUNIDADORGANICA_ID, USMO_sORGANOSERVICIO_ID, USMO_sPAIS_ID, USMO_dFEC_VIG_INI, USMO_dFEC_VIG_FIN, 
						USMO_sUSUARIO_CREACION, USMO_vIP_CREACION)  
				Values (@l_Id, @l_unidadorg, @p_ose, @l_pai, Convert(datetime,getdate(),103), Convert(datetime,getdate(),103), 
						@p_usr, @p_ipc)

			set	@l_Id = @l_Id;
			set @l_mensaje	= 'Su solicitud ha sido enviada. En breve se le enviará un correo electrónico con las instrucciones de acceso.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;

		end
	else
		begin
			-- Ya existe
			set	@l_Id = 0;
			set @l_mensaje	= 'El correo ingresado ya se encuentra registrado.'
			set @l_status	= 0;
			set @l_bs_tipo	= 4;
		end
	
	
	select	'i_id' = @l_Id,
			's_msg'	= @l_mensaje,
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE MENUITEM
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_MENUITEM_LISTAR') is not null)
	drop procedure SC_COMUN.USP_MENUITEM_LISTAR
go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Lista los elementos del menú
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEM_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MENUITEM_LISTAR
as
begin

	With Menus (Id, IdPadre, Nivel)
	As (
		Select	MENU_sMENUITEM_ID, MENU_sMENUITEM_PADRE, 0 as Nivel
		From	SC_COMUN.SE_MENUITEM
		Where	MENU_sMENUITEM_PADRE = 0 and 
				MENU_cESTADO = 'A'
	
		Union All
	
		Select	mn.MENU_sMENUITEM_ID, mn.MENU_sMENUITEM_PADRE, Nivel+1
		From	SC_COMUN.SE_MENUITEM mn
				Inner Join Menus m on (mn.MENU_sMENUITEM_PADRE = m.Id)
		Where	mn.MENU_cESTADO = 'A'
		)
		Select	'i_row' = row_number() over (order by mn.Id),
				'i_idm' = mn.Id, 
				'i_idp' = mn.IdPadre, 
				's_nom' = om.MENU_vNOMBRE, 
				's_des' = om.MENU_vDESCRIPCION, 

				's_con' = om.MENU_vCONTROLADOR, 
				's_met' = om.MENU_vMETODO, 
				's_par' = om.MENU_vPARAMETRO, 
				's_url' = om.MENU_vURL, 

				's_ico' = om.MENU_vICONO, 

				'i_pop' = om.MENU_bISPOPUP, 
				'i_vis' = om.MENU_bISVISIBLE, 
				'i_grp' = om.MENU_bISGRUPO,
				'i_ord' = om.MENU_iORDEN, 

				'i_nvl' = mn.Nivel,
				's_usr' = isnull(om.MENU_sUSUARIO_MODIFICACION, om.MENU_sUSUARIO_CREACION),
				's_ipu' = isnull(om.MENU_vIP_MODIFICACION, om.MENU_vIP_CREACION),
				's_fcr' = Convert(varchar(10), isnull(om.MENU_dFECHA_MODIFICACION, om.MENU_dFECHA_CREACION), 103),
			
				'i_est' = MENU_cESTADO
		From	
				Menus mn
				Inner Join SC_COMUN.SE_MENUITEM om on (om.MENU_sMENUITEM_ID = mn.Id)
		Order by
				om.MENU_iORDEN
	end
go



if (object_id(N'SC_COMUN.USP_MENUITEM_LISTAR_byPERFIL') is not null)
	drop procedure SC_COMUN.USP_MENUITEM_LISTAR_byPERFIL
go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Lista los elementos del menú segun el perfil
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEM_LISTAR_byPERFIL 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create Procedure SC_COMUN.USP_MENUITEM_LISTAR_byPERFIL(
	@p_idp	Smallint
)
As
Begin
	With Menus(	
			MENU_sMENUITEM_ID, MENU_sMENUITEM_PADRE, MENU_vNOMBRE, MENU_vDESCRIPCION,
			MENU_vCONTROLADOR, MENU_vMETODO, MENU_vPARAMETRO, MENU_vURL,
			MENU_vICONO,
			MENU_bISPOPUP, MENU_bISVISIBLE, MENU_bISGRUPO, MENU_iORDEN,
			MENU_cESTADO, NIVEL)
	As (
		Select	MENU_sMENUITEM_ID, MENU_sMENUITEM_PADRE, MENU_vNOMBRE, MENU_vDESCRIPCION,
				MENU_vCONTROLADOR, MENU_vMETODO, MENU_vPARAMETRO, MENU_vURL,
				MENU_vICONO,
				MENU_bISPOPUP, MENU_bISVISIBLE, MENU_bISGRUPO, MENU_iORDEN,
				MENU_cESTADO, 0 AS NIVEL
		From	
				SC_COMUN.SE_MENUITEM
		Where
				MENU_sMENUITEM_PADRE = 0 and 
				MENU_cESTADO = 'A'
		Union All
		Select	mi.MENU_sMENUITEM_ID, mi.MENU_sMENUITEM_PADRE, mi.MENU_vNOMBRE, mi.MENU_vDESCRIPCION,
				mi.MENU_vCONTROLADOR, mi.MENU_vMETODO, mi.MENU_vPARAMETRO, mi.MENU_vURL,
				mi.MENU_vICONO,
				mi.MENU_bISPOPUP, mi.MENU_bISVISIBLE, mi.MENU_bISGRUPO, mi.MENU_iORDEN,
				mi.MENU_cESTADO, NIVEL +1
		From	
				SC_COMUN.SE_MENUITEM mi
				Inner Join Menus as m on (mi.MENU_sMENUITEM_PADRE = m.MENU_sMENUITEM_ID)
		Where
				mi.MENU_cESTADO = 'A')

		Select
				'i_mnusid' = MENU_sMENUITEM_ID, 
				'i_mnupad' = MENU_sMENUITEM_PADRE, 
				's_mnunom' = MENU_vNOMBRE, 
				's_mnudes' = MENU_vDESCRIPCION,
				's_mnucon' = MENU_vCONTROLADOR, 
				's_mnumet' = MENU_vMETODO, 
				's_mnupar' = MENU_vPARAMETRO, 
				's_mnuurl' = MENU_vURL,
				's_mnuico' = MENU_vICONO,
				'i_mnupop' = MENU_bISPOPUP, 
				'i_mnuvis' = MENU_bISVISIBLE, 
				'i_mnugrp' = MENU_bISGRUPO, 
				'i_mnuord' = MENU_iORDEN,
				'i_mnuniv' = NIVEL,
				'i_mnuaut' = Case 
					When pe.PEME_sMENUITEM_ID is null Then 0 Else 1 End
		From	
				Menus
				Left Join SC_COMUN.SE_PERFIL_MENUITEM pe on (pe.PEME_sMENUITEM_ID = Menus.MENU_sMENUITEM_ID and pe.PEME_cESTADO = 'A' and pe.PEME_sPERFIL_ID = @p_idp)
		Order  by
				NIVEL, MENU_iORDEN, MENU_vNOMBRE
End
Go



if (object_id(N'SC_COMUN.USP_MENUITEM_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_MENUITEM_LISTAR_BYID
go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Lista los elementos del menú segun su id
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEM_LISTAR_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MENUITEM_LISTAR_BYID(
	@p_ido int
)
as
begin
	select	'i_id'  = MENU_sMENUITEM_ID,
			'i_idp' = MENU_sMENUITEM_PADRE,
			's_nom' = MENU_vNOMBRE,
			's_des' = MENU_vDESCRIPCION,
	
			's_con' = MENU_vCONTROLADOR,
			's_met' = MENU_vMETODO,
			's_par' = MENU_vPARAMETRO,
			's_url' = MENU_vURL,
	
			's_ico' = MENU_vICONO,
		
			'i_pop' = MENU_bISPOPUP,
			'i_vis' = MENU_bISVISIBLE,
			'i_grp' = MENU_bISGRUPO,
			'i_ord' = MENU_iORDEN,

			's_usr' = isnull(MENU_sUSUARIO_MODIFICACION, MENU_sUSUARIO_CREACION),
			's_ipu' = isnull(MENU_vIP_MODIFICACION, MENU_vIP_CREACION),
			's_fcr' = Convert(varchar(10), isnull(MENU_dFECHA_MODIFICACION, MENU_dFECHA_CREACION), 103),
		
			'i_est' = MENU_cESTADO
	From	
			SC_COMUN.SE_MENUITEM i
	Where
			MENU_sMENUITEM_ID = @p_ido and
			MENU_cESTADO = 'A'

End
go



if (object_id(N'SC_COMUN.USP_MENUITEM_GRABAR') is not null)
	drop procedure SC_COMUN.USP_MENUITEM_GRABAR
go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Graba un elemento de menu
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEM_LISTAR_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MENUITEM_GRABAR(
	@p_ido	int,
	@p_idp	int,
	@p_nom	varchar(150),
	@p_des	varchar(150),
	
	@p_con	varchar(80),
	@p_met	varchar(80),
	@p_par	varchar(30),
	@p_url	varchar(150),

	@p_ico	varchar(40),

	@p_ipo	bit,
	@p_ivi	bit,
	@p_igr	bit,

	@p_ord	int,

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
	
	if (@p_ido = 0)
		begin
			Insert Into SC_COMUN.SE_MENUITEM (MENU_sMENUITEM_PADRE, MENU_vNOMBRE, MENU_vDESCRIPCION, MENU_vCONTROLADOR, MENU_vMETODO, MENU_vPARAMETRO, MENU_vURL, MENU_vICONO,
					MENU_bISPOPUP, MENU_bISVISIBLE, MENU_bISGRUPO, MENU_iORDEN,
					MENU_sUSUARIO_CREACION, MENU_vIP_CREACION, MENU_dFECHA_CREACION) Values 
					(@p_idp, @p_nom, @p_des, @p_con, @p_met, @p_par, @p_url, @p_ico,
					@p_ipo, @p_ivi, @p_igr, @p_ord,
					@p_usr, @p_ipc, getdate())
			
			
			set @l_mensaje	= 'Se agrego el elemento.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			update	SC_COMUN.SE_MENUITEM
			set		MENU_sMENUITEM_PADRE = @p_idp,
					MENU_vNOMBRE = @p_nom,
					MENU_vDESCRIPCION = @p_des,
					MENU_vCONTROLADOR = @p_con,
					MENU_vMETODO = @p_met,
					MENU_vPARAMETRO = @p_par,
					MENU_vURL = @p_url,
					MENU_vICONO = @p_ico,
					MENU_bISPOPUP = @p_ipo,
					MENU_bISVISIBLE = @p_ivi,
					MENU_bISGRUPO = @p_igr,
					MENU_iORDEN = @p_ord,
					MENU_sUSUARIO_MODIFICACION = @p_usr,
					MENU_vIP_MODIFICACION = @p_ipc,
					MENU_dFECHA_MODIFICACION = getdate()
			where
					MENU_sMENUITEM_ID = @p_ido and
					MENU_cESTADO = 'A'

			set @l_mensaje	= 'Se actualizó el elemento.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go



if (object_id(N'SC_COMUN.USP_MENUITEMS_RESET_BYPERFIL') is not null)
	drop procedure SC_COMUN.USP_MENUITEMS_RESET_BYPERFIL
go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Desvincula los elementos de menu a un perfil
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEMS_RESET_BYPERFIL 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MENUITEMS_RESET_BYPERFIL(
	@p_idp	int,

	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	-- Elimina todo
	update	SC_COMUN.SE_PERFIL_MENUITEM
	set		PEME_cESTADO = 'I',
			PEME_sUSUARIO_MODIFICACION = @p_usr, 
			PEME_vIP_MODIFICACION = @p_ipc,
			PEME_dFECHA_MODIFICACION = getdate()
	where	
			PEME_sPERFIL_ID = @p_idp
end
go



if (object_id(N'SC_COMUN.USP_MENUITEMS_GRABAR_BYPERFIL') is not null)
	drop procedure SC_COMUN.USP_MENUITEMS_GRABAR_BYPERFIL
Go
/*
Sistema		: Aplicativo de Gestion de Misiones
Objetivo	: Vincula los elementos de una opcion del menu a un perfil
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: 
	@p_idp - Id del Perfil

Ejecutar	: 
	exec SC_COMUN.USP_MENUITEMS_GRABAR_BYPERFIL 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MENUITEMS_GRABAR_BYPERFIL(
	@p_ido	int,
	@p_idp	int,

	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,
			@l_id_padre int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	-- Busca si existe la opcion
	Select @l_cant = Count(1) From SC_COMUN.SE_PERFIL_MENUITEM Where PEME_sPERFIL_ID = @p_idp and PEME_sMENUITEM_ID = @p_ido and PEME_cESTADO = 'I'
	Select @l_id_padre = MENU_sMENUITEM_PADRE From SC_COMUN.SE_MENUITEM where MENU_sMENUITEM_ID = @p_ido and MENU_cESTADO = 'A'

	if (@l_cant > 0)
		begin -- Existe la opcion
			Update	SC_COMUN.SE_PERFIL_MENUITEM
			Set		PEME_cESTADO = 'A',
					PEME_sUSUARIO_MODIFICACION = @p_usr, 
					PEME_dFECHA_MODIFICACION = GETDATE(),
					PEME_vIP_MODIFICACION = @p_ipc
			Where	
					PEME_sMENUITEM_ID = @p_ido and 
					PEME_sPERFIL_ID = @p_idp

			set @l_mensaje	= 'Se actualizó la opción del menu.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			Insert Into SC_COMUN.SE_PERFIL_MENUITEM (PEME_sMENUITEM_ID, PEME_sMENUITEM_PADRE, PEME_sPERFIL_ID, PEME_sUSUARIO_CREACION, PEME_vIP_CREACION, PEME_dFECHA_CREACION)
			Values (@p_ido, @l_id_padre, @p_idp, @p_usr, @p_ipc, getdate())

			set @l_mensaje	= 'Se agrego la opción del menú.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE PERFIL
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_PERFIL_VALIDAR_VISTA') is not null)
	drop procedure SC_COMUN.USP_PERFIL_VALIDAR_VISTA
go
/*
Sistema		: Aplicativo de Gestion de Servicio Exterior
Objetivo	: Verfica si el perfil tiene acceso al controlador/metodo especificado
Creado por	: Victor Neyra
Fecha		: 07/04/2017
Parametros	: Perfill, controlador, método
Ejecutar	: 
	declare @p_stus bit
	exec SC_COMUN.USP_PERFIL_VALIDAR_VISTA 1, 'Home', 'Index', @p_stus OUTPUT
	Select @p_stus

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_PERFIL_VALIDAR_VISTA (
	@p_perf smallint,
	@p_ctrl varchar(40),
	@p_mtdo	varchar(40),
	@p_stus bit output
)
as
begin
	Select	@p_stus = Case When Count(1) > 0 Then 1 Else 0 end 
	From	SC_COMUN.SE_PERFIL_MENUITEM pm
			Inner Join SC_COMUN.SE_MENUITEM mi on (mi.MENU_sMENUITEM_ID = pm.PEME_sMENUITEM_ID and mi.MENU_cESTADO = 'A')
	Where	
			pm.PEME_sPERFIL_ID = @p_perf and
			mi.MENU_vCONTROLADOR = @p_ctrl and
			mi.MENU_vMETODO = @p_mtdo and
			pm.PEME_cESTADO = 'A'
end
Go


if (object_id(N'SC_COMUN.USP_PERFIL_LISTAR_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_PERFIL_LISTAR_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de perfiles para el control selectlist
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_PERFIL_LISTAR_TOSELECT

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERFIL_LISTAR_TOSELECT
As
Begin
	Select	'i_persid' 		= p.PERF_sPERFIL_ID, 
			's_pernom'		= p.PERF_vNOMBRE 
					
	From	SC_COMUN.SE_PERFIL p
	Where	
			P.PERF_cESTADO = 'A'
End
Go



if (object_id(N'SC_COMUN.USP_PERFIL_LISTAR_byUSER') is not null)
	drop procedure SC_COMUN.USP_PERFIL_LISTAR_byUSER
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Lista uno o todos los perfiles asociados a un usuario
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_PERFIL_LISTAR_byUSER 1
	exec  SC_COMUN.USP_PERFIL_LISTAR_byUSER 2

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create Procedure SC_COMUN.USP_PERFIL_LISTAR_byUSER(
	@p_idU	int
)
As
Begin
	Select	'i_persid'	= p.PERF_sPERFIL_ID, 
			's_pernom'	= p.PERF_vNOMBRE,
			's_perabr'	= p.PERF_vABREVIATURA,
			's_perdes'	= p.PERF_vDESCRIPCION
					
	From	SC_COMUN.SE_USUARIO_PERFIL up
			Inner Join SC_COMUN.SE_PERFIL p On (p.PERF_sPERFIL_ID = up.USPE_sPERFIL_ID and p.PERF_cESTADO = 'A')
	Where	
			up.USPE_sUSUARIO_ID = @p_idu and
			up.USPE_cESTADO = 'A'
End
Go



if (object_id(N'SC_COMUN.USP_PERFIL_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PERFIL_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de perfiles
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.USP_PERFIL_LISTAR 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERFIL_LISTAR(
	@p_idp int
)
As
Begin
	If (@p_idp = 0) 
		begin
			Select	'i_perrow'	= row_number() over (order by PERF_sPERFIL_ID),
					'i_persid' 	= PERF_sPERFIL_ID, 
					's_pernom'	= PERF_vNOMBRE,
					's_perabr'	= PERF_vABREVIATURA,
					's_perdes'	= PERF_vDESCRIPCION
			From	
					SC_COMUN.SE_PERFIL p
			Where	
					P.PERF_cESTADO = 'A'
		end
	else
		begin
			Select	'i_persid' 	= PERF_sPERFIL_ID, 
					's_pernom'	= PERF_vNOMBRE,
					's_perabr'	= PERF_vABREVIATURA,
					's_perdes'	= PERF_vDESCRIPCION
			From	
					SC_COMUN.SE_PERFIL p
			Where	
					PERF_sPERFIL_ID = @p_idp and
					PERF_cESTADO = 'A'
		end
End
Go



if (object_id(N'SC_COMUN.USP_PERFIL_GRABAR') is not null)
	drop procedure SC_COMUN.USP_PERFIL_GRABAR
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba un perfil
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid		Id del usuario

Ejecutar	: 
	exec  SC_COMUN.PERFIL_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PERFIL_GRABAR(
	@p_idp	int,
	@p_nom	varchar(35),
	@p_abr	varchar(10),
	@p_des	varchar(35),

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
	
	if (@p_idp = 0)
		begin
			Insert Into SC_COMUN.SE_PERFIL (PERF_vNOMBRE, PERF_vABREVIATURA, PERF_vDESCRIPCION,
					PERF_sUSUARIO_CREACION, PERF_vIP_CREACION, PERF_dFECHA_CREACION) Values 
					(@p_nom, @p_abr, @p_des,
					@p_usr, @p_ipc, getdate())

			set @l_mensaje	= 'Se agrego el perfil.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	else
		begin
			update	SC_COMUN.SE_PERFIL
			set		PERF_vNOMBRE = @p_nom,
					PERF_vABREVIATURA = @p_abr,
					PERF_vDESCRIPCION = @p_des,

					PERF_sUSUARIO_MODIFICACION = @p_usr,
					PERF_vIP_MODIFICACION = @p_ipc,
					PERF_dFECHA_MODIFICACION = getdate()
			where
					PERF_sPERFIL_ID = @p_idp and
					PERF_cESTADO = 'A'

			set @l_mensaje	= 'Se actualizó el perfil.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE UNIDADES ORGÁNICAS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_UNIDADORGANICA_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR_TODT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de unidades organicas para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_page_nmber	Número de página
	@p_page_rows	Cantidad de registros por página
	@p_page_search	Buscador
	@p_page_sort	Orden
	@p_page_dir		Dirección del orden
	@p_rows_totl	Total de registros

Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_UNIDADORGANICA_LISTAR_TODT 0, 20, '', 0, 'asc', @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR_TODT (
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin

	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_UNIDADORGANICA
	Where	UNID_cESTADO = 'A'

	Select	'i_row' = row_number() over (order by uo.UNID_sUNIDADORGANICA_ID),
			'i_idu' = uo.UNID_sUNIDADORGANICA_ID, 
			's_nom' = uo.UNID_vNOMBRE, 
			's_abr' = uo.UNID_vABREVIATURA, 
			's_des' = uo.UNID_vDESCRIPCION, 
			's_usp' = us.UNID_vNOMBRE 
	From	
			SC_COMUN.SE_UNIDADORGANICA uo
			Left Join SC_COMUN.SE_UNIDADORGANICA us on (us.UNID_sUNIDADORGANICA_ID = uo.UNID_sUNIDADSUPERIOR and us.UNID_cESTADO = 'A')
	Where
			uo.UNID_cESTADO = 'A' and (
			(uo.UNID_vNOMBRE Like '%' + @p_page_search + '%'))
	
	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then uo.UNID_sUNIDADORGANICA_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then uo.UNID_sUNIDADORGANICA_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then uo.UNID_vNOMBRE end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then uo.UNID_vNOMBRE end desc

	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
Go



if (object_id(N'SC_COMUN.USP_UNIDADORGANICA_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de una unidad organica
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_UNIDADORGANICA_LISTAR_BYID 2

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
	
$*/
Create Procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR_BYID (
	@p_sid	int
)
As
Begin
	Select	'i_idu' = uo.UNID_sUNIDADORGANICA_ID, 
			's_nom' = uo.UNID_vNOMBRE, 
			's_abr' = uo.UNID_vABREVIATURA, 
			's_des' = uo.UNID_vDESCRIPCION, 
			'i_usp' = us.UNID_sUNIDADORGANICA_ID
	From	
			SC_COMUN.SE_UNIDADORGANICA uo
			Left Join SC_COMUN.SE_UNIDADORGANICA us on (us.UNID_sUNIDADORGANICA_ID = uo.UNID_sUNIDADSUPERIOR and us.UNID_cESTADO = 'A')
	Where
			uo.UNID_sUNIDADORGANICA_ID = @p_sid and
			uo.UNID_cESTADO = 'A' 
End
Go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE BANCOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_BANCO_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_BANCO_LISTAR_TODT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de bancos para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
				@p_page_nmber	Número de página
				@p_page_rows	Cantidad de registros por página
				@p_page_search	Buscador
				@p_page_sort	Orden
				@p_page_dir		Dirección del orden
				@p_rows_totl	Total de registros

Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_BANCO_LISTAR_TODT 1, 10, '', 0, 'asc', @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCO_LISTAR_TODT (
	--@p_page_env		int,
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin
	/*
		Situacion es polivalente, en bancos puede significar Habilidado/Inhabilitado, en otros procesos
		puede cambiar su significado por dos o mas tipos (anulado, cancelado, registrado, verificado, ...etc)

		Situacion	:	1 Registro Habilitado (Permite todas las operaciones)
						0 Registro Inhabilitado (Las operaciones se restringen)
		
		-- Campo interno
		Estado		:	A Activo	: Visible en la interfaz
						I Inactivo	: Invisible en la interfaz. Eliminado Lógico
	*/


	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_BANCO
	Where	BANC_tSITUACION = 1 and
			BANC_cESTADO = 'A'

	Select	'i_row' = row_number() over (order by bn.BANC_sBANCO_ID),
			'i_sid' = bn.BANC_sBANCO_ID,
			's_nom' = bn.BANC_vNOMBRE,
			's_url' = bn.BANC_vURL,
			'i_sit' = bn.BANC_tSITUACION 
	From	
			SC_COMUN.SE_BANCO bn
	Where 
			BANC_tSITUACION = 1 and
			BANC_cESTADO = 'A' and (
			(bn.BANC_vNOMBRE Like '%' + @p_page_search + '%'))
			
	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then bn.BANC_sBANCO_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then bn.BANC_sBANCO_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then bn.BANC_vNOMBRE end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then bn.BANC_vNOMBRE end desc
	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
Go


if (object_id(N'SC_COMUN.USP_BANCO_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_BANCO_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de un banco
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_BANCO_LISTAR_BYID 10

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCO_LISTAR_BYID(
	@p_sid int
)
As
begin
	select	'i_sid' = bn.BANC_sBANCO_ID, 
			's_nom' = bn.BANC_vNOMBRE, 
			's_url' = bn.BANC_vURL, 
			'i_sit' = bn.BANC_tSITUACION
	from	
			SC_COMUN.SE_BANCO bn
	where	
			bn.BANC_sBANCO_ID = @p_sid and
			bn.BANC_cESTADO = 'A'
end
go


if (object_id(N'SC_COMUN.USP_BANCO_GRABAR') is not null)
	drop procedure SC_COMUN.USP_BANCO_GRABAR
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Almacena los datos de un banco
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: Datos del banco
Ejecutar	: 
	exec SC_COMUN.USP_BANCO_GRABAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCO_GRABAR(
	@p_idb		Smallint,
	@p_nom		varchar(35),	-- Nombre
	@p_url		varchar(120),	-- Url
	@p_sit		tinyint,		-- Situacion

	@p_usr		smallint,
	@p_ipc		varchar(15)
)
As 
Begin
	declare @l_cant int,
			@l_id	int = 0,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1

	if (@p_idb = 0)
		begin
			Select @l_cant = Count(1) from SC_COMUN.SE_BANCO Where BANC_vNOMBRE = @p_nom and BANC_cESTADO = 'A'
			if (@l_cant > 0)
				begin
					set @l_mensaje	= 'Ya existe un banco con el nombre ' + @p_nom
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
			else
				begin 
					begin transaction
						Insert Into SC_COMUN.SE_BANCO (BANC_vNOMBRE, BANC_vURL, BANC_tSITUACION, BANC_sUSUARIO_CREACION, BANC_vIP_CREACION)
						Values (@p_nom, @p_url, @p_sit, @p_usr, @p_ipc)

						set @l_mensaje	= 'Se agrego el Banco ' + @p_nom
						set @l_status	= 1;
						set @l_bs_tipo	= 1;

						set	@l_id = scope_identity();
					commit;
				end
		end
	else
		begin
			Update	SC_COMUN.SE_BANCO
			Set		BANC_vNOMBRE = @p_nom,
					BANC_vURL = @p_url, 
					BANC_tSITUACION = @p_sit,

					BANC_sUSUARIO_MODIFICACION = @p_usr,
					BANC_vIP_MODIFICACION = @p_ipc,
					BANC_dFECHA_MODIFICACION = getdate()
			Where
					BANC_sBANCO_ID = @p_idb and
					BANC_cESTADO = 'A'

			set	@l_id =@p_idb;
			set @l_mensaje	= 'Se actualizaron los datos del banco.';
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id'	= @l_id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
End 
go


if (object_id(N'SC_COMUN.USP_BANCOAGENCIA_LISTAR') is not null)
	drop procedure SC_COMUN.USP_BANCOAGENCIA_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve una agencia bancaria por su ID o todas según el parámetro
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_BANCOAGENCIA_LISTAR 1, 0

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCOAGENCIA_LISTAR (
	@p_idb		int,  -- Banco
	@p_ida		int -- Agencia
)
As
Begin
	Declare	@CONST_TIPO_DESTINO int = 2
	
	if (@p_ida = 0)
		begin
			-- Listar todas las agencias del banco
			Select	'i_row' = row_number() over (order by ba.BAAG_sBANCOAGENCIA_ID),
					'i_age' = ba.BAAG_sBANCOAGENCIA_ID,
					'i_bco' = ba.BAAG_sBANCO_ID, 
					's_nom' = ba.BAAG_vNOMBREAGENCIA, 
					's_di1' = ba.BAAG_vDOMICILIO1, 
					's_di2' = ba.BAAG_vDOMICILIO2,
					'i_tip' = ba.BAAG_tTIPO,
					's_tip' = pm.PAIT_vTEXTO,
					'i_pai' = ba.BAAG_sPAIS_ID,
					's_pai' = ps.PAIS_vNOMBRE
			From	
					SC_COMUN.SE_BANCO_AGENCIA ba
					Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = ba.BAAG_sPAIS_ID and ps.PAIS_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM pm on (pm.PAIT_sPARAMETRO_ID = @CONST_TIPO_DESTINO and pm.PAIT_vVALOR = ba.BAAG_tTIPO and pm.PAIT_cESTADO = 'A')
			Where	
					ba.BAAG_sBANCO_ID = @p_idb and
					ba.BAAG_cESTADO = 'A'
		end
	else 
		begin
			-- Listar una sola agencia de un banco determinado
			Select	'i_age' = ba.BAAG_sBANCOAGENCIA_ID,
					'i_bco' = ba.BAAG_sBANCO_ID, 
					's_nom' = ba.BAAG_vNOMBREAGENCIA, 
					's_di1' = ba.BAAG_vDOMICILIO1, 
					's_di2' = ba.BAAG_vDOMICILIO2,
					'i_tip' = ba.BAAG_tTIPO,
					's_tip' = pm.PAIT_vTEXTO,
					'i_pai' = ba.BAAG_sPAIS_ID,
					's_pai' = ps.PAIS_vNOMBRE
			From	
					SC_COMUN.SE_BANCO_AGENCIA ba
					Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = ba.BAAG_sPAIS_ID and ps.PAIS_cESTADO = 'A')
					Inner Join SC_COMUN.SE_PARAMETRO_ITEM pm on (pm.PAIT_sPARAMETRO_ID = @CONST_TIPO_DESTINO and pm.PAIT_vVALOR = ba.BAAG_tTIPO and pm.PAIT_cESTADO = 'A')
			Where	
					ba.BAAG_sBANCOAGENCIA_ID = @p_ida and
					ba.BAAG_cESTADO = 'A'
		end
End
go



if (object_id(N'SC_COMUN.USP_BANCOAGENCIA_GRABAR') is not null)
	drop procedure SC_COMUN.USP_BANCOAGENCIA_GRABAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve una agencia bancaria por su ID o todas según el parámetro
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_BANCOAGENCIA_LISTAR 121, 0

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCOAGENCIA_GRABAR (
	@p_ida		int, -- Agencia
	@p_idb		int, -- Banco

	@p_nom		varchar(35),
	@p_dir1		varchar(35),
	@p_dir2		varchar(35),
	@p_tip		int,
	@p_pai		int,
	@p_usr		int,
	@p_ipc		varchar(15)
)
As
Begin
	Declare		@l_cant		int,
				@l_Id		int = 0,

				@l_mensaje	varchar(255),
				@l_status	int = 0,
				@l_bs_tipo	int = 1

	if (@p_ida = 0)
		begin
			Select @l_cant = count(1) From SC_COMUN.SE_BANCO_AGENCIA Where (BAAG_vNOMBREAGENCIA = @p_dir1 and BAAG_cESTADO = 'A')
			if (@l_cant = 0)
				begin
					begin transaction
						Insert Into SC_COMUN.SE_BANCO_AGENCIA (BAAG_sBANCO_ID, BAAG_vNOMBREAGENCIA, BAAG_vDOMICILIO1, BAAG_vDOMICILIO2, BAAG_tTIPO, BAAG_sPAIS_ID, BAAG_sUSUARIO_CREACION, BAAG_vIP_CREACION) 
						Values (@p_idb, @p_nom, @p_dir1, @p_dir2, @p_tip, @p_pai, @p_usr, @p_ipc)

						set	@l_Id = scope_identity();
						
						set @l_mensaje	= 'Se agrego la Agencia Bancaria ' + @p_dir1
						set @l_status	= 1;
						set @l_bs_tipo	= 1;

					commit;
				end
			else
				begin
					set @l_Id = 0;
					set @l_mensaje	= 'Ya existe una Agencia con esos datos.'
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
		
		end
	else
		begin
			
			Declare @l_nom	varchar(35),
					@l_di1	varchar(35),
					@l_di2	varchar(35)

			Update	SC_COMUN.SE_BANCO_AGENCIA
			Set		BAAG_vNOMBREAGENCIA = @p_nom, 
					BAAG_vDOMICILIO1 = @p_dir1, 
					BAAG_vDOMICILIO2 = @p_dir2,
					BAAG_tTIPO = @p_tip,
					BAAG_sPAIS_ID = @p_pai,
					BAAG_sUSUARIO_MODIFICACION = @p_usr,
					BAAG_vIP_MODIFICACION = @p_ipc,
					BAAG_dFECHA_MODIFICACION = getdate()
			Where
					BAAG_sBANCOAGENCIA_ID =  @p_ida

			set @l_Id = @p_ida
			set @l_mensaje	= 'Se actualizaron los datos de agencia.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end
	
	Select	'i_id'	= @l_Id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo

End
go


if (object_id(N'SC_COMUN.USP_BANCOAGENCIA_LISTAR_SELECT_BYOSE') is not null)
	drop procedure SC_COMUN.USP_BANCOAGENCIA_LISTAR_SELECT_BYOSE
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las agencias bancarias según el país del organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_BANCOAGENCIA_LISTAR_SELECT_BYOSE 130

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCOAGENCIA_LISTAR_SELECT_BYOSE (
	@p_sid		int
)
As
Begin
	Declare @AgenciaTipoDestino Int = 2,
			@AgenciaTipoTodos	Int = 3
	
	Select	'i_agesid' = Age.BAAG_sBANCOAGENCIA_ID, 
			's_agenom' = Concat(Ban.BANC_vNOMBRE,' - ',Age.BAAG_vNOMBREAGENCIA)
	From	SC_COMUN.SE_ORGANOSERVICIO Ose
			Inner Join SC_COMUN.SE_BANCO_AGENCIA Age On (Age.BAAG_sPAIS_ID = Ose.ORGA_sPAIS_ID and Ose.ORGA_cESTADO = 'A' and (Age.BAAG_tTIPO = @AgenciaTipoDestino or Age.BAAG_tTIPO = @AgenciaTipoTodos))
			Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and Ban.BANC_cESTADO = 'A')
	Where
			Ose.ORGA_sORGANOSERVICIO_ID = @p_sid
End
Go


if (object_id(N'SC_COMUN.USP_BANCOAGENCIA_LISTARINTERMEDIO_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_BANCOAGENCIA_LISTARINTERMEDIO_TOSELECT
go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de bancos para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_BANCOAGENCIA_LISTARINTERMEDIO_TOSELECT

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_BANCOAGENCIA_LISTARINTERMEDIO_TOSELECT
As
Begin
	
	Declare @l_agencias_intermedias int = 1,
			@l_agencias_todas int = 3

	Select	'i_agesid' = ag.BAAG_sBANCOAGENCIA_ID, 
			's_agenom' = Concat(ba.BANC_vNOMBRE, ' - ', ag.BAAG_vNOMBREAGENCIA)
	From	
			SC_COMUN.SE_BANCO_AGENCIA ag
			Inner Join SC_COMUN.SE_BANCO ba on (ba.BANC_sBANCO_ID = ag.BAAG_sBANCO_ID and ba.BANC_cESTADO = 'A')
	Where	ag.BAAG_tTIPO = @l_agencias_intermedias or 
			ag.BAAG_tTIPO = @l_agencias_todas
	Order by
			ba.BANC_vNOMBRE, ag.BAAG_vNOMBREAGENCIA

End
go


if (object_id(N'SC_REPORTES.USP_BANCO_EXPORTAR_BASE') is not null)
	drop procedure SC_REPORTES.USP_BANCO_EXPORTAR_BASE
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve todos los registros para el reporte de BancoAgencias en Excel
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_REPORTES.USP_BANCO_EXPORTAR_BASE

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_REPORTES.USP_BANCO_EXPORTAR_BASE
As
Begin
	-- Tabla Parametros: Tipo de Agencia Bancaria para Transferencias 
	Declare	@P_TIPO_AGENCIA_BANCARIA int = 2
	
	Select	's_ban' = ba.BANC_vNOMBRE,
			's_age' = ag.BAAG_vNOMBREAGENCIA, 
			's_do1' = ag.BAAG_vDOMICILIO1, 
			's_do2' = ag.BAAG_vDOMICILIO2, 
			's_tip' = pa.PAIT_vTEXTO,
			's_pai' = ps.PAIS_vNOMBRE
	From	
			SC_COMUN.SE_BANCO ba
			Inner Join SC_COMUN.SE_BANCO_AGENCIA ag on (ag.BAAG_sBANCO_ID = ba.BANC_sBANCO_ID and ag.BAAG_tSITUACION = 1 and ag.BAAG_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pa on (pa.PAIT_sPARAMETRO_ID = @P_TIPO_AGENCIA_BANCARIA and pa.PAIT_vVALOR = ag.BAAG_tTIPO and pa.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = ag.BAAG_sPAIS_ID and ps.PAIS_cESTADO = 'A')
	Where
			ba.BANC_tSITUACION = 1 and
			ba.BANC_cESTADO = 'A'
	Order by
			ba.BANC_vNOMBRE, ag.BAAG_vNOMBREAGENCIA
End
Go


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
			's_ose' = os.ORGA_vABREVIATURA
	From	
			SC_COMUN.SE_BANCO ba
			Inner Join SC_COMUN.SE_BANCO_AGENCIA ag on (ag.BAAG_sBANCO_ID = ba.BANC_sBANCO_ID and ag.BAAG_tSITUACION = 1 and ag.BAAG_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pa on (pa.PAIT_sPARAMETRO_ID = @P_TIPO_AGENCIA_BANCARIA and pa.PAIT_vVALOR = ag.BAAG_tTIPO and pa.PAIT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = ag.BAAG_sPAIS_ID and ps.PAIS_cESTADO = 'A')
			Left Join SC_COMUN.SE_CUENTACORRIENTE ct on (ct.CUEN_sBANCO_AGENCIA_ID = ag.BAAG_sBANCOAGENCIA_ID and ct.CUEN_tSITUACION = 1 and ct.CUEN_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE dct on (dct.ORCT_sCUENTACORRIENTE_ID = ct.CUEN_sCUENTACORRIENTE_ID and dct.ORCT_cESTADO = 'A')
			Inner Join SC_COMUN.SE_ORGANOSERVICIO os on (os.ORGA_sORGANOSERVICIO_ID = dct.ORCT_sORGANOSERVICIO_ID and os.ORGA_tSITUACION = 3 and os.ORGA_cESTADO = 'A')
	Where
			ba.BANC_tSITUACION = 1 and
			ba.BANC_cESTADO = 'A'
	Order by
			ba.BANC_vNOMBRE, ag.BAAG_vNOMBREAGENCIA
End
Go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE CUENTAS CORRIENTES
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
					'i_ctasit' = cta.CUEN_tSITUACION
			From	
					SC_COMUN.SE_CUENTACORRIENTE Cta
					Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and Det.ORCT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_ORGANOSERVICIO Ose on (Ose.ORGA_sORGANOSERVICIO_ID = Det.ORCT_sORGANOSERVICIO_ID and Ose.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_MONEDA Mnd on (Mnd.MONE_sMONEDA_ID = Cta.CUEN_sMONEDA_ID and Mnd.MONE_cESTADO = 'A')
		
					Inner Join SC_COMUN.SE_BANCO_AGENCIA Age on (Age.BAAG_sBANCOAGENCIA_ID = Cta.CUEN_sBANCO_AGENCIA_ID and Age.BAAG_cESTADO = 'A')
					Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and Ban.BANC_cESTADO = 'A')
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

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then Cta.CUEN_bESCOMPARTIDA end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then Cta.CUEN_bESCOMPARTIDA end desc

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
					'i_ctasit' = CUEN_tSITUACION
			From	
					SC_COMUN.SE_CUENTACORRIENTE Cta
					Inner Join SC_COMUN.SE_ORGANOSERVICIO_CTACTE Det on (Det.ORCT_sCUENTACORRIENTE_ID = Cta.CUEN_sCUENTACORRIENTE_ID and Det.ORCT_cESTADO = 'A')
					Inner Join SC_COMUN.SE_ORGANOSERVICIO Ose on (
						Ose.ORGA_sORGANOSERVICIO_ID = Det.ORCT_sORGANOSERVICIO_ID and 
						Ose.ORGA_sORGANOSERVICIO_ID = @p_page_flt and
						Ose.ORGA_cESTADO = 'A')
					Inner Join SC_COMUN.SE_MONEDA Mnd on (Mnd.MONE_sMONEDA_ID = Cta.CUEN_sMONEDA_ID and Mnd.MONE_cESTADO = 'A')
		
					Inner Join SC_COMUN.SE_BANCO_AGENCIA Age on (Age.BAAG_sBANCOAGENCIA_ID = Cta.CUEN_sBANCO_AGENCIA_ID and Age.BAAG_cESTADO = 'A')
					Inner Join SC_COMUN.SE_BANCO Ban on (Ban.BANC_sBANCO_ID = Age.BAAG_sBANCO_ID and Ban.BANC_cESTADO = 'A')
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

					case when @p_page_sort = 5 and @p_page_dir = 'asc' then Cta.CUEN_bESCOMPARTIDA end,
					case when @p_page_sort = 5 and @p_page_dir = 'desc' then Cta.CUEN_bESCOMPARTIDA end desc

			OFFSET
					(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
		End
End
Go


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
	exec SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID 2

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
			
			's_plaent' = Tem.TRTE_sENTIDAD_ID, 
			's_placta' = Tem.TRTE_sCTAORIGEN_ID,
			's_plades' = Tem.TRTE_sTIPOCTADES_ID,
			's_plaage' = Tem.TRTE_sAGENCIAINT_ID, 
			's_pladat' = Tem.TRTE_vDATOAGENCIA,
			's_plamru' = Tem.TRTE_sRUTEOMET_ID,
			's_plarut' = Tem.TRTE_vRUTEOCOD,
			's_plasub' = Tem.TRTE_sSUBSIDIARIA_ID,
			
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
									CUEN_tSITUACION = 1,
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
															CUEN_tSITUACION = 1,

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
															CUEN_tSITUACION = 1,

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
											CUEN_tSITUACION = 1,

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
Objetivo	: Graba la observacion de una cuenta corriente
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
    @p_obs		varchar(255),
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

			@c_cuenta_confirmada	tinyint = 9

	
	Update	SC_COMUN.SE_CUENTACORRIENTE
	Set		CUEN_vOBSERVACION = @p_obs,
			CUEN_tSITUACION = @c_cuenta_confirmada,
			CUEN_sUSUARIO_MODIFICACION = @p_usr,
			CUEN_vIP_MODIFICACION = @p_ipc,
			CUEN_dFECHA_MODIFICACION = GetDate()
	Where
			CUEN_sCUENTACORRIENTE_ID = @p_sid and
			CUEN_cESTADO = 'A'

	set	@l_Id		= @p_sid;
	set @l_mensaje	= 'Los datos han sido confirmados. Muchas gracias por su participación.';
	set @l_status	= 1;
	set @l_bs_tipo	= 1;

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
Create Procedure SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR
As
Begin
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


End
go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE PAISES
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_PAIS_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PAIS_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista completa de paises
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PAIS_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PAIS_LISTAR
As
Begin
	Select	'i_row' = row_number() over (order by ps.PAIS_sPAIS_ID),
			'i_sid' = ps.PAIS_sPAIS_ID,
			's_pai' = ps.PAIS_vNOMBRE, 
			's_nof' = ps.PAIS_vNOMBREOFICIAL, 
			's_gen' = ps.PAIS_vGENTILICIO, 
			's_m49' = ps.PAIS_cM49, 
			's_iso' = ps.PAIS_cISOA3,
			'i_rid' = rg.REGI_sREGION_ID, 
			's_rnm' = rg.REGI_vNOMBRE, 
			's_ron' = rg.REGI_cCODIGO_ONU,
			'i_cid' = cn.CONT_sCONTINENTE_ID, 
			's_cnm' = cn.CONT_vNOMBRE, 
			's_con' = cn.CONT_cCODIGO_ONU,
			's_mas' = substring(MndAsignacion, 3, len(MndAsignacion)),
			's_mlc' = substring(MndLocal,3,len(MndLocal))
	From	
			SC_COMUN.SE_PAIS ps
			Inner Join SC_COMUN.SE_REGION rg on (rg.REGI_sREGION_ID = ps.PAIS_sREGION_ID and rg.REGI_cESTADO = 'A')
			Inner Join SC_COMUN.SE_CONTINENTE cn on (cn.CONT_sCONTINENTE_ID = rg.REGI_sCONTINENTE_ID and cn.CONT_cESTADO = 'A')
	
	Cross Apply (
			Select	', (' + mn.MONE_cISO4217 + ') ' + mn.MONE_vNOMBRE
			From	SC_COMUN.SE_PAIS_MONEDA pm
					Left Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = pm.PAMO_sMONEDA_ID and mn.MONE_cESTADO = 'A')
			Where	
					pm.PAMO_sPAIS_ID = ps.PAIS_sPAIS_ID and mn.MONE_bASIGNACION = 0 and pm.PAMO_cESTADO = 'A'

			FOR XML PATH('')) D (MndLocal)

	Cross Apply (
			Select	', (' + mn.MONE_cISO4217 + ') ' + mn.MONE_vNOMBRE
			From	SC_COMUN.SE_PAIS_MONEDA pm
					Left Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = pm.PAMO_sMONEDA_ID and mn.MONE_cESTADO = 'A')
			Where	
					pm.PAMO_sPAIS_ID = ps.PAIS_sPAIS_ID and mn.MONE_bASIGNACION = 1 and pm.PAMO_cESTADO = 'A'

			FOR XML PATH('')) ML (MndAsignacion)
	Where	
			ps.PAIS_cESTADO = 'A'
	
	Order by 
			ps.PAIS_vNOMBRE

End
Go


if (object_id(N'SC_COMUN.USP_PAIS_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_PAIS_LISTAR_TODT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de paises para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_page_nmber	Número de página
	@p_page_rows	Cantidad de registros por página
	@p_page_search	Buscador
	@p_page_sort	Orden
	@p_page_dir		Dirección del orden
	@p_rows_totl	Total de registros

Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_PAIS_LISTAR_TODT 0, 5, '', 0, 'asc', @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_PAIS_LISTAR_TODT (
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin
	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_PAIS
	Where	PAIS_cESTADO = 'A'

	Select	'i_row' = row_number() over (order by ps.PAIS_sPAIS_ID),
			'i_sid' = ps.PAIS_sPAIS_ID,
			's_pai' = ps.PAIS_vNOMBRE, 
			's_nof' = ps.PAIS_vNOMBREOFICIAL, 
			's_rnm' = rg.REGI_vNOMBRE, 
			's_cnm' = cn.CONT_vNOMBRE 
	From	
			SC_COMUN.SE_PAIS ps
			Inner Join SC_COMUN.SE_REGION rg on (rg.REGI_sREGION_ID = ps.PAIS_sREGION_ID and rg.REGI_cESTADO = 'A')
			Inner Join SC_COMUN.SE_CONTINENTE cn on (cn.CONT_sCONTINENTE_ID = rg.REGI_sCONTINENTE_ID and cn.CONT_cESTADO = 'A')
	Where
			ps.PAIS_cESTADO = 'A' and (
			(ps.PAIS_vNOMBRE Like '%' + @p_page_search + '%') or
			(rg.REGI_vNOMBRE Like '%' + @p_page_search + '%') or
			(cn.CONT_vNOMBRE Like '%' + @p_page_search + '%'))
	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then ps.PAIS_sPAIS_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then ps.PAIS_sPAIS_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then ps.PAIS_vNOMBRE end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then ps.PAIS_vNOMBRE end desc,

			case when @p_page_sort = 2 and @p_page_dir = 'asc' then ps.PAIS_vNOMBREOFICIAL end,
			case when @p_page_sort = 2 and @p_page_dir = 'desc' then ps.PAIS_vNOMBREOFICIAL end desc,

			case when @p_page_sort = 3 and @p_page_dir = 'asc' then rg.REGI_vNOMBRE end,
			case when @p_page_sort = 3 and @p_page_dir = 'desc' then rg.REGI_vNOMBRE end desc,

			case when @p_page_sort = 4 and @p_page_dir = 'asc' then cn.CONT_vNOMBRE end,
			case when @p_page_sort = 4 and @p_page_dir = 'desc' then cn.CONT_vNOMBRE end desc

	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
Go


if (object_id(N'SC_COMUN.USP_PAIS_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_PAIS_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de paises por ID
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PAIS_LISTAR_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PAIS_LISTAR_BYID (
	@p_sid int
)
As
Begin
	Select	'i_sid' = ps.PAIS_sPAIS_ID,
			's_pai' = ps.PAIS_vNOMBRE, 
			's_nof' = ps.PAIS_vNOMBREOFICIAL, 
			's_gen' = ps.PAIS_vGENTILICIO, 
			's_m49' = ps.PAIS_cM49, 
			's_iso' = ps.PAIS_cISOA3,
			'i_rid' = rg.REGI_sREGION_ID, 
			's_rnm' = rg.REGI_vNOMBRE, 
			's_ron' = rg.REGI_cCODIGO_ONU,
			'i_cid' = cn.CONT_sCONTINENTE_ID, 
			's_cnm' = cn.CONT_vNOMBRE, 
			's_con' = cn.CONT_cCODIGO_ONU
	From	
			SC_COMUN.SE_PAIS ps
			Inner Join SC_COMUN.SE_REGION rg on (rg.REGI_sREGION_ID = ps.PAIS_sREGION_ID and rg.REGI_cESTADO = 'A')
			Inner Join SC_COMUN.SE_CONTINENTE cn on (cn.CONT_sCONTINENTE_ID = rg.REGI_sCONTINENTE_ID and cn.CONT_cESTADO = 'A')
	Where	
			ps.PAIS_sPAIS_ID = @p_sid and
			ps.PAIS_cESTADO = 'A'
End
Go


if (object_id(N'SC_COMUN.USP_PAIS_GRABAR_MONEDA') is not null)
	drop procedure SC_COMUN.USP_PAIS_GRABAR_MONEDA
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Asocia una moneda a un país
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PAIS_GRABAR_MONEDA 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PAIS_GRABAR_MONEDA(
	@p_pai	int,
	@p_mnd	int,

	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,
			@l_idp	int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1
	
	-- []
	Select @l_cant = count(1)  From SC_COMUN.SE_PAIS_MONEDA Where PAMO_sPAIS_ID = @p_pai and PAMO_sMONEDA_ID = @p_mnd

	if (@l_cant > 0) -- existe
		begin
			Select @l_cant = count(1)  From SC_COMUN.SE_PAIS_MONEDA Where PAMO_sPAIS_ID = @p_pai and PAMO_sMONEDA_ID = @p_mnd and PAMO_cESTADO = 'I'

			if (@l_cant > 0) -- Esta desabilitado? lo habilita.
				begin
					update	SC_COMUN.SE_PAIS_MONEDA
					set		PAMO_cESTADO = 'A',
							PAMO_sUSUARIO_MODIFICACION = @p_usr,
							PAMO_vIP_MODIFICACION = @p_ipc,
							PAMO_dFECHA_MODIFICACION = getdate()
					where	
							PAMO_sPAIS_ID = @p_pai and 
							PAMO_sMONEDA_ID = @p_mnd and
							PAMO_cESTADO = 'I'
					
					set @l_mensaje	= 'Actualizado.'
					set @l_status	= 1;
					set @l_bs_tipo	= 1;
				end
		end
	else -- no existe
		begin
			Insert Into	SC_COMUN.SE_PAIS_MONEDA (PAMO_sPAIS_ID, PAMO_sMONEDA_ID,  PAMO_sUSUARIO_CREACION, PAMO_vIP_CREACION)
			values (@p_pai, @p_mnd, @p_usr, @p_ipc)
			
			set @l_mensaje	= 'Insertado.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go


if (object_id(N'SC_COMUN.USP_PAIS_GRABAR') is not null)
	drop procedure SC_COMUN.USP_PAIS_GRABAR
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba/actualiza los datos de un país
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PAIS_GRABAR 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PAIS_GRABAR(
	@p_idp	int,
	@p_nom	varchar(40),
	@p_ofi	varchar(60),
	@p_gen	varchar(40),
	@p_m49	varchar(3),
	@p_iso	varchar(3),
	@p_reg	int,

	@p_usr	varchar(12),
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,

			@l_idp		int,
			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1
	
	if (@p_idp = 0)
		begin
			begin transaction

				Insert Into SC_COMUN.SE_PAIS (PAIS_vNOMBRE, PAIS_vNOMBREOFICIAL, PAIS_vGENTILICIO, PAIS_cM49, PAIS_cISOA3, PAIS_sREGION_ID,
						PAIS_sUSUARIO_CREACION, PAIS_vIP_CREACION) Values 
						(@p_nom, @p_ofi, @p_gen, @p_m49, @p_iso, @p_reg,
						@p_usr, @p_ipc)

				Set	@l_idp = SCOPE_IDENTITY();

				set @l_mensaje	= 'Se agrego el país.'
				set @l_status	= 1;
				set @l_bs_tipo	= 1;

			commit;
		end
	else
		begin
			update	SC_COMUN.SE_PAIS
			set		PAIS_vNOMBRE = @p_nom,
					PAIS_vNOMBREOFICIAL = @p_ofi,
					PAIS_vGENTILICIO = @p_gen,
					PAIS_cM49 = @p_m49,
					PAIS_cISOA3 = @p_iso,
					PAIS_sREGION_ID = @p_reg,

					PAIS_sUSUARIO_MODIFICACION = @p_usr,
					PAIS_vIP_MODIFICACION = @p_ipc,
					PAIS_dFECHA_MODIFICACION = getdate()
			where
					PAIS_sPAIS_ID = @p_idp and
					PAIS_cESTADO = 'A'

			Set	@l_idp = @p_idp

			-- Desvincula las monedas
			-- TODO: Comprobar si las monedas estan siendo utilizadas en asignación/rendición.

			update	SC_COMUN.SE_PAIS_MONEDA
			set		PAMO_cESTADO = 'I',
					PAMO_sUSUARIO_MODIFICACION = @p_usr,
					PAMO_vIP_MODIFICACION = @p_ipc,
					PAMO_dFECHA_MODIFICACION = getdate()
			where	
					PAMO_sPAIS_ID = @p_idp
			
			set @l_mensaje	= 'Se actualizó el pais.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id'	= @l_idp,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE MONEDAS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR_BYPAIS') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR_BYPAIS
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas a un organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR_BYPAIS 2

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MONEDA_LISTAR_BYPAIS(
	@p_pai		int
)
As
Begin
	Select	'i_sid' = mn.MONE_sMONEDA_ID,
			's_nom' = mn.MONE_vNOMBRE,
			's_abr' = mn.MONE_vABREVIATURA,
			's_suf' = mn.MONE_vSUFIJOCONTABLE,
			's_sim' = mn.MONE_vSIMBOLO,
			's_iso' = mn.MONE_cISO4217,
			's_asg' = mn.MONE_bASIGNACION,
			'i_asg' = case when mn.MONE_bASIGNACION = '0' then 0 else 1 end
	From	
			SC_COMUN.SE_MONEDA mn
			Inner Join SC_COMUN.SE_PAIS_MONEDA pm on (pm.PAMO_sMONEDA_ID = mn.MONE_sMONEDA_ID and pm.PAMO_sPAIS_ID = @p_pai and pm.PAMO_cESTADO = 'A')
	Where	
			mn.MONE_cESTADO = 'A'
	Order by
			 mn.MONE_bASIGNACION
End
Go


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
					's_nom' = Mnd.MONE_vNOMBRE
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
					's_nom' = Mnd.MONE_vNOMBRE
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
Go


if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR_TODT
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
Create Procedure SC_COMUN.USP_MONEDA_LISTAR_TODT(
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin
	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_MONEDA
	Where	MONE_cESTADO = 'A'

	Select	'i_row' = row_number() over (order by mn.MONE_sMONEDA_ID),
			'i_sid' = mn.MONE_sMONEDA_ID,
			's_nom' = mn.MONE_vNOMBRE,
			's_abr' = mn.MONE_vABREVIATURA,
			's_suf' = mn.MONE_vSUFIJOCONTABLE,
			's_sim' = mn.MONE_vSIMBOLO,
			's_iso' = mn.MONE_cISO4217,
			'i_asg' = mn.MONE_bASIGNACION,
			's_asg' = case when mn.MONE_bASIGNACION = 0 then 'NO' else 'SI' end
	From	
			SC_COMUN.SE_MONEDA mn
	Where
			mn.MONE_cESTADO = 'A' and (
			(mn.MONE_vNOMBRE Like '%' + @p_page_search + '%') or
			(mn.MONE_cISO4217 Like '%' + @p_page_search + '%'))
	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then mn.MONE_sMONEDA_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then mn.MONE_sMONEDA_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then mn.MONE_vNOMBRE end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then mn.MONE_vNOMBRE end desc,

			case when @p_page_sort = 3 and @p_page_dir = 'asc' then mn.MONE_cISO4217 end,
			case when @p_page_sort = 3 and @p_page_dir = 'desc' then mn.MONE_cISO4217 end desc,

			case when @p_page_sort = 4 and @p_page_dir = 'asc' then mn.MONE_bASIGNACION end,
			case when @p_page_sort = 4 and @p_page_dir = 'desc' then mn.MONE_bASIGNACION end desc

	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
Go


if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas a un organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR_BYID 136

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MONEDA_LISTAR_BYID(
	@p_sid		int
)
As
Begin
	Select	'i_sid' = mn.MONE_sMONEDA_ID,
			's_nom' = mn.MONE_vNOMBRE,
			's_abr' = mn.MONE_vABREVIATURA,
			's_suf' = mn.MONE_vSUFIJOCONTABLE,
			's_sim' = mn.MONE_vSIMBOLO,
			's_iso' = mn.MONE_cISO4217,
			'i_asg' = mn.MONE_bASIGNACION,
			's_asg' = case when mn.MONE_bASIGNACION = 0 then 'NO' else 'SI' end
	From	
			SC_COMUN.SE_MONEDA mn
	Where	
			mn.MONE_sMONEDA_ID = @p_sid and mn.MONE_cESTADO = 'A'
End
Go


if (object_id(N'SC_COMUN.USP_MONEDA_GRABAR') is not null)
	drop procedure SC_COMUN.USP_MONEDA_GRABAR
Go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas a un organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR_BYID 136

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MONEDA_GRABAR(
	@p_idp	int,
	@p_nom	varchar(40),
	@p_abr	varchar(20),
	@p_suf	varchar(15),
	@p_sim	varchar(5),
	@p_iso	varchar(3),
	@p_asi	bit,

	@p_usr	smallint,
	@p_ipc	varchar(15)
)
as
begin
	declare @l_cant int,

			@l_mensaje	varchar(255),
			@l_status	int = 0,
			@l_bs_tipo	int = 1
	
	if (@p_idp = 0)
		begin
			Select @l_cant = count(1) From SC_COMUN.SE_MONEDA Where MONE_cISO4217 = @p_iso and MONE_cESTADO = 'A'

			if (@l_cant > 0)
				begin
					set @l_mensaje	= 'No se pudo agregar la moneda porque ya existe un ISO4217 con el valor ' + @p_iso
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
			else
				begin
					Insert Into SC_COMUN.SE_MONEDA (MONE_vNOMBRE, MONE_vABREVIATURA, MONE_vSUFIJOCONTABLE, MONE_vSIMBOLO, MONE_cISO4217, MONE_bASIGNACION,
							MONE_sUSUARIO_CREACION, MONE_vIP_CREACION) Values 
							(@p_nom, @p_abr, @p_suf, @p_sim, @p_iso, @p_asi,
							@p_usr, @p_ipc)
			
					set @l_mensaje	= 'Se agrego la moneda.'
					set @l_status	= 1;
					set @l_bs_tipo	= 1;	
				end
		end
	else
		begin
			update	SC_COMUN.SE_MONEDA
			set		MONE_vNOMBRE = @p_nom,
					MONE_vABREVIATURA = @p_abr,
					MONE_vSUFIJOCONTABLE = @p_suf,
					MONE_vSIMBOLO = @p_sim,
					MONE_cISO4217 = @p_iso,
					MONE_bASIGNACION = @p_asi,

					MONE_sUSUARIO_MODIFICACION = @p_usr,
					MONE_vIP_MODIFICACION = @p_ipc,
					MONE_dFECHA_MODIFICACION = getdate()
			where
					MONE_sMONEDA_ID = @p_idp and
					MONE_cESTADO = 'A'

			set @l_mensaje	= 'Se actualizó la moneda.'
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = 0,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go


if (object_id(N'SC_COMUN.USP_MONEDA_LISTAR') is not null)
	drop procedure SC_COMUN.USP_MONEDA_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las monedas asociadas a un organo de servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organos de Servicio (0: Todos, [1..n] Organo de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_MONEDA_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_MONEDA_LISTAR
As
Begin
	Select	'i_row' = row_number() over (order by mn.MONE_sMONEDA_ID),
			'i_sid' = mn.MONE_sMONEDA_ID,
			's_nom' = mn.MONE_vNOMBRE,
			's_abr' = mn.MONE_vABREVIATURA,
			's_suf' = mn.MONE_vSUFIJOCONTABLE,
			's_sim' = mn.MONE_vSIMBOLO,
			's_iso' = mn.MONE_cISO4217,
			'i_asg' = mn.MONE_bASIGNACION,
			's_asg' = case when mn.MONE_bASIGNACION = 0 then 'NO' else 'SI' end
	From	
			SC_COMUN.SE_MONEDA mn
	Where	
			mn.MONE_cESTADO = 'A'
End
Go



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE ORGANOS DE SERVICIO EXTERIOR
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_ORGSER_LISTAR_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ORGSER_LISTAR_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de una o de todas las cuentas corriente
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_tip		Id del tipo de lista (0 Todos, [1-4] Tipos de Organos de Servicio)

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_LISTAR_TOSELECT 0

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_LISTAR_TOSELECT (
	@p_tip		Smallint
)
As
Begin
	if (@p_tip = 0)
		begin
			Select	'i_osesid' = ORGA_sORGANOSERVICIO_ID,
					's_oseabr' = ORGA_vABREVIATURA 
			From	
					SC_COMUN.SE_ORGANOSERVICIO
			Order by
					ORGA_vABREVIATURA 
		end
	else
		begin
			Select	'i_osesid' = ORGA_sORGANOSERVICIO_ID,
					's_oseabr' = ORGA_vABREVIATURA 
			From	
					SC_COMUN.SE_ORGANOSERVICIO
			where
					ORGA_tTIPO = @p_tip
			Order by
					ORGA_vABREVIATURA 
		end
	End
Go


if (object_id(N'SC_COMUN.USP_ORGSER_LISTAR_TODT') is not null)
	drop procedure SC_COMUN.USP_ORGSER_LISTAR_TODT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de organos de servicio para el control datatable
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_page_nmber	Número de página
	@p_page_rows	Cantidad de registros por página
	@p_page_search	Buscador
	@p_page_sort	Orden
	@p_page_dir		Dirección del orden
	@p_rows_totl	Total de registros

Ejecutar	: 
	Declare @v_total_registros Int
	exec SC_COMUN.USP_ORGSER_LISTAR_TODT 0, 10, '', 0, 'asc', @v_total_registros out
	Select @v_total_registros

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_LISTAR_TODT (
	@p_page_nmber	int,
	@p_page_rows	int,
	@p_page_search	varchar(36),
	@p_page_sort	int,
	@p_page_dir		varchar(4),
	@p_rows_totl	int output		
)
As
Begin
	declare	@PARAM_TIPO_OSE int = 1;	/* Id de la Tabla Parametros */

	Select	@p_rows_totl = Count(1)
	From	SC_COMUN.SE_ORGANOSERVICIO
	Where	ORGA_cESTADO = 'A'

	Select	'i_oserow' = row_number() over (order by os.ORGA_sORGANOSERVICIO_ID),
			'i_osesid' = os.ORGA_sORGANOSERVICIO_ID, 
			's_oseabr' = os.ORGA_vABREVIATURA,
			's_osenom' = os.ORGA_vNOMBRE, 
			's_topabr' = pm.PAIT_vTEXTO, 
			's_painom' = ps.PAIS_vNOMBRE
	From	
			SC_COMUN.SE_ORGANOSERVICIO os
			Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = os.ORGA_sPAIS_ID and ps.PAIS_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pm on (pm.PAIT_sPARAMETRO_ID = @PARAM_TIPO_OSE and pm.PAIT_sPARAMETROITEM_ID = os.ORGA_tTIPO and pm.PAIT_cESTADO = 'A')
	Where
			(os.ORGA_vNOMBRE Like '%' + @p_page_search + '%') or
			(os.ORGA_vABREVIATURA Like '%' + @p_page_search + '%') or
			(ps.PAIS_vNOMBRE Like '%' + @p_page_search + '%') or
			(pm.PAIT_vTEXTO  Like '%' + @p_page_search + '%')

	Order by
			case when @p_page_sort = 0 and @p_page_dir = 'asc' then os.ORGA_sORGANOSERVICIO_ID end,
			case when @p_page_sort = 0 and @p_page_dir = 'desc' then os.ORGA_sORGANOSERVICIO_ID end desc,
			
			case when @p_page_sort = 1 and @p_page_dir = 'asc' then os.ORGA_vABREVIATURA end,
			case when @p_page_sort = 1 and @p_page_dir = 'desc' then os.ORGA_vABREVIATURA end desc,

			case when @p_page_sort = 2 and @p_page_dir = 'asc' then os.ORGA_vNOMBRE end,
			case when @p_page_sort = 2 and @p_page_dir = 'desc' then os.ORGA_vNOMBRE end desc,

			case when @p_page_sort = 3 and @p_page_dir = 'asc' then pm.PAIT_vTEXTO end,
			case when @p_page_sort = 3 and @p_page_dir = 'desc' then pm.PAIT_vTEXTO end desc,
			
			case when @p_page_sort = 4 and @p_page_dir = 'asc' then ps.PAIS_vNOMBRE end,
			case when @p_page_sort = 4 and @p_page_dir = 'desc' then ps.PAIS_vNOMBRE end desc

	OFFSET
			(@p_page_nmber * @p_page_rows) ROWS FETCH NEXT @p_page_rows ROWS ONLY
End
Go


if (object_id(N'SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve los datos de una o de todas los organos de servicio por tipo y pais
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_tip		Id del tipo de lista (0 Todos, [1-4] Tipos de Organos de Servicio)
	@p_pai		Id del País

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT 0, 13
	exec SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT 2, 13

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT (
	@p_tip		Smallint,
	@p_pai		Smallint
)
As
Begin
	if (@p_tip = 0)
		begin
			Select	'i_osesid' = ORGA_sORGANOSERVICIO_ID,
					's_oseabr' = ORGA_vABREVIATURA 
			From	
					SC_COMUN.SE_ORGANOSERVICIO
			Where
					ORGA_sPAIS_ID = @p_pai
			Order by
					ORGA_vABREVIATURA 
		end
	else
		begin
			Select	'i_osesid' = ORGA_sORGANOSERVICIO_ID,
					's_oseabr' = ORGA_vABREVIATURA 
			From	
					SC_COMUN.SE_ORGANOSERVICIO
			Where
					ORGA_tTIPO = @p_tip and
					ORGA_sPAIS_ID = @p_pai
			Order by
					ORGA_vABREVIATURA 
		end
	End
Go


if (object_id(N'SC_COMUN.USP_ORGSER_LISTAR_BYID') is not null)
	drop procedure SC_COMUN.USP_ORGSER_LISTAR_BYID
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve un órgano de servicio especificado por el Id
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid	Id del registro principal

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_LISTAR_BYID 0
	exec SC_COMUN.USP_ORGSER_LISTAR_BYID 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ORGSER_LISTAR_BYID (
	@p_sid	int
)
As
Begin
	declare	@PARAM_TIPO_OSE int = 1;	/* Id de la Tabla Parametros */

	Select	's_osenom' = os.ORGA_vNOMBRE,
			's_oseabr' = os.ORGA_vABREVIATURA,
			'i_osejef' = IsNull(os.ORGA_sJEFATURASERVICIO, 0),
			's_osejef' = IsNull(js.ORGA_vNOMBRE,''),
			'i_paisid' = os.ORGA_sPAIS_ID,
			's_painom' = ps.PAIS_vNOMBRE,
			'i_osecod' = os.ORGA_vINTEROP,
			'i_tipsid' = os.ORGA_tTIPO,
			's_tipnom' = pm.PAIT_vTEXTO
	From	
			SC_COMUN.SE_ORGANOSERVICIO os
			Inner Join SC_COMUN.SE_PAIS ps on (ps.PAIS_sPAIS_ID = os.ORGA_sPAIS_ID and ps.PAIS_cESTADO = 'A')
			Inner Join SC_COMUN.SE_PARAMETRO_ITEM pm on (pm.PAIT_sPARAMETRO_ID = @PARAM_TIPO_OSE and pm.PAIT_sPARAMETROITEM_ID = os.ORGA_tTIPO and pm.PAIT_cESTADO = 'A')
			Left Join SC_COMUN.SE_ORGANOSERVICIO js on (js.ORGA_sORGANOSERVICIO_ID = os.ORGA_sJEFATURASERVICIO and js.ORGA_cESTADO = 'A')
	Where
			os.ORGA_sORGANOSERVICIO_ID = @p_sid and
			os.ORGA_cESTADO = 'A'
End
Go


if (object_id(N'SC_COMUN.USP_ORGSER_LISTAR_JEFSER_BYOSE_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ORGSER_LISTAR_JEFSER_BYOSE_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las jefaturas de servicio (consulados) disponibles por el pais del ose.
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_ose		Id del Organo de servicio

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT 2, 13
	exec SC_COMUN.USP_ORGSER_LISTAR_JEFSER_BYOSE_TOSELECT 82

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/

Create Procedure SC_COMUN.USP_ORGSER_LISTAR_JEFSER_BYOSE_TOSELECT (
	@p_ose		Smallint
)
As
Begin
	declare @l_pai int;
	declare	@param_consulados int = 2;
	
	Select	@l_pai = ORGA_sPAIS_ID
	From	SC_COMUN.SE_ORGANOSERVICIO os
	Where
			os.ORGA_sORGANOSERVICIO_ID = @p_ose

	Select	'i_osesid' = os.ORGA_sORGANOSERVICIO_ID,
			's_oseabr' = os.ORGA_vABREVIATURA 
	From	
			SC_COMUN.SE_ORGANOSERVICIO os
	Where
			os.ORGA_tTIPO = @param_consulados and
			os.ORGA_sPAIS_ID = @l_pai and
			os.ORGA_cESTADO = 'A'
	Order by
			ORGA_vABREVIATURA 
	End
Go


if (object_id(N'SC_COMUN.USP_ORGSER_GRABAR') is not null)
	drop procedure SC_COMUN.USP_ORGSER_GRABAR
Go

/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Graba los datos del Órgano de Servicio
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_sid	Id del registro principal

Ejecutar	: 
	exec SC_COMUN.USP_ORGSER_GRABAR 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_ORGSER_GRABAR(
	@p_ido	int,

	@p_nom	varchar(100),
	@p_abr	varchar(25),
	@p_tip	int,
	@p_pai	int,
	@p_cod	varchar(5),
	@p_jsv	int,

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
			@l_bs_tipo	int = 1,

			@l_REG_APROBADO int = 3
	
	if (@p_ido = 0) -- nuevo
		begin
			-- Nombre, Abreviatura y Codigo ORH no pueden ser los mismos
			Select @l_cant = count(1) From SC_COMUN.SE_ORGANOSERVICIO Where (ORGA_vNOMBRE = @p_nom or ORGA_vABREVIATURA = @p_abr or (@p_cod <> '' and ORGA_vINTEROP = @p_cod)) and ORGA_cESTADO = 'A'

			if (@l_cant > 0)
				begin
					set @l_mensaje	= 'Ya existe un Órgano de Servicio Exterior con ese nombre, abreviatura ó código.'
					set @l_status	= 0;
					set @l_bs_tipo	= 4;
				end
			else
				begin
					-- Inserta
					begin transaction
						Insert Into SC_COMUN.SE_ORGANOSERVICIO (ORGA_vNOMBRE, ORGA_vABREVIATURA, ORGA_sJEFATURASERVICIO, ORGA_sPAIS_ID, ORGA_tTIPO, ORGA_vINTEROP,
								ORGA_tSITUACION,
								ORGA_sUSUARIO_CREACION, ORGA_vIP_CREACION) 
							Values (@p_nom, @p_abr, @p_jsv,  @p_pai, @p_tip, @p_cod,
								@l_REG_APROBADO,
								@p_usr, @p_ipc)

							set	@l_id = scope_identity();
							set @l_mensaje	= 'Se agrego el Órgano de Servicio Exterior.'
							set @l_status	= 1;
							set @l_bs_tipo	= 1;
					commit;
				end
		end
	else
		begin
			-- Actualiza
			update	SC_COMUN.SE_ORGANOSERVICIO
			set		ORGA_vNOMBRE = @p_nom,
					ORGA_vABREVIATURA = @p_abr,
					ORGA_sJEFATURASERVICIO = @p_jsv,
					ORGA_sPAIS_ID = @p_pai,
					ORGA_tTIPO = @p_tip,
					ORGA_vINTEROP = @p_cod,
					ORGA_tSITUACION = @l_REG_APROBADO,

					ORGA_sUSUARIO_MODIFICACION = @p_usr,
					ORGA_vIP_MODIFICACION = @p_ipc,
					ORGA_dFECHA_MODIFICACION = getdate()
			where
					ORGA_sORGANOSERVICIO_ID = @p_ido and
					ORGA_cESTADO = 'A'
			
			-- Datos de beneficiario
			set	@l_id = @p_ido;
			set @l_mensaje	= 'Se actualizó el Órgano de Servicio Exterior.';
			set @l_status	= 1;
			set @l_bs_tipo	= 1;
		end

	Select	'i_id' = @l_id,
			's_msg'	= @l_mensaje, 
			'i_est'	= @l_status,
			'i_btp' = @l_bs_tipo
end
go



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
					OSER_sTIPO in (1,2) and
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
					OSER_sTIPO in (1,2) and
					OSER_cESTADO = 'A'
			Order by
					OSER_vAPELLIDOS
		end
	End
Go



if (object_id(N'SC_SYSTEM.USP_ERRORLOG_INSERTAR') is not null)
	drop procedure SC_SYSTEM.USP_ERRORLOG_INSERTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Insercion manual de un log de error 
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
	@p_capa		Capa donde se produce el error
	@p_clase	Clase
	@p_metodo	Método ó funcion donde se produce el mapeo del error
	@p_error	Descripcion del error

Ejecutar	: 
	exec SC_SYSTEM.USP_ERRORLOG_INSERTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_SYSTEM.USP_ERRORLOG_INSERTAR (
	@p_cpa	varchar(150),
	@p_cls	varchar(150),
	@p_mtd	varchar(150),
	@p_err	varchar(max),
	@p_usr	smallint,
	@p_ipc	varchar(15)
)
As
Begin
	Insert Into SC_SYSTEM.SE_ERRORLOG (ERLO_vCAPA, ERLO_vCLASE, ERLO_vMETODO, ERLO_vERROR, ERLO_sUSUARIO_CREACION, ERLO_vIP_CREACION) 
	Values (@p_cpa, @p_cls, @p_mtd, @p_err, @p_usr, @p_ipc)
End
Go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	PROCEDIMIENTOS DE PARAMETROS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --


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
	exec SC_COMUN.USP_PARAMETROITEM_LISTAR 3, 0

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


if (object_id(N'SC_COMUN.USP_PARAMETRO_GRUPO_LISTAR') is not null)
	drop procedure SC_COMUN.USP_PARAMETRO_GRUPO_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de grupos de parametros
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_PARAMETRO_GRUPO_LISTAR 

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_PARAMETRO_GRUPO_LISTAR
as
begin
	Select	'i_sid' = PAGR_sPARAMETROGRUPO_ID, 
			's_nom' = PAGR_vNOMBRE
	From	
			SC_COMUN.SE_PARAMETRO_GRUPO 
	Where 
			PAGR_cESTADO = 'A'
end
go


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--
--	OTROS PROCEDIMIENTOS
--
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --



if (object_id(N'SC_COMUN.USP_UNIDADORGANICA_LISTAR') is not null)
	drop procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve todas las unidades organicas
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_UNIDADORGANICA_LISTAR

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_UNIDADORGANICA_LISTAR

As
Begin
	Select	'i_idu' = uo.UNID_sUNIDADORGANICA_ID, 
			's_nom' = uo.UNID_vNOMBRE, 
			's_abr' = uo.UNID_vABREVIATURA, 
			's_des' = uo.UNID_vDESCRIPCION, 
			'i_usp' = us.UNID_sUNIDADORGANICA_ID
	From	
			SC_COMUN.SE_UNIDADORGANICA uo
			Left Join SC_COMUN.SE_UNIDADORGANICA us on (us.UNID_sUNIDADORGANICA_ID = uo.UNID_sUNIDADSUPERIOR and us.UNID_cESTADO = 'A')
	Where
			uo.UNID_cESTADO = 'A' 
End
Go


if (object_id(N'SC_COMUN.USP_ENTIDADPUBLICA_LISTARCTAS_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ENTIDADPUBLICA_LISTARCTAS_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve las cuentas corrientes establecidas para la entidad (MRE)
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_ENTIDADPUBLICA_LISTARCTAS_TOSELECT

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
Create Procedure SC_COMUN.USP_ENTIDADPUBLICA_LISTARCTAS_TOSELECT
As
Begin
	Declare @l_id_entidad_mre int = 1;
	
	Select	'i_sid' = ct.ENCT_sENTIDADPUBLICA_CTACTE_ID,
			's_nro' = Concat(ct.ENCT_vNUMCTA, '-', mn.MONE_cISO4217)
	From	
			SC_COMUN.SE_ENTIDADPUBLICA_CTACTE ct
			Inner Join SC_COMUN.SE_MONEDA mn on (mn.MONE_sMONEDA_ID = ct.ENCT_sMONEDA_ID and mn.MONE_cESTADO = 'A')
	Where
			ct.ENCT_sENTIDAD_ID = @l_id_entidad_mre and
			ct.ENCT_cESTADO = 'A'
end
Go


if (object_id(N'SC_COMUN.USP_ENTIDADPUBLICA_LISTAR_TOSELECT') is not null)
	drop procedure SC_COMUN.USP_ENTIDADPUBLICA_LISTAR_TOSELECT
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista completa de entidades publicas
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_ENTIDADPUBLICA_LISTAR_TOSELECT

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_ENTIDADPUBLICA_LISTAR_TOSELECT
As
Begin
	Select	'i_sid' = ENTI_sENTIDAD_ID, 
			's_nom' = ENTI_cENTIDADNOMBRE
	From	
			SC_COMUN.SE_ENTIDADPUBLICA ep
	Where
			ENTI_cESTADO = 'A'
End
go


if (object_id(N'SC_COMUN.USP_REGION_LISTAR_BYCN') is not null)
	drop procedure SC_COMUN.USP_REGION_LISTAR_BYCN
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de regiones por continente
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_REGION_LISTAR_BYCN 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_REGION_LISTAR_BYCN(
	@p_con int
)
As
Begin
	Select	'i_sid' = REGI_sREGION_ID, 
			's_nom' = REGI_vNOMBRE, 
			's_onu' = REGI_cCODIGO_ONU
	From	
			SC_COMUN.SE_REGION
	Where
			REGI_sCONTINENTE_ID = @p_con and
			REGI_cESTADO = 'A'
End
Go


if (object_id(N'SC_COMUN.USP_CONTINENTE_LISTAR') is not null)
	drop procedure SC_COMUN.USP_CONTINENTE_LISTAR
go
/*
Sistema		: Sistema Integrado de Rendición de Cuentas
Objetivo	: Devuelve la lista de regiones por continente
Creado por	: Victor Neyra
Fecha		: 10.01.2018
Parametros	: 
Ejecutar	: 
	exec SC_COMUN.USP_CONTINENTE_LISTAR 1

Historial	: (@Fecha, @Autor, @Motivo)
	10.01.2018	Victor Neyra	Inicial
$*/
create procedure SC_COMUN.USP_CONTINENTE_LISTAR
As
Begin
	Select	'i_sid' = CONT_sCONTINENTE_ID, 
			's_nom' = CONT_vNOMBRE, 
			's_onu' = CONT_cCODIGO_ONU 
	From	
			SC_COMUN.SE_CONTINENTE
	Where
			CONT_cESTADO = 'A'
End
Go