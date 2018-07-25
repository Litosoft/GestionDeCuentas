using SGSE.Entidad.Componentes;
using SGSE.Webapp.App_Base;
using System.Linq;
using System.Web.Mvc;

namespace Parqueo.Webapp.App_Filters
{
    public class MessagesActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            BaseController controller = filterContext.Controller as BaseController;
            if (filterContext.Result.GetType() == typeof(ViewResult))
            {
                if (controller.Toastr != null && controller.Toastr.ToastMessages.Count() > 0)
                {
                    controller.ViewData["Toastr"] = controller.Toastr;
                }
            }
            else if (filterContext.Result.GetType() == typeof(RedirectToRouteResult))
            {
                if (controller.Toastr != null && controller.Toastr.ToastMessages.Count() > 0)
                {
                    controller.TempData["Toastr"] = controller.Toastr;
                }
            }

            base.OnActionExecuted(filterContext);
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            BaseController controller = filterContext.Controller as BaseController;
            if (controller != null)
                controller.Toastr = (controller.TempData["Toastr"] as Toastr)
                                     ?? new Toastr();

            base.OnActionExecuting(filterContext);
        }
    }
}