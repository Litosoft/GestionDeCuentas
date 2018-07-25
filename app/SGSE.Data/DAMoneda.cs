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
    public class DAMoneda : AbstractDataManager
    {
        private string sp_listar_byOrganoServicio = "SC_COMUN.USP_MONEDA_LISTAR_SELECT_BYOSE";
        private string sp_listar_byPersonalLocal = "SC_COMUN.USP_MONEDA_LISTAR_BYPERSONAL";
        private string sp_listar_toDT = "SC_COMUN.USP_MONEDA_LISTAR_TODT";
        private string sp_listar_byId = "SC_COMUN.USP_MONEDA_LISTAR_BYID";
        private string sp_grabar = "SC_COMUN.USP_MONEDA_GRABAR";
        private string sp_listar_bypais = "SC_COMUN.USP_MONEDA_LISTAR_BYPAIS";
        private string sp_listar = "SC_COMUN.USP_MONEDA_LISTAR";


        /// <summary>
        /// Devuelve las monedas vinculadas a la locación de un Órgano de Servicio
        /// </summary>
        /// <param name="id">Id del Organo de Servicio</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_Select_byOSE(int id)
        {
            List<BEMoneda> Monedas = new List<BEMoneda>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byOrganoServicio, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_ose", SqlDbType.SmallInt).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Monedas.Add(new BEMoneda
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                ISO4217 = DataUtil.ObjectToString(dr["s_iso"])
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
            return Monedas;
        }


        /// <summary>
        /// Devuelve las monedas vinculadas al pais del personal local
        /// </summary>
        /// <param name="id">Id del Personal Local</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_Select_byPL(int id)
        {
            List<BEMoneda> Monedas = new List<BEMoneda>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byPersonalLocal, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.SmallInt).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Monedas.Add(new BEMoneda
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
            return Monedas;
        }



        /// <summary>
        /// Devuelve todos las monedas para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEMoneda> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEMoneda> Monedas = new List<BEMoneda>();
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
                            Monedas.Add(new BEMoneda
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                SufijoContable = DataUtil.ObjectToString(dr["s_suf"]),
                                Simbolo = DataUtil.ObjectToString(dr["s_sim"]),
                                ISO4217 = DataUtil.ObjectToString(dr["s_iso"]),
                                Asignable = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_asg"]),
                                    IntValue = DataUtil.ObjectToInt(dr["i_asg"])
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

            return Monedas;
        }

        /// <summary>
        /// Devuelve los datos de una moneda según su id
        /// </summary>
        /// <param name="id">Id de la moneda</param>
        /// <returns>BEMoneda</returns>
        public BEMoneda Listar_byId(int id)
        {
            BEMoneda Moneda = new BEMoneda();
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
                            Moneda.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"]));

                            Moneda.Nombre = DataUtil.ObjectToString(dr["s_nom"]);
                            Moneda.Abreviatura = DataUtil.ObjectToString(dr["s_abr"]);
                            Moneda.SufijoContable = DataUtil.ObjectToString(dr["s_suf"]);
                            Moneda.Simbolo = DataUtil.ObjectToString(dr["s_sim"]);
                            Moneda.ISO4217 = DataUtil.ObjectToString(dr["s_iso"]);
                            Moneda.Asignable = new ItemGenerico
                            {
                                IntValue = DataUtil.ObjectToInt16(dr["i_asg"]),
                                Texto = DataUtil.ObjectToString(dr["s_asg"])
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
            return Moneda;
        }


        /// <summary>
        /// Graba o actualiza los datos de una moneda
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEMoneda model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idp", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 40).Value = model.Nombre;
                    oComando.Parameters.Add("@p_abr", SqlDbType.VarChar, 20).Value = model.Abreviatura;
                    oComando.Parameters.Add("@p_suf", SqlDbType.VarChar, 15).Value = model.SufijoContable;
                    oComando.Parameters.Add("@p_sim", SqlDbType.VarChar, 5).Value = model.Simbolo;
                    oComando.Parameters.Add("@p_iso", SqlDbType.VarChar, 3).Value = model.ISO4217;
                    oComando.Parameters.Add("@p_asi", SqlDbType.Bit).Value = model.Asignable.IntValue;
                    oComando.Parameters.Add("@p_usr", SqlDbType.SmallInt).Value = model.RowAudit.IUsr;
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
        /// Devuelve las monedas vinculadas a un país
        /// </summary>
        /// <param name="id">Id del Pais</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_byPais(int id)
        {
            List<BEMoneda> Monedas = new List<BEMoneda>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_bypais, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_pai", SqlDbType.Int).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Monedas.Add(new BEMoneda
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                SufijoContable = DataUtil.ObjectToString(dr["s_suf"]),
                                Simbolo = DataUtil.ObjectToString(dr["s_sim"]),
                                ISO4217 = DataUtil.ObjectToString(dr["s_iso"]),
                                Asignable = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_asg"]),
                                    IntValue = DataUtil.ObjectToInt16(dr["i_asg"])
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
            return Monedas;
        }


        /// <summary>
        /// Devuelve todas las monedas registradas en la aplicación
        /// </summary>
        /// <returns>IEnumerable BEPais</returns>
        public IEnumerable<BEMoneda> Listar()
        {
            List<BEMoneda> Monedas = new List<BEMoneda>();
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
                            Monedas.Add(new BEMoneda
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"]),
                                SufijoContable = DataUtil.ObjectToString(dr["s_suf"]),
                                Simbolo = DataUtil.ObjectToString(dr["s_sim"]),
                                ISO4217 = DataUtil.ObjectToString(dr["s_iso"]),
                                Asignable = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_asg"]),
                                    IntValue = DataUtil.ObjectToInt(dr["i_asg"])
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
            return Monedas;
        }

    }
}
