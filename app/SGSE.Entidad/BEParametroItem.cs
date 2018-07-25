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
    /// Grupo del parámetro
    /// </summary>
    public class BEParametroGrupo : AbstractEntityBase
    {
        /// <summary>
        /// Nombre del grupo
        /// </summary>
        public string Nombre { get; set; }

        /// <summary>
        /// Descripción del grupo
        /// </summary>
        public string Descripcion { get; set; }

    }

    /// <summary>
    /// Parametro (Encabezado)
    /// </summary>
    public class BEParametro : AbstractEntityBase
    {
        /// <summary>
        /// Nombre del parámetro
        /// </summary>
        public string Nombre { get; set; }

        /// <summary>
        /// Descripción
        /// </summary>
        public string Descripcion { get; set; }

        /// <summary>
        /// Grupo
        /// </summary>
        public BEParametroGrupo Grupo { get; set; }

        /// <summary>
        /// Detalle seleccionado
        /// </summary>
        public BEParametroItem Detalle { get; set; }

        /// <summary>
        /// Registros asociados al parametro
        /// </summary>
        public IEnumerable<BEParametroItem> Detalles { get; set; }
    }


    public class BEParametroItem : AbstractEntityBase
    {
        /// <summary>
        /// Texto del parámetro
        /// </summary>
        public string Texto { get; set; }

        /// <summary>
        /// Valor del parámetro
        /// </summary>
        public string Valor { get; set; }

        /// <summary>
        /// Mensaje de ayuda
        /// </summary>
        public string Ayuda { get; set; }

        /// <summary>
        /// Número de orden
        /// </summary>
        public int Orden { get; set; }

        /// <summary>
        /// Indica si el parametro es una agrupación
        /// </summary>
        public ItemGenerico IsGrupo { get; set; }
    }
}
