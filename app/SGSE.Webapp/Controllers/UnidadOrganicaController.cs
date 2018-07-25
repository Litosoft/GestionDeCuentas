using SGSE.Business;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Enumeradores;
using SGSE.Webapp.App_Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class UnidadOrganicaController : BaseController
    {
        // GET: UnidadOrganica
        public ActionResult Listar()
        {
            ViewBag.Controller = this.Controlador();
            ViewBag.Method = this.Metodo();

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

                dataTableData.draw = draw;
                dataTableData.data = new BLUnidadOrganica().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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
    }
}