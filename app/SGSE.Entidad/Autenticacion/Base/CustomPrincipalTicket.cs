using System;

namespace SGSE.Entidad.Autenticacion
{
    /// <summary>
    /// Modelo serial del Custom Principal
    /// </summary>
    [Serializable]
    public class CustomPrincipalTicket
    {
        /// <summary> CID del Usuario </summary>
        public string CID { get; set; }

        /// <summary> Apellidos y Nombres </summary>
        public string Usuario { get; set; }

        /// <summary>CID del Órgano de Servicio</summary>
        public string OrganoServicio_CID { get; set; }

        /// <summary>Nombre</summary>
        public string OrganoServicio_Nombre { get; set; }

        /// <summary>Abreviatura</summary>
        public string OrganoServicio_Abr { get; set; }

        /// <summary>CID de la Unidad</summary>
        public string Unidad_CID { get; set; }

        /// <summary>Nombre de unidad</summary>
        public string Unidad_Nombre { get; set; }

        /// <summary>CID del Perfil</summary>
        public string Perfil_CID { get; set; }

        /// <summary>Nombre del perfil</summary>
        public string Perfil_Nombre { get; set; }
        
        /// <summary>Rol (0: Registrador, 1: Autorizador)</summary>
        public UsuarioRolType Rol_Accion { get; set; }
    }
}
