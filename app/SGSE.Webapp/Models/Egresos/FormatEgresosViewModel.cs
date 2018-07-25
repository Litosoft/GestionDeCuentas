using SGSE.Entidad;
using System.Collections.Generic;
using System.Web.Mvc;

namespace SGSE.Webapp.Models.Egresos
{
    public class FormatEgresosViewModel
    {
        public FormatEgresosViewModel()
        {
            this.CuentasOse = new List<SelectListItem>();
            this.Proveedores = new List<SelectListItem>();
            this.ItemsClasificador = new List<BEClasificadorItem>();
            this.ItemsFormaPago = new List<SelectListItem>();
            this.ItemsDestinoGasto = new List<SelectListItem>();
            this.ItemsProgramasPoliticos = new List<SelectListItem>();
        }

        /// <summary>
        /// Número máximo de registro
        /// </summary>
        public int MaxRegistro { get; set; }
        
        /// <summary>
        /// Cuentas de cargo del organo de servicio
        /// </summary>
        public IEnumerable<SelectListItem> CuentasOse { get; set; }

        /// <summary>
        /// Proveedores del Órgano de Servicio Exterior
        /// </summary>
        public IEnumerable<SelectListItem> Proveedores { get; set; }

        /// <summary>
        /// Items del clasificador de gasto
        /// </summary>
        public IEnumerable<BEClasificadorItem> ItemsClasificador { get; set; }

        /// <summary>
        /// Items de las formas de pago
        /// </summary>
        public IEnumerable<SelectListItem> ItemsFormaPago { get; set; }

        /// <summary>
        /// Items del destino del gasto
        /// </summary>
        public IEnumerable<SelectListItem> ItemsDestinoGasto { get; set; }

        /// <summary>
        /// Programas de Política Exterior
        /// </summary>
        public IEnumerable<SelectListItem> ItemsProgramasPoliticos { get; set; }

    }
}