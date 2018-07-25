using SGSE.Webapp.App_Base;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class ErrorController : BaseController
    {
        // GET: Error
        public ActionResult NotFound()
        {
            var _Url = Request.QueryString["aspxerrorpath"];
            ViewBag.Url = _Url;
            return View();
        }

        public ActionResult ServerError()
        {
            return View();
        }
    }
}