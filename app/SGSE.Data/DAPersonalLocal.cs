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
    public class DAPersonalLocal : AbstractDataManager
    {
        // Personal Directivo de una mision (Diplomaticos = 1, Administrativos Lima = 2)
        private string sp_listar_personal_toselect = "SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_TOSELECT";
        private string sp_listar_todt = "SC_COMUN.USP_PERSONAL_LISTAR_toDT";
        private string sp_listar_byid = "SC_COMUN.USP_ORGSER_PERSONAL_LISTAR_byID";
        private string sp_listar_apdd = "SC_COMUN.USP_ORGSER_PERSONAL_PLANILLA_byID";
        private string sp_grabar_general = "SC_COMUN.USP_PERSONAL_GRABAR";
        private string sp_exportar = "SC_REPORTES.USP_PERSONAL_EXPORTAR";
        private string sp_grabar_contrato = "SC_COMUN.USP_PERSONAL_GRABAR_CONTRATO";
        private string sp_listar_contrato = "SC_COMUN.USP_PERSONAL_LISTAR_CONTRATO_BASE";


        #region Listas del personal hacia DT

        /// <summary>
        /// Devuelve la lista del personal local para el usuario administrador
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPersonalLocal_DTAdmin> Listar_byAdm_ToDT(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            List<BEPersonalLocal_DTAdmin> Personas = new List<BEPersonalLocal_DTAdmin>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_todt, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_page_nmber", SqlDbType.Int).Value = pageNumber;
                    oComando.Parameters.Add("@p_page_rows", SqlDbType.Int).Value = pageRows;
                    oComando.Parameters.Add("@p_page_search", SqlDbType.VarChar, 35).Value = search;
                    oComando.Parameters.Add("@p_page_sort", SqlDbType.Int).Value = sort;
                    oComando.Parameters.Add("@p_page_dir", SqlDbType.VarChar, 4).Value = dir;
                    oComando.Parameters.Add("@p_page_flt", SqlDbType.VarChar, 4).Value = 0;

                    oComando.Parameters.Add("@p_rows_totl", SqlDbType.Int).Direction = ParameterDirection.Output;
                    oConexion.Open();


                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Personas.Add(new BEPersonalLocal_DTAdmin
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["s_per_sid"])),

                                Pais = DataUtil.ObjectToString(dr["s_per_pai"]),
                                Tipo = DataUtil.ObjectToString(dr["s_ose_tip"]),
                                OSE = DataUtil.ObjectToString(dr["s_ose_abr"]),
                                SitLab = DataUtil.ObjectToString(dr["s_sit_lab"]),

                                Personal = DataUtil.ObjectToString(dr["s_per_ape"]),
                                Sueldo = DataUtil.ObjectToString(dr["s_sue_bas"]),
                                Moneda = DataUtil.ObjectToString(dr["s_sue_mon"]),

                                Estado = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_sit_est"]),
                                    StrValue = DataUtil.ObjectToString(dr["s_sit_est"])
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

            return Personas;
        }

        /// <summary>
        /// Devuelve la lista del personal local para usuarios de la misión
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="flt">Identificador de la misión</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPersonalLocal> Listar_byOSE_ToDT(int pageNumber, int pageRows, string search, int sort, string dir, int flt, ref int totalRows)
        {
            List<BEPersonalLocal> Personas = new List<BEPersonalLocal>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_todt, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_page_nmber", SqlDbType.Int).Value = pageNumber;
                    oComando.Parameters.Add("@p_page_rows", SqlDbType.Int).Value = pageRows;
                    oComando.Parameters.Add("@p_page_search", SqlDbType.VarChar, 35).Value = search;
                    oComando.Parameters.Add("@p_page_sort", SqlDbType.Int).Value = sort;
                    oComando.Parameters.Add("@p_page_dir", SqlDbType.VarChar, 4).Value = dir;
                    oComando.Parameters.Add("@p_page_flt", SqlDbType.VarChar, 4).Value = flt;

                    oComando.Parameters.Add("@p_rows_totl", SqlDbType.Int).Direction = ParameterDirection.Output;
                    oConexion.Open();

                    //: Si es usuario de mision
                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Personas.Add(new BEPersonalLocal
                            {
                                Row = DataUtil.ObjectToInt(dr["i_row"]),
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["s_per_sid"])),

                                OrganoServicio = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_ose_abr"])
                                },
                                Apellidos = DataUtil.ObjectToString(dr["s_per_ape"]),
                                Nombres = DataUtil.ObjectToString(dr["s_per_nom"]),
                                TipoPersonal = new ItemGenerico { Texto = DataUtil.ObjectToString(dr["s_per_tpo"]) },
                                GradoProfesional = new ItemGenerico { Texto = DataUtil.ObjectToString(dr["s_per_gra"]) },
                                SituacionLaboral = new ItemGenerico { Texto = DataUtil.ObjectToString(dr["s_sit_lab"]) },
                                Estado = new ItemGenerico
                                {
                                    IntValue = DataUtil.ObjectToInt(dr["i_sit_est"]),
                                    StrValue = DataUtil.ObjectToString(dr["s_sit_est"])
                                }
                            });
                        }

                        totalRows = DataUtil.ObjectToInt(oComando.Parameters["@p_rows_totl"].Value);
                        oComando.Dispose();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Personas;
        }

        #endregion


        /// <summary>
        /// Devuelve el personal directivo de una mision (diplomaticos y administrativos lima)
        /// </summary>
        /// <param name="id">Id de la cuenta corriente</param>
        /// <returns>BECuentaCorriente</returns>
        public IEnumerable<BEPersonalLocal> Listar_Directivo_toSelect_byOse(int id)
        {
            List<BEPersonalLocal> Personas = new List<BEPersonalLocal>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_personal_toselect, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_ose", SqlDbType.Int).Value = id;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Personas.Add(new BEPersonalLocal
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_persid"])),
                                Apellidos = DataUtil.ObjectToString(dr["s_pernom"])
                            });
                        };
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Personas;
        }

        /// <summary>
        /// Lista los datos de un personal de servicio exterior por su id
        /// </summary>
        /// <param name="sid">Id del personal de servicio exterior</param>
        /// <returns></returns>
        public BEPersonalLocal Listar_byID(int sid)
        {
            BEPersonalLocal PersonalLocal = new BEPersonalLocal();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byid, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            PersonalLocal.CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_per_sid"]));
                            PersonalLocal.OrganoServicio = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_ose_sid"])) };
                            PersonalLocal.Apellidos = DataUtil.ObjectToString(dr["s_per_ape"]);
                            PersonalLocal.Nombres = DataUtil.ObjectToString(dr["s_per_nom"]);
                            PersonalLocal.TipoDocumento = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_tdc_sid"])) };
                            PersonalLocal.NumeroDocumento = DataUtil.ObjectToString(dr["s_tdc_num"]);
                            PersonalLocal.TipoPersonal = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_tpe_sid"])) };
                            PersonalLocal.FechaNacimiento = DataUtil.ObjectToString(dr["s_per_fnc"]);
                            PersonalLocal.LugarDesempeno = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_lug_sid"])) };
                            PersonalLocal.Nacionalidad = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_per_nac"])) };
                            PersonalLocal.EstadoCivil = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_per_civ"])) };
                            PersonalLocal.Email = DataUtil.ObjectToString(dr["s_per_mai"]);
                            PersonalLocal.Genero = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_gen_sid"])) };
                            PersonalLocal.Discapacidad = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_dis_sid"]) };
                            PersonalLocal.GradoProfesional = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_gra_sid"])) };
                            PersonalLocal.Especialidad = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["i_esp_sid"])) };
                            PersonalLocal.Observacion = DataUtil.ObjectToString(dr["s_per_obs"]);
                            PersonalLocal.InicioFunciones = DataUtil.ObjectToString(dr["s_per_ini"]);
                            PersonalLocal.SituacionLaboral = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_lab_sid"])) };
                            PersonalLocal.Situacion = new ItemGenerico { StrValue = Peach.EncriptText(DataUtil.ObjectToString(dr["s_reg_sid"])) };

                            PersonalLocal.RowAudit = new IRowAudit
                            {
                                IUsr = DataUtil.ObjectToInt16(dr["i_usr"]),
                                Log = String.Concat("Ultima actualización: ", DataUtil.ObjectToString(dr["s_usr"]), " el ", DataUtil.ObjectToString(dr["s_fcr"]))
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
            return PersonalLocal;
        }

        /// <summary>
        /// Devuelve la lista de aportes y descuentos para el trabajador del OSE
        /// </summary>
        /// <param name="IdContrato"></param>
        /// <returns></returns>
        public IEnumerable<BEAporteDeduccion> Listar_AportesDescuentos(int IdContrato)
        {
            List<BEAporteDeduccion> Aportes = new List<BEAporteDeduccion>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_apdd, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = IdContrato;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Aportes.Add(new BEAporteDeduccion
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Concepto = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_con"])
                                },
                                Descripcion = DataUtil.ObjectToString(dr["s_des"]),
                                Operacion = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_inc"])
                                },
                                Afectacion = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_afe"])
                                },
                                TipoAfectacion = new ItemGenerico
                                {
                                    Texto = DataUtil.ObjectToString(dr["s_tpo"])
                                },
                                MontoAfectacion = DataUtil.ObjectToString(dr["i_mon"])
                            });
                        };
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Aportes;
        }

        /// <summary>
        /// Graba o actualiza los datos de un trabajador local
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPersonalLocal model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar_general, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = model.Id;
                    oComando.Parameters.Add("@p_ido", SqlDbType.Int).Value = model.OrganoServicio.IntValue;

                    oComando.Parameters.Add("@p_ape", SqlDbType.VarChar, 45).Value = model.Apellidos;
                    oComando.Parameters.Add("@p_nom", SqlDbType.VarChar, 45).Value = model.Nombres;
                    oComando.Parameters.Add("@p_fna", SqlDbType.VarChar, 10).Value = model.FechaNacimiento;

                    oComando.Parameters.Add("@p_gen", SqlDbType.SmallInt).Value = model.Genero.IntValue;
                    oComando.Parameters.Add("@p_dis", SqlDbType.Bit).Value = model.Discapacidad.IntValue;
                    oComando.Parameters.Add("@p_nac", SqlDbType.SmallInt).Value = model.Nacionalidad.IntValue;

                    oComando.Parameters.Add("@p_tdc", SqlDbType.Int).Value = model.TipoDocumento.IntValue;
                    oComando.Parameters.Add("@p_ndc", SqlDbType.VarChar, 25).Value = model.NumeroDocumento;
                    oComando.Parameters.Add("@p_mai", SqlDbType.VarChar, 60).Value = model.Email;

                    oComando.Parameters.Add("@p_ecv", SqlDbType.SmallInt).Value = model.EstadoCivil.IntValue;
                    oComando.Parameters.Add("@p_grd", SqlDbType.SmallInt).Value = model.GradoProfesional.IntValue;
                    oComando.Parameters.Add("@p_esp", SqlDbType.SmallInt).Value = model.Especialidad.IntValue;
                    oComando.Parameters.Add("@p_tps", SqlDbType.SmallInt).Value = model.TipoPersonal.IntValue;

                    oComando.Parameters.Add("@p_obs", SqlDbType.VarChar).Value = model.Observacion;
                    oComando.Parameters.Add("@p_sla", SqlDbType.SmallInt).Value = model.SituacionLaboral.IntValue;
                    oComando.Parameters.Add("@p_sit", SqlDbType.SmallInt).Value = model.Situacion.IntValue;

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
        /// Graba o actualiza los datos del contrato de un trabajador 
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarContrato(BEPersonalLocal model)
        {
            ResponserData Responser = new ResponserData();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar_contrato, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_sid", SqlDbType.SmallInt).Value = model.Contrato.Id;
                    oComando.Parameters.Add("@p_per_sid", SqlDbType.SmallInt).Value = model.Id;
                    oComando.Parameters.Add("@p_ose_sid", SqlDbType.SmallInt).Value = model.OrganoServicio.IntValue;
                    oComando.Parameters.Add("@p_con_tip", SqlDbType.SmallInt).Value = model.Contrato.TipoContrato.IntValue;
                    oComando.Parameters.Add("@p_con_ref", SqlDbType.SmallInt).Value = model.Contrato.Referencia.IntValue;

                    oComando.Parameters.Add("@p_con_num", SqlDbType.VarChar, 25).Value = model.Contrato.Numero;
                    oComando.Parameters.Add("@p_con_fec", SqlDbType.VarChar, 10).Value = model.Contrato.FechaContrato;
                    oComando.Parameters.Add("@p_con_ini", SqlDbType.VarChar, 10).Value = model.Contrato.FechaInicio;
                    oComando.Parameters.Add("@p_con_fin", SqlDbType.VarChar, 10).Value = model.Contrato.FechaTermino;

                    oComando.Parameters.Add("@p_con_ind", SqlDbType.Bit).Value = model.Contrato.Indefinido;

                    oComando.Parameters.Add("@p_con_car", SqlDbType.SmallInt).Value = model.Contrato.Cargo.IntValue;
                    oComando.Parameters.Add("@p_con_mon", SqlDbType.SmallInt).Value = model.Contrato.Moneda.IntValue;
                    oComando.Parameters.Add("@p_con_rem", SqlDbType.Decimal).Value = model.Contrato.RemuneracionBruta;
                    oComando.Parameters.Add("@p_con_fun", SqlDbType.VarChar, 10).Value = model.Contrato.FechaInicioFuncion;
                    oComando.Parameters.Add("@p_con_aut", SqlDbType.VarChar, 25).Value = model.Contrato.DocumentoAutorizacion;
                    oComando.Parameters.Add("@p_con_autfec", SqlDbType.VarChar, 10).Value = model.Contrato.FechaAutorizacion;

                    oComando.Parameters.Add("@p_con_tco", SqlDbType.SmallInt).Value = model.Contrato.TipoContrato.IntValue;
                    oComando.Parameters.Add("@p_con_obs", SqlDbType.VarChar).Value = (model.Contrato.Observacion == null) ? string.Empty : model.Contrato.Observacion;

                    oComando.Parameters.Add("@p_con_sit", SqlDbType.SmallInt).Value = model.Contrato.Situacion.IntValue;


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
        /// Lista simple de contratos
        /// </summary>
        /// <param name="sid">Id del personal</param>
        /// <returns></returns>
        public IEnumerable<ItemGenerico> ListarContratos(int sid)
        {
            List<ItemGenerico> Contratos = new List<ItemGenerico>();

            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_contrato, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_sid_per", SqlDbType.SmallInt).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Contratos.Add(new ItemGenerico
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                StrValue = DataUtil.ObjectToString(dr["s_con"])
                            });
                        };
                    }
                    oComando.Dispose();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }


            return Contratos;
        }


        /// <summary>
        /// Esporta todos los datos del personal local
        /// </summary>
        /// <returns></returns>
        public IEnumerable<RPPersonal> ExportarPersonalLocal(int sid)
        {
            List<RPPersonal> Personal = new List<RPPersonal>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_exportar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Personal.Add(new RPPersonal
                            {
                                OrganoServicio = DataUtil.ObjectToString(dr["oseabr"]),
                                Apellidos = DataUtil.ObjectToString(dr["perape"]),
                                Nombres = DataUtil.ObjectToString(dr["pernom"]),
                                TipoDocumento = DataUtil.ObjectToString(dr["doctip"]),
                                NumeroDocumento = DataUtil.ObjectToString(dr["docnum"]),
                                TipoPersonal = DataUtil.ObjectToString(dr["pertip"]),
                                FechaNacimiento = DataUtil.ObjectToString(dr["pernac"]),
                                Nacionalidad = DataUtil.ObjectToString(dr["pergen"]),
                                EstadoCivil = DataUtil.ObjectToString(dr["perciv"]),
                                Email = DataUtil.ObjectToString(dr["permai"]),
                                Genero = DataUtil.ObjectToString(dr["pergen"]),
                                Discapacidad = DataUtil.ObjectToString(dr["perdis"]),
                                GradoAcademico = DataUtil.ObjectToString(dr["pergra"]),
                                Especialidad = DataUtil.ObjectToString(dr["peresp"]),
                                SituacionLaboral = DataUtil.ObjectToString(dr["persit"]),
                                SituacionRegistro = DataUtil.ObjectToString(dr["perreg"]),
                                Observacion = DataUtil.ObjectToString(dr["perobs"]),
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
            return Personal;
        }
    }
}
