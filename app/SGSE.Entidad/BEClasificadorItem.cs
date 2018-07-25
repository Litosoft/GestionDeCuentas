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
    /// Items del clasificador de gasto
    /// </summary>
    public class BEClasificadorItem : AbstractEntityBase
    {
        /// <summary>
        /// Nombre del Item
        /// </summary>
        public string Nombre { get; set; }

        /// <summary>
        /// Código de la clase
        /// </summary>
        public string CodigoClase { get; set; }

        /// <summary>
        /// Item superior
        /// </summary>
        public int ItemSuperior { get; set; }

        /// <summary>
        /// Nivel del item
        /// </summary>
        public int Nivel { get; set; }

        /// <summary>
        /// Tipo de Item (0 - Generica / 1 - Específica)
        /// </summary>
        public ItemGenerico Tipo { get; set; }

        /// <summary>
        /// Indica si el item corresponde a un grupo (optgroup)
        /// </summary>
        public ItemGenerico EsGrupo { get; set; }

        /// <summary>
        /// Indica si el item es deducible como caja chica.
        /// </summary>
        public ItemGenerico EsCajaChica { get; set; }

    }
}
