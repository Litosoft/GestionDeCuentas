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
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DACuentaCorriente : AbstractDataManager
    {
        private string sp_cuentacorriente_listar_toDT = "SC_COMUN.USP_CUENTACORRIENTE_LISTAR_TODT";
        private string sp_cuentacorriente_listar_byId = "SC_COMUN.USP_CUENTACORRIENTE_LISTAR_BYID";
        private string sp_cuentacorriente_grabar = "SC_COMUN.USP_CUENTACORRIENTE_GRABAR";
        private string sp_cuentacorriente_grabar_obs = "SC_COMUN.USP_CUENTACORRIENTE_GRABAROBS";

        private string sp_exportar_cuentas = "SC_REPORTES.USP_CUENTACORRIENTE_EXPORTAR";
        private string sp_selector_cuentacargo_formatoegreso = "SC_COMUN.USP_CTACTE_LISTAR_byUSR";


        /// <summary>
        /// Devuelve todos la cuentas corrientes para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, int flt, ref int totalRows)
        {
            List<BECuentaCorriente> Cuentas = new List<BECuentaCorriente>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_cuentacorriente_listar_toDT, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_page_nmber", SqlDbType.Int).Value = pageNumber;
                    oComando.Parameters.Add("@p_page_rows", SqlDbType.Int).Value = pageRows;
                    oComando.Parameters.Add("@p_page_search", SqlDbType.VarChar, 35).Value = search;
                    oComando.Parameters.Add("@p_page_sort", SqlDbType.Int).Value = sort;
                    oComando.Parameters.Add("@p_page_dir", SqlDbType.VarChar, 4).Value = dir;
                    oComando.Parameters.Add("@p_page_flt", SqlDbType.VarChar, 4).Value = flt;

                    oComando.Parameters.Add("@p_rows_totl", SqlDbType.Int).Direction = ParameterDirection.Output;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Cuentas.Add(new BECuentaCorriente
                            {
                                Row = DataUtil.ObjectToInt(dr["i_ctarow"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_ctasid"])),

                                NumeroCuenta = DataUtil.ObjectToString(dr["s_ctanro"]),
                                EsCompartida = new ItemGenerico {
                                    StrValue = DataUtil.ObjectToString(dr["s_ctacom"]),
                                },
                                Moneda = new BEMoneda
                                {
                                    ISO4217 = DataUtil.ObjectToString(dr["s_ctaiso"])
                                },
                                OrganoServicio = new BEOrganoServicio
                                {
                                    Abreviatura = DataUtil.ObjectToString(dr["s_osenom"])
                                },
                                Agencia = new BEAgenciaBancaria
                                {
                                    Nombre = DataUtil.ObjectToString(dr["s_bannom"])
                                },
                                Situacion = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_ctasit"]),
                                    StrValue = DataUtil.ObjectToString(dr["s_ctasit"])
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

            return Cuentas;
        }


        /// <summary>
        /// Devuelve los datos de una cuenta corriente según su id
        /// </summary>
        /// <param name="id">Id de la cuenta corriente</param>
        /// <returns>BECuentaCorriente</returns>
        public BECuentaCorriente Listar_byId(int id)
        {
            BECuentaCorriente CuentaCorriente = new BECuentaCorriente();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_cuentacorriente_listar_byId, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            CuentaCorriente.CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_ctasid"]));
                            CuentaCorriente.OrganoServicio = new BEOrganoServicio { CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_osesid"])) };
                            CuentaCorriente.OrganoServicio.Abreviatura = DataUtil.ObjectToString(dr["s_oseabr"]);
                            CuentaCorriente.NumeroCuenta = DataUtil.ObjectToString(dr["s_ctanum"]);
                            CuentaCorriente.Moneda = new BEMoneda { CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_mndsid"])) };
                            CuentaCorriente.Moneda.Nombre = DataUtil.ObjectToString(dr["s_mndnom"]);
                            CuentaCorriente.Agencia = new BEAgenciaBancaria { CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_bansid"])) };
                            CuentaCorriente.Agencia.Nombre = DataUtil.ObjectToString(dr["s_bannom"]);
                            CuentaCorriente.CodigoRuteo = new ItemGenerico { CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_rutsid"])) };
                            CuentaCorriente.CodigoRuteo.Texto = DataUtil.ObjectToString(dr["s_rutnom"]);
                            CuentaCorriente.Iban = DataUtil.ObjectToString(dr["s_ctaiba"]);
                            CuentaCorriente.Swift = DataUtil.ObjectToString(dr["s_ctaswi"]);
                            CuentaCorriente.ABA = DataUtil.ObjectToString(dr["s_ctaaba"]);

                            CuentaCorriente.RIB = DataUtil.ObjectToString(dr["s_ctarib"]);
                            CuentaCorriente.CBU = DataUtil.ObjectToString(dr["s_ctacbu"]);
                            CuentaCorriente.BSB = DataUtil.ObjectToString(dr["s_ctabsb"]);
                            CuentaCorriente.ABI = DataUtil.ObjectToString(dr["s_ctaabi"]);
                            CuentaCorriente.CAB = DataUtil.ObjectToString(dr["s_ctacab"]);

                            CuentaCorriente.Destino = new ItemGenerico { CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_ctades"])) };
                            CuentaCorriente.Destino.Texto = DataUtil.ObjectToString(dr["s_ctades"]);
                            CuentaCorriente.FechaApertura = DataUtil.ObjectToString(dr["s_ctaini"]);
                            CuentaCorriente.FechaCierre = DataUtil.ObjectToString(dr["s_ctafin"]);
                            CuentaCorriente.Documento = new BEDocumento
                            {
                                Numero = DataUtil.ObjectToString(dr["s_ctadnu"]),
                                Fecha = DataUtil.ObjectToString(dr["s_ctadfe"]),
                            };
                            CuentaCorriente.Apoderado = new ItemGenerico
                            {
                                CID = Peach.EncriptText(Peach.EncriptText(DataUtil.ObjectToString(dr["i_aposid"])))
                            };
                            CuentaCorriente.EsCompartida = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_ctacom"]) };
                            CuentaCorriente.Situacion = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_ctasit"]) };
                            CuentaCorriente.Observacion = DataUtil.ObjectToString(dr["s_ctaobs"]);

                            CuentaCorriente.BeneficiarioNombre = DataUtil.ObjectToString(dr["s_bennom"]);
                            CuentaCorriente.BeneficiarioDir1 = DataUtil.ObjectToString(dr["s_bendo1"]);
                            CuentaCorriente.BeneficiarioDir2 = DataUtil.ObjectToString(dr["s_bendo2"]);
                            CuentaCorriente.BeneficiarioDir3 = DataUtil.ObjectToString(dr["s_bendo3"]);

                            // Datos de plantilla
                            CuentaCorriente.Plantilla = new BETransferenciaPlantilla();
                            CuentaCorriente.Plantilla.Entidad = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_plaent"])) };
                            CuentaCorriente.Plantilla.CuentaOrigen = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_placta"])) };
                            CuentaCorriente.Plantilla.TipoDestino = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_plades"])) };
                            CuentaCorriente.Plantilla.Agencia = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_plaage"])) };
                            CuentaCorriente.Plantilla.DatoAdicional = DataUtil.ObjectToString(dr["s_pladat"]);
                            CuentaCorriente.Plantilla.MetodoRuteo = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_plamru"])) };
                            CuentaCorriente.Plantilla.CodigoRuteo = DataUtil.ObjectToString(dr["s_plarut"]);
                            CuentaCorriente.Plantilla.EntidadSolicitante = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_plasub"])) };

                            CuentaCorriente.RowAudit = new IRowAudit
                            {
                                IUsr = DataUtil.ObjectToInt16(dr["i_audtus"]),
                                Log = String.Concat("Ultima actualización: ", DataUtil.ObjectToString(dr["s_audtus"]), " el ", DataUtil.ObjectToString(dr["s_audtfe"]))
                            };
                        };
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return CuentaCorriente;
        }


        /// <summary>
        /// Graba o actualiza los datos de una cuenta corriente
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BECuentaCorriente model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_cuentacorriente_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_ose", SqlDbType.Int).Value = model.OrganoServicio.Id;
                    oComando.Parameters.Add("@p_mnd", SqlDbType.SmallInt).Value = model.Moneda.Id;
                    oComando.Parameters.Add("@p_bic", SqlDbType.VarChar, 11).Value = model.Swift;
                    oComando.Parameters.Add("@p_rib", SqlDbType.VarChar, 23).Value = model.RIB;

                    oComando.Parameters.Add("@p_abi", SqlDbType.VarChar, 9).Value = model.ABI;
                    oComando.Parameters.Add("@p_ini", SqlDbType.VarChar, 10).Value = model.FechaApertura;
                    oComando.Parameters.Add("@p_doc", SqlDbType.VarChar, 18).Value = model.Documento.Numero;

                    oComando.Parameters.Add("@p_cta", SqlDbType.VarChar, 34).Value = model.NumeroCuenta;
                    oComando.Parameters.Add("@p_des", SqlDbType.TinyInt).Value = model.Destino.IntValue;
                    oComando.Parameters.Add("@p_iba", SqlDbType.VarChar, 30).Value = model.Iban;
                    oComando.Parameters.Add("@p_cbu", SqlDbType.VarChar, 22).Value = model.CBU;
                    oComando.Parameters.Add("@p_cab", SqlDbType.VarChar, 5).Value = model.CAB;
                    oComando.Parameters.Add("@p_fin", SqlDbType.VarChar, 10).Value = model.FechaCierre;
                    oComando.Parameters.Add("@p_fdo", SqlDbType.VarChar, 10).Value = model.Documento.Fecha;

                    oComando.Parameters.Add("@p_age", SqlDbType.SmallInt).Value = model.Agencia.Id;
                    oComando.Parameters.Add("@p_rut", SqlDbType.TinyInt).Value = model.CodigoRuteo.IntValue;
                    oComando.Parameters.Add("@p_aba", SqlDbType.VarChar, 9).Value = model.ABA;
                    oComando.Parameters.Add("@p_bsb", SqlDbType.VarChar, 6).Value = model.BSB;

                    oComando.Parameters.Add("@p_apo", SqlDbType.SmallInt).Value = model.Apoderado.IntValue;
                    oComando.Parameters.Add("@p_obs", SqlDbType.VarChar, 255).Value = model.Observacion;
                    oComando.Parameters.Add("@p_sit", SqlDbType.SmallInt).Value = model.Situacion.IntValue;

                    oComando.Parameters.Add("@p_ben", SqlDbType.VarChar, 35).Value = model.BeneficiarioNombre;
                    oComando.Parameters.Add("@p_di1", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir1;
                    oComando.Parameters.Add("@p_di2", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir2;
                    oComando.Parameters.Add("@p_di3", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir3;

                    oComando.Parameters.Add("@p_ent", SqlDbType.SmallInt).Value = model.Plantilla.Entidad.IntValue;
                    oComando.Parameters.Add("@p_ctp", SqlDbType.SmallInt).Value = model.Plantilla.CuentaOrigen.IntValue;
                    oComando.Parameters.Add("@p_dep", SqlDbType.SmallInt).Value = model.Plantilla.TipoDestino.IntValue;
                    oComando.Parameters.Add("@p_agp", SqlDbType.SmallInt).Value = model.Plantilla.Agencia.IntValue;
                    oComando.Parameters.Add("@p_dap", SqlDbType.VarChar, 35).Value = model.Plantilla.DatoAdicional;
                    oComando.Parameters.Add("@p_mru", SqlDbType.SmallInt).Value = model.Plantilla.MetodoRuteo.IntValue;
                    oComando.Parameters.Add("@p_rup", SqlDbType.VarChar, 11).Value = model.Plantilla.CodigoRuteo;
                    oComando.Parameters.Add("@p_bep", SqlDbType.SmallInt).Value = model.Plantilla.EntidadSolicitante.IntValue;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
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
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Actualiza la observacion de una cuenta corriente
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarObservacion(BECuentaCorriente model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_cuentacorriente_grabar_obs, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_mnd", SqlDbType.SmallInt).Value = model.Moneda.Id;
                    oComando.Parameters.Add("@p_bic", SqlDbType.VarChar, 11).Value = model.Swift;
                    oComando.Parameters.Add("@p_rib", SqlDbType.VarChar, 23).Value = model.RIB;

                    oComando.Parameters.Add("@p_abi", SqlDbType.VarChar, 9).Value = model.ABI;
                    oComando.Parameters.Add("@p_ini", SqlDbType.VarChar, 10).Value = model.FechaApertura;
                    oComando.Parameters.Add("@p_doc", SqlDbType.VarChar, 18).Value = model.Documento.Numero;

                    oComando.Parameters.Add("@p_cta", SqlDbType.VarChar, 34).Value = model.NumeroCuenta;
                    oComando.Parameters.Add("@p_des", SqlDbType.TinyInt).Value = model.Destino.IntValue;
                    oComando.Parameters.Add("@p_iba", SqlDbType.VarChar, 30).Value = model.Iban;
                    oComando.Parameters.Add("@p_cbu", SqlDbType.VarChar, 22).Value = model.CBU;
                    oComando.Parameters.Add("@p_cab", SqlDbType.VarChar, 5).Value = model.CAB;
                    oComando.Parameters.Add("@p_fin", SqlDbType.VarChar, 10).Value = model.FechaCierre;
                    oComando.Parameters.Add("@p_fdo", SqlDbType.VarChar, 10).Value = model.Documento.Fecha;

                    oComando.Parameters.Add("@p_age", SqlDbType.SmallInt).Value = model.Agencia.Id;
                    oComando.Parameters.Add("@p_rut", SqlDbType.TinyInt).Value = model.CodigoRuteo.IntValue;
                    oComando.Parameters.Add("@p_aba", SqlDbType.VarChar, 9).Value = model.ABA;
                    oComando.Parameters.Add("@p_bsb", SqlDbType.VarChar, 6).Value = model.BSB;

                    oComando.Parameters.Add("@p_apo", SqlDbType.SmallInt).Value = model.Apoderado.IntValue;
                    oComando.Parameters.Add("@p_obs", SqlDbType.VarChar, 255).Value = model.Observacion;
                    oComando.Parameters.Add("@p_sit", SqlDbType.SmallInt).Value = model.Situacion.IntValue;

                    oComando.Parameters.Add("@p_ben", SqlDbType.VarChar, 35).Value = model.BeneficiarioNombre;
                    oComando.Parameters.Add("@p_di1", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir1;
                    oComando.Parameters.Add("@p_di2", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir2;
                    oComando.Parameters.Add("@p_di3", SqlDbType.VarChar, 35).Value = model.BeneficiarioDir3;

                    oComando.Parameters.Add("@p_usr", SqlDbType.VarChar, 12).Value = model.RowAudit.IUsr;
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
                throw ex;
            }
            return Responser;
        }


        /// <summary>
        /// Esporta todos los datos de las cuentas
        /// </summary>
        /// <returns></returns>
        public IEnumerable<RPCuentasCorrientes> ExportarCuentas(int sid)
        {
            List<RPCuentasCorrientes> Cuentas = new List<RPCuentasCorrientes>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_exportar_cuentas, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Cuentas.Add(new RPCuentasCorrientes
                            {
                                OrganoServicio = DataUtil.ObjectToString(dr["oseabr"]),
                                NumeroCuenta = DataUtil.ObjectToString(dr["ctanum"]),
                                Moneda = DataUtil.ObjectToString(dr["ctamon"]),
                                BancoAgencia = DataUtil.ObjectToString(dr["ctaban"]),
                                SwiftBIC = DataUtil.ObjectToString(dr["ctaswi"]),
                                IBAN = DataUtil.ObjectToString(dr["ctaiba"]),
                                ABA = DataUtil.ObjectToString(dr["ctaaba"]),
                                RIB = DataUtil.ObjectToString(dr["ctarib"]),
                                CBU = DataUtil.ObjectToString(dr["ctacbu"]),
                                BSB = DataUtil.ObjectToString(dr["ctabsb"]),
                                ABI = DataUtil.ObjectToString(dr["ctaabi"]),
                                CAB = DataUtil.ObjectToString(dr["ctacab"]),
                                DestinoCuenta = DataUtil.ObjectToString(dr["ctades"]),
                                FechaApertura = DataUtil.ObjectToString(dr["ctaini"]),
                                FechaCierre = DataUtil.ObjectToString(dr["ctafin"]),
                                Apoderado = DataUtil.ObjectToString(dr["ctaapo"]),
                                Autorizacion = DataUtil.ObjectToString(dr["ctaaut"]),
                                FechaAut = DataUtil.ObjectToString(dr["ctafec"]),
                                Observaciones = DataUtil.ObjectToString(dr["ctaobs"]),
                                Beneficiario = DataUtil.ObjectToString(dr["bennom"]),
                                Domicilio1 = DataUtil.ObjectToString(dr["bendi1"]),
                                Domicilio2 = DataUtil.ObjectToString(dr["bendi2"]),
                                Domicilio3 = DataUtil.ObjectToString(dr["bendi3"]),
                                TransferenciaCtaOrigen = DataUtil.ObjectToString(dr["placta"]),
                                TransferenciaTpDestino = DataUtil.ObjectToString(dr["plades"]),
                                TransferenciaBancoInt = DataUtil.ObjectToString(dr["plabco"]),
                                TransferenciaRuteoInt = DataUtil.ObjectToString(dr["plarut"])
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
            return Cuentas;
        }

        /// <summary>
        /// Devuelve las cuentas de cargo para el formato de egreso
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> ListarCuentasCargo(int sid_usr)
        {
            List<BECuentaCorriente> Cuentas = new List<BECuentaCorriente>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_selector_cuentacargo_formatoegreso, oConexion);
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid_usr;
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Cuentas.Add(new BECuentaCorriente
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_ctasid"])),
                                NumeroCuenta = DataUtil.ObjectToString(dr["s_resumn"])
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
            return Cuentas;
        }
    }
}
