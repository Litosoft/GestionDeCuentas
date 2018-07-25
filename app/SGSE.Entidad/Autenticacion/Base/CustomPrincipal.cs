using System;
using System.Security.Principal;

namespace SGSE.Entidad.Autenticacion
{
    [Serializable]
    public class CustomPrincipal : ICustomPrincipal
    {
        #region Implementación de la Interfaz

        public CustomPrincipal(string Ticket)
        {
            Identity = new GenericIdentity(Ticket);
        }

        /// <summary> CID del Usuario </summary>
        public string CID { get; set; }

        /// <summary> Apellidos y Nombres </summary>
        public string Usuario { get; set; }

        /// <summary>IIdentity</summary>
        public IIdentity Identity { get; private set; }

        /// <summary>Rol</summary>
        /// <param name="role"></param>
        /// <returns></returns>
        public bool IsInRole(string role) { return false; }

        #endregion

        #region Implementaciones adicionales

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

        #endregion
    }
}
