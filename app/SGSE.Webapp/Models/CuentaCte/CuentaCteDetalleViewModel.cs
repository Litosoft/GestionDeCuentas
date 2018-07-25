using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.CuentaCte
{
    public class CuentaCteDetalleViewModel : AbstractBaseViewModel
    {
        public IEnumerable<SelectListItem> OrganosServicio { get; set; }

        public IEnumerable<SelectListItem> CodigosRuteo { get; set; }

        public IEnumerable<SelectListItem> DestinosCuenta { get; set; }

        public IEnumerable<SelectListItem> EntidadesPublicas { get; set; }

        public IEnumerable<SelectListItem> CuentasEntidad { get; set; }
        
        public IEnumerable<SelectListItem> AgenciasBancoIntermedio { get; set; }

        public IEnumerable<SelectListItem> CodigosRuteoIntermedio { get; set; }

        public BECuentaCorriente CuentaCorriente { get; set; }

        public IEnumerable<BEAuditoria> Auditoria { get; set; }

    }
}