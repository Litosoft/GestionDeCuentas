using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections;
using System.Collections.Generic;

namespace SGSE.Entidad.Autenticacion
{
    /// <summary>
    /// Módulo del aplicativo.
    /// </summary>
    [Serializable]
    public class CFModulo : AbstractEntityBase
    {
        public ItemGenerico Padre { get; set; }

        public string Icono { get; set; }

        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        public byte Orden { get; set; }

        public string Controlador { get; set; }

        public string Metodo { get; set; }

        public string Parametro { get; set; }

        public string URL { get; set; }

        public bool IsPopup { get; set; }

        public bool IsClicEvent { get; set; }

        public IEnumerable<CFPermiso> Permisos { get; set; }

        public CFPermiso Permiso { get; set; }
    }
}
