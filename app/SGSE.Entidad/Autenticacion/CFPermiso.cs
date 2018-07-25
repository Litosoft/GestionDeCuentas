using SGSE.Entidad.Primitivos;
using System;

namespace SGSE.Entidad.Autenticacion
{
    /// <summary>
    /// Permisos del aplicativo
    /// </summary>
    [Serializable]
    public class CFPermiso : Abstracts.AbstractEntityBase
    {
        public ItemGenerico Permiso { get; set; }

        public string Controlador { get; set; }

        public string MetodoJSON { get; set; }
    }
}
