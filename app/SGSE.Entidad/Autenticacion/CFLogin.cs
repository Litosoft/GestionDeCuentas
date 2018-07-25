using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Autenticacion
{
    /// <summary>
    /// Modelo de acceso a la aplicación
    /// </summary>
    [Serializable]
    public class CFLogin
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
