using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Autenticacion;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Helpers;
using SGSE.Webapp.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using System.Web.Security;

namespace SGSE.Webapp.Controllers
{
    [Serializable]
    public class AccountController : BaseController
    {
        [AllowAnonymous]
        [HttpGet]
        public ActionResult Login()
        {
            //: Motivo de retorno
            var m = Request.QueryString["m"];
            if (m != null)
            {
                if (m == "NotAuthenticated")
                {
                    AddToastMessage("No Autenticado", "Debe ingresar sus credenciales para acceder a la aplicación.", BootstrapAlertType.danger);
                }
                else if (m == "TempDataNull")
                {
                    AddToastMessage("Datos Nulos", "Los datos temporales han sido eliminados por límite de inactividad, ingrese nuevamente a su sesión", BootstrapAlertType.danger);
                }
                else if (m == "SessionNull")
                {
                    AddToastMessage("Sesión Terminada", "Su sesión ha expirado, ingrese nuevamente a su sesión", BootstrapAlertType.danger);
                }
                else if (m == "ErrorCatch")
                {
                    var e = Request.QueryString["e"];
                    if (e != null)
                    {
                        AddToastMessage("Error", e, BootstrapAlertType.danger);
                    }
                    else
                    {
                        AddToastMessage("Error", "Ocurrió un error inesperado, consulte con el administrador del sistema.", BootstrapAlertType.danger);
                    }
                }
            }
            ViewBag.ShowCaptcha = ConfigurationManager.ConfigurationManager.GetCaptchaConfig();

            return View(new BELogin());
        }


        /// <summary>Procesa las credenciales de acceso</summary>
        /// <param name="model">Modelo de logueo</param>
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(BELogin model)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            BLUsuario oblUsuario = new BLUsuario();

            try
            {
                if (ModelState.IsValid)
                {
                    var _usr = model.user.Trim().ToUpper();
                    var _pwd = Peach.EncriptText(Crypto.CryptoProvider.TripleDES, model.pass.Trim());

                    var responser = oblUsuario.getUsuario_byLogin(_usr, _pwd);

                    if (responser.Estado == ResponserEstado.Ok)
                    {
                        BEUsuario UserData = (BEUsuario) responser.DataContent;
                        if (UserData.IsDominio == 1)
                        {
                            var DominioResult = BLUsuario.ValidaDominio(new BELogin { user = _usr, pass = model.pass.Trim() });
                            if (!DominioResult)
                            {
                                AddToastMessage(string.Empty, "Su contraseña no es correcta. Utilice su contraseña de dominio.", BootstrapAlertType.danger);
                                return View();
                            }
                        }

                        // :Ticket de cookie
                        CustomPrincipalTicket _dataTicket = new CustomPrincipalTicket
                        {
                            CID = UserData.CID,
                            Usuario = UserData.Apellidos,
                            Unidad_Nombre = UserData.Unidad.Nombre,
                            OrganoServicio_CID = UserData.OrganoServicio.CID,
                            OrganoServicio_Nombre = UserData.OrganoServicio.Nombre,
                            OrganoServicio_Abr = UserData.OrganoServicio.Abreviatura,
                            Rol_Accion = (UsuarioRolType) UserData.Rol.IntValue
                        };

                        // :Perfiles
                        int num_perfiles = (UserData.Perfiles != null) ? UserData.Perfiles.ToList().Count() : 1;
                        if (num_perfiles == 1)
                        {
                            // :Tiene un perfil => adiciona al ticket 
                            _dataTicket.Perfil_CID = UserData.Perfil.CID;
                            _dataTicket.Perfil_Nombre = UserData.Perfil.Nombre;
                        }

                        // :Serializa, encripta, genera la cookie y establece la sesión
                        string userData = serializer.Serialize(_dataTicket);
                        SessionHelper.AddUserToSession(Peach.EncriptText(userData));
                        
                        if (num_perfiles == 1)
                        {
                            // :Home
                            return RedirectToAction("Index", "Home");
                        }
                        else
                        {
                            // Redirecciona a la página para la selección de perfil
                            TempData["jJ0PG6Fk"] = UserData.Perfiles;
                            return RedirectToAction("Perfil", "Account");
                        }
                    }
                    else
                    {
                        AddToastMessage(string.Empty, responser.Mensaje, responser.TipoAlerta);
                        return View();
                    }
                }
                else
                {
                    AddToastMessage("Acceso no permitido", "Sus credenciales de acceso no son válidas", BootstrapAlertType.danger);
                    return View();
                }
            }
            catch (Exception ex)
            {
                AddToastMessage("Error", ex.Message, BootstrapAlertType.danger);
            }

            return View();
        }


        [AllowAnonymous]
        [HttpGet]
        public ActionResult Signup()
        {
            SignUpViewModel model = new SignUpViewModel();
            SelectListItem NingunOSE = new SelectListItem { Text = "- NINGUNO - ", Value = Peach.EncriptText("0") };
            List<SelectListItem> IOrganosServicio = new List<SelectListItem>();
            IOrganosServicio.Add(NingunOSE);
            IOrganosServicio.AddRange(new SelectList(
                new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));

            model.OrganosDeServicio = IOrganosServicio;
            return View(model);
        }


        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Signup(SignUpViewModel model)
        {
            try
            {
                var usr = model.Usuario;
                int ose = Convert.ToInt16(Peach.DecriptText(model.Usuario.OrganoServicio.CID));

                if (ose == 0)
                {
                    model.OrganosDeServicio = GetOrganosServicio();
                    AddToastMessage(string.Empty, "Debe seleccionar un Órgano de Servicio.", BootstrapAlertType.danger);
                    return View(model);
                }
                else if (!model.Usuario.Email.ToUpper().Contains("@RREE.GOB.PE"))
                {
                    model.OrganosDeServicio = GetOrganosServicio();
                    AddToastMessage(string.Empty, "Debe ingresar su correo institucional incluido @RREE.GOB.PE", BootstrapAlertType.danger);
                    return View(model);
                }
                else
                {
                    var arr_user = model.Usuario.Email.Split('@');
                    var lanusr = arr_user[0];

                    model.Usuario.Apellidos = model.Usuario.Apellidos.Trim().ToUpper();
                    model.Usuario.Nombres = model.Usuario.Nombres.Trim().ToUpper();
                    model.Usuario.Email = model.Usuario.Email.Trim().ToUpper();
                    model.Usuario.Login = new BELogin
                    {
                        user = lanusr.ToUpper(),
                        pass = Peach.EncriptText(Crypto.CryptoProvider.TripleDES, "Z")
                    };

                    model.Usuario.OrganoServicio = new BEOrganoServicio { Id = ose };
                    model.Usuario.RowAudit = new IRowAudit
                    {
                        IUsr = 1,
                        IP = Common.PageUtility.GetUserIpAddress()
                    };

                    ResponserData oResponse = new BLUsuario().GrabarSolicitud(model.Usuario);
                    if (oResponse.Estado == ResponserEstado.Ok)
                    {
                        AddToastMessage(string.Empty, oResponse.Mensaje, oResponse.TipoAlerta);
                        return View("Login");
                    }
                    else
                    {
                        model.OrganosDeServicio = GetOrganosServicio();
                        AddToastMessage(string.Empty, oResponse.Mensaje, oResponse.TipoAlerta);
                        return View(model);
                    }
                }
            }
            catch (Exception ex)
            {
                AddToastMessage(string.Empty, ex.Message, BootstrapAlertType.danger);
                return View("Login");
            }
        }


        /// <summary>
        /// Muestra el selector de perfiles
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Authorize]
        public ActionResult Perfil()
        {
            try
            {
                if (TempData["jJ0PG6Fk"] != null)
                {
                    PerfilLoginModel model = new PerfilLoginModel();
                    var _Perfiles = (List<BEPerfil>)TempData["jJ0PG6Fk"];
                    model.Perfiles = _Perfiles.Select(p => new SelectListItem { Value = p.CID, Text = p.Nombre }).ToList();
                    return View(model);
                }
                else
                {
                    return RedirectToAction("Login", "Account", new { m = "TempDataNull" });
                }
            }
            catch (Exception ex)
            {
                return RedirectToAction("Login", "Account", new { m = "ErrorCatch", e = ex.Message });
            }
        }


        /// <summary>
        /// Procesa el selector de perfiles
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public ActionResult Perfil(PerfilLoginModel model)
        {
            if (ModelState.IsValid)
            {
                // Ticket de cookie
                CustomPrincipalTicket _dataTicket = new CustomPrincipalTicket
                {
                    CID = User.CID,
                    Usuario = User.Usuario,
                    Unidad_Nombre = User.Unidad_Nombre,
                    OrganoServicio_CID = User.OrganoServicio_CID,
                    OrganoServicio_Nombre = User.OrganoServicio_Nombre,
                    OrganoServicio_Abr = User.OrganoServicio_Abr,
                    Rol_Accion = User.Rol_Accion,
                    Perfil_CID = model.Perfil.CID,
                    Perfil_Nombre = model.SelectPerfil
                };

                SessionHelper.DestroyUserSession();
                
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                string userData = serializer.Serialize(_dataTicket);
                SessionHelper.AddUserToSession(Peach.EncriptText(userData));
            }
            else
            {
                AddToastMessage("Error", "El modelo de datos de seleccion de perfil no es válido", BootstrapAlertType.danger);
            }

            return RedirectToAction("Index", "Home");
        }


        /// <summary>
        /// Devuelve el menu de opciones personalizado según el perfil del usuario. Los parámetros controlador y método retroalimentan el menu
        /// de modo tal que permita establecer el elemento seleccionado.
        /// </summary>
        /// <param name="selectController">Controlador seleccionado</param>
        /// <param name="selectMethod">Método seleccionado</param>
        /// <returns></returns>
        [Authorize]
        [ChildActionOnly]
        public PartialViewResult GetCustomMenu(string selectController, string selectMethod)
        {
            CustomMenuModel model = new CustomMenuModel();

            if (Request.IsAuthenticated)
            {
                try
                {
                    if (User.CID != null)
                    {
                        // Obtener el perfil del usuario
                        var IdPerfil = Convert.ToInt16(Peach.DecriptText(User.Perfil_CID));

                        model.ItemsMenu = new BLMenu().getMenu_byPerfil(IdPerfil).Where(e => e.IsVisible.IntValue == 1).ToList();
                        model.selectController = (selectController != null) ? selectController : string.Empty;
                        model.selectMethod = (selectMethod != null) ? selectMethod : string.Empty;
                    }
                    else
                    {
                        AddToastMessage(string.Empty, "Su sesión expiró. Ingrese nuevamente a la aplicación.", BootstrapAlertType.danger);
                    }
                }
                catch (Exception ex)
                {
                    AddToastMessage(string.Empty, ex.Message, BootstrapAlertType.danger);
                }
            }
            else
            {
                AddToastMessage(string.Empty, "Su sesión expiró. Ingrese nuevamente a la aplicación.", BootstrapAlertType.danger);
            }
            return PartialView("_CustomMenu", model);
        }


        /// <summary>
        /// Cierra la sesión
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult LogOut()
        {
            FormsAuthentication.SignOut();
            //Session.Abandon();

            //var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, string.Empty) { Expires = DateTime.Now.AddYears(-1) };
            //Response.Cookies.Add(authCookie);

            //var sessionCookie = new HttpCookie("ASP.NET_SessionId", string.Empty) { Expires = DateTime.Now.AddYears(-1) };
            //Response.Cookies.Add(sessionCookie);

            Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
            Response.Expires = -1500;
            Response.CacheControl = "no-cache";

            //FormsAuthentication.RedirectToLoginPage();
            return RedirectToAction("Login", "Account");
        }


        /// <summary>
        /// Devuelve la lista de organos de servicio exterior.
        /// 
        /// </summary>
        /// <returns></returns>
        /// TODO: Factorizar el  método en la capa de negocios
        public List<SelectListItem> GetOrganosServicio()
        {
            SelectListItem NingunOSE = new SelectListItem { Text = "- OFICINA LIMA - ", Value = Peach.EncriptText("0") };
            List<SelectListItem> IOrganosServicio = new List<SelectListItem>();
            IOrganosServicio.Add(NingunOSE);
            IOrganosServicio.AddRange(new SelectList(
                new BLOrganoServicio().Listar_ToSelect(OrganosServicioType.Todos), "CID", "Abreviatura"));
            return IOrganosServicio;
        }
    }
}