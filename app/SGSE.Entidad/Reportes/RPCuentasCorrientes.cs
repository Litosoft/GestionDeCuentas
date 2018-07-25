using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Reportes
{
    /// <summary>
    /// Reporte 01. Cuentas Corrientes Datos Completoss
    /// </summary>
    public class RPCuentasCorrientes
    {
        public string OrganoServicio { get; set; }
        public string NumeroCuenta { get; set; }
        public string Moneda { get; set; }
        public string BancoAgencia { get; set; }
        public string SwiftBIC { get; set; }
        public string IBAN { get; set; }
        public string ABA { get; set; }
        public string RIB { get; set; }
        public string CBU { get; set; }
        public string BSB { get; set; }
        public string ABI { get; set; }
        public string CAB { get; set; }
        public string DestinoCuenta { get; set; }
        public string FechaApertura { get; set; }
        public string FechaCierre { get; set; }
        public string Autorizacion { get; set; }
        public string FechaAut { get; set; }
        public string Apoderado { get; set; }
        public string Beneficiario { get; set; }
        public string Domicilio1 { get; set; }
        public string Domicilio2 { get; set; }
        public string Domicilio3 { get; set; }
        public string TransferenciaCtaOrigen { get; set; }
        public string TransferenciaTpDestino { get; set; }
        public string TransferenciaBancoInt { get; set; }
        public string TransferenciaRuteoInt { get; set; }
        public string Observaciones { get; set; }
    }
}
