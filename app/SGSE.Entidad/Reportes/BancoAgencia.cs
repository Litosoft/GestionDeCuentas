using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Reportes
{
    public class BancoAgenciaXls
    {
        public BancoAgenciaXls() {
            Banco = string.Empty;
            Agencia = string.Empty;
            Domicilio1 = string.Empty;
            Domicilio2 = string.Empty;
            Tipo = string.Empty;
            Pais = string.Empty;
        }

        public string Banco { get; set; }
        public string Agencia { get; set; }
        public string Domicilio1 { get; set; }
        public string Domicilio2 { get; set; }
        public string Tipo { get; set; }
        public string Pais { get; set; }
        
    }

    public class BancoCuentaMisionXls : BancoAgenciaXls
    {
        public BancoCuentaMisionXls()
        {
            OrganoServicio = string.Empty;
            Cuenta = string.Empty;
        }

        public string OrganoServicio { get; set; }
        public string Cuenta { get; set; }

        public string Situacion { get; set; }
        
    }
}
