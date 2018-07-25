using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEDocumento: AbstractEntityBase
    {
        /// <summary>
        ///  Tipo (Memo, Cable, RM)
        /// </summary>
        public ItemGenerico TipoDocumento { get; set; }

        /// <summary>
        /// Numero de documento
        /// </summary>
        public string Numero { get; set; }

        /// <summary>
        /// Fecha
        /// </summary>
        public string Fecha { get; set; }

        /// <summary>
        /// Observación
        /// </summary>
        public string Observacion { get; set; }
    }
}
