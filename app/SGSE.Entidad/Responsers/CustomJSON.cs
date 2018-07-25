using System;

namespace SGSE.Entidad.Responsers
{
    /// <summary>
    /// Estructura de datos para la devolución de solicitudes Ajax
    /// </summary>
    [Serializable]
    public class CustomJSON
    {
        /// <summary>
        /// Datos
        /// </summary>
        public object DATA { get; set; }

        /// <summary>
        /// Mensaje de error
        /// </summary>
        public string ERR { get; set; }
    }
}
