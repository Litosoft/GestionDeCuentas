using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Models.Usuario;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace SGSE.Webapp.Controllers
{
    public class UsuarioController : BaseController
    {
        
        #region Usuarios

        public ActionResult Listar()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    UsuarioViewModel model = new UsuarioViewModel();
                    List<SelectListItem> OrganosServicio = new List<SelectListItem>();

                    SelectListItem ItemNinguno = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };
                    OrganosServicio.Add(ItemNinguno);
                    OrganosServicio.AddRange(new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos)
                        .Select(p => new SelectListItem { Text = p.Abreviatura, Value = p.CID }));


                    model.UnidadesOrganicas = new BLUnidadOrganica().Listar()
                        .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID });

                    model.OrganosServicio = OrganosServicio;

                    model.Paises = new BLPais().Listar_ToSelect()
                        .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID });

                    model.Perfiles = new BLPerfil().Listar_ToSelect()
                        .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID });


                    Array values = Enum.GetValues(typeof(UsuarioRolType));
                    List<SelectListItem> Items = new List<SelectListItem>(values.Length);
                    int ItemVal = 0;
                    foreach (var i in values)
                    {
                        Items.Add(new SelectListItem
                        {
                            Text = Enum.GetName(typeof(UsuarioRolType), i),
                            Value = Peach.EncriptText(ItemVal.ToString())
                        });
                        ItemVal++;
                    }
                    model.Roles = Items;


                    return View(model);
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }


        /// <summary>
        /// Devuelve los usuarios destinados al Data Table
        /// </summary>
        /// <param name="draw"></param>
        /// <param name="start"></param>
        /// <param name="length"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult VEdTdnlP(int draw, int start, int length)
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
                dataTableData.data = new BLUsuario().Listar_toDataTables(start_offset, length, search, sortColumn, sortDirection, ref recordsTotal);
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
        /// Devuelve los datos de un usuario especificado por su id
        /// </summary>
        /// <param name="sid">id sha1 del usuario</param>
        /// <returns></returns>
        public ActionResult V0I0MmZV(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            BEUsuario Usuario = new BEUsuario();

            string _err = string.Empty;
            if (User != null)
            {
                try
                {
                    string Id = Peach.DecriptFromBase64(sid);

                    Usuario = new BLUsuario().Listar_byId(Convert.ToInt16(Id));
                    globalResponse.DATA = Usuario;
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
        /// Graba los datos basicos de un usuario.
        /// </summary>
        /// <param name="model">Arreglo que contiene la data a grabar</param>
        /// <returns></returns>
        public ActionResult clc2N1ZQ(UsuarioModel model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();
            int id = 0;

            if (User != null)
            {
                try
                {
                    if (model.ape == null)
                    {
                        globalResponse.ERR = "No ha ingresado el apellido";
                    }
                    else if (model.nom == null)
                    {
                        globalResponse.ERR = "No ha ingresado el apellido";
                    }
                    else if (model.mai == null)
                    {
                        globalResponse.ERR = "No ha ingresado el email";
                    }
                    else if (model.usr == null && model.dom == "0")
                    {
                        globalResponse.ERR = "No ha ingresado el usuario";
                    }
                    else if (model.pwd == null && model.dom == "0")
                    {
                        globalResponse.ERR = "No ha ingresado la contraseña";
                    }
                    else if (model.ini == null)
                    {
                        globalResponse.ERR = "No ha ingresado fecha de inicio de vigencia (desde)";
                    }
                    else if (model.fin == null)
                    {
                        globalResponse.ERR = "No ha ingresado fecha de termino de vigencia (hasta)";
                    }
                    else if (model.und == null)
                    {
                        globalResponse.ERR = "No seleccionado una Unidad Orgánica";
                    }
                    else if (model.pai == null)
                    {
                        globalResponse.ERR = "No seleccionó el País";
                    }
                    else if (model.ose == null)
                    {
                        globalResponse.ERR = "No seleccionó un Organo de Servicio";
                    }
                    else if (model.rol == null)
                    {
                        globalResponse.ERR = "No seleccionó el Rol";
                    }
                    else
                    {
                        var und = Convert.ToInt16(Peach.DecriptText(model.und));
                        var pai = Convert.ToInt16(Peach.DecriptText(model.pai));
                        var ose = Convert.ToInt16(Peach.DecriptText(model.ose));
                        var rol = Convert.ToInt16(Peach.DecriptText(model.rol));

                        BEUsuario usuario = new BEUsuario
                        {
                            Apellidos = model.ape.Trim().ToUpper(),
                            Nombres = model.nom.Trim().ToUpper(),
                            Email = model.mai.Trim().ToUpper(),
                            Telefono = (model.tel != null) ? model.tel.Trim().ToUpper() : string.Empty,
                            Login = new BELogin
                            {
                                user = model.usr.Trim().ToUpper(),
                                pass = (model.pwd != null) ? model.pwd.Trim() : string.Empty
                            },
                            Desde = model.ini.Trim(),
                            Hasta = model.fin.Trim(),
                            Unidad = new BEUnidad { Id = und },
                            Pais = new BEPais { Id = pai },
                            OrganoServicio = new BEOrganoServicio { Id = ose },
                            Rol = new ItemGenerico { IntValue = rol },
                            RowAudit = new Entidad.Primitivos.IRowAudit
                            {
                                IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                IP = Common.PageUtility.GetUserIpAddress()
                            }
                        };

                        // SID
                        if (model.sid != "0")
                        {
                            var sid = Peach.DecriptText(model.sid);
                            id = Convert.ToInt16(sid);
                        }
                        usuario.Id = id;

                        // Encrptacion
                        if (usuario.Login.pass != string.Empty)
                        {
                            usuario.Login.pass = Peach.EncriptText(Crypto.CryptoProvider.TripleDES, usuario.Login.pass);
                        }

                        // Dominio
                        usuario.IsDominio = Convert.ToByte(model.dom);

                        // Checks
                        usuario.CambiarPwd = Convert.ToByte(model.ses);
                        usuario.Estado = new ItemGenerico { IntValue = Convert.ToInt16(model.est) };

                        // Perfiles
                        List<BEPerfil> Perfiles = new List<BEPerfil>();
                        if (model.per != null)
                        {
                            foreach (string per in model.per)
                            {
                                Perfiles.Add(new BEPerfil { Id = Convert.ToInt16(Peach.DecriptText(per)) });
                            }
                        }
                        usuario.Perfiles = Perfiles;
                        oResponse = new BLUsuario().Grabar(usuario);

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


        #region Perfiles 

        public ActionResult Perfiles()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {

                    List<BEPerfil> Perfiles = new List<BEPerfil>();
                    Perfiles = new BLPerfil().Listar();

                    return View(Perfiles);
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }

        /// <summary>
        /// Graba un perfil
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult aytQVy91(List<string> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();

            if (User != null)
            {
                try
                {
                    var id = (model[3] == "0") ? model[3] : Peach.DecriptText(model[3]);

                    BEPerfil Perfil = new BEPerfil
                    {
                        Nombre = model[0].Trim().ToUpper(),
                        Abreviatura = model[1].Trim().ToUpper(),
                        Descripcion = model[2].Trim().ToUpper(),
                        Id = Convert.ToInt16(id),
                        RowAudit = new Entidad.Primitivos.IRowAudit
                        {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        }
                    };

                    oResponse = new BLPerfil().Grabar(Perfil);
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
        /// Devuelve un perfil segun su id
        /// </summary>
        /// <param name="Perfil"></param>
        /// <returns></returns>
        public ActionResult TjQxYWpE(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            BEPerfil Perfil = new BEPerfil();

            string _err = string.Empty;
            if (User != null)
            {
                try
                {
                    string Id = Peach.DecriptText(sid);

                    Perfil = new BLPerfil().Listar_byId(Convert.ToInt16(Id));
                    globalResponse.DATA = Perfil;
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


        // Tree de Perfiles

        /// <summary>
        /// Devuelve todas las opciones del menu, con las opciones del perfil seleccionado
        /// </summary>
        /// <param name="sid">Id del perfil</param>
        /// <returns></returns>
        public ActionResult XVxJ3pT0(string sid)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();
            List<BEMenuItem> Items = new List<BEMenuItem>();
            List<JsTreeModel> jsTree = new List<JsTreeModel>();

            string _err = string.Empty;

            if (User != null)
            {
                try
                {
                    var id = Peach.DecriptText(sid);
                    Items = new BLMenu().ListarInterfaz(Convert.ToInt16(id)).ToList();

                    foreach (BEMenuItem menu in Items)
                    {
                        jsTree.Add(new JsTreeModel
                        {
                            id = menu.Id.ToString(),
                            parent = (menu.Padre.IntValue == 0) ? "#" : menu.Padre.IntValue.ToString(),
                            text = menu.Nombre,
                            data = new JsTreeModel_data
                            {
                                idp = (menu.Padre.IntValue == 0) ? "#" : menu.Padre.IntValue.ToString(),
                                nop = menu.Padre.Texto,
                            },
                            state = new JsTreeModelState
                            {
                                opened = true,
                                selected = (menu.IsAuth.IntValue == 1)
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
        /// Graba las opciones del menu asociadas a un perfil
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ActionResult ZFppSXFj(List<string[]> model)
        {
            CustomJSON globalResponse = new CustomJSON();
            ResponserData oResponse = new ResponserData();
            List<BEMenuItem> Items = new List<BEMenuItem>();
            BEPerfil perfil = new BEPerfil();

            if (User != null)
            {
                try
                {
                    var sid = Peach.DecriptText(model[0][0].ToString());
                    var seleccion_determinada = model[1];

                    if (seleccion_determinada.Length > 0)
                    {
                        foreach (string s in seleccion_determinada)
                        {
                            Items.Add(new BEMenuItem
                            {
                                Id = Convert.ToInt16(s),
                                RowAudit = new IRowAudit
                                {
                                    IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                    IP = Common.PageUtility.GetUserIpAddress()
                                }
                            });
                        }

                        // No determinadas
                        if (model.Count > 2)
                        {
                            var seleccion_nodeterminada = model[2];
                            foreach (string s in seleccion_nodeterminada)
                            {
                                Items.Add(new BEMenuItem
                                {
                                    Id = Convert.ToInt16(s),
                                    RowAudit = new IRowAudit
                                    {
                                        IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                                        IP = Common.PageUtility.GetUserIpAddress()
                                    }
                                });
                            }
                        }

                        // resto de datos

                        perfil.Id = Convert.ToInt16(sid);
                        perfil.OpcionesMenu = Items;
                        perfil.RowAudit = new IRowAudit {
                            IUsr = Convert.ToInt16(Peach.DecriptText(User.CID)),
                            IP = Common.PageUtility.GetUserIpAddress()
                        };

                        oResponse = new BLMenu().Grabar_byPerfil(perfil);
                        globalResponse.DATA = oResponse;
                    }
                    else
                    {
                        globalResponse.ERR = "No existen opciones seleccionadas.";
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