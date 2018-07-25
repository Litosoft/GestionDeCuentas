using SGSE.Entidad.Abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEContinente : AbstractEntityBase
    {
        public string CodigoONU { get; set; }
        public string Nombre { get; set; }
    }
}
