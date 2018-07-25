using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Autenticacion;
using SGSE.Entidad.Componentes;
using SGSE.Entidad.Enumeradores;
using SGSE.Security;
using System;
using System.Web.Mvc;
using System.Web.Security;

namespace SGSE.Webapp.App_Base
{
    /// <summary>Controlador base para el manejo del custom principal y mensajes toast</summary>
    [Serializable]
    public class BaseController : Controller
    {
        /// <summary>Manejador de mensajes</summary>
        public Toastr Toastr { get; set; }

        /// <summary>Constructor</summary>
        public BaseController()
        {
            Toastr = new Toastr();
        }

        /// <summary>Usuario</summary>
        protected virtual new CustomPrincipal User
        {
            get { return HttpContext.User as CustomPrincipal; }
        }

        /// <summary>Adiciona un mensaje al contenedor principal de mensajes</summary>
        /// <param name="title">Titulo</param>
        /// <param name="message">Mensaje</param>
        /// <param name="Type">Tipo</param>
        /// <param name="isSticky">Indica si el mensaje permanece visible</param>
        public ToastMessage AddToastMessage(string title, string message, BootstrapAlertType Type, bool isSticky = false)
        {
            ToastType TipoToast = ToastType.Success;

            switch (Type)
            {
                case BootstrapAlertType.info:
                    TipoToast = ToastType.Info; break;

                case BootstrapAlertType.warning:
                    TipoToast = ToastType.Warning; break;

                case BootstrapAlertType.danger:
                    TipoToast = ToastType.Error; break;
            }

            return Toastr.AddToastMessage(title, message, TipoToast, isSticky);
        }

        /// <summary>
        /// Valida si el usuario tiene permisos para acceder al método y controlador
        /// </summary>
        /// <returns></returns>
        public bool IsPermitido()
        {
            if (User.CID != null)
            {
                var _perfil = Peach.DecriptText(User.Perfil_CID);

                bool _IsPermitido = new BLPerfil().ValidaPermisoPerfil(Convert.ToInt16(_perfil),
                    this.Controlador(), this.Metodo());

                if (!_IsPermitido)
                    AddToastMessage(string.Empty, "No tiene los permisos necesarios para acceder a esta opción.", BootstrapAlertType.danger);

                return _IsPermitido;
            }
            else
            {
                RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
                return false;
            }
        }

        /// <summary>
        /// Devuelve el controlador
        /// </summary>
        /// <returns></returns>
        public string Controlador()
        {
            //return this.ControllerContext.RouteData.Values["controller"].ToString();
            return string.Empty;
        }

        /// <summary>
        /// Devuelve el método
        /// </summary>
        /// <returns></returns>
        public string Metodo()
        {
            //return this.ControllerContext.RouteData.Values["action"].ToString();
            return string.Empty;
        }

    }
}
