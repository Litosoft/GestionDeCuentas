using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace SGSE.Data
{
    public class DAUsuario : AbstractDataManager
    {
        /* Migrado */
        private string sp_login_usuario = "SC_COMUN.USP_USUARIO_LOGIN";
        private string sp_listar_toDataTable = "SC_COMUN.USP_USUARIO_LISTAR_toDT";
        private string sp_listar_byId = "SC_COMUN.USP_USUARIO_LISTAR_BYID";
        private string sp_grabar = "SC_COMUN.USP_USUARIO_GRABAR";
        private string sp_grabar_solicitud = "SC_COMUN.USP_USUARIO_GRABARSOL";


        /// <summary>
        /// Devuelve los datos de un usuario según sus credenciales de acceso
        /// </summary>
        /// <param name="usr">usuario</param>
        /// <param name="pwd">contraseña</param>
        /// <returns>BEUsuario object</returns>
        public ResponserData getUsuario_byLogin(string usr, string pwd)
        {
            ResponserData Responser = new ResponserData();
            BEUsuario Usuario = new BEUsuario();
            List<BEPerfil> Perfiles = new List<BEPerfil>();

            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_login_usuario, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 50).Value = usr;
                    oComando.Parameters.Add("@p_pwd", SqlDbType.VarChar, 44).Value = pwd;

                    oConexion.Open();
                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToInt(dr["i_qrysts"]);

                            if (Responser.Estado == ResponserEstado.Ok)
                            {
                                var usr_cid = Peach.EncriptText(DataUtil.ObjectToString(dr["i_usucid"]));

                                Usuario.CID = usr_cid;
                                Usuario.Apellidos = DataUtil.ObjectToString(dr["s_usuape"]);
                                Usuario.CambiarPwd = DataUtil.ObjectToByte(dr["i_usucpw"]);
                                Usuario.IsDominio = DataUtil.ObjectToByte(dr["i_usudom"]);
                                Usuario.Rol = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_rolbas"]) };

                                Usuario.Unidad = new BEUnidad {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_undcid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_undnom"])
                                };

                                Usuario.OrganoServicio = new BEOrganoServicio {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osecid"])),
                                    Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"]),
                                    Nombre = DataUtil.ObjectToString(dr["s_osenom"]),

                                };

                                Usuario.Pais = new BEPais
                                {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_paicid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_painom"])
                                };
                                

                                int num_perfiles = DataUtil.ObjectToInt(dr["i_pernum"]);
                                if (num_perfiles == 1)
                                {
                                    Usuario.Perfil = new BEPerfil {
                                        CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_percid"])),
                                        Nombre = DataUtil.ObjectToString(dr["s_pernom"])
                                    };
                                }

                                Perfiles.Add(new BEPerfil
                                {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_percid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_pernom"])
                                });
                            }
                            else
                            {
                                Responser.TipoAlerta = (BootstrapAlertType) DataUtil.ObjectToInt(dr["i_qrytpo"]);
                                Responser.Mensaje = DataUtil.ObjectToString(dr["s_qrymsg"]);
                            }
                        }

                        if (Perfiles.Count > 1) {
                            Usuario.Perfil = null;
                            Usuario.Perfiles = Perfiles;
                        }

                        Responser.DataContent = Usuario;
                    }

                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Devuelve todos los usuarios para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEUsuario> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEUsuario> Usuarios = new List<BEUsuario>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_toDataTable, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_page_nmber", SqlDbType.Int).Value = pageNumber;
                    oComando.Parameters.Add("@p_page_rows", SqlDbType.Int).Value = pageRows;
                    oComando.Parameters.Add("@p_page_search", SqlDbType.VarChar, 35).Value = search;
                    oComando.Parameters.Add("@p_page_sort", SqlDbType.Int).Value = sort;
                    oComando.Parameters.Add("@p_page_dir", SqlDbType.VarChar, 4).Value = dir;

                    oComando.Parameters.Add("@p_rows_totl", SqlDbType.Int).Direction = ParameterDirection.Output;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Usuarios.Add(new BEUsuario
                            {
                                Row = DataUtil.ObjectToInt16(dr["i_usurow"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_usucid"])),

                                Apellidos = DataUtil.ObjectToString(dr["s_usuape"]),
                                Login = new BELogin { user = DataUtil.ObjectToString(dr["s_usulan"]) },
                                Unidad = new BEUnidad
                                {
                                    Abreviatura = DataUtil.ObjectToString(dr["s_undabr"])
                                },
                                OrganoServicio = new BEOrganoServicio
                                {
                                    Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"])
                                },
                                Hasta = DataUtil.ObjectToString(dr["s_usrfin"]),
                                Perfil = new BEPerfil
                                {
                                    Nombre = DataUtil.ObjectToString(dr["s_pernom"])
                                },

                                Estado = new ItemGenerico
                                {
                                    StrValue = DataUtil.ObjectToString(dr["s_usuest"])
                                }
                            });
                        }
                    }
                    totalRows = DataUtil.ObjectToInt(oComando.Parameters["@p_rows_totl"].Value);
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Usuarios;
        }


        /// <summary>
        /// Devuelve los datos de un usuario
        /// </summary>
        /// <param name="Id">Id del usuario</param>
        /// <returns>Objeto Usuario</returns>
        public BEUsuario Listar_byId(int Id)
        {
            BEUsuario Usuario = new BEUsuario();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byId, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idu", SqlDbType.Int).Value = Id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Usuario.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_usrsid"]));
                            Usuario.Apellidos = DataUtil.ObjectToString(dr["s_usrape"]);
                            Usuario.Nombres = DataUtil.ObjectToString(dr["s_usrnom"]);
                            Usuario.Email = DataUtil.ObjectToString(dr["s_usrema"]);
                            Usuario.Telefono = DataUtil.ObjectToString(dr["s_usrtel"]);
                            Usuario.IsDominio = DataUtil.ObjectToByte(dr["i_usrdom"]);

                            Usuario.Login = new BELogin();
                            Usuario.Login.user = DataUtil.ObjectToString(dr["s_usrlan"]);
                            if (Usuario.IsDominio == 0) {
                                Usuario.Login.pass = Peach.DecriptText(Crypto.CryptoProvider.TripleDES, DataUtil.ObjectToString(dr["s_usrpwd"]));
                            }
                            else {
                                Usuario.Login.pass = DataUtil.ObjectToString(dr["s_usrpwd"]);
                            }
                            
                            Usuario.Desde = DataUtil.ObjectToString(dr["s_usrini"]);
                            Usuario.Hasta = DataUtil.ObjectToString(dr["s_usrfin"]);
                            Usuario.Unidad = new BEUnidad
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_unisid"])),
                            };
                            Usuario.OrganoServicio = new BEOrganoServicio
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osesid"])),
                            };
                            Usuario.Pais = new BEPais {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_paisid"])),
                            };
                            Usuario.CambiarPwd = DataUtil.ObjectToByte(dr["i_usrchg"]);
                            Usuario.Estado = new ItemGenerico {
                                IntValue = DataUtil.ObjectToInt(dr["i_usrest"])
                            };
                            Usuario.Rol = new ItemGenerico {
                                StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_usrrol"]))
                            }; 
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Usuario;
        }


        /// <summary>
        /// Graba/actualiza los datos de un usuario
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEUsuario model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idu", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_ape", SqlDbType.VarChar, 35).Value = model.Apellidos;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombres;
                    oComando.Parameters.Add("@p_mai", SqlDbType.VarChar, 50).Value = model.Email;
                    oComando.Parameters.Add("@p_tel", SqlDbType.VarChar, 12).Value = model.Telefono;

                    oComando.Parameters.Add("@p_lan", SqlDbType.VarChar, 12).Value = model.Login.user;
                    oComando.Parameters.Add("@p_pwd", SqlDbType.VarChar, 44).Value = model.Login.pass;

                    oComando.Parameters.Add("@p_ini", SqlDbType.VarChar, 10).Value = model.Desde;
                    oComando.Parameters.Add("@p_fin", SqlDbType.VarChar, 10).Value = model.Hasta;

                    oComando.Parameters.Add("@p_und", SqlDbType.Int).Value = model.Unidad.Id;
                    oComando.Parameters.Add("@p_pai", SqlDbType.Int).Value = model.Pais.Id;
                    oComando.Parameters.Add("@p_ose", SqlDbType.Int).Value = model.OrganoServicio.Id;
                    oComando.Parameters.Add("@p_rol", SqlDbType.Int).Value = model.Rol.IntValue;

                    oComando.Parameters.Add("@p_dom", SqlDbType.Int).Value = model.IsDominio;
                    oComando.Parameters.Add("@p_chg", SqlDbType.Int).Value = model.CambiarPwd;
                    oComando.Parameters.Add("@p_sts", SqlDbType.Char, 1).Value = (model.Estado.IntValue == 0) ? 'I' : 'A';

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Responser.XID = DataUtil.ObjectToInt(dr["i_id"]);
                            Responser.Mensaje = DataUtil.ObjectToString(dr["s_msg"]);
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToInt(dr["i_est"]);
                            Responser.TipoAlerta = (BootstrapAlertType)DataUtil.ObjectToInt(dr["i_btp"]);
                        }
                    }
                    oComando.Dispose();
                }

                if (Responser.Estado != ResponserEstado.Fallo)
                {
                    model.Id = Responser.XID;
                    foreach (BEPerfil perfil in model.Perfiles)
                    {
                        perfil.RowAudit = new IRowAudit
                        {
                            IUsr = model.RowAudit.IUsr,
                            IP = model.RowAudit.IP
                        };

                        new DAPerfil().Grabar_byPerfilUsuario(perfil, model.Id);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Graba/actualiza los datos de un usuario
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData GrabarSolicitud(BEUsuario model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar_solicitud, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ape", SqlDbType.VarChar, 35).Value = model.Apellidos;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombres;
                    oComando.Parameters.Add("@p_mai", SqlDbType.VarChar, 50).Value = model.Email;
                    oComando.Parameters.Add("@p_lan", SqlDbType.VarChar, 12).Value = model.Login.user;
                    oComando.Parameters.Add("@p_pas", SqlDbType.VarChar, 44).Value = model.Login.pass;
                    oComando.Parameters.Add("@p_ose", SqlDbType.Int).Value = model.OrganoServicio.Id;

                    oComando.Parameters.Add("@p_usr", SqlDbType.SmallInt).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Responser.XID = DataUtil.ObjectToInt(dr["i_id"]);
                            Responser.Mensaje = DataUtil.ObjectToString(dr["s_msg"]);
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToInt(dr["i_est"]);
                            Responser.TipoAlerta = (BootstrapAlertType)DataUtil.ObjectToInt(dr["i_btp"]);
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Responser;
        }
    }
}
