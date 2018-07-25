using System;

namespace SGSE.Entidad.Primitivos
{
    /// <summary>
    /// Maneja los datos de auditoria por registro
    /// </summary>
    public class IRowAudit
    {
        /// <summary>
        /// Id del Usuario
        /// </summary>
        public short IUsr { get; set; }
        

        /// <summary>
        /// Usuario del aplicativo
        /// </summary>
        public string Usuario { get; set; }


        /// <summary>
        /// IP de acceso
        /// </summary>
        public string IP { get; set; }

        /// <summary>
        /// Fecha de Acceso
        /// </summary>
        public string Fecha { get; set; }


        public string Log { get; set; }
    }
}
