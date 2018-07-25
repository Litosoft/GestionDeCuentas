using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BECuentaCorriente : AbstractEntityBase
    {
        public BEOrganoServicio OrganoServicio { get; set; }

        public string NumeroCuenta { get; set; }

        public BEMoneda Moneda { get; set; }

        public BEAgenciaBancaria Agencia { get; set; }

        public ItemGenerico CodigoRuteo { get; set; }

        public string Iban { get; set; }

        public string Swift { get; set; }

        public string ABA { get; set; }

        public string RIB{ get; set; }

        public string CBU { get; set; }

        public string BSB { get; set; }

        public string ABI { get; set; }

        public string CAB { get; set; }

        public ItemGenerico Destino { get; set; }

        public string FechaApertura { get; set; }

        public string FechaCierre { get; set; }

        public BEDocumento Documento { get; set; }

        public ItemGenerico Apoderado { get; set; }

        public ItemGenerico EsCompartida { get; set; }

        public string BeneficiarioNombre { get; set;  }

        public string BeneficiarioDir1 { get; set; }

        public string BeneficiarioDir2 { get; set; }


        public string BeneficiarioDir3 { get; set; }

        /// <summary>
        /// Plantilla de Transferencia
        /// </summary>
        public BETransferenciaPlantilla Plantilla { get; set; }

        public string Observacion { get; set; }
    }
    
}
