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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class BancoController : BaseController
    {
        // GET: Banco
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
        /// Pagina de detalle del banco (Detalles del banco y Agencias Bancarias)
        /// </summary>
        /// <param name="sid">sid del banco</param>
        /// <returns>Vista detalle de banco</returns>
        public ActionResult Detalle(string sid)
        {
            BEBanco Banco = new BEBanco();
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


                        ViewBag.Paises = new SelectList(
                            new BLPais().Listar(), "CID", "Nombre");

                        ViewBag.Tipo = new SelectList(new BLParametro().ListarDetalle(Parametros.TipoAgenciaBancaria), "Valor", "Texto");

                        // Datos del Banco
                        if (sid != "0")
                        {
                            string Id = Peach.DecriptFromBase64(sid);
                            Banco = new BLBanco().Listar_byId(Convert.ToInt16(Id));
                        }
                        return View(Banco);
                    }
                    else
                    {
                        AddToastMessage("Error", "No se ha recibido los datos principales del banco.", BootstrapAlertType.danger);
                        return RedirectToAction("Lista", "Banco");
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


        // Ajax- Index
        #region Ajax-Index

        /// <summary>
        /// Devuelve la lista de bancos para el control datatable
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
                dataTableData.data = new BLBanco().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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

        //. Reportes.

        /// <summary>
        /// Reporte 1. Devuelve los datos de los bancos y agencias
        /// </summary>
        /// <returns></returns>
        public FileContentResult R1zJ2UHV()
        {
            try
            {
                string TituloWorksheet = "Bancos";
                string NombreFileExcel = "BancosGeneral.xlsx";

                List<BancoAgenciaXls> Bancos = new List<BancoAgenciaXls>();

                Bancos = new BLBanco().ExpBancoAgencia().ToList();
                string[] columns = { "Banco", "Agencia", "Domicilio1", "Domicilio2", "Tipo", "Pais" };

                if (Bancos.Count > 0)
                {
                    byte[] filecontent = ExcelExportHelper.ExportExcel(
                        Bancos, TituloWorksheet,
                        String.Format("Exportado por {0} el {1} a las {2}.", User.Usuario, DateTime.Now.ToShortDateString(), DateTime.Now.ToShortTimeString()),
                        true,
                        columns);

                    return File(filecontent, ExcelExportHelper.ExcelContentType, NombreFileExcel);
                }
                else
                {
                    List<BancoAgenciaXls> emptySheet = new List<BancoAgenciaXls>();
                    AddToastMessage(string.Empty, "No hay datos que importar.", BootstrapAlertType.info);

                    byte[] filecontent = ExcelExportHelper.ExportExcel(
                        emptySheet, TituloWorksheet,
                        "",
                        true, columns);
                    return File(filecontent, ExcelExportHelper.ExcelContentType, NombreFileExcel);
                }
            }
            catch (Exception ex)
            {
                AddToastMessage("Sesion registrada", "Ha intentado acceder a una ubicación no permitida para su perfil.", BootstrapAlertType.danger);
                throw ex;
            }
        }


        /// <summary>
        /// Reporte 2. Devuelve los datos de los bancos y agencias
        /// </summary>
        /// <returns></returns>
        public FileContentResult R2zJ2UHV()
        {
            try
            {
                string TituloWorksheet = "Cuentas por Mision";
                string NombreFileExcel = "CuentasPorMision.xlsx";

                List<BancoCuentaMisionXls> Bancos = new List<BancoCuentaMisionXls>();

                Bancos = new BLBanco().ExpBancoAgenciaCuentaMision().ToList();
                string[] columns = { "OrganoServicio", "Cuenta", "Banco", "Agencia", "Domicilio1", "Domicilio2", "Tipo", "Pais", "Situacion" };

                if (Bancos.Count > 0)
                {
                    byte[] filecontent = ExcelExportHelper.ExportExcel(
                        Bancos, TituloWorksheet,
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
                AddToastMessage("Sesion registrada", "Ha intentado acceder a una ubicación no permitida para su perfil.", BootstrapAlertType.danger);
                throw ex;
            }
        }


        #endregion


        // Ajax- Detalle

        /// <summary>
        /// Inserta o actualiza los datos de un banco
        /// </summary>
        /// <param name="dat">Parametros</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult enNBUT09(List<string> dat)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var nom = dat[0].Trim().ToUpper();
                    var url = dat[1].Trim().ToUpper();
                    var sit = dat[2];
                    var sid = dat[3];

                    if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un nombre para el banco";
                    }
                    else
                    {
                        BEBanco Banco = new BEBanco
                        {
                            Id = (sid != "") ? Convert.ToInt16(Peach.DecriptFromBase64(sid)) : 0,
                            Nombre = nom,
                            Url = url,
                            Situacion = new ItemGenerico { IntValue = Convert.ToByte(sit) },
                            
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };

                        oResponse = new BLBanco().Grabar(Banco);
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
        /// Devuelve todas las agencias bancarias pertenecientes a un banco especificado en el parámetro
        /// </summary>
        /// <param name="sid">sid del banco</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult YVVFN2hr(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    if (sid != string.Empty)
                    {
                        int id = Convert.ToInt16(Peach.DecriptFromBase64(sid));
                        globalResponse.DATA = new BLBanco().ListarAgencias(id);
                    }
                    else
                    {
                        globalResponse.DATA = null;
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
        /// Inserta o actualiza los datos de una agencia bancaria
        /// </summary>
        /// <param name="dat">Datos de la agencia bancaria</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult NGZIbEEr(List<string> dat)
        {
            //  L0hWZz09
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var nom = dat[0].Trim().ToUpper();
                    var dir1 = dat[1].Trim().ToUpper();
                    var dir2 = dat[2].Trim().ToUpper();
                    var tpo = dat[3];
                    var pai = dat[4];
                    var agen = dat[5];
                    var banc = dat[6];

                    if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un nombre para la agencia";
                    }
                    else if (tpo == null)
                    {
                        globalResponse.ERR = "No ha seleccionado el Tipo";
                    }
                    else if (pai == null)
                    {
                        globalResponse.ERR = "No ha seleccionado un País";
                    }
                    else
                    {
                        BEBanco Banco = new BEBanco
                        {
                            Id = Convert.ToInt16(Peach.DecriptFromBase64(banc)),
                            Agencia = new BEAgenciaBancaria
                            {
                                Id = (agen == "0") ? 0 : Convert.ToInt16(Peach.DecriptFromBase64(agen)),
                                Nombre = nom,
                                Direccion1 = dir1,
                                Direccion2 = dir2,
                                Tipo = new ItemGenerico { IntValue = Convert.ToInt16(Peach.DecriptText(tpo)) },
                                Pais = new BEPais { Id = Convert.ToInt16(Peach.DecriptText(pai)) }
                            },
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };

                        oResponse = new BLBanco().GrabarAgencia(Banco);
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
        /// Devuelve los datos de una agencia bancaria especificada por su id
        /// </summary>
        /// <param name="sid">sid de la agencia bancaria</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult TU1sdEZJ(string sid)
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
                        var AgenciaBancaria = new BLBanco().ListarAgencia(id);
                        globalResponse.DATA = AgenciaBancaria;
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
    }
}