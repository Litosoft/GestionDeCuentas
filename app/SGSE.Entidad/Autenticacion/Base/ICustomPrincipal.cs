using System.Security.Principal;

namespace SGSE.Entidad.Autenticacion
{
    /// <summary>
    /// Interfaz personalizada IPrincipal
    /// </summary>
    interface ICustomPrincipal : IPrincipal
    {
        /// <summary>
        /// Cipher ID
        /// </summary>
        string CID { get; set; }

        /// <summary>
        /// Usuario
        /// </summary>
        string Usuario { get; set; }

    }
}
