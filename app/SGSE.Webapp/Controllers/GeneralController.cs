using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class GeneralController : BaseController
    {
        // GET: General
        public ActionResult Moneda()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

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

        public ActionResult Pais()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    List<SelectListItem> Continentes = new BLPais().Listar_Continentes()
                        .Select(p => new SelectListItem { Value = p.CID, Text = p.Nombre }).ToList();

                    List<SelectListItem> model = Continentes;
                    return View(model);
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


        #region Ajax-Monedas

        /// <summary>
        /// + Devuelve la lista de monedas para el control datatable
        /// </summary>
        /// <param name="draw">Página</param>
        /// <param name="start">Fila inicial</param>
        /// <param name="length">Longitud</param>
        /// <returns>Json object</returns>
        [HttpGet]
        public ActionResult TXpDQ0V1(int draw, int start, int length)
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

                dataTableData.draw = draw;
                dataTableData.data = new BLMoneda().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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
        /// + Devuelve una moneda segun su id
        /// </summary>
        /// <param name="sid">IdMoneda</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult MmhHNEhy(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            BEMoneda Moneda = new BEMoneda();

            string _err = string.Empty;
            if (User != null)
            {
                try
                {
                    string Id = Peach.DecriptText(sid);

                    Moneda = new BLMoneda().Listar_byId(Convert.ToInt16(Id));
                    globalResponse.DATA = Moneda;
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
        /// + Inserta o actualiza los datos de una moneda
        /// </summary>
        [HttpPost]
        public ActionResult enNBUT09(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();
            BEMoneda Moneda = new BEMoneda();

            if (User != null)
            {
                try
                {
                    var nom = dat[0].Trim().ToUpper();
                    var abr = dat[1].Trim();
                    var suf = dat[2].Trim();
                    var sim = dat[3].Trim();
                    var iso = dat[4].Trim().ToUpper();
                    var asg = dat[5];
                    var sid = dat[6];

                    if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado el nombre";
                    }
                    else if (iso == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado el ISO";
                    }
                    else
                    {
                        var i_sid = (sid == "0") ? 0 : Convert.ToInt16(Peach.DecriptText(sid));

                        Moneda.Nombre = nom;
                        Moneda.Abreviatura = abr;
                        Moneda.SufijoContable = suf;
                        Moneda.Simbolo = sim;
                        Moneda.ISO4217 = iso;
                        Moneda.Asignable = new ItemGenerico { IntValue = Convert.ToInt16(asg) };
                        Moneda.Id = i_sid;

                        Moneda.RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };

                        oResponse = new BLMoneda().Grabar(Moneda);
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

        #endregion


        #region Ajax-Pais
        
        /// <summary>
        /// Devuelve la lista de paises para el control datatable
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

                dataTableData.draw = draw;
                dataTableData.data = new BLPais().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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
        /// Devuelve un País segun su id
        /// </summary>
        /// <param name="Perfil"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult TjQxYWpE(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            BEPais Pais = new BEPais();

            string _err = string.Empty;
            if (User != null)
            {
                try
                {
                    string Id = Peach.DecriptText(sid);

                    Pais = new BLPais().Listar_byId(Convert.ToInt16(Id));
                    globalResponse.DATA = Pais;
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
        /// Inserta o actualiza los datos de un país
        /// </summary>
        [HttpPost]
        public ActionResult bi8wZz09(List<string> dat, string[] mnd)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();
            List<BEMoneda> Monedas = new List<BEMoneda>();
            BEPais Pais = new BEPais();

            if (User != null)
            {
                try
                {

                    var nom = dat[0].Trim().ToUpper();
                    var ofi = dat[1].Trim().ToUpper();
                    var gen = dat[2].Trim().ToUpper();
                    var m49 = dat[3].Trim().ToUpper();
                    var iso = dat[4].Trim().ToUpper();
                    var reg = dat[5];
                    var sid = (dat[6] == "0") ? dat[6] : Peach.DecriptText(dat[6]);

                    Pais.Nombre = nom;
                    Pais.Oficial = ofi;
                    Pais.Gentilicio = gen;
                    Pais.M49 = m49;
                    Pais.ISOA3 = iso;

                    Pais.Region = new BERegion { Id = Convert.ToInt16(Peach.DecriptText(reg)) };
                    Pais.Id = Convert.ToInt16(sid);

                    if (mnd != null)
                    {
                        foreach (var m in mnd)
                        {
                            string sidm = Peach.DecriptText(m);
                            Monedas.Add(new BEMoneda { Id = Convert.ToInt16(sidm) });
                        }
                    }

                    Pais.Monedas = Monedas;
                    Pais.RowAudit = new IRowAudit
                    {
                        IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                        IP = Common.PageUtility.GetUserIpAddress()
                    };

                    oResponse = new BLPais().Grabar(Pais);
                    globalResponse.DATA = oResponse;
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
        /// Devuelve las regiones por continente
        /// </summary>
        /// <param name="sid">Id del continente</param>
        /// <returns>Json Result</returns>
        [HttpGet]
        public ActionResult Tk5obGw4(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    if (sid != null)
                    {
                        int i_sid = Convert.ToInt16(Peach.DecriptText(sid));
                        var Regiones = new BLPais().Listar_Regiones_byContinente(i_sid)
                            .Select(p => new SelectListItem { Value = p.CID, Text = p.Nombre }).ToList();

                        globalResponse.DATA = Regiones;
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
        /// Devuelve todas las monedas
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult hSm2WfIC()
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var Monedas = new BLMoneda().Listar()
                        .Select(p => new SelectListItem { Value = p.CID, Text = p.ISO4217 + " - " + p.Nombre })
                        .OrderBy(q => q.Text)
                        .ToList();

                    globalResponse.DATA = Monedas;
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

    }
}