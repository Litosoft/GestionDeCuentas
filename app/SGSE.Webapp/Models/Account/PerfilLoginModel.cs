using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.Account
{
    public class PerfilLoginModel
    {
        public List<SelectListItem> Perfiles { get; set; }

        public BEPerfil Perfil { get; set; }

        public string SelectPerfil { get; set; }
    }
}