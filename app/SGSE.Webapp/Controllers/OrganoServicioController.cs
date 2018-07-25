using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Models.OrganoServicio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class OrganoServicioController : BaseController
    {
        // GET: Devuelve los organos de servicio
        public ActionResult Listar()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();
            if (User != null)
            {
                if (this.IsPermitido())
                {
                    ViewBag.Controller = strControlador;
                    ViewBag.Method = strMetodo;

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
        /// Devuelve los detalles del órgano de servicio
        /// </summary>
        /// <param name="sid">ID Base64 del Órgano de Servicio</param>
        /// <returns></returns>
        public ActionResult Detalle(string sid)
        {
            OrganoServicioDetalleViewModel model = new OrganoServicioDetalleViewModel();
            List<SelectListItem> Items = new List<SelectListItem>();

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

                        // Tipo de Órganos de Servicio
                        model.TiposOrganoServicio = new SelectList(
                            new BLParametro().ListarDetalle(Parametros.TipoOrganoServicio), "Valor", "Texto");

                        // Pais
                        model.Paises = new SelectList(
                            new BLPais().Listar_ToSelect_Base64(), "CID", "Nombre");

                        // Procesando el Id
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);

                        // Jefatura de Servicio
                        Items.Add(new SelectListItem { Text = "- NINGUNO -", Value = Peach.EncriptText("0") });
                        Items.AddRange(
                            new BLOrganoServicio().Listar_JefaturaServicio_byOSE_ToSelect (i_sid)
                            .Select(p => new SelectListItem { Text = p.Abreviatura,  Value = p.CID })
                            .ToList());

                        model.JefaturasServicio = Items;
                        model.OrganoServicio = new BLOrganoServicio().Listar_byId(i_sid);
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

        /// <summary>
        /// Devuelve la lista de Órganos de Servicio para el control datatable
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
                dataTableData.data = new BLOrganoServicio().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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
        /// Graba los datos generales del Organo de Servicio Exterior
        /// </summary>
        /// <param name="model">Areglo con datos</param>
        /// <returns></returns>
        public ActionResult aTIya1Nr(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var nom = model[0].Trim().ToUpper();
                    var abr = model[1].Trim().ToUpper();
                    var tpo = model[2];
                    var pai = model[3];
                    var cod = model[4].Trim().ToUpper();
                    var jse = model[5];
                    var sid = model[6];

                    if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un nombre para el Órgano de Servicio";
                    }
                    else if (abr == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un nombre abreviado para el Órgano de Servicio";
                    }
                    else if (tpo == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el tipo de Organo de Servicio";
                    }
                    else if (pai == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el país del Organo de Servicio";
                    }
                    else
                    {
                        BEOrganoServicio OrganoServicio = new BEOrganoServicio
                        {
                            Id = (sid != "0") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0,
                            Nombre = nom,
                            Abreviatura = abr,
                            TipoOrgano = new ItemGenerico { Id = Convert.ToInt16(Peach.DecriptText(tpo)) },
                            Pais = new BEPais { Id = Convert.ToInt16(Peach.DecriptFromBase64(pai)) },
                            CodigoInterop = cod,
                            JefaturaServicio = new ItemGenerico {
                                Id = Convert.ToInt16(Peach.DecriptText(jse))
                            },
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };

                        oResponse = new BLOrganoServicio().Grabar(OrganoServicio);
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
        /// Devuelve las Jefaturas de Servicio (Consulados)
        /// </summary>
        /// <param name="sid">Código de País</param>
        /// <returns></returns>
        public ActionResult dklHc0hk(string sid)
        {
            /*
            Nota:
            - Sólo los consulados son considerados Jefaturas de Servicios
            */

            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    if (sid != null)
                    {
                        string s_sid = (sid != "0") ? Peach.DecriptFromBase64(sid) : "0";
                        int i_sid = Convert.ToInt16(s_sid);

                        // Jefatura de Servicio
                        List<SelectListItem> Items = new List<SelectListItem>();
                        Items.Add(new SelectListItem { Text = "- NINGUNO -", Value = Peach.EncriptText("0") });
                        Items.AddRange(
                            new BLOrganoServicio().Listar_byTipoPais_ToSelect(OrganosServicioType.Consulado, i_sid)
                            .Select(p => new SelectListItem { Text = p.Abreviatura, Value = p.CID })
                            .ToList());
                        
                        globalResponse.DATA = Items;
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
    }
}