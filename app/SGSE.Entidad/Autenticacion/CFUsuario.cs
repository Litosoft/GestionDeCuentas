using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Autenticacion
{
    [Serializable]
    public class CFUsuario
    {
        /// <summary>
        /// Nombres
        /// </summary>
        public string Nombres { get; set; }

        /// <summary>
        /// Apellidos
        /// </summary>
        public string Apellidos { get; set; }

        /// <summary>
        /// Correo electrónico
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// Teléfono
        /// </summary>
        public string Telefono { get; set; }

        /// <summary>
        /// Fecha de inicio de vigencia
        /// </summary>
        public string Desde { get; set; }

        /// <summary>
        /// Fecha de término de vigencia
        /// </summary>
        public string Hasta { get; set; }

        /// <summary>
        /// Indicador para cambiar contraseña
        /// </summary>
        public byte CambiarPwd { get; set; }

        /// <summary>
        /// Indicador si es usuario de dominio
        /// </summary>
        public byte IsDominio { get; set; }

        /// <summary>
        /// Logueo
        /// </summary>
        public CFLogin Login { get; set; }

        /// <summary>
        /// Rol
        /// </summary>
        public CFRol Rol { get; set; }

        /// <summary>
        /// Perfiles
        /// </summary>
        public IEnumerable<CFRol> Roles { get; set; }

        /// <summary>
        /// Accion (Autorizador, Registrador, Reporteador)
        /// </summary>
        public ItemGenerico Accion { get; set; }

        #region Custom 

        /// <summary>
        /// Unidad
        /// </summary>
        public BEUnidad Unidad { get; set; }

        /// <summary>
        /// Órgano de Servicio Exterior
        /// </summary>
        public BEOrganoServicio OrganoServicio { get; set; }

        /// <summary>
        /// País
        /// </summary>
        public BEPais Pais { get; set; }

        #endregion

    }
}
