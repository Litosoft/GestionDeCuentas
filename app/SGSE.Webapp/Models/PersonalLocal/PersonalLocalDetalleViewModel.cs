using SGSE.Entidad;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SGSE.Webapp.Models.PersonalLocal
{
    public class PersonalLocalDetalleViewModel : AbstractBaseViewModel
    {
        public BEPersonalLocal PersonalLocal { get; set; }

        public IEnumerable<BEAporteDeduccion> Aportes { get; set; }

        public IEnumerable<BEAuditoria> Auditoria { get; set; }

        public IEnumerable<ItemGenerico> Contratos { get; set; }
    }
}