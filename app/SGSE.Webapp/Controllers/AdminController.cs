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
    public class AdminController : BaseController
    {
        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Menu()
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

        #region Ajax Menu

        /// <summary>
        /// Devuelve los items del menu para el control TreeView
        /// </summary>
        /// <returns></returns>
        public ActionResult YjFJRVFs()
        {
            CustomJSON globalResponse = new CustomJSON();
            List<BEMenuItem> MenuItems = new List<BEMenuItem>();
            List<JsTreeModel> jsTree = new List<JsTreeModel>();

            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    MenuItems = new BLMenu().Listar();
                    foreach (BEMenuItem menu in MenuItems)
                    {
                        jsTree.Add(new JsTreeModel
                        {
                            id = menu.Id.ToString(),
                            parent = (menu.Padre.Id == 0) ? "#" : menu.Padre.Id.ToString(),
                            text = menu.Nombre,
                            data = new JsTreeModel_data
                            {
                                idp = (menu.Padre.Id == 0) ? "#" : menu.Padre.Id.ToString(),
                                nop = menu.Padre.Texto,
                            },
                            state = new JsTreeModelState
                            {
                                opened = true
                            }
                        });
                    }
                    globalResponse.DATA = jsTree;
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
            return Json(jsTree, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Devuelve los datos de una opcion de menu en base a su id
        /// </summary>
        /// <param name="id">Id de la opcion</param>
        /// <returns>Json result</returns>
        public ActionResult SFpocmJ3(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            BEMenuItem Item = new BEMenuItem();

            string _err = string.Empty;
            if (User != null)
            {
                try
                {
                    Item = new BLMenu().Listar_byId(Convert.ToInt16(sid));
                    globalResponse.DATA = Item;
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
        /// Devuelve todos los elementos del menu para el control combo-box
        /// </summary>
        /// <returns>Json CustomJSON</returns>
        public ActionResult UVdTdmlD()
        {
            CustomJSON globalResponse = new CustomJSON();
            List<SelectListItem> Items = new List<SelectListItem>();

            if (User != null)
            {
                try
                {
                    Items.Add(new SelectListItem { Text = "Ninguno", Value = "0" });
                    Items.AddRange(new BLMenu().Listar().Select(p => new SelectListItem { Text = add_dash(p.Nombre, p.Nivel), Value = p.Id.ToString() }).ToList());

                    globalResponse.DATA = Items;
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
        /// Graba la opción de menú
        /// </summary>
        /// <returns>Json</returns>
        public ActionResult TW5UTjZN(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var sid = model[0];
                    var pad = model[1];
                    var nom = model[2];
                    var des = model[3];
                    var con = model[4];
                    var met = model[5];
                    var par = model[6];
                    var url = model[7];
                    var ico = model[8];
                    var ord = model[9];
                    var pop = model[10];
                    var vis = model[11];
                    var grp = model[12];

                    var e = User;

                    BEMenuItem Item = new BEMenuItem
                    {
                        Id = Convert.ToInt16(model[0]),
                        Padre = new ItemGenerico
                        {
                            Id = Convert.ToInt16(model[1])
                        },
                        Nombre = model[2].Trim(),
                        Descripcion = model[3].Trim(),
                        Controlador = model[4].Trim(),
                        Metodo = model[5].Trim(),
                        Parametro = model[6].Trim(),
                        Url = model[7].Trim(),
                        Icono = model[8].Trim(),
                        Orden = (model[9] == string.Empty) ? 0 : Convert.ToInt16(model[9]),
                        IsPopup = new ItemGenerico
                        {
                            IntValue = Convert.ToInt16(model[10])
                        },
                        IsVisible = new ItemGenerico
                        {
                            IntValue = Convert.ToInt16(model[11])
                        },
                        IsGrupo = new ItemGenerico
                        {
                            IntValue = Convert.ToInt16(model[12])
                        },
                        RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        }
                    };

                    oResponse = new BLMenu().Grabar(Item);
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

        #region Funciones Privadas


        /// <summary>
        /// Identa los elementos del combo box
        /// </summary>
        /// <param name="data">cadena con datos</param>
        /// <param name="dash">numero de identación</param>
        /// <returns>cadena identada</returns>
        private string add_dash(string data, int dash)
        {
            string output = string.Empty;
            for (int i = 0; i < dash; i++)
            {
                output += '_';
            }
            output += data;
            return output;
        }


        #endregion

        #endregion

        [HttpGet]
        public ActionResult Parametro()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    ViewBag.Grupos = new BLParametro().ListarGrupo();

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


        #region Ajax Parametros

        // Lista los párametros - (maestro)
        [HttpPost]
        public ActionResult S2lFNm44()
        {
            CustomJSON globalResponse = new CustomJSON();
            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    globalResponse.DATA = new BLParametro().Listar();
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


        // Lista los detalles de un parámetro
        [HttpPost]
        public ActionResult Tk1hVEVk(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    var idp = Peach.DecriptText(sid);
                    BEParametro parametro = new BEParametro();
                    parametro.Id = Convert.ToInt16(idp);

                    globalResponse.DATA = new BLParametro().ListarDetalle(parametro);
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
        /// Muestra los datos de un parámetro
        /// </summary>
        /// <param name="sid">Id del parámetro</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult OSthOFJz(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();

            if (User != null)
            {
                try
                {
                    var id = Peach.DecriptText(sid);
                    BEParametro parametro = new BLParametro().Listar_byId(Convert.ToInt16(id));
                    globalResponse.DATA = parametro;
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
                return Json(globalResponse, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
        }


        // Inserta o actualiza un parámetro
        [HttpPost]
        public ActionResult Y2ZTaUlU(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var nom = model[0].Trim().ToUpper();
                    var grp = model[1];
                    var des = model[2].Trim().ToUpper();
                    var sid = model[3].Trim();

                    if (nom == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado un nombre para el parámetro.";
                    }
                    else if (grp == null)
                    {
                        globalResponse.ERR = "No ha seleccionado un grupo para el parámetro.";
                    }
                    else
                    {
                        BEParametro parametro = new BEParametro
                        {
                            Id = (sid != string.Empty) ? Convert.ToInt16(Peach.DecriptText(sid)) : 0,
                            Nombre = nom,
                            Grupo = new BEParametroGrupo
                            {
                                Id = Convert.ToInt16(Peach.DecriptText(grp))
                            },
                            Descripcion = des,
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };
                        oResponse = new BLParametro().Grabar(parametro);
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

        
        // Elimina un parametro
        [HttpPost]
        public ActionResult Vy9WaHkz(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            int id = 0;

            if (User != null)
            {
                try
                {
                    if (sid != string.Empty) id = Convert.ToInt16(Peach.DecriptText(sid));
                    BEParametro parametro = new BEParametro
                    {
                        Id = id,
                        RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        }
                    };
                    oResponse = new BLParametro().Eliminar(parametro);
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

        
        // Inserta o actualiza el detalle del parámetro item
        [HttpPost]
        public ActionResult RUJJa3Np(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            string _err = string.Empty;
            int idp = 0;
            int idd = 0;
            int ord = 0;

            if (User != null)
            {
                try
                {
                    var sip = model[0].Trim();
                    var tex = model[1].Trim().ToUpper();
                    var val = model[2].Trim().ToUpper();
                    var ayu = model[3].Trim().ToUpper();
                    var _ord = model[4].Trim();
                    var grp = model[5];
                    var sid = model[6].Trim();

                    if (tex == string.Empty)
                    {
                        globalResponse.ERR = "No ha ingresado el texto del parámetro";
                    }
                    else
                    {
                        if (_ord != string.Empty)
                        {
                            bool isnum = int.TryParse(_ord, out ord);
                            if (!isnum) { ord = 0; }
                        }

                        if (sip != string.Empty) idp = Convert.ToInt16(Peach.DecriptText(sip));
                        if (sid != string.Empty) idd = Convert.ToInt16(Peach.DecriptText(sid));

                        BEParametro parametro = new BEParametro()
                        {
                            Id = idp,
                            Detalle = new BEParametroItem
                            {
                                Id = idd,
                                Texto = tex,
                                Valor = val,
                                Ayuda = ayu,
                                Orden = ord,
                                IsGrupo = new ItemGenerico
                                {
                                    IntValue = (grp == "True") ? 1 : 0
                                },
                            },
                            RowAudit = new IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };
                        oResponse = new BLParametro().GrabarDetalle(parametro);
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


        // Muestra los datos de un detalle
        [HttpPost]
        public ActionResult OUlSU3Ez(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();

            if (User != null)
            {
                try
                {
                    var id = Peach.DecriptText(sid);

                    BEParametro parametro = new BEParametro();
                    parametro.Id = 0;
                    parametro.Detalle = new BEParametroItem
                    {
                        Id = Convert.ToInt16(id)
                    };

                    BEParametroItem detalle = new BLParametro().ListarDetalle_byId(parametro);
                    globalResponse.DATA = detalle;
                }
                catch (Exception ex)
                {
                    globalResponse.ERR = ex.Message;
                }
                return Json(globalResponse, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return RedirectToAction("Index", "Account", new { act = "timeout" });
            }
        }


        // Elimina un detalle
        [HttpPost]
        public ActionResult SVkwTXVC(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            int id = 0;

            if (User != null)
            {
                try
                {
                    if (sid != string.Empty) id = Convert.ToInt16(Peach.DecriptText(sid));
                    BEParametroItem detalle = new BEParametroItem
                    {
                        Id = Convert.ToInt16(id),
                        RowAudit = new IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        }
                    };
                    oResponse = new BLParametro().EliminarDetalle(detalle);
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

        #endregion
    }


}