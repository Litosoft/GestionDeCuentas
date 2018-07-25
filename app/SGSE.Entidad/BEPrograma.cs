using SGSE.Entidad.Abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEPrograma : AbstractEntityBase
    {
        public string Nombre { get; set; }

        public string Abreviatura { get; set; }
    }
}
