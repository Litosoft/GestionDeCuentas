using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    [Serializable]
    public class BEUnidad : AbstractEntityBase
    {
        /// <summary>
        /// Nombre
        /// </summary>
        public string Nombre { get; set; }

        /// <summary>
        /// Abreviatura
        /// </summary>
        public string Abreviatura { get; set; }

        /// <summary>
        /// Descripción
        /// </summary>
        public string Descripcion { get; set; }

        /// <summary>
        /// Unidad Orgánica Superior
        /// </summary>
        public ItemGenerico UnidadSuperior { get; set; }
    }
}
