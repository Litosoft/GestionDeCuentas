using SGSE.Entidad.Enumeradores;
using System;

namespace SGSE.Entidad.Responsers
{
    /// <summary>
    /// Objeto de respuesta de capa de datos a web
    /// </summary>
    [Serializable]
    public class ResponserData
    {
        /// <summary>
        /// Código sin encriptar
        /// </summary>
        public int XID { get; set; }
        
        /// <summary>
        /// Codigo encriptado (Utilizado en algunas rutinas)
        /// </summary>
        public string CID { get; set; }
        
        /// <summary>
        /// Data contenido
        /// </summary>
        public object DataContent { get; set; }

        /// <summary>
        /// Mensaje de respuesta
        /// </summary>
        public string Mensaje { get; set; }

        /// <summary>
        /// Estado de la operacion
        /// </summary>
        public ResponserEstado Estado { get; set; }

        /// <summary>
        /// Tipo de alerta bootstrap
        /// </summary>
        public BootstrapAlertType TipoAlerta { get; set; }
    }
}
