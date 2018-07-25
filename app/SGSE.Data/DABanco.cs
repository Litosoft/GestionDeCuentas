using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Reportes;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace SGSE.Data
{
    public class DABanco : AbstractDataManager
    {
        // Migrado
        private string sp_listar_toDT = "SC_COMUN.USP_BANCO_LISTAR_TODT";
        private string sp_listar_byId = "SC_COMUN.USP_BANCO_LISTAR_BYID";
        private string sp_grabar = "SC_COMUN.USP_BANCO_GRABAR";
        private string sp_exportar_base = "SC_REPORTES.USP_BANCO_EXPORTAR_BASE";
        private string sp_exporta_ctaose = "SC_REPORTES.USP_BANCO_EXPORTAR_BANCOMISION";
        private string sp_listar_agencia = "SC_COMUN.USP_BANCOAGENCIA_LISTAR";
        private string sp_grabar_agencia = "SC_COMUN.USP_BANCOAGENCIA_GRABAR";
        private string sp_listar_select_byose = "SC_COMUN.USP_BANCOAGENCIA_LISTAR_SELECT_BYOSE";
        private string sp_listarintermedios_toselect = "SC_COMUN.USP_BANCOAGENCIA_LISTARINTERMEDIO_TOSELECT";


        /// <summary>
        /// Devuelve todos los bancos para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEBanco> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEBanco> Bancos = new List<BEBanco>();
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
                            Bancos.Add(new BEBanco
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Url = DataUtil.ObjectToString(dr["s_url"]),
                                Situacion = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_sit"]) }
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

            return Bancos;
        }


        /// <summary>
        /// Devuelve los datos de un banco según su id
        /// </summary>
        /// <param name="id">Id del banco</param>
        /// <returns>BEBanco</returns>
        public BEBanco Listar_byId(int id)
        {
            BEBanco Banco = new BEBanco();
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
                            Banco.CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_sid"]));
                            Banco.Nombre = DataUtil.ObjectToString(dr["s_nom"]);
                            Banco.Url = DataUtil.ObjectToString(dr["s_url"]);
                            Banco.Situacion = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_sit"]) };
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Banco;
        }


        /// <summary>
        /// Graba o actualiza los datos de un banco
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEBanco model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_idb", SqlDbType.SmallInt).Value = model.Id;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Nombre;
                    oComando.Parameters.Add("@p_url", SqlDbType.VarChar, 120).Value = model.Url;
                    oComando.Parameters.Add("@p_sit", SqlDbType.TinyInt).Value = model.Situacion.IntValue;

                    oComando.Parameters.Add("@p_usr", SqlDbType.SmallInt).Value = model.RowAudit.IUsr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = model.RowAudit.IP;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read())
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
                new DAError().GrabarLog("Data", "DABanco", "Grabar", 
                    string.Concat(ex.Message, "Ip:", model.RowAudit.IP, ", Len:" , model.RowAudit.IP.Length.ToString()), 
                    model.RowAudit.IUsr, model.RowAudit.IP);
                throw ex;
            }
            return Responser;
        }


        //: Agencias


        /// <summary>
        /// Devuelve todas las agencias bancarias asociadas a un banco o solo una.
        /// </summary>
        /// <param name="idb">Id banco</param>
        public IEnumerable<BEAgenciaBancaria> ListarAgencias(int idb)
        {
            List<BEAgenciaBancaria> Agencias = new List<BEAgenciaBancaria>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_agencia, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_ida", SqlDbType.Int).Value = 0;
                    oComando.Parameters.Add("@p_idb", SqlDbType.Int).Value = idb;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Agencias.Add(new BEAgenciaBancaria
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_age"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Direccion1 = DataUtil.ObjectToString(dr["s_di1"]),
                                Direccion2 = DataUtil.ObjectToString(dr["s_di2"]),
                                Tipo = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_tip"])
                                },
                                Pais = new BEPais
                                {
                                    Nombre = DataUtil.ObjectToString(dr["s_pai"])
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
            return Agencias;
        }


        /// <summary>
        /// Graba o actualiza los datos de una agencia bancaria
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarAgencia(BEBanco model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar_agencia, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_ida", SqlDbType.Int).Value = model.Agencia.Id;
                    oComando.Parameters.Add("@p_idb", SqlDbType.VarChar, 35).Value = model.Id;

                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 35).Value = model.Agencia.Nombre;
                    oComando.Parameters.Add("@p_dir1", SqlDbType.VarChar, 35).Value = model.Agencia.Direccion1;
                    oComando.Parameters.Add("@p_dir2", SqlDbType.VarChar, 35).Value = model.Agencia.Direccion2;
                    oComando.Parameters.Add("@p_tip", SqlDbType.Int).Value = model.Agencia.Tipo.IntValue;
                    oComando.Parameters.Add("@p_pai", SqlDbType.Int).Value = model.Agencia.Pais.Id;

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
        /// Devuelve los datos de una agencia especificada por su Id.
        /// </summary>
        /// <param name="ida">Id agencia</param>
        public BEAgenciaBancaria ListarAgencia(int ida)
        {
            BEAgenciaBancaria AgenciaBancaria = new BEAgenciaBancaria();
            string id = string.Empty;
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_agencia, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_idb", SqlDbType.Int).Value = 0;
                    oComando.Parameters.Add("@p_ida", SqlDbType.Int).Value = ida;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            AgenciaBancaria.CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_age"]));
                            AgenciaBancaria.Nombre = DataUtil.ObjectToString(dr["s_nom"]);
                            AgenciaBancaria.Direccion1 = DataUtil.ObjectToString(dr["s_di1"]);
                            AgenciaBancaria.Direccion2 = DataUtil.ObjectToString(dr["s_di2"]);
                            AgenciaBancaria.Tipo = new ItemGenerico
                            {
                                StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_tip"])),
                                Texto = DataUtil.ObjectToString(dr["s_tip"])
                            };
                            AgenciaBancaria.Pais = new BEPais
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_pai"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pai"])
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
            return AgenciaBancaria;
        }

        
        /// <summary>
        /// Devuelve las agencias bancarias asociadas a un organo de servicio
        /// </summary>
        /// <param name="sid">Id de agencia bancaria</param>
        public IEnumerable<BEAgenciaBancaria> ListarAgencia_ToSelect_ByOse(int sid)
        {
            List<BEAgenciaBancaria> Agencias = new List<BEAgenciaBancaria>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_select_byose, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Agencias.Add(new BEAgenciaBancaria
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_agesid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_agenom"])
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
            return Agencias;
        }


        //: Selector agencias de bancos intermedios
        /// <summary>
        /// Devuelves todas las agencias de uso intermedio para transferencias bancarias.
        /// </summary>
        public IEnumerable<BEAgenciaBancaria> ListarAgencias_BancoIntermedios_toSelect()
        {
            List<BEAgenciaBancaria> Agencias = new List<BEAgenciaBancaria>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listarintermedios_toselect, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Agencias.Add(new BEAgenciaBancaria
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_agesid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_agenom"])
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
            return Agencias;
        }


        #region Reporte

        /// <summary>
        /// Devuelve todos los bancos y agencias para un reporte en excel
        /// </summary>
        public IEnumerable<BancoAgenciaXls> ExpBancoAgencia()
        {
            List<BancoAgenciaXls> Bancos = new List<BancoAgenciaXls>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_exportar_base, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Bancos.Add(new BancoAgenciaXls
                            {
                                Banco = DataUtil.ObjectToString(dr["s_ban"]),
                                Agencia = DataUtil.ObjectToString(dr["s_age"]),
                                Domicilio1 = DataUtil.ObjectToString(dr["s_do1"]),
                                Domicilio2 = DataUtil.ObjectToString(dr["s_do2"]),
                                Tipo = DataUtil.ObjectToString(dr["s_tip"]),
                                Pais = DataUtil.ObjectToString(dr["s_pai"]),
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
            return Bancos;
        }

        /// <summary>
        /// Devuelve todos los bancos, agencias, cuentas y misiones para un reporte en excel
        /// </summary>
        public IEnumerable<BancoCuentaMisionXls> ExpBancoAgenciaCuentaMision()
        {
            List<BancoCuentaMisionXls> Bancos = new List<BancoCuentaMisionXls>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_exporta_ctaose, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Bancos.Add(new BancoCuentaMisionXls
                            {
                                OrganoServicio = DataUtil.ObjectToString(dr["s_ose"]),
                                Cuenta = DataUtil.ObjectToString(dr["s_cta"]),
                                Banco = DataUtil.ObjectToString(dr["s_ban"]),
                                Agencia = DataUtil.ObjectToString(dr["s_age"]),
                                Domicilio1 = DataUtil.ObjectToString(dr["s_do1"]),
                                Domicilio2 = DataUtil.ObjectToString(dr["s_do2"]),
                                Tipo = DataUtil.ObjectToString(dr["s_tip"]),
                                Pais = DataUtil.ObjectToString(dr["s_pai"]),
                                Situacion = DataUtil.ObjectToString(dr["s_sit"])
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
            return Bancos;
        }

        #endregion
    }
}
