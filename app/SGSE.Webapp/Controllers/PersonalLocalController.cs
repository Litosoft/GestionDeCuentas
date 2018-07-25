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
using SGSE.Webapp.Models.PersonalLocal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    /// <summary>
    /// controlador de Personal Local
    /// </summary>
    public class PersonalLocalController : BaseController
    {

        #region Vista Admnistrador Lima

       
        /// <summary>
        /// Módulo de administración en Lima. Pagina inicial del personal local, sólo devuelve la vista en blanco
        /// </summary>
        /// <returns></returns>
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
        /// Detalle del Personal Local seleccionado (Administrador)
        /// </summary>
        /// <param name="sid"></param>
        /// <returns></returns>
        public ActionResult Detalle(string sid)
        {
            var oBlParametro = new BLParametro();
            PersonalLocalDetalleViewModel model = new PersonalLocalDetalleViewModel();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (sid != string.Empty && sid != null)
                    {
                        // Procesando el ID-Base64
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);


                        List<SelectListItem> ItemsOrganosServicio = new List<SelectListItem>();
                        ItemsOrganosServicio.AddRange(new SelectList(
                            new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));

                        List<SelectListItem> ItemsNacionalidad = new List<SelectListItem>();
                        ItemsNacionalidad.AddRange(new BLPais().Listar()
                            .Select(p => new SelectListItem { Value = p.CID, Text = p.Gentilicio })
                            .ToList());

                        List<SelectListItem> ItemsGenero = new List<SelectListItem>();
                        ItemsGenero.AddRange(oBlParametro.ListarItems_byGrupo("IDENTIDAD_GENERO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsTipoDocumento = new List<SelectListItem>();
                        ItemsTipoDocumento.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_DOCUMENTO_IDENTIDAD")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsEstadoCivil = new List<SelectListItem>();
                        ItemsEstadoCivil.AddRange(oBlParametro.ListarItems_byGrupo("ESTADO_CIVIL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsGrado = new List<SelectListItem>();
                        ItemsGrado.AddRange(oBlParametro.ListarItems_byGrupo("GRADO_PROFESIONAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsTipoPersonal = new List<SelectListItem>();
                        ItemsTipoPersonal.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_PERSONAL_OSE")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        

                        List<SelectListItem> ItemsSituacionLaboral = new List<SelectListItem>();
                        ItemsSituacionLaboral.AddRange(oBlParametro.ListarItems_byGrupo("SITUACION_LABORAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsEspecialidad = new List<SelectListItem>();
                        ItemsEspecialidad.AddRange(oBlParametro.ListarItems_byGrupo("ESPECIALIDAD_ESTUDIOS")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());


                        ViewBag.OrganosServicio = ItemsOrganosServicio;
                        ViewBag.Genero = ItemsGenero;
                        ViewBag.TipoDocumento = ItemsTipoDocumento;
                        ViewBag.EstadoCivil = ItemsEstadoCivil;
                        ViewBag.Grado = ItemsGrado;
                        ViewBag.TipoPersonal = ItemsTipoPersonal;

                        ViewBag.Nacionalidad = ItemsNacionalidad;
                        ViewBag.SituacionLaboral = ItemsSituacionLaboral;
                        ViewBag.Especialidad = ItemsEspecialidad;

                        #region Contratos

                        List<SelectListItem> ItemsTipoDocContrato = new List<SelectListItem>();
                        ItemsTipoDocContrato.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_DOCUMENTO_CONTRATO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsCargo = new List<SelectListItem>();
                        ItemsCargo.AddRange(oBlParametro.ListarItems_byGrupo("CARGO_LABORAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsMoneda = new List<SelectListItem>();
                        ItemsMoneda.AddRange(new BLMoneda().Listar_Select_byPL(i_sid)
                            .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID })
                            .OrderBy(q => q.Text)
                            .ToList());

                        List<SelectListItem> ItemsTipoContrato = new List<SelectListItem>();
                        ItemsTipoContrato.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_CONTRATO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsModalidadContrato = new List<SelectListItem>();
                        ItemsModalidadContrato.AddRange(oBlParametro.ListarItems_byGrupo("MODALIDAD_CONTRATO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());


                        ViewBag.DocumentosContrato = ItemsTipoDocContrato;
                        ViewBag.Cargos = ItemsCargo;
                        ViewBag.Monedas = ItemsMoneda;
                        ViewBag.TiposContrato = ItemsTipoContrato;
                        ViewBag.Modalidad = ItemsModalidadContrato;

                        #endregion

                        // Procesando el Id
                        
                        model.PersonalLocal = new BLPersonalLocal().Listar_byID(i_sid);

                        if (i_sid > 0)
                        {
                            model.Auditoria = new BLAuditoria().Listar_byModuloyUser(ModulosAuditoria.PersonalLocal, i_sid, model.PersonalLocal.RowAudit.IUsr);
                        }

                        //model.Aportes = new BLPersonalLocal().Listar_AportesDescuentos(1);
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

        [HttpPost]
        public ActionResult PD_Contrato(string pm)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            try
            {
                var Sid = System.Web.HttpContext.Current.Request["SID"];
                Sid = Peach.DecriptFromBase64(Sid);

                var TipoDoc = System.Web.HttpContext.Current.Request["TipDoc"];
                TipoDoc = Peach.DecriptText(TipoDoc);

                string NumeroDoc = System.Web.HttpContext.Current.Request["NumDoc"];
                NumeroDoc = NumeroDoc.Trim().ToUpper();

                var FechaInicio = System.Web.HttpContext.Current.Request["FecIni"];
                var FechaTermino = System.Web.HttpContext.Current.Request["FecFin"];

                var Indefinido = System.Web.HttpContext.Current.Request["PerInd"];

                var Cargo = System.Web.HttpContext.Current.Request["CarLab"];
                Cargo = Peach.DecriptText(Cargo);

                var Funciones = System.Web.HttpContext.Current.Request["DesFun"];
                Funciones = Funciones.ToUpper();

                var Sueldo = System.Web.HttpContext.Current.Request["SueBru"];

                var Moneda = System.Web.HttpContext.Current.Request["Moneda"];
                Moneda = Peach.DecriptText(Moneda);

                var TipoContrato = System.Web.HttpContext.Current.Request["TipCon"];
                TipoContrato = Peach.DecriptText(TipoContrato);

                var Modalidad = System.Web.HttpContext.Current.Request["ModLab"];
                Modalidad = Peach.DecriptText(Modalidad);

                var InicioFunciones = System.Web.HttpContext.Current.Request["IniFun"];

                var MensajeAutorizacion = System.Web.HttpContext.Current.Request["MsgAut"];
                MensajeAutorizacion = MensajeAutorizacion.ToUpper();

                var Observacion = System.Web.HttpContext.Current.Request["ObsGrl"];
                Observacion = Observacion.ToUpper();

                var httppostedfile = System.Web.HttpContext.Current.Request.Files["File"];

                oResponse.Estado = new ResponserEstado();
                oResponse.Estado = ResponserEstado.Ok;

                globalResponse.DATA = httppostedfile.FileName;
            }
            catch(Exception ex)
            {
                globalResponse.ERR = ex.Message;
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }
             

        
        #endregion


        #region Vista Usuario OSE

        // Lista PersonalLocal : Usuarios OSE
        public ActionResult Personal()
        {
            if (User.CID != null)
            {
                if (this.IsPermitido())
                {
                    // Obtiene la misión del usuario
                    var osesid = Peach.DecriptText(User.OrganoServicio_CID);
                    ViewBag.OSESID = Peach.EncriptToBase64(osesid);
                    ViewBag.OSE = User.OrganoServicio_Abr;

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



        // Detalle del personal del Organo de servicio : Usuario OSE
        public ActionResult DetallePersonal(string sid)
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();
            var oBlParametro = new BLParametro();
            PersonalLocalDetalleViewModel model = new PersonalLocalDetalleViewModel();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    if (sid != string.Empty && sid != null)
                    {
                        short IdOSE = Convert.ToInt16(Peach.DecriptText(User.OrganoServicio_CID));

                        List<SelectListItem> ItemsNacionalidad = new List<SelectListItem>();
                        ItemsNacionalidad.AddRange(new BLPais().Listar()
                            .Select(p => new SelectListItem { Value = p.CID, Text = p.Gentilicio })
                            .ToList());

                        List<SelectListItem> ItemsMoneda = new List<SelectListItem>();
                        ItemsMoneda.AddRange(new BLMoneda().Listar_Select_byOSE(IdOSE)
                            .Select(p => new SelectListItem { Text = p.Nombre + " (" + p.ISO4217 + ')', Value = p.CID })
                            .OrderBy(q => q.Text)
                            .ToList());

                        List<SelectListItem> ItemsGenero = new List<SelectListItem>();
                        ItemsGenero.AddRange(oBlParametro.ListarItems_byGrupo("IDENTIDAD_GENERO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsTipoDocumento = new List<SelectListItem>();
                        ItemsTipoDocumento.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_DOCUMENTO_IDENTIDAD")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsEstadoCivil = new List<SelectListItem>();
                        ItemsEstadoCivil.AddRange(oBlParametro.ListarItems_byGrupo("ESTADO_CIVIL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsGrado = new List<SelectListItem>();
                        ItemsGrado.AddRange(oBlParametro.ListarItems_byGrupo("GRADO_PROFESIONAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsTipoPersonal = new List<SelectListItem>();
                        ItemsTipoPersonal.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_PERSONAL_OSE")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsCargo = new List<SelectListItem>();
                        ItemsCargo.AddRange(oBlParametro.ListarItems_byGrupo("CARGO_LABORAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsTipoContrato = new List<SelectListItem>();
                        ItemsTipoContrato.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_CONTRATO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsSituacionLaboral = new List<SelectListItem>();
                        ItemsSituacionLaboral.AddRange(oBlParametro.ListarItems_byGrupo("SITUACION_LABORAL")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        List<SelectListItem> ItemsEspecialidad = new List<SelectListItem>();
                        ItemsEspecialidad.AddRange(oBlParametro.ListarItems_byGrupo("ESPECIALIDAD_ESTUDIOS")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());

                        ViewBag.Genero = ItemsGenero;
                        ViewBag.TipoDocumento = ItemsTipoDocumento;
                        ViewBag.EstadoCivil = ItemsEstadoCivil;
                        ViewBag.Grado = ItemsGrado;
                        ViewBag.TipoPersonal = ItemsTipoPersonal;

                        ViewBag.Cargos = ItemsCargo;
                        ViewBag.TiposContrato = ItemsTipoContrato;
                        ViewBag.Monedas = ItemsMoneda;
                        ViewBag.Nacionalidad = ItemsNacionalidad;
                        ViewBag.SituacionLaboral = ItemsSituacionLaboral;

                        ViewBag.Especialidad = ItemsEspecialidad;

                        // Contratos
                        List<SelectListItem> ItemsTipoDocContrato = new List<SelectListItem>();
                        ItemsTipoDocContrato.AddRange(oBlParametro.ListarItems_byGrupo("TIPO_DOC_CONTRATO")
                            .Select(p => new SelectListItem { Text = p.Texto, Value = p.Valor }).ToList());
                        ViewBag.TipoDocumentoContrato = ItemsTipoDocContrato;


                        // Procesando el Id
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);
                        model.PersonalLocal = new BLPersonalLocal().Listar_byID(i_sid);

                        if (i_sid > 0)
                        {
                            model.Auditoria = new BLAuditoria().Listar_byModuloyUser(ModulosAuditoria.PersonalLocal, i_sid, model.PersonalLocal.RowAudit.IUsr);
                            model.Contratos = new BLPersonalLocal().ListarContratos(i_sid);
                        }

                        //model.Aportes = new BLPersonalLocal().Listar_AportesDescuentos(1);
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


        #endregion


        #region Metodos Ajax

        /// <summary>
        /// Devuelve la lista de personal local para el control datatable
        /// </summary>
        /// <param name="draw">Página</param>
        /// <param name="start">Fila inicial</param>
        /// <param name="length">Longitud</param>
        /// <returns>Json object</returns>
        [HttpGet]
        [Authorize]
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
                        flt = Convert.ToInt16(s_mose);
                    }
                }

                dataTableData.draw = draw;
                if (flt == 0)
                {   //: Administrador
                    dataTableData.data = new BLPersonalLocal().Listar_byAdm_ToDT(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
                }
                else
                {
                    //: Usuario OSE
                    dataTableData.data = new BLPersonalLocal().Listar_byOSE_ToDT(start_offset, length, search, sortColumn, sortDirection, flt, ref recordsTotal);
                }
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
        /// Inserta o actualiza los datos del personal local (Pendiente de Evaluacion)
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
                    var ape = dat[1].Trim().ToUpper();
                    var nom = dat[2].Trim().ToUpper();
                    var nac = dat[3];
                    var gen = dat[4];
                    var dis = dat[5];
                    var pai = dat[6];
                    var doc = dat[7];
                    var num = dat[8].Trim();
                    var mai = dat[9].Trim().ToUpper();
                    var civ = dat[10];
                    var gra = dat[11];
                    var esp = dat[12];
                    var tpe = dat[13];
                    var sla = dat[14];
                    var obs = dat[15].Trim().ToUpper();
                    var sid = dat[16];

                    if (ose == null)
                    {
                        globalResponse.ERR = "No seleccionó el Órgano de Servicio";
                    }
                    else if (ape == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el apellido";
                    }
                    else if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el nombre";
                    }
                    else if (gen == null)
                    {
                        globalResponse.ERR = "No seleccionó el género";
                    }
                    else if (dis == null)
                    {
                        globalResponse.ERR = "No seleccionó el indicador de discapacidad";
                    }
                    else if (nac == null)
                    {
                        globalResponse.ERR = "No ingreso la fecha de nacimiento";
                    }
                    else if (pai == null)
                    {
                        globalResponse.ERR = "No seleccionó la nacionalidad";
                    }
                    else if (civ == null)
                    {
                        globalResponse.ERR = "No seleccionó el estado civil";
                    }
                    else if (gra == null)
                    {
                        globalResponse.ERR = "No seleccionó el grado académico";
                    }
                    else if (esp == null)
                    {
                        globalResponse.ERR = "No seleccionó la especialidad";
                    }
                    else if (tpe == null)
                    {
                        globalResponse.ERR = "No seleccionó el tipo de personal";
                    }
                    else if (sla == null)
                    {
                        globalResponse.ERR = "No seleccionó la situación laboral";
                    }
                    // Customs
                    else if (DateTime.Parse(nac) > DateTime.Now)
                    {
                        globalResponse.ERR = "La fecha de nacimiento no puede ser mayor a la actual.";
                    }
                    else if (DateTime.Today.Year - DateTime.Parse(nac).Year < 18)
                    {
                        globalResponse.ERR = "El personal local no puede ser menor de edad.";
                    }
                    else
                    {
                        int _doc = 0;
                        int _Id = (sid != "") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0;

                        int _ose = Convert.ToInt16(Peach.DecriptText(ose));
                        int _gen = Convert.ToInt16(Peach.DecriptText(gen));
                        int _pai = Convert.ToInt16(Peach.DecriptText(pai));
                        if (doc != null)
                        {
                            _doc = Convert.ToInt16(Peach.DecriptText(doc));
                        }
                        int _civ = Convert.ToInt16(Peach.DecriptText(civ));
                        int _gra = Convert.ToInt16(Peach.DecriptText(gra));
                        int _esp = Convert.ToInt16(Peach.DecriptText(esp));
                        int _tpe = Convert.ToInt16(Peach.DecriptText(tpe));
                        int _sla = Convert.ToInt16(Peach.DecriptText(sla));

                        BEPersonalLocal Personal = new BEPersonalLocal();
                        Personal.Id = _Id;
                        Personal.OrganoServicio = new ItemGenerico { IntValue = _ose };

                        Personal.Apellidos = ape;
                        Personal.Nombres = nom;
                        Personal.Email = mai;
                        Personal.FechaNacimiento = nac;

                        Personal.Genero = new ItemGenerico { IntValue = _gen };
                        Personal.Discapacidad = new ItemGenerico { IntValue = Convert.ToInt16(dis) };
                        Personal.Nacionalidad = new ItemGenerico { IntValue = _pai };

                        Personal.TipoDocumento = new ItemGenerico { IntValue = _doc };
                        Personal.NumeroDocumento = num;
                        Personal.Email = mai;

                        Personal.EstadoCivil = new ItemGenerico { IntValue = _civ };
                        Personal.GradoProfesional = new ItemGenerico { IntValue = _gra };
                        Personal.Especialidad = new ItemGenerico { IntValue = _esp };
                        Personal.TipoPersonal = new ItemGenerico { IntValue = _tpe };
                        Personal.SituacionLaboral = new ItemGenerico { IntValue = _sla };
                        Personal.Observacion = obs;

                        Personal.RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };
                        
                        Personal.Situacion = new ItemGenerico { IntValue = (int) SitReg_Personal.PendienteDeAprobacion };

                        oResponse = new BLPersonalLocal().Grabar(Personal);
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
        /// Inserta o actualiza los datos del personal local (Administrador - Aprobación)
        /// </summary>
        /// <param name="dat">Datos de la cuenta bancaria</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult qNv6NGjJ(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var ose = dat[0];
                    var ape = dat[1].Trim().ToUpper();
                    var nom = dat[2].Trim().ToUpper();
                    var nac = dat[3];
                    var gen = dat[4];
                    var dis = dat[5];
                    var pai = dat[6];
                    var doc = dat[7];
                    var num = dat[8].Trim();
                    var mai = dat[9].Trim().ToUpper();
                    var civ = dat[10];
                    var gra = dat[11];
                    var esp = dat[12];
                    var tpe = dat[13];
                    var sla = dat[14];
                    var obs = dat[15].Trim().ToUpper();
                    var sid = dat[16];

                    if (ose == null)
                    {
                        globalResponse.ERR = "No seleccionó el Órgano de Servicio";
                    }
                    else if (ape == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el apellido";
                    }
                    else if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el nombre";
                    }
                    else if (gen == null)
                    {
                        globalResponse.ERR = "No seleccionó el género";
                    }
                    else if (dis == null)
                    {
                        globalResponse.ERR = "No seleccionó el indicador de discapacidad";
                    }
                    else if (nac == null)
                    {
                        globalResponse.ERR = "No ingreso la fecha de nacimiento";
                    }
                    else if (pai == null)
                    {
                        globalResponse.ERR = "No seleccionó la nacionalidad";
                    }
                    else if (civ == null)
                    {
                        globalResponse.ERR = "No seleccionó el estado civil";
                    }
                    else if (gra == null)
                    {
                        globalResponse.ERR = "No seleccionó el grado académico";
                    }
                    else if (esp == null)
                    {
                        globalResponse.ERR = "No seleccionó la especialidad";
                    }
                    else if (tpe == null)
                    {
                        globalResponse.ERR = "No seleccionó el tipo de personal";
                    }
                    else if (sla == null)
                    {
                        globalResponse.ERR = "No seleccionó la situación laboral";
                    }
                    // Customs
                    else if (DateTime.Parse(nac) > DateTime.Now)
                    {
                        globalResponse.ERR = "La fecha de nacimiento no puede ser mayor a la actual.";
                    }
                    else if (DateTime.Today.Year - DateTime.Parse(nac).Year < 18)
                    {
                        globalResponse.ERR = "El personal local no puede ser menor de edad.";
                    }
                    else
                    {
                        int _doc = 0;
                        int _Id = (sid != "") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0;

                        int _ose = Convert.ToInt16(Peach.DecriptText(ose));
                        int _gen = Convert.ToInt16(Peach.DecriptText(gen));
                        int _pai = Convert.ToInt16(Peach.DecriptText(pai));
                        if (doc != null)
                        {
                            _doc = Convert.ToInt16(Peach.DecriptText(doc));
                        }
                        int _civ = Convert.ToInt16(Peach.DecriptText(civ));
                        int _gra = Convert.ToInt16(Peach.DecriptText(gra));
                        int _esp = Convert.ToInt16(Peach.DecriptText(esp));
                        int _tpe = Convert.ToInt16(Peach.DecriptText(tpe));
                        int _sla = Convert.ToInt16(Peach.DecriptText(sla));

                        BEPersonalLocal Personal = new BEPersonalLocal();
                        Personal.Id = _Id;
                        Personal.OrganoServicio = new ItemGenerico { IntValue = _ose };

                        Personal.Apellidos = ape;
                        Personal.Nombres = nom;
                        Personal.Email = mai;
                        Personal.FechaNacimiento = nac;

                        Personal.Genero = new ItemGenerico { IntValue = _gen };
                        Personal.Discapacidad = new ItemGenerico { IntValue = Convert.ToInt16(dis) };
                        Personal.Nacionalidad = new ItemGenerico { IntValue = _pai };

                        Personal.TipoDocumento = new ItemGenerico { IntValue = _doc };
                        Personal.NumeroDocumento = num;
                        Personal.Email = mai;

                        Personal.EstadoCivil = new ItemGenerico { IntValue = _civ };
                        Personal.GradoProfesional = new ItemGenerico { IntValue = _gra };
                        Personal.Especialidad = new ItemGenerico { IntValue = _esp };
                        Personal.TipoPersonal = new ItemGenerico { IntValue = _tpe };
                        Personal.SituacionLaboral = new ItemGenerico { IntValue = _sla };
                        Personal.Observacion = obs;

                        Personal.RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };

                        Personal.Situacion = new ItemGenerico { IntValue = (int)SitReg_Personal.RegistroAprobado };

                        oResponse = new BLPersonalLocal().Grabar(Personal);
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
        /// Inserta o actualiza los datos del personal local: (Rindente - Pendiente de Evaluacion)
        /// </summary>
        /// <param name="dat">Datos de la cuenta bancaria</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult Sp5AU25u(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var ape = dat[0].Trim().ToUpper();
                    var nom = dat[1].Trim().ToUpper();
                    var nac = dat[2];
                    var gen = dat[3];
                    var dis = dat[4];
                    var pai = dat[5];
                    var doc = dat[6];
                    var num = dat[7].Trim();
                    var mai = dat[8].Trim().ToUpper();
                    var civ = dat[9];
                    var gra = dat[10];
                    var esp = dat[11];
                    var tpe = dat[12];
                    var sla = dat[13];
                    var obs = dat[14].Trim().ToUpper();
                    var sid = dat[15];

                    if (ape == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el apellido";
                    }
                    else if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el nombre";
                    }
                    else if (gen == null)
                    {
                        globalResponse.ERR = "No seleccionó el género";
                    }
                    else if (dis == null)
                    {
                        globalResponse.ERR = "No seleccionó el indicador de discapacidad";
                    }
                    else if (nac == null)
                    {
                        globalResponse.ERR = "No ingreso la fecha de nacimiento";
                    }
                    else if (pai == null)
                    {
                        globalResponse.ERR = "No seleccionó la nacionalidad";
                    }
                    else if (civ == null)
                    {
                        globalResponse.ERR = "No seleccionó el estado civil";
                    }
                    else if (gra == null)
                    {
                        globalResponse.ERR = "No seleccionó el grado académico";
                    }
                    else if (esp == null)
                    {
                        globalResponse.ERR = "No seleccionó la especialidad";
                    }
                    else if (tpe == null)
                    {
                        globalResponse.ERR = "No seleccionó el tipo de personal";
                    }
                    else if (sla == null)
                    {
                        globalResponse.ERR = "No seleccionó la situación laboral";
                    }
                    // Customs
                    else if (DateTime.Parse(nac) > DateTime.Now)
                    {
                        globalResponse.ERR = "La fecha de nacimiento no puede ser mayor a la actual.";
                    }
                    else if (DateTime.Today.Year - DateTime.Parse(nac).Year < 18)
                    {
                        globalResponse.ERR = "El personal local no puede ser menor de edad.";
                    }
                    else
                    {
                        int _doc = 0;
                        int _Id = (sid != "") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0;
                        
                        var ose = User.OrganoServicio_CID;

                        int _ose = Convert.ToInt16(Peach.DecriptText(ose));
                        int _gen = Convert.ToInt16(Peach.DecriptText(gen));
                        int _pai = Convert.ToInt16(Peach.DecriptText(pai));
                        if (doc != null)
                        {
                            _doc = Convert.ToInt16(Peach.DecriptText(doc));
                        }
                        int _civ = Convert.ToInt16(Peach.DecriptText(civ));
                        int _gra = Convert.ToInt16(Peach.DecriptText(gra));
                        int _esp = Convert.ToInt16(Peach.DecriptText(esp));
                        int _tpe = Convert.ToInt16(Peach.DecriptText(tpe));
                        int _sla = Convert.ToInt16(Peach.DecriptText(sla));

                        BEPersonalLocal Personal = new BEPersonalLocal();
                        Personal.Id = _Id;
                        Personal.OrganoServicio = new ItemGenerico { IntValue = _ose };

                        Personal.Apellidos = ape;
                        Personal.Nombres = nom;
                        Personal.Email = mai;
                        Personal.FechaNacimiento = nac;

                        Personal.Genero = new ItemGenerico { IntValue = _gen };
                        Personal.Discapacidad = new ItemGenerico { IntValue = Convert.ToInt16(dis) };
                        Personal.Nacionalidad = new ItemGenerico { IntValue = _pai };

                        Personal.TipoDocumento = new ItemGenerico { IntValue = _doc };
                        Personal.NumeroDocumento = num;
                        Personal.Email = mai;

                        Personal.EstadoCivil = new ItemGenerico { IntValue = _civ };
                        Personal.GradoProfesional = new ItemGenerico { IntValue = _gra };
                        Personal.Especialidad = new ItemGenerico { IntValue = _esp };
                        Personal.TipoPersonal = new ItemGenerico { IntValue = _tpe };
                        Personal.SituacionLaboral = new ItemGenerico { IntValue = _sla };
                        Personal.Observacion = obs;

                        Personal.RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };

                        // Validación
                        if (User.Perfil_Nombre == "RINDENTE")
                        {
                            Personal.Situacion = new ItemGenerico { IntValue = 8 };
                        }
                        else
                        {
                            Personal.Situacion = new ItemGenerico { IntValue = 1 };
                        }

                        oResponse = new BLPersonalLocal().Grabar(Personal);
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


        // Contratos


        // Inserta o actualiza los datos de contratos del personal local
        public ActionResult gO0MJEFp(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var tip = dat[0];
                    var num = dat[1].Trim().ToUpper();
                    var ini = dat[2].Trim();
                    var car = dat[3];
                    var dau = dat[4].Trim().ToUpper();

                    var rej = dat[5].Trim();
                    var fco = dat[6];
                    var fte = dat[7];
                    var rem = dat[8].Trim();
                    var fau = dat[9];

                    var tco = dat[10];
                    var ind = dat[11];
                    var mon = dat[12];
                    var fif = dat[13];

                    var obs = dat[14].Trim().ToUpper();
                    var sid = dat[15];

                    if (tip == null)
                    {
                        globalResponse.ERR = "No seleccionó el Tipo de documento";
                    }
                    else if (num == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó el número de documento ";
                    }
                    else if (ini == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó la fecha de inicio";
                    }
                    else if (car == null)
                    {
                        globalResponse.ERR = "No seleccionó el cargo";
                    }
                    else if (dau == string.Empty)
                    {
                        globalResponse.ERR = "No ingreso el documento de autorización";
                    }
                    else if (fco == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó la fecha del contrato";
                    }
                    else if (rem == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó la remuneración bruta";
                    }
                    else if (fau == string.Empty)
                    {
                        globalResponse.ERR = "No ingresó la fecha de autorización";
                    }
                    else if (tco == null)
                    {
                        globalResponse.ERR = "No seleccionó el tipo de contrato";
                    }
                    else if (ind == null)
                    {
                        globalResponse.ERR = "No indico si es periodo indefinido";
                    }
                    else if (mon == null)
                    {
                        globalResponse.ERR = "No seleccionó la moneda";
                    }
                    else
                    {
                        int _Id = (sid != "") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0;

                        int _tip = Convert.ToInt16(Peach.DecriptText(tip));
                        int _car = Convert.ToInt16(Peach.DecriptText(car));
                        int _tco = Convert.ToInt16(Peach.DecriptText(tco));
                        int _ind = Convert.ToInt16(ind);
                        int _mon = Convert.ToInt16(Peach.DecriptText(mon));

                        BEContrato Contrato = new BEContrato();
                        Contrato.TipoContrato = new ItemGenerico { IntValue = _tip };
                        Contrato.Numero = num;
                        Contrato.FechaInicio = ini;
                        Contrato.Cargo = new ItemGenerico { IntValue = _car };
                        Contrato.DocumentoAutorizacion = dau;
                        Contrato.Referencia = new ItemGenerico { StrValue = rej };
                        Contrato.FechaContrato = fco;
                        Contrato.FechaTermino = fte;

                        decimal remuneracion = 0;
                        decimal.TryParse(rem, out remuneracion);
                        Contrato.RemuneracionBruta = remuneracion;

                        Contrato.FechaAutorizacion = fau;
                        Contrato.TipoContrato = new ItemGenerico { IntValue = _tco };
                        Contrato.Indefinido = (_ind == 0) ? false : true;
                        Contrato.Moneda = new ItemGenerico { IntValue = _mon };
                        Contrato.FechaInicioFuncion = fif;

                        BEPersonalLocal Persona = new BEPersonalLocal();
                        Persona.Id = _Id;
                        Persona.Contrato = Contrato;
                        Persona.RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };
                        
                        Persona.OrganoServicio = new ItemGenerico
                        {
                            IntValue = Convert.ToInt16(Peach.DecriptText(User.OrganoServicio_CID))
                        };
                        
                        // Validación
                        if (User.Perfil_Nombre == "RINDENTE")
                        {
                            Persona.Contrato.Situacion = new ItemGenerico { IntValue = 8 };
                        }
                        else
                        {
                            Persona.Contrato.Situacion = new ItemGenerico { IntValue = 1 };
                        }
                        oResponse = new BLPersonalLocal().GrabarContrato(Persona);
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
        /// Exportacion de datos : usuario de servicio exterior
        /// </summary>
        /// <returns></returns>
        public FileContentResult PLus9XJE()
        {
            string TituloWorksheet = "Personal del Servicio Exterior";
            string NombreFileExcel = "PersonalLocal.xlsx";
            string[] columns = { "OrganoServicio", "Apellidos", "Nombres", "TipoDocumento", "NumeroDocumento", "TipoPersonal", "FechaNacimiento", "Genero", "Nacionalidad", "EstadoCivil", "Email", "Discapacidad", "GradoAcademico", "Especialidad", "SituacionLaboral", "SituacionRegistro", "Observacion" };

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    try
                    {
                        int OrganoServicio = 0;

                        if (User.OrganoServicio_Abr != string.Empty)
                        {
                            var oabr = Peach.DecriptText(User.OrganoServicio_CID);
                            if (oabr != string.Empty)
                            {
                                OrganoServicio = Convert.ToInt16(oabr);
                            }
                        }

                        List<RPPersonal> Cuentas = new BLPersonalLocal().ExportarPersonalLocal(OrganoServicio).ToList();
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

        #endregion
    }
}