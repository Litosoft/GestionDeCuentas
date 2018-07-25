using SGSE.Entidad;
using SGSE.Entidad.Autenticacion;
using SGSE.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Script.Serialization;
using System.Web.Security;

namespace SGSE.Webapp
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_PostAuthenticateRequest(Object sender, EventArgs e)
        {
            HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);
                var data = Peach.DecriptText(authTicket.UserData);
                CustomPrincipalTicket _dataTicket = serializer.Deserialize<CustomPrincipalTicket>(data);
                CustomPrincipal CustomPrincipalLogin = new CustomPrincipal(authTicket.Name);

                CustomPrincipalLogin.CID = _dataTicket.CID;
                CustomPrincipalLogin.Usuario = _dataTicket.Usuario;

                CustomPrincipalLogin.Unidad_CID = _dataTicket.Unidad_CID;
                CustomPrincipalLogin.Unidad_Nombre = _dataTicket.Unidad_Nombre;

                CustomPrincipalLogin.OrganoServicio_CID = _dataTicket.OrganoServicio_CID;
                CustomPrincipalLogin.OrganoServicio_Nombre = _dataTicket.OrganoServicio_Nombre;
                CustomPrincipalLogin.OrganoServicio_Abr = _dataTicket.OrganoServicio_Abr;

                if (_dataTicket.Perfil_CID != null)
                {
                    CustomPrincipalLogin.Perfil_CID = _dataTicket.Perfil_CID;
                    CustomPrincipalLogin.Perfil_Nombre = _dataTicket.Perfil_Nombre;
                }

                HttpContext.Current.User = CustomPrincipalLogin;
            }
        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            //var session = System.Web.HttpContext.Current.Session;
            //if (session == null || string.IsNullOrWhiteSpace(session.SessionID)) return;

            //var userIsAuthenticated = User != null &&
            //    User.Identity != null &&
            //    User.Identity.IsAuthenticated;

            //if (userIsAuthenticated && !session.SessionID.Equals(Session["__MyAppSession"]))
            //{
            //    Logoff();
            //}

            //if (!userIsAuthenticated && session.SessionID.Equals(Session["__MyAppSession"]))
            //{
            //    ClearSession();
            //}
        }

        private void Logoff()
        {
            FormsAuthentication.SignOut();
            var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, string.Empty) { Expires = DateTime.Now.AddYears(-1) };
            Response.Cookies.Add(authCookie);
            FormsAuthentication.RedirectToLoginPage();
        }

        private void ClearSession()
        {
            Session.Abandon();
            var sessionCookie = new HttpCookie("cdx", string.Empty) { Expires = DateTime.Now.AddYears(-1) };
            Response.Cookies.Add(sessionCookie);
            FormsAuthentication.SignOut();
        }
    }
    
}
