using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLClasificador : IDisposable
    {
        private DAClasificador DA = null;

        public BLClasificador()
        {
            DA = new DAClasificador();
        }

        /// <summary>
        /// Devuelve todos los items de gasto del clasificador vigente
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEClasificadorItem> ListarItemsGasto()
        {
            try
            {
                return DA.ListarItemsGasto();
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
