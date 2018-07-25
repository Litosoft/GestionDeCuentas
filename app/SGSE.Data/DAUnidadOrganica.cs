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
    public class DAUnidadOrganica : AbstractDataManager
    {
        //NOTE: DAUnidadOrganica Migrado
        private string sp_listar_toDT = "SC_COMUN.USP_UNIDADORGANICA_LISTAR_TODT";
        private string sp_listar_byId = "SC_COMUN.USP_UNIDADORGANICA_LISTAR_BYID";

        //TODO: Revisar estos procedimientos
        private string sp_listar = "SC_COMUN.USP_UNIDADORGANICA_LISTAR";
        private string sp_grabar = "SC_COMUN.USP_MENUITEM_GRABAR";


        /// <summary>
        /// Devuelve todos las unidades orgánicas para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEUnidad> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEUnidad> Unidades = new List<BEUnidad>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_toDT, oConexion);
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
                            Unidades.Add(new BEUnidad
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idu"])),

                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),
                                UnidadSuperior = new ItemGenerico
                                {
                                    StrValue = DataUtil.ObjectToString(dr["s_usp"])
                                    
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
            return Unidades;
        }


        /// <summary>Devuelve los datos de una unidad orgánica</summary>
        public BEUnidad Listar_byId(int id)
        {
            BEUnidad Unidad = null;
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byId, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Unidad = new BEUnidad
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idu"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),
                                UnidadSuperior = new ItemGenerico
                                {
                                    StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_usp"])),
                                }
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
            return Unidad;
        }


        /// <summary>Devuelve todas las unidades orgánicas </summary>
        public IEnumerable<BEUnidad> Listar()
        {
            List<BEUnidad> Unidades = new List<BEUnidad>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Unidades.Add(new BEUnidad
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_idu"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),
                                UnidadSuperior = new ItemGenerico {
                                    StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_usp"])),
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
            return Unidades;
        }


        


        /// <summary>
        /// Agrega/Actualiza una unidad organica
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEUnidad model)
        {
            ResponserData Responser = new ResponserData();

            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = model.Id;

                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombre;
                    oComando.Parameters.Add("@p_abr", SqlDbType.VarChar, 10).Value = model.Abreviatura;
                    oComando.Parameters.Add("@p_des", SqlDbType.VarChar, 35).Value = model.Descripcion;
                    oComando.Parameters.Add("@p_usu", SqlDbType.Int).Value = model.UnidadSuperior.Id;
                    
                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();
                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Responser.CID = DataUtil.ObjectToString(dr["i_id"]);
                            Responser.Mensaje = DataUtil.ObjectToString(dr["s_msg"]);
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToByte(dr["i_est"]);
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
