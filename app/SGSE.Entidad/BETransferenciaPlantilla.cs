using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BETransferenciaPlantilla
    {
        /// <summary>
        /// Entidad responsable por la transacción
        /// </summary>
        public ItemGenerico Entidad { get; set; }

        /// <summary>
        /// Número de cuenta desde donde se origina la transacción
        /// </summary>
        public ItemGenerico CuentaOrigen { get; set; }

        /// <summary>
        /// Indica que codigo utilizara la plantilla como cuenta de destino
        /// </summary>
        public ItemGenerico TipoDestino { get; set; }

        /// <summary>
        /// Banco de la cuenta Intermedia
        /// </summary>
        public ItemGenerico Agencia { get; set; }

        /// <summary>
        /// Dato adicional de la cuenta intermedia (
        /// </summary>
        public string DatoAdicional { get; set; }

        /// <summary>
        /// Método de Ruteo del Banco Intermediario
        /// </summary>
        public ItemGenerico MetodoRuteo { get; set; }

        /// <summary>
        /// ID del Ruteo asociado al método de Ruteo
        /// </summary>
        public string CodigoRuteo { get; set; }

        /// <summary>
        /// Entidad subsidiaria solicitante del pago
        /// </summary>
        public ItemGenerico EntidadSolicitante { get; set; }

    }
}
