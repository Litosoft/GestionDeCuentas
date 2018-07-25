using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
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
    public class DAPais : AbstractDataManager
    {
        private string sp_listar = "SC_COMUN.USP_PAIS_LISTAR";
        private string sp_listar_toDT = "SC_COMUN.USP_PAIS_LISTAR_TODT";
        private string sp_listar_byId = "SC_COMUN.USP_PAIS_LISTAR_BYID";
        private string sp_grabar = "SC_COMUN.USP_PAIS_GRABAR";
        private string sp_grabar_detalle_moneda = "SC_COMUN.USP_PAIS_GRABAR_MONEDA";
        private string sp_listar_regiones_bycn = "SC_COMUN.USP_REGION_LISTAR_BYCN";
        private string sp_listar_continentes = "SC_COMUN.USP_CONTINENTE_LISTAR";


        /// <summary>
        /// Devuelve la lista completa de paises
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar()
        {
            List<BEPais> Paises = new List<BEPais>();
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
                            Paises.Add(new BEPais
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_pai"]),
                                Oficial = DataUtil.ObjectToString(dr["s_nof"]),
                                Gentilicio = DataUtil.ObjectToString(dr["s_gen"]),
                                M49 = DataUtil.ObjectToString(dr["s_m49"]),
                                ISOA3 = DataUtil.ObjectToString(dr["s_iso"]),
                                Region = new BERegion
                                {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_rid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_rnm"]),
                                    CodigoONU = DataUtil.ObjectToString(dr["s_ron"]),
                                    Continente = new BEContinente
                                    {
                                        CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_cid"])),
                                        Nombre = DataUtil.ObjectToString(dr["s_cnm"]),
                                        CodigoONU = DataUtil.ObjectToString(dr["s_con"])
                                    }
                                },
                                Monedas_Asg = DataUtil.ObjectToString(dr["s_mas"]),
                                Monedas_Lcl = DataUtil.ObjectToString(dr["s_mlc"])
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
            return Paises;
        }


        /// <summary>
        /// Devuelve la lista completa de paises para el control selector
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar_ToSelect()
        {
            List<BEPais> Paises = new List<BEPais>();
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
                            Paises.Add(new BEPais
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pai"]),
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
            return Paises;
        }


        public IEnumerable<BEPais> Listar_ToSelect_Base64()
        {
            List<BEPais> Paises = new List<BEPais>();
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
                            Paises.Add(new BEPais
                            {
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pai"]),
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
            return Paises;
        }


        /// <summary>
        /// Devuelve todos los paises para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEPais> Paises = new List<BEPais>();
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
                            Paises.Add(new BEPais
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),

                                Nombre = DataUtil.ObjectToString(dr["s_pai"]),
                                Oficial = DataUtil.ObjectToString(dr["s_nof"]),
                                Region = new BERegion
                                {
                                    Nombre = DataUtil.ObjectToString(dr["s_rnm"]),
                                    Continente = new BEContinente
                                    {
                                        Nombre = DataUtil.ObjectToString(dr["s_cnm"]),
                                    }
                                },
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

            return Paises;
        }


        /// <summary>
        /// Devuelve los datos de un Pais
        /// </summary>
        /// <param name="sid">Id del País</param>
        /// <returns></returns>
        public BEPais Listar_byId(int sid)
        {
            BEPais Pais = new BEPais();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byId, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Pais.CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"]));
                            Pais.Nombre = DataUtil.ObjectToString(dr["s_pai"]);
                            Pais.Oficial = DataUtil.ObjectToString(dr["s_nof"]);
                            Pais.Gentilicio = DataUtil.ObjectToString(dr["s_gen"]);
                            Pais.M49 = DataUtil.ObjectToString(dr["s_m49"]);
                            Pais.ISOA3 = DataUtil.ObjectToString(dr["s_iso"]);
                            Pais.Region = new BERegion
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_rid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_rnm"]),
                                Continente = new BEContinente
                                {
                                    CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_cid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_cnm"])
                                }
                            };
                        }
                    }
                    Pais.Monedas = new DAMoneda().Listar_byPais(sid);
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Pais;
        }


        /// <summary>
        /// Graba o actualiza los datos de un pais
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPais model)
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
                    oComando.Parameters.Add("@p_ofi", SqlDbType.VarChar, 60).Value = model.Oficial;
                    oComando.Parameters.Add("@p_gen", SqlDbType.VarChar, 40).Value = model.Gentilicio;
                    oComando.Parameters.Add("@p_m49", SqlDbType.VarChar, 3).Value = model.M49;
                    oComando.Parameters.Add("@p_iso", SqlDbType.VarChar, 3).Value = model.ISOA3;
                    oComando.Parameters.Add("@p_reg", SqlDbType.Int).Value = model.Region.Id;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Responser.XID = DataUtil.ObjectToInt16(dr["i_id"]);
                            Responser.Mensaje = DataUtil.ObjectToString(dr["s_msg"]);
                            Responser.Estado = (ResponserEstado)DataUtil.ObjectToInt(dr["i_est"]);
                            Responser.TipoAlerta = (BootstrapAlertType)DataUtil.ObjectToInt(dr["i_btp"]);
                        }
                    }
                    oComando.Dispose();
                }

                if (Responser.XID > 0 && Responser.Estado == ResponserEstado.Ok)
                {
                    model.Id = Responser.XID;
                    foreach (BEMoneda moneda in model.Monedas)
                    {
                        model.Moneda = new BEMoneda
                        {
                            Id = moneda.Id
                        };
                        this.VincularMoneda(model);
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
        /// Devuelve las regiones asociadas a un continente registrados en la aplicación
        /// </summary>
        /// <returns>IEnumerable BERegion</returns>
        public IEnumerable<BERegion> Listar_Regiones_byContinente(int sid)
        {
            List<BERegion> Regiones = new List<BERegion>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_regiones_bycn, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_con", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Regiones.Add(new BERegion
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                CodigoONU = DataUtil.ObjectToString(dr["s_onu"])
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
            return Regiones;
        }


        /// <summary>
        /// Devuelve todos los continentes registrados en la aplicación
        /// </summary>
        /// <returns>IEnumerable BEContinente</returns>
        public IEnumerable<BEContinente> Listar_Continentes()
        {
            List<BEContinente> Continentes = new List<BEContinente>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_continentes, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Continentes.Add(new BEContinente
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                CodigoONU = DataUtil.ObjectToString(dr["s_onu"])
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
            return Continentes;
        }


        #region Métodos Privados

        /// <summary>
        /// Asocia una moneda a un pais.
        /// </summary>
        /// <param name="BEPais">País</param>
        private void VincularMoneda(BEPais Pais)
        {
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    using (SqlCommand oComando = new SqlCommand(sp_grabar_detalle_moneda, oConexion))
                    {
                        oComando.CommandType = CommandType.StoredProcedure;
                        oComando.Parameters.Add("@p_pai", SqlDbType.TinyInt).Value = Pais.Id;
                        oComando.Parameters.Add("@p_mnd", SqlDbType.SmallInt).Value = Pais.Moneda.Id;
                        oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = Pais.RowAudit.IUsr;
                        oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = Pais.RowAudit.IP;

                        oConexion.Open();
                        oComando.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #endregion

    }
}
