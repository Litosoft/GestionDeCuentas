using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SGSE.Webapp.Models.Usuario
{
    public class UsuarioModel
    {
        /// <summary>
        /// Apellido
        /// </summary>
        public string ape { get; set; }

        /// <summary>
        /// Nombre
        /// </summary>
        public string nom { get; set; }

        /// <summary>
        /// Email
        /// </summary>
        public string mai { get; set; }

        /// <summary>
        /// Teléfono
        /// </summary>
        public string tel { get; set; }

        /// <summary>
        /// Usuario 
        /// </summary>
        public string usr { get; set; }

        /// <summary>
        /// Contraseña
        /// </summary>
        public string pwd { get; set; }

        /// <summary>
        /// Fecha inicio
        /// </summary>
        public string ini { get; set; }

        /// <summary>
        /// Fecha término
        /// </summary>
        public string fin { get; set; }

        /// <summary>Unidad Organica</summary>
        public string und { get; set; }

        /// <summary>País</summary>
        public string pai { get; set; }

        /// <summary>Órgano de servicio</summary>
        public string ose { get; set; }

        /// <summary>
        /// Indicador si es usuario de dominio
        /// </summary>
        public string dom { get; set; }

        /// <summary>
        /// Solicitar cambio de contraseña
        /// </summary>
        public string ses { get; set; }

        /// <summary>
        /// Estado
        /// </summary>
        public string est { get; set; }

        /// <summary>
        /// Perfil(es)
        /// </summary>
        public string[] per { get; set; }

        /// <summary>Rol (Registrador, Autorizador)</summary>
        public string rol { get; set; }

        /// <summary>
        /// Id
        /// </summary>
        public string sid { get; set; }
    }
}