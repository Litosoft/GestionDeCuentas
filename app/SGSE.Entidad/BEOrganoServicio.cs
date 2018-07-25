using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    [Serializable]
    public class BEOrganoServicio : AbstractEntityBase
    {

        public BEOrganoServicio()
        {
            TipoOrgano = new ItemGenerico();
            Pais = new BEPais();
            JefaturaServicio = new ItemGenerico();
        }

        public string Nombre { get; set; }
        
        /// <summary>
        /// Abreviatura del Órgano de Servicio
        /// </summary>
        public string Abreviatura { get; set; }

        /// <summary>
        /// Codigo utilizado en la generacion de planillas de transferencias
        /// </summary>
        public string CodigoInterop { get; set; }


        public BEPais Pais { get; set; }

        /// <summary>
        /// Tipo de Órgano de Servicio
        /// </summary>
        public ItemGenerico TipoOrgano { get; set; }


        public ItemGenerico JefaturaServicio { get; set; }

    }
}
