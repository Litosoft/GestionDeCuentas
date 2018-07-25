using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.Usuario
{
    [Serializable]
    public class UsuarioViewModel
    {
        public IEnumerable<SelectListItem> UnidadesOrganicas { get; set; }

        /// <summary>Organos de Servicio</summary>
        public IEnumerable<SelectListItem> OrganosServicio { get; set; }

        /// <summary>Paises</summary>
        public IEnumerable<SelectListItem> Paises { get; set; }

        /// <summary>Perfiles</summary>
        public IEnumerable<SelectListItem> Perfiles { get; set; }

        /// <summary>
        /// Roles
        /// </summary>
        public IEnumerable<SelectListItem> Roles { get; set; }
    }
}