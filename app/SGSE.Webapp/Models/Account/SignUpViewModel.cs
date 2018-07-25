using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.Account
{
    public class SignUpViewModel
    {
        public BEUsuario Usuario { get; set; }

        public IEnumerable<SelectListItem> OrganosDeServicio { get; set; }
    }
}