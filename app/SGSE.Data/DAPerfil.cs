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
    public class DAPerfil : AbstractDataManager
    {
        /* Migrado */
        private string sp_perfil_listar_bySelect = "SC_COMUN.USP_PERFIL_LISTAR_TOSELECT";
        private string sp_perfil_listar_byUser = "SC_COMUN.USP_PERFIL_LISTAR_byUSER";
        private string sp_perfil_validavista = "SC_COMUN.USP_PERFIL_VALIDAR_VISTA";
        private string sp_listar = "SC_COMUN.USP_PERFIL_LISTAR";
        private string sp_grabar = "SC_COMUN.USP_PERFIL_GRABAR";

        // TODO: Migrar procedimiento a DAUsuario
        private string sp_graba_perfil_usuario = "SC_COMUN.USP_USUARIO_GRABARPERFIL";

        /// <summary>
        /// Devuelve todos los perfiles de la aplicación
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPerfil> Listar()
        {
            List<BEPerfil> Perfiles = new List<BEPerfil>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = 0;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Perfiles.Add(new BEPerfil
                            {
                                Row = DataUtil.ObjectToInt(dr["i_perrow"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_persid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_pernom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_perabr"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_perdes"]),

                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Perfiles;
        }


        /// <summary>
        /// Devuelve los perfiles asociados a un usuario
        /// </summary>
        /// <param name="Id">Id de usuario</param>
        /// <returns></returns>
        public IEnumerable<BEPerfil> Listar_byUsuario(int Id)
        {
            List<BEPerfil> Perfiles = new List<BEPerfil>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_perfil_listar_byUser, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idu", SqlDbType.Int).Value = Id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Perfiles.Add(new BEPerfil
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_persid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pernom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_perabr"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_perdes"])
                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Perfiles;
        }


        /// <summary>
        /// Valida el acceso al controlador/metodo segun el perfil ingresado
        /// </summary>
        /// <param name="idp">Id perfil</param>
        /// <param name="ctrl">Controlador</param>
        /// <param name="mtdo">Método</param>
        /// <returns></returns>
        public bool ValidaPermisoPerfil(int idp, string ctrl, string mtdo)
        {
            SqlConnection oConexion = new SqlConnection(DBConexion);
            try
            {
                using (SqlCommand oComando = new SqlCommand(sp_perfil_validavista, oConexion))
                {
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_perf", SqlDbType.SmallInt).Value = idp;
                    oComando.Parameters.Add("@p_ctrl", SqlDbType.VarChar, 40).Value = ctrl;
                    oComando.Parameters.Add("@p_mtdo", SqlDbType.VarChar, 40).Value = mtdo;
                    oComando.Parameters.Add("@p_stus", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    oConexion.Open();
                    oComando.ExecuteNonQuery();
                    return DataUtil.ObjectToBoolean(oComando.Parameters["@p_stus"].Value);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                oConexion.Close();
                oConexion.Dispose();
            }
        }


        /// <summary>
        /// Devuelve los perfiles para el control select list
        /// </summary>
        /// <param name="Id">Id de usuario</param>
        /// <returns></returns>
        public IEnumerable<BEPerfil> Listar_ToSelect()
        {
            List<BEPerfil> Perfiles = new List<BEPerfil>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_perfil_listar_bySelect, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Perfiles.Add(new BEPerfil
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_persid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pernom"])
                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Perfiles;
        }


        /// <summary>
        /// Graba o actualiza los datos de un perfil
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPerfil model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombre;
                    oComando.Parameters.Add("@p_abr", SqlDbType.VarChar, 10).Value = model.Abreviatura;
                    oComando.Parameters.Add("@p_des", SqlDbType.VarChar, 35).Value = model.Descripcion;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
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


        /// <summary>
        /// Devuelve un solo perfil de la aplicación
        /// </summary>
        /// <returns></returns>
        public BEPerfil Listar_byId(int Id)
        {
            BEPerfil Perfil = new BEPerfil();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = Id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Perfil.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_persid"]));
                            Perfil.Nombre = DataUtil.ObjectToString(dr["s_pernom"]);
                            Perfil.Abreviatura = DataUtil.ObjectToString(dr["s_perabr"]);
                            Perfil.Descripcion = DataUtil.ObjectToString(dr["s_perdes"]);
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Perfil;
        }

        /// <summary>
        /// Graba o actualiza los datos de un perfil asociados a un usuario
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public void Grabar_byPerfilUsuario(BEPerfil model, int idu)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_graba_perfil_usuario, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idu", SqlDbType.Int).Value = idu;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    oComando.ExecuteNonQuery();
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
