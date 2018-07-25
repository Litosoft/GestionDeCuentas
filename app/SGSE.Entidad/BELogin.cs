using System;

namespace SGSE.Entidad
{
    /// <summary>
    /// Modelo de acceso a la aplicación
    /// </summary>
    [Serializable]
    public class BELogin
    {
        /// <summary>
        /// nombre de usuario
        /// </summary>
        public string user { get; set; }

        /// <summary>
        /// contraseña
        /// </summary>
        public string pass { get; set; }

        /// <summary>
        /// Mantener la sesión iniciada
        /// </summary>
        public bool sess { get; set; }
    }
}
