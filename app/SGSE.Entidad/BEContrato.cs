using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEContrato : AbstractEntityBase
    {
        public ItemGenerico TipoDocumento { get; set; }

        public ItemGenerico Referencia { get; set; }

        public string Numero { get; set; }

        public string FechaContrato { get; set; }

        public string FechaInicio { get; set; }

        public string FechaTermino { get; set; }

        public bool Indefinido { get; set; }

        public ItemGenerico Cargo { get; set; }

        public ItemGenerico Moneda { get; set; }

        public decimal RemuneracionBruta { get; set; }

        public string FechaInicioFuncion { get; set; }

        public string DocumentoAutorizacion { get; set; }

        public string FechaAutorizacion { get; set; }

        public ItemGenerico TipoContrato { get; set; }

        public string Observacion { get; set; }




    }
}
