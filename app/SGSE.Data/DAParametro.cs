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
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DAParametro : AbstractDataManager
    {

        private string sp_listarDetalle = "SC_COMUN.USP_PARAMETROITEM_LISTAR";
        private string sp_listarGrupo = "SC_COMUN.USP_PARAMETRO_GRUPO_LISTAR";
        private string sp_listar = "SC_COMUN.USP_PARAMETRO_LISTAR";
        private string sp_grabar = "SC_COMUN.USP_PARAMETRO_GRABAR";
        private string sp_eliminar = "SC_COMUN.USP_PARAMETRO_ELIMINAR";
        private string sp_grabarDetalle = "SC_COMUN.USP_PARAMETROITEM_GRABAR";
        private string sp_eliminarDetalle = "SC_COMUN.USP_PARAMETROITEM_ELIMINAR";
        private string sp_listaritems_grupo = "SC_COMUN.USP_PARAMETROITEMS_LISTAR_byGRUPO";

        /// <summary>
        /// Lista los items correspondientes a un parámetro especificado en el enumerador
        /// </summary>
        /// <param name="Parametro">Enumerador parámetro</param>
        /// <returns>Lista de items pertenecientes al parámetro</returns>
        public IEnumerable<BEParametroItem> ListarDetalle(Parametros Parametro)
        {
            List<BEParametroItem> Detalles = new List<BEParametroItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listarDetalle, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = Parametro;
                    oComando.Parameters.Add("@p_idd", SqlDbType.Int).Value = 0;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Detalles.Add(new BEParametroItem
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idd"])),
                                Texto = DataUtil.ObjectToString(dr["s_tex"]),
                                Valor = Peach.EncriptText(DataUtil.ObjectToString(dr["s_val"])),
                                Ayuda = DataUtil.ObjectToString(dr["s_ayu"]),
                                Orden = DataUtil.ObjectToInt(dr["i_ord"]),
                                IsGrupo = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_gru"]),
                                    IntValue = DataUtil.ObjectToInt(dr["i_gru"])
                                }
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
            return Detalles;
        }

        /// <summary>
        /// Devuelve los parametros segun el texto de su grupo
        /// </summary>
        /// <param name="Parametro"></param>
        /// <returns></returns>
        public IEnumerable<BEParametroItem> ListarItems_byGrupo(string Grupo)
        {
            List<BEParametroItem> Detalles = new List<BEParametroItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listaritems_grupo, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_grupo", SqlDbType.VarChar, 35).Value = Grupo;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Detalles.Add(new BEParametroItem
                            {
                                Texto = DataUtil.ObjectToString(dr["s_tex"]),
                                Valor = Peach.EncriptText(DataUtil.ObjectToString(dr["s_val"]))
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
            return Detalles;
        }


        // Lista todos los detalles de los parametros de la aplicación
        public IEnumerable<BEParametroItem> ListarDetalle(BEParametro model)
        {
            List<BEParametroItem> Detalles = new List<BEParametroItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listarDetalle, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_idd", SqlDbType.Int).Value = 0;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Detalles.Add(new BEParametroItem
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idd"])),
                                Texto = DataUtil.ObjectToString(dr["s_tex"]),
                                Valor = DataUtil.ObjectToString(dr["s_val"]),
                                Ayuda = DataUtil.ObjectToString(dr["s_ayu"]),
                                Orden = DataUtil.ObjectToInt16(dr["i_ord"]),
                                IsGrupo = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_gru"])
                                }
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
            return Detalles;
        }


        /// <summary>
        /// Lista los grupos de los parámetros
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEParametroGrupo> ListarGrupo()
        {
            List<BEParametroGrupo> Grupos = new List<BEParametroGrupo>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listarGrupo, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Grupos.Add(new BEParametroGrupo
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"])
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
            return Grupos;
        }


        // Lista todos los parametros de la aplicación
        public IEnumerable<BEParametro> Listar()
        {
            List<BEParametro> Parametros = new List<BEParametro>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = 0;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Parametros.Add(new BEParametro
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),
                                Grupo = new BEParametroGrupo
                                {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_grp"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_grp"])
                                }
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
            return Parametros;
        }


        // Devuelve los datos de un parametro
        public BEParametro Listar_byId(int id)
        {
            BEParametro Parametro = new BEParametro();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Parametro.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"]));
                            Parametro.Nombre = DataUtil.ObjectToString(dr["s_nom"]);
                            Parametro.Descripcion = DataUtil.ObjectToString(dr["s_des"]);
                            Parametro.Grupo = new BEParametroGrupo
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_grp"])),
                                Nombre = DataUtil.ObjectToString(dr["s_grp"])
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
            return Parametro;
        }


        // Agrega/actualiza un parámetro
        public ResponserData Grabar(BEParametro model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_id", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombre;
                    oComando.Parameters.Add("@p_grp", SqlDbType.Int).Value = model.Grupo.Id;
                    oComando.Parameters.Add("@p_des", SqlDbType.VarChar, 255).Value = model.Descripcion;

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


        // Elimina un parámetro
        public ResponserData Eliminar(BEParametro model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_eliminar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_id", SqlDbType.Int).Value = model.Id;

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
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Agrega/Actualiza un detalle de un item
        /// </summary>
        /// <param name="model">BEParametro</param>
        /// <returns></returns>
        public ResponserData GrabarDetalle(BEParametro model)
        {
            ResponserData Responser = new ResponserData();

            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabarDetalle, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_id", SqlDbType.Int).Value = model.Detalle.Id;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_tex", SqlDbType.VarChar, 50).Value = model.Detalle.Texto;
                    oComando.Parameters.Add("@p_val", SqlDbType.VarChar, 50).Value = model.Detalle.Valor;
                    oComando.Parameters.Add("@p_ayu", SqlDbType.VarChar, 255).Value = model.Detalle.Ayuda;
                    oComando.Parameters.Add("@p_ord", SqlDbType.Int).Value = model.Detalle.Orden;
                    oComando.Parameters.Add("@p_grp", SqlDbType.Bit).Value = model.Detalle.IsGrupo.IntValue;

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


        public BEParametroItem ListarDetalle_byId(BEParametro model)
        {
            BEParametroItem Detalle = new BEParametroItem();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listarDetalle, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = 0;
                    oComando.Parameters.Add("@p_idd", SqlDbType.Int).Value = model.Detalle.Id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Detalle.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idd"]));
                            Detalle.Texto = DataUtil.ObjectToString(dr["s_tex"]);
                            Detalle.Valor = DataUtil.ObjectToString(dr["s_val"]);
                            Detalle.Ayuda = DataUtil.ObjectToString(dr["s_ayu"]);
                            Detalle.Orden = DataUtil.ObjectToInt16(dr["i_ord"]);
                            Detalle.IsGrupo = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt(dr["i_gru"])
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
            return Detalle;
        }


        // Elimina un parámetro
        public ResponserData EliminarDetalle(BEParametroItem model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_eliminarDetalle, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idd", SqlDbType.Int).Value = model.Id;

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
