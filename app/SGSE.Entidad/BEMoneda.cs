using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    /// <summary>
    /// Entidad Moneda
    /// </summary>
    public class BEMoneda : AbstractEntityBase
    {
        public string Nombre { get; set; }

        public string Abreviatura { get; set; }

        public string SufijoContable { get; set; }

        public string Simbolo { get; set; }

        public string ISO4217 { get; set; }

        public ItemGenerico Asignable { get; set; }
    }
}
