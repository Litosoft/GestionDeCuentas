using SGSE.Entidad;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.OrganoServicio
{
    public class OrganoServicioDetalleViewModel : AbstractBaseViewModel
    {
        public IEnumerable<SelectListItem> TiposOrganoServicio { get; set; }

        public IEnumerable<SelectListItem> Paises { get; set; }

        public BEOrganoServicio OrganoServicio { get; set; }

        public IEnumerable<SelectListItem> JefaturasServicio { get; set; }
    }
}