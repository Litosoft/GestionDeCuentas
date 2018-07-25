using SGSE.Entidad.Abstracts;
using System;
using System.Collections.Generic;

namespace SGSE.Entidad
{
    /// <summary>
    /// Entidad Perfil
    /// </summary>
    [Serializable]
    public class BEPerfil : AbstractEntityBase
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
        /// Opciones del menú asociadas al perfil
        /// </summary>
        public IEnumerable<BEMenuItem> OpcionesMenu { get; set; }
    }
}
