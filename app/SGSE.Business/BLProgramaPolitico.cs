using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLProgramaPolitico : IDisposable
    {
        private DAProgramaPolitico DA = null;

        public BLProgramaPolitico()
        {
            DA = new DAProgramaPolitico();
        }

        /// <summary>
        /// Devuelve la lista de los programas de política exterior según el Tipo de Órgano de Servicio
        /// </summary>
        /// <param name="Tipo">Tipo de Órgano de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEPrograma> Listar_byOSE(OrganosServicioType Tipo)
        {
            try
            {
                return DA.Listar_byOSE(Tipo);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public void Dispose()
        {
            if (DA != null)
            {
                DA = null;
            }
        }
    }
}
