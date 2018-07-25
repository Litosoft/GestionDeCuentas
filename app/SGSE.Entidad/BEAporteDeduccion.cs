using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEAporteDeduccion : AbstractEntityBase
    {
        public ItemGenerico Contrato { get; set; }

        public ItemGenerico Concepto { get; set; }

        public string Descripcion { get; set; }

        public ItemGenerico Operacion { get; set; }
        
        public ItemGenerico Afectacion { get; set; }

        public ItemGenerico TipoAfectacion { get; set; }

        public string MontoAfectacion { get; set; }

    }
}
