using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Reportes;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Helpers;
using SGSE.Webapp.Models.CuentaCte;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace SGSE.Webapp.Controllers
{
    public class CuentaCteController : BaseController
    {
        // Lista todas las cuentas corrientes.
        public ActionResult Listar()
        {
            if (User != null)
            {
                if (this.IsPermitido())
                {
                    return View();
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }

        /// <summary>
        /// Devuelve las cuentas corrientes de un organo de servicio exterior específico
        /// </summary>
        /// <returns></returns>
        public ActionResult Cuentas()
        {
            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (User.OrganoServicio_CID == string.Empty) {
                        return View();
                    }

                    // Obtiene los datos del usuario
                    var U = System.Web.HttpContext.Current.User;

                    // Obtiene la misión del usuario
                    var osesid = Peach.DecriptText(User.OrganoServicio_CID);
                    ViewBag.OSESID = Peach.EncriptToBase64(osesid);
                    ViewBag.OSE = User.OrganoServicio_Nombre;

                    return View();
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }


        /// <summary>
        /// Devuelve los detalles de la cuenta corriente
        /// </summary>
        /// <param name="sid">ID Base64 del Órgano de Servicio</param>
        /// <returns></returns>
        public ActionResult Detalle(string sid)
        {
            CuentaCteDetalleViewModel model = new CuentaCteDetalleViewModel();

            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (sid != string.Empty && sid != null)
                    {
                        int IdEntidadPublica = 1;

                        ViewBag.Controller = strControlador;
                        ViewBag.Method = strMetodo;

                        // * Tab General *
                        // Organos de Servicio

                        SelectListItem NingunOSE = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };
                        List<SelectListItem> IOrganosServicio = new List<SelectListItem>();
                        IOrganosServicio.Add(NingunOSE);
                        IOrganosServicio.AddRange(new SelectList(
                            new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));
                        model.OrganosServicio = IOrganosServicio;


                        // Destino de la cuenta
                        model.DestinosCuenta = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.DestinoCuentaCorriente), "Valor", "Texto");

                        // Código de Ruteo
                        model.CodigosRuteo = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.CodigoDeRuteo), "Valor", "Texto");


                        // Tab: Plantilla
                        // Entidad Publica Responsable por Transaccion
                        SelectListItem ItemNinguno = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };

                        // Entidades Públicas
                        List<SelectListItem> IEntidadesPublicas = new List<SelectListItem>();
                        IEntidadesPublicas.Add(ItemNinguno);
                        IEntidadesPublicas.AddRange(
                            new BLEntidadPublica().ListarEntidad_toSelect()
                            .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID })
                            );
                        model.EntidadesPublicas = IEntidadesPublicas;

                        // Cuentas de Entidad Publica
                        List<SelectListItem> ICuentasPublicas = new List<SelectListItem>();
                        ICuentasPublicas.Add(ItemNinguno);
                        ICuentasPublicas.AddRange(
                            new BLEntidadPublica().ListarEntidadCuentas_toSelect(IdEntidadPublica)
                            .Select(p => new SelectListItem { Text = p.NumeroCuenta, Value = p.CID })
                            );
                        model.CuentasEntidad = ICuentasPublicas;

                        // Tipos de Cuentas de Destino
                        Array CuentasDestinoArray = Enum.GetValues(typeof(CuentaDestinoType));
                        List<SelectListItem> ICuentasDestino = new List<SelectListItem>();
                        foreach (var e in CuentasDestinoArray)
                        {
                            ICuentasDestino.Add(new SelectListItem
                            {
                                Text = Enum.GetName(typeof(CuentaDestinoType), e),
                                Value = e.ToString()
                            });
                        }



                        // Cuentas de bancos intermedios
                        List<SelectListItem> IIntermediarios = new List<SelectListItem>();
                        IIntermediarios.Add(ItemNinguno);
                        IIntermediarios.AddRange(
                            new BLBanco().ListarAgencias_BancoIntermedios_toSelect()
                            .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID })
                            .ToList());
                        model.AgenciasBancoIntermedio = IIntermediarios;

                        // Tipos de cuentas de destino


                        // Código de Ruteo Intermedio
                        List<SelectListItem> IMetodosRuteo = new List<SelectListItem>();
                        IMetodosRuteo.Add(ItemNinguno);
                        IMetodosRuteo.AddRange(
                            new SelectList(
                                new BLParametro().ListarDetalle(Parametros.CodigoDeRuteo), "Valor", "Texto"));
                        model.CodigosRuteoIntermedio = IMetodosRuteo;

                        // Procesando el Id
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);

                        model.CuentaCorriente = new BLCuentaCorriente().Listar_byId(i_sid);
                        model.CID = sid;
                        
                        if (i_sid > 0) {
                            model.Auditoria = new BLAuditoria().Listar_byModuloyUser(ModulosAuditoria.CuentasBancarias, i_sid, model.CuentaCorriente.RowAudit.IUsr);
                        }
                        
                        return View(model);
                    }
                    else
                    {
                        AddToastMessage("Error", "No se ha especificado el ID del Órgano de Servicio.", BootstrapAlertType.danger);
                        return RedirectToAction("Listar", "OrganoServicio");
                    }
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }

        /// <summary>
        /// Obsoleto. Devuelve el detalle de una cuenta corriente sin los parámetros de plantilla de transferencia
        /// </summary>
        /// <param name="sid"></param>
        /// <returns></returns>
        public ActionResult DetalleSimple(string sid)
        {
            CuentaCteDetalleViewModel model = new CuentaCteDetalleViewModel();

            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (sid != string.Empty && sid != null)
                    {
                        ViewBag.Controller = strControlador;
                        ViewBag.Method = strMetodo;

                        // * Tab General *
                        // Organos de Servicio

                        SelectListItem NingunOSE = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };
                        List<SelectListItem> IOrganosServicio = new List<SelectListItem>();
                        IOrganosServicio.Add(NingunOSE);
                        IOrganosServicio.AddRange(new SelectList(
                            new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));
                        model.OrganosServicio = IOrganosServicio;


                        // Destino de la cuenta
                        model.DestinosCuenta = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.DestinoCuentaCorriente), "Valor", "Texto");

                        // Código de Ruteo
                        model.CodigosRuteo = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.CodigoDeRuteo), "Valor", "Texto");


                        // Procesando el Id
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);

                        model.CuentaCorriente = new BLCuentaCorriente().Listar_byId(i_sid);
                        model.CID = sid;

                        return View(model);
                    }
                    else
                    {
                        AddToastMessage("Error", "No se ha especificado el ID del Órgano de Servicio.", BootstrapAlertType.danger);
                        return RedirectToAction("Listar", "OrganoServicio");
                    }
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }

        /// <summary>
        /// Detalle de cuenta corriente para los organos de servicio exterior
        /// </summary>
        /// <param name="sid"></param>
        /// <returns></returns>
        public ActionResult DetalleCuenta(string sid)
        {
            CuentaCteDetalleViewModel model = new CuentaCteDetalleViewModel();

            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (sid != string.Empty && sid != null)
                    {
                        

                        ViewBag.Controller = strControlador;
                        ViewBag.Method = strMetodo;

                        #region Tab General
                        
                        // Organos de Servicio

                        SelectListItem NingunOSE = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };
                        List<SelectListItem> IOrganosServicio = new List<SelectListItem>();
                        IOrganosServicio.Add(NingunOSE);
                        IOrganosServicio.AddRange(new SelectList(
                            new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));
                        model.OrganosServicio = IOrganosServicio;


                        // Destino de la cuenta
                        model.DestinosCuenta = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.DestinoCuentaCorriente), "Valor", "Texto");

                        // Código de Ruteo
                        model.CodigosRuteo = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.CodigoDeRuteo), "Valor", "Texto");

                        #endregion

                        // Procesando el Id
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);

                        model.CuentaCorriente = new BLCuentaCorriente().Listar_byId(i_sid);
                        model.CID = sid;

                        return View(model);
                    }
                    else
                    {
                        AddToastMessage("Error", "No se ha especificado el ID del Órgano de Servicio.", BootstrapAlertType.danger);
                        return RedirectToAction("Listar", "OrganoServicio");
                    }
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }
            

        #region Llamadas Ajax


        #endregion


        /// <summary>
        /// Devuelve la lista de cuentas corrientes para el control datatable
        /// </summary>
        /// <param name="draw">Página</param>
        /// <param name="start">Fila inicial</param>
        /// <param name="length">Longitud</param>
        /// <returns>Json object</returns>
        [HttpGet]
        public ActionResult WvJRpzl5(int draw, int start, int length)
        {
            JsonDataTable dataTableData = new JsonDataTable();
            string search = string.Empty;
            int recordsFiltered = 0;
            int recordsTotal = 0;

            if (User != null)
            {
                int sortColumn = -1;
                string sortDirection = "asc";

                if (Request.QueryString["order[0][column]"] != null)
                {
                    sortColumn = int.Parse(Request.QueryString["order[0][column]"]);
                }

                if (Request.QueryString["order[0][dir]"] != null)
                {
                    sortDirection = Request.QueryString["order[0][dir]"];
                }

                var start_offset = start;
                if (start_offset != 0)
                {
                    start_offset = start / length;
                }

                if (Request.QueryString["search[value]"] != null)
                {
                    search = Request.QueryString["search[value]"].Trim();
                }

                int flt = 0;
                if (Request.QueryString["mose"] != null)
                {
                    var s_mose = Peach.DecriptFromBase64(Request.QueryString["mose"].Trim());
                    if (s_mose != string.Empty)
                    {
                        flt = Convert.ToInt16((s_mose));
                    }
                }

                dataTableData.draw = draw;
                dataTableData.data = new BLCuentaCorriente().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, flt, ref recordsTotal);
                recordsFiltered = dataTableData.data.Count();
                dataTableData.recordsTotal = recordsTotal;
                dataTableData.recordsFiltered = (search == string.Empty ? recordsTotal : recordsFiltered);

                return Json(dataTableData, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
        }


        /// <summary>
        /// Inserta o actualiza los datos de una cuenta corriente
        /// </summary>
        /// <param name="dat">Datos de la cuenta bancaria</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult NGZIbEEr(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {

                    var ose = dat[0];
                    var mnd = dat[1];
                    var bic = dat[2].Trim().ToUpper();
                    var rib = dat[3].Trim().ToUpper();

                    var abi = dat[4].Trim().ToUpper();
                    var ini = dat[5].Trim();
                    var doc = dat[6].Trim().ToUpper();

                    var cta = dat[7].Trim().ToUpper();
                    var des = dat[8];
                    var iba = dat[9].Trim().ToUpper();
                    var cbu = dat[10].Trim().ToUpper();
                    var cab = dat[11].Trim().ToUpper();
                    var fin = dat[12].Trim().ToUpper();
                    var fdo = dat[13].Trim();

                    var age = dat[14];
                    var rut = dat[15];
                    var aba = dat[16].Trim().ToUpper();
                    var bsb = dat[17].Trim().ToUpper();

                    var apo = dat[18];
                    var obs = dat[19].Trim().ToUpper();

                    var ben = dat[20].Trim().ToUpper();
                    var di1 = dat[21].Trim().ToUpper();
                    var di2 = dat[22].Trim().ToUpper();
                    var di3 = dat[23].Trim().ToUpper();

                    var ent = dat[24];
                    var ctp = dat[25];  // cta plantilla
                    var dep = dat[26];  // des plantilla
                    var agp = dat[27];  // age plantilla
                    var dap = dat[28].Trim().ToUpper();  // dat plantilla
                    var mru = dat[29];
                    var rup = dat[30].Trim().ToUpper();  // rut plantilla
                    var bep = dat[31];  // ben plantilla

                    var sid = dat[32];


                    if (ose == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el Órgano de Servicio";
                    }
                    else if (cta == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un número de cuenta";
                    }
                    else if (mnd == null)
                    {
                        globalResponse.ERR = "No ha seleccionado una moneda";
                    }
                    else if (age == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el banco / agencia";
                    }
                    else if (rut == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el código de ruteo";
                    }
                    else
                    {
                        int _Id = (sid != "0") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0;
                        int _ose = Convert.ToInt16(Peach.DecriptText(ose));
                        int _mnd = Convert.ToInt16(Peach.DecriptText(mnd));
                        int _age = Convert.ToInt16(Peach.DecriptText(age));
                        int _rut = Convert.ToInt16(Peach.DecriptText(rut));
                        int _des = Convert.ToInt16(Peach.DecriptText(des));

                        BETransferenciaPlantilla oPlantilla = new BETransferenciaPlantilla();
                        oPlantilla.Entidad = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(ent)) };
                        oPlantilla.CuentaOrigen = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(ctp)) };
                        oPlantilla.TipoDestino = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(dep)) };

                        oPlantilla.Agencia = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(agp)) };
                        oPlantilla.DatoAdicional = dap;

                        oPlantilla.MetodoRuteo = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(mru)) };
                        oPlantilla.CodigoRuteo = rup;
                        oPlantilla.EntidadSolicitante = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(bep)) };


                        BECuentaCorriente Cuenta = new BECuentaCorriente
                        {
                            Id = _Id,
                            OrganoServicio = new BEOrganoServicio
                            {
                                Id = _ose
                            },
                            NumeroCuenta = cta,
                            Moneda = new BEMoneda
                            {
                                Id = _mnd
                            },
                            Agencia = new BEAgenciaBancaria
                            {
                                Id = _age
                            },
                            CodigoRuteo = new ItemGenerico
                            {
                                IntValue = _rut
                            },
                            Iban = iba,
                            Swift = bic,
                            ABA = aba,

                            RIB = rib,
                            ABI = abi,
                            CBU = cbu,
                            CAB = cab,
                            BSB = bsb,

                            Destino = new ItemGenerico
                            {
                                IntValue = _des
                            },
                            FechaApertura = ini,
                            FechaCierre = fin,
                            Documento = new BEDocumento
                            {
                                Numero = doc,
                                Fecha = fdo
                            },
                            EsCompartida = new ItemGenerico
                            {
                                IntValue = 0
                            },
                            Apoderado = new ItemGenerico
                            {
                                IntValue = (apo == "0" || apo == null) ? 0 : Convert.ToInt16(Peach.DecriptText(apo))
                            },
                            Observacion = obs,

                            BeneficiarioNombre = ben,
                            BeneficiarioDir1 = di1,
                            BeneficiarioDir2 = di2,
                            BeneficiarioDir3 = di3,

                            Plantilla = oPlantilla,
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };


                        // Validación

                        if (User.Perfil_Nombre == "RINDENTE")
                        {
                            Cuenta.Situacion = new ItemGenerico { IntValue = (int) SitReg_Cuentas.PendienteDeAprobacion };
                        }
                        else
                        {
                            Cuenta.Situacion = new ItemGenerico { IntValue = (int) SitReg_Cuentas.RegistroAprobado };
                        }

                        oResponse = new BLCuentaCorriente().Grabar(Cuenta);
                        globalResponse.DATA = oResponse;

                    }
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Actualiza los datos de la cuenta bancaria
        /// </summary>
        /// <param name="dat">Datos de la cuenta bancaria</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult VUyNXUxV(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var mnd = dat[0];
                    var bic = dat[1].Trim().ToUpper();
                    var rib = dat[2].Trim().ToUpper();

                    var abi = dat[3].Trim().ToUpper();
                    var ini = dat[4].Trim();
                    var doc = dat[5].Trim().ToUpper();

                    var cta = dat[6].Trim().ToUpper();
                    var des = dat[7];
                    var iba = dat[8].Trim().ToUpper();
                    var cbu = dat[9].Trim().ToUpper();
                    var cab = dat[10].Trim().ToUpper();
                    var fin = dat[11].Trim().ToUpper();
                    var fdo = dat[12].Trim();

                    var age = dat[13];
                    var rut = dat[14];
                    var aba = dat[15].Trim().ToUpper();
                    var bsb = dat[16].Trim().ToUpper();

                    var apo = dat[17];
                    var obs = dat[18].Trim().ToUpper();

                    var ben = dat[19].Trim().ToUpper();
                    var di1 = dat[20].Trim().ToUpper();
                    var di2 = dat[21].Trim().ToUpper();
                    var di3 = dat[22].Trim().ToUpper();
                    var sid = dat[23];


                    if (cta == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un número de cuenta";
                    }
                    else if (mnd == null)
                    {
                        globalResponse.ERR = "No ha seleccionado una moneda";
                    }
                    else if (age == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el banco / agencia";
                    }
                    else if (rut == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el código de ruteo";
                    }
                    else
                    {
                        int _Id = Convert.ToInt16(Peach.DecriptFromBase64(sid));
                        int _mnd = Convert.ToInt16(Peach.DecriptText(mnd));
                        int _age = Convert.ToInt16(Peach.DecriptText(age));
                        int _rut = Convert.ToInt16(Peach.DecriptText(rut));
                        int _des = Convert.ToInt16(Peach.DecriptText(des));

                        BETransferenciaPlantilla oPlantilla = new BETransferenciaPlantilla();

                        BECuentaCorriente Cuenta = new BECuentaCorriente
                        {
                            Id = _Id,
                            NumeroCuenta = cta,
                            Moneda = new BEMoneda
                            {
                                Id = _mnd
                            },
                            Agencia = new BEAgenciaBancaria
                            {
                                Id = _age
                            },
                            CodigoRuteo = new ItemGenerico
                            {
                                IntValue = _rut
                            },
                            Iban = iba,
                            Swift = bic,
                            ABA = aba,

                            RIB = rib,
                            ABI = abi,
                            CBU = cbu,
                            CAB = cab,
                            BSB = bsb,

                            Destino = new ItemGenerico
                            {
                                IntValue = _des
                            },
                            FechaApertura = ini,
                            FechaCierre = fin,
                            Documento = new BEDocumento
                            {
                                Numero = doc,
                                Fecha = fdo
                            },
                            EsCompartida = new ItemGenerico
                            {
                                IntValue = 0
                            },
                            Apoderado = new ItemGenerico
                            {
                                IntValue = (apo == "0" || apo == null) ? 0 : Convert.ToInt16(Peach.DecriptText(apo))
                            },
                            Observacion = obs,

                            BeneficiarioNombre = ben,
                            BeneficiarioDir1 = di1,
                            BeneficiarioDir2 = di2,
                            BeneficiarioDir3 = di3,

                            Plantilla = oPlantilla,
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };

                        // Validación
                        if (User.Perfil_Nombre == "RINDENTE")
                        {
                            Cuenta.Situacion = new ItemGenerico { IntValue = (int)SitReg_Cuentas.PendienteDeAprobacion };
                        }
                        else
                        {
                            Cuenta.Situacion = new ItemGenerico { IntValue = (int)SitReg_Cuentas.RegistroAprobado };
                        }

                        oResponse = new BLCuentaCorriente().GrabarObservacion(Cuenta);
                        globalResponse.DATA = oResponse;

                    }
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }


        #region Servicios Complementarios Ajax 

        /// <summary>
        /// Devuelve las monedas asociadas al país del órgano de servicio
        /// </summary>
        /// <param name="sid">sid del órgano de servicio</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult TU1sdEZJ(string sid)
        {
            /*
            Obs:    Se convierte en IEnumerable<SelectListItem> para factorizar las funciones javascript "fillxxx "
                    en documento que lo invoca
            */
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    if (sid != null)
                    {
                        int id = Convert.ToInt16(Peach.DecriptText(sid));
                        IEnumerable<SelectListItem> monedas = new BLMoneda().Listar_Select_byOSE(id)
                            .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID });

                        globalResponse.DATA = monedas;
                    }
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Devuelve las agencias bancarias asociadas al país del órgano de servicio
        /// </summary>
        /// <param name="sid">sid del órgano de servicio</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult NVdqVjlt(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    if (sid != null)
                    {
                        int id = Convert.ToInt16(Peach.DecriptText(sid));
                        IEnumerable<SelectListItem> agencias = new BLBanco().ListarAgencia_ToSelect_ByOse(id)
                            .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID });

                        globalResponse.DATA = agencias;
                    }
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Devuelve el personal directivo de un organo de servicio (diplomatico/planilla lima)
        /// </summary>
        /// <param name="sid">sid del órgano de servicio</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult OvEIqYav(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    if (sid != null)
                    {
                        int id = Convert.ToInt16(Peach.DecriptText(sid));
                        IEnumerable<SelectListItem> personas = new BLPersonalLocal().Listar_Directivo_toSelect_byOse(id)
                            .Select(q => new SelectListItem { Text = q.Apellidos, Value = q.CID });

                        globalResponse.DATA = personas;
                    }
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }


        #endregion


        /// <summary>
        /// Método de exportación a excel
        /// </summary>
        /// <returns></returns>
        public FileContentResult dklHc0hk()
        {
            string TituloWorksheet = "Cuentas Corrientes de Órganos de Servicio Exterior";
            string NombreFileExcel = "CuentasCorrientes.xlsx";
            string[] columns = { "OrganoServicio", "NumeroCuenta", "Moneda", "BancoAgencia", "SwiftBIC", "IBAN", "ABA", "RIB", "CBU", "BSB", "ABI", "CAB", "DestinoCuenta", "FechaApertura", "FechaCierre", "Autorizacion", "FechaAut", "Apoderado", "Beneficiario", "Domicilio1", "Domicilio2", "Domicilio3", "TransferenciaCtaOrigen", "TransferenciaTpDestino", "TransferenciaBancoInt", "TransferenciaRuteoInt", "Observaciones" };

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    try
                    {
                        List<RPCuentasCorrientes> Cuentas = new BLCuentaCorriente().ExportarCuentas().ToList();
                        if (Cuentas.Count > 0)
                        {
                            byte[] filecontent = ExcelExportHelper.ExportExcel(
                                Cuentas, TituloWorksheet,
                                String.Format("Exportado por {0} el {1} a las {2}.", User.Usuario, DateTime.Now.ToShortDateString(), DateTime.Now.ToShortTimeString()),
                                true,
                                columns);

                            return File(filecontent, ExcelExportHelper.ExcelContentType, NombreFileExcel);
                        }
                        else
                        {
                            return File(Encoding.UTF8.GetBytes("No hay datos"), "text/plain", string.Format("Reporte.txt"));
                        }
                    }
                    catch (Exception ex)
                    {
                        return File(Encoding.UTF8.GetBytes(ex.Message), "text/plain", string.Format("Error.txt"));
                    }
                }
                else
                {
                    return File(Encoding.UTF8.GetBytes("Ups! No tienes permisos. ;( sorry."), "text/plain", string.Format("Reporte.txt"));
                }
            }
            else
            {
                return File(Encoding.UTF8.GetBytes("Ups! No estas logueado. =( sorry."), "text/plain", string.Format("Reporte.txt"));
            }
        }

        /// <summary>
        /// Exportacion de datos : usuario de servicio exterior
        /// </summary>
        /// <returns></returns>
        public FileContentResult PLus9XJE()
        {
            string TituloWorksheet = "Cuentas Corrientes";
            string NombreFileExcel = "CuentasCorrientes.xlsx";
            //string[] columns = { "OrganoServicio", "NumeroCuenta", "Moneda", "BancoAgencia", "SwiftBIC", "IBAN", "ABA", "RIB", "CBU", "BSB", "ABI", "CAB", "DestinoCuenta", "FechaApertura", "FechaCierre", "Autorizacion", "FechaAut", "Apoderado", "Beneficiario", "Domicilio1", "Domicilio2", "Domicilio3", "TransferenciaCtaOrigen", "TransferenciaTpDestino", "TransferenciaBancoInt", "TransferenciaRuteoInt", "Observaciones" };
            string[] columns = { "OrganoServicio", "NumeroCuenta", "Moneda", "BancoAgencia", "SwiftBIC", "IBAN", "ABA", "RIB", "CBU", "BSB", "ABI", "CAB", "DestinoCuenta", "FechaApertura", "FechaCierre", "Autorizacion", "FechaAut", "Apoderado", "Beneficiario", "Domicilio1", "Domicilio2", "Domicilio3", "Observaciones" };

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    try
                    {
                        int OrganoServicio = Convert.ToInt16(Peach.DecriptText(User.OrganoServicio_CID));

                        List<RPCuentasCorrientes> Cuentas = new BLCuentaCorriente().ExportarCuentas(OrganoServicio).ToList();
                        if (Cuentas.Count > 0)
                        {
                            byte[] filecontent = ExcelExportHelper.ExportExcel(
                                Cuentas, TituloWorksheet,
                                String.Format("Exportado por {0} el {1} a las {2}.", User.Usuario, DateTime.Now.ToShortDateString(), DateTime.Now.ToShortTimeString()),
                                true,
                                columns);

                            return File(filecontent, ExcelExportHelper.ExcelContentType, NombreFileExcel);
                        }
                        else
                        {
                            return File(Encoding.UTF8.GetBytes("No hay datos"), "text/plain", string.Format("Reporte.txt"));
                        }
                    }
                    catch (Exception ex)
                    {
                        return File(Encoding.UTF8.GetBytes(ex.Message), "text/plain", string.Format("Error.txt"));
                    }
                }
                else
                {
                    return File(Encoding.UTF8.GetBytes("Lo sentimos, no tiene permisos para exportar el reporte."), "text/plain", string.Format("Reporte.txt"));
                }
            }
            else
            {
                return File(Encoding.UTF8.GetBytes("Error. No ha ingresado correctamente a la aplicación."), "text/plain", string.Format("Reporte.txt"));
            }
        }
    }
}