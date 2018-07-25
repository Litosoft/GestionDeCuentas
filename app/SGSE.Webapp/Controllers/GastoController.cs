using SGSE.Business;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Models.Gasto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class GastoController : BaseController
    {
        /// <summary>
        /// Registro de Gastos (Generación de Formato de Egreso)
        /// </summary>
        /// <returns></returns>
        public ActionResult Registro()
        {
            RegistroGastoViewModel model = new RegistroGastoViewModel();
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    var OSE_CID = Peach.DecriptText(User.OrganoServicio_CID);

                    if (OSE_CID == string.Empty)
                    {
                        AddToastMessage("Restricción", "El usuario no esta asociado a un Órgano de Servicio.", BootstrapAlertType.danger);
                        return View(model);
                    }

                    int sid_usr = Convert.ToInt16(Peach.DecriptText(User.CID));
                    string ose = User.OrganoServicio_Nombre;

                    int sid_ose = Convert.ToInt16(Peach.DecriptText(User.OrganoServicio_CID));

                    model.CuentasOse = new BLCuentaCorriente().ListarCuentasCargo(sid_usr)
                        .Select(q => new SelectListItem { Value = q.CID, Text = q.NumeroCuenta })
                        .ToList();

                    model.MaxRegistro = new BLGasto().Get_MaximoRegistroGasto(sid_ose) + 1;

                    model.Proveedores = new BLProveedor().Listarby_OSE(sid_ose)
                        .Select(p => new SelectListItem { Value = p.CID, Text = p.Nombre })
                        .ToList();

                    /**/

                    model.ItemsClasificador = new BLClasificador().ListarItemsGasto();

                    model.ItemsFormaPago = new BLParametro().ListarItems_byGrupo("FORMATO_FORMA_PAGO")
                        .Select(p => new SelectListItem { Value = p.Valor, Text = p.Texto })
                        .ToList();

                    model.ItemsDestinoGasto = new BLParametro().ListarItems_byGrupo("FORMATO_DESTINO_GASTO")
                        .Select(p => new SelectListItem { Value = p.Valor, Text = p.Texto })
                        .ToList();

                    model.ItemsProgramasPoliticos = new BLProgramaPolitico().Listar_byOSE(OrganosServicioType.Consulado)
                        .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID })
                        .ToList();

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

            return View(model);
        }


        /// <summary>
        /// Devuelve la lista del personal local para el gasto
        /// </summary>
        /// <returns></returns>
        public ActionResult S2lFNm44()
        {
            CustomJSON globalResponse = new CustomJSON();
            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    var OSE_CID = Convert.ToInt16(Peach.DecriptText(User.OrganoServicio_CID));
                    List<SelectListItem> li = new BLGasto().Get_PersonalGasto(OSE_CID)
                        .Select(p => new SelectListItem { Value = p.CID, Text = p.Apellidos })
                        .ToList();
                    globalResponse.DATA = li;
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
            return Json(globalResponse, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Graba el gasto
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ActionResult aTIya1Nr(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var fechaGasto = model[0];
                    var sidCuenta = model[1];
                    var tipoGasto = model[2];
                    var sidProveedor = model[3];
                    var nombreProveedor = model[4].Trim().ToUpper();
                    var detalleGasto = model[5].Trim().ToUpper();
                    var formaPago = model[6];
                    var numeroPago = model[7].Trim().ToUpper();
                    var esCajaChica = model[8];
                    var detalleString = model[9];

                    /*
                    Dependiendo del tipo de gasto: 1 proveedor, 2 personal.
                    */
                    string[] arrdate = fechaGasto.Split('/');
                    if (arrdate[2] != new DateTime().Year.ToString())
                    {
                        globalResponse.ERR = "Sólo puede registrar gastos dentro del año actual.";
                    }
                    else if (arrdate[1] != new DateTime().Month.ToString())
                    {
                        globalResponse.ERR = "Sólo puede registrar gastos dentro del mes actual.";
                    }


                    /*
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
                            JefaturaServicio = new ItemGenerico
                            {
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
                    */
                    globalResponse.DATA = "Testing";
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