using SGSE.Business;
using SGSE.Entidad.Enumeradores;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {
            /*
            if (SessionHelper.ExistUserInSession())
            {
                if (this.IsPermitido())
                {
                    var m = Request.QueryString["m"];
                    if (m != null)
                    {
                        if (m == "NoPermitido")
                        {
                            AddToastMessage("No Permitido", "Inentó acceder a una opción no permitida.", BootstrapAlertType.warning);
                        }
                    }
                    return View();
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
            }
            return View();
            */
           
            if (Request.IsAuthenticated)
            {
                if (this.IsPermitido())
                {
                    var m = Request.QueryString["m"];
                    if (m != null)
                    {
                        if (m == "NoPermitido")
                        {
                            AddToastMessage("No Permitido", "Inentó acceder a una opción no permitida.", BootstrapAlertType.warning);
                        }
                    }


                    return View();
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
            }
            return View(); 
        }

        public ActionResult About()
        {
            if (Request.IsAuthenticated)
            {
                if (this.IsPermitido())
                {
                    return View();
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
            }
        }

        public ActionResult Contact()
        {
            if (Request.IsAuthenticated)
            {
                if (this.IsPermitido())
                {
                    return View();
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
            }
            return View();
        }

        public ActionResult HelpUs()
        {
            if (Request.IsAuthenticated)
            {
                if (this.IsPermitido())
                {
                    ViewBag.Info = Peach.EncriptToBase64(new BLAuditoria().GetDBInfo());
                    return View();
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { m = "NotAuthenticated" });
            }
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult HelpUs(FormDataModel model)
        {
            ViewBag.Info = Peach.EncriptToBase64(new BLAuditoria().GetDBInfo());
            try
            {
                List<string> Lista = new BLHome().HelpUsExecute(model.TextAreaInput);
                if (Lista.Count == 0)
                {
                    AddToastMessage(string.Empty, "La consulta no devolvió registros.", BootstrapAlertType.info);
                }

                model.OutputList = Lista;
            }
            catch(Exception ex)
            {
                model.Error = ex.Message;
                AddToastMessage(string.Empty, ex.Message, BootstrapAlertType.danger);
            }

            return View(model);
        }

        public ActionResult Reglamento()
        {
            return View();
        }
    }

    public class FormDataModel
    {
        public string TextAreaInput { get; set; }

        public string TextAreaOutput { get; set; }

        public List<string> OutputList { get; set; }

        public string Error { get; set; }
    }
}