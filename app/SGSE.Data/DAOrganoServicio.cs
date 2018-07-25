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
    public class DAOrganoServicio : Abstract.AbstractDataManager
    {
        private string sp_listar_select = "SC_COMUN.USP_ORGSER_LISTAR_TOSELECT";
        private string sp_listar_datatable = "SC_COMUN.USP_ORGSER_LISTAR_TODT";
        private string sp_listar_bypai_select = "SC_COMUN.USP_ORGSER_LISTAR_BYPAIS_TOSELECT";
        private string sp_listar_byId = "SC_COMUN.USP_ORGSER_LISTAR_BYID";
        private string sp_listar_jefaturasservicio_byose_toselect = "SC_COMUN.USP_ORGSER_LISTAR_JEFSER_BYOSE_TOSELECT";
        private string sp_grabar = "SC_COMUN.USP_ORGSER_GRABAR";


        /// <summary>
        /// Devuelve los datos de organos de servicio para un control selector
        /// </summary>
        /// <param name="Tipo">0: Todos, [1-4] Tipos de Órganos de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_ToSelect(OrganosServicioType Tipo)
        {
            List<BEOrganoServicio> OrganosServicio = new List<BEOrganoServicio>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_select, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_tip", SqlDbType.SmallInt).Value = Tipo;

                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            OrganosServicio.Add(new BEOrganoServicio
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osesid"])),
                                Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"])
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

            return OrganosServicio;
        }


        /// <summary>
        /// Devuelve todos los organos de servicio para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEOrganoServicio> OrganosDeServicio = new List<BEOrganoServicio>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_datatable, oConexion);
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
                            OrganosDeServicio.Add(new BEOrganoServicio
                            {
                                Row = DataUtil.ObjectToInt(dr["i_oserow"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_osesid"])),
                                Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"]),
                                Nombre = DataUtil.ObjectToString(dr["s_osenom"]),
                                TipoOrgano = new ItemGenerico {  Texto = DataUtil.ObjectToString(dr["s_topabr"])},
                                Pais = new BEPais {  Nombre = DataUtil.ObjectToString(dr["s_painom"])}
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

            return OrganosDeServicio;
        }


        /// <summary>
        /// Devuelve los datos de una o de todas los organos de servicio por tipo y pais
        /// </summary>
        /// <param name="Tipo">0: Todos, [1-4] Tipos de Órganos de Servicio</param>
        /// <param name="Pais">[1-n] Códigos de país</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_byTipoPais_ToSelect(OrganosServicioType Tipo, int IdPais)
        {
            List<BEOrganoServicio> OrganosServicio = new List<BEOrganoServicio>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_bypai_select, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_tip", SqlDbType.SmallInt).Value = Tipo;
                    oComando.Parameters.Add("@p_pai", SqlDbType.SmallInt).Value = IdPais;

                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            OrganosServicio.Add(new BEOrganoServicio
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osesid"])),
                                Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"])
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

            return OrganosServicio;
        }


        /// <summary>
        /// Devuelve un órgano de servicio especificado por el Id
        /// </summary>
        /// <param name="IdOrganoServicio">Id principal</param>
        /// <returns></returns>
        public BEOrganoServicio Listar_byId(int IdOrganoServicio)
        {
            BEOrganoServicio OrganosDeServicio = new BEOrganoServicio();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byId, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = IdOrganoServicio;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            OrganosDeServicio = new BEOrganoServicio
                            {
                                Nombre = DataUtil.ObjectToString(dr["s_osenom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"]),

                                Pais = new BEPais {
                                    CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_paisid"])),
                                    Nombre = DataUtil.ObjectToString(dr["s_painom"])
                                },

                                JefaturaServicio = new ItemGenerico
                                {
                                    StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osejef"])),
                                    Texto = DataUtil.ObjectToString(dr["s_osejef"])
                                },

                                CodigoInterop = DataUtil.ObjectToString(dr["i_osecod"]),

                                TipoOrgano = new ItemGenerico {
                                    StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_tipsid"])),
                                    Texto = DataUtil.ObjectToString(dr["s_tipnom"])
                                },
                                
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

            return OrganosDeServicio;
        }


        /// <summary>
        /// Devuelve los consulados disponibles en el pais del órgano de servicio
        /// </summary>
        /// <param name="IdOrganoServicio">[1-n] Órganos de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_JefaturaServicio_byOSE_ToSelect(int IdOrganoServicio)
        {
            List<BEOrganoServicio> OrganosServicio = new List<BEOrganoServicio>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_jefaturasservicio_byose_toselect, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_ose", SqlDbType.SmallInt).Value = IdOrganoServicio;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            OrganosServicio.Add(new BEOrganoServicio
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osesid"])),
                                Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"])
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

            return OrganosServicio;
        }


        /// <summary>
        /// Graba/actualiza los datos de un órgano de servicio
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEOrganoServicio model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = model.Id;

                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 100).Value = model.Nombre;
                    oComando.Parameters.Add("@p_abr", SqlDbType.VarChar, 25).Value = model.Abreviatura;
                    oComando.Parameters.Add("@p_tip", SqlDbType.Int).Value = model.TipoOrgano.Id;
                    oComando.Parameters.Add("@p_pai", SqlDbType.Int).Value = model.Pais.Id;
                    oComando.Parameters.Add("@p_cod", SqlDbType.VarChar, 5).Value = model.CodigoInterop;
                    oComando.Parameters.Add("@p_jsv", SqlDbType.Int).Value = model.JefaturaServicio.Id;

                    oComando.Parameters.Add("@p_usr", SqlDbType.SmallInt).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Responser.CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_id"]));
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
