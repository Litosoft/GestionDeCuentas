using SGSE.Entidad.Abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    /// <summary>
    /// Entidad Pais
    /// </summary>
    [Serializable]
    public class BEPais : AbstractEntityBase
    {
        public string Nombre { get; set; }
        public string Oficial { get; set; }
        public string Gentilicio { get; set; }
        public string M49 { get; set; }
        public string ISOA3 { get; set; }
        public BERegion Region { get; set; }

        //: Desnormalizacion EI
        public string Monedas_Asg { get; set; }
        public string Monedas_Lcl { get; set; }

        public IEnumerable<BEMoneda> Monedas { get; set; }

        public BEMoneda Moneda { get; set; }
    }
}
