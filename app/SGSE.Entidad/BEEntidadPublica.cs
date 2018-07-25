using SGSE.Entidad.Abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    /// <summary>
    /// Entidad Publica de Gobierno
    /// </summary>
    public class BEEntidadPublica : AbstractEntityBase
    {
        public string Nombre { get; set; }

        public string Direccion1 { get; set; }

        public string Direccion2 { get; set; }

        public string Direccion3 { get; set; }

    }
}
