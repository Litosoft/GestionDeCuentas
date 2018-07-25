using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;

namespace SGSE.Entidad
{
    /// <summary>
    /// Items que conforman el menu de la aplicación
    /// </summary>
    public class BEMenuItem : AbstractEntityBase
    {
        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        public string Controlador { get; set; }

        public string Metodo { get; set; }

        public string Parametro { get; set; }

        public string Url { get; set; }

        /// <summary>
        /// Icono Bootstrap (icon-*)
        /// </summary>
        public string Icono { get; set; }

        public int Orden { get; set; }

        public int Nivel { get; set; }

        public ItemGenerico IsPopup { get; set; }

        public ItemGenerico IsVisible { get; set; }

        public ItemGenerico IsAuth { get; set; }

        public ItemGenerico IsGrupo { get; set; }

        public ItemGenerico Padre { get; set; }

    }
}
