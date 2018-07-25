using SGSE.Entidad;
using System;
using System.Collections.Generic;

namespace SGSE.Webapp.Models.Account
{
    /// <summary>
    /// Modelo del menu personalizado
    /// </summary>
    [Serializable]
    public class CustomMenuModel
    {
        /// <summary>
        /// Elementos del menú
        /// </summary>
        public List<BEMenuItem> ItemsMenu { get; set; }

        /// <summary>
        /// Contorlador seleccionado
        /// </summary>
        public string selectController { get; set; }

        /// <summary>
        /// Método seleccionado
        /// </summary>
        public string selectMethod { get; set; }
    }
}