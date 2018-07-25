using SGSE.Entidad.Abstracts;

namespace SGSE.Entidad.Autenticacion
{
    public class CFRol : AbstractEntityBase
    {
        public string Nombre { get; set; }

        public string Abreviatura { get; set; }

        public string Descripcion { get; set; }
    }
}
