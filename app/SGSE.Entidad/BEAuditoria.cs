using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEAuditoria
    {
        public string Fecha { get; set; }

        public string  Elemento { get; set; }

        public string ValorAnterior { get; set; }

        public string ValorNuevo { get; set; }

        public string Registro { get; set; }

    }
}
