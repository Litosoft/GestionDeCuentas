using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLProveedor : IDisposable
    {
        private DAProveedor DA = null;

        public BLProveedor()
        {
            DA = new DAProveedor();
        }

        /// <summary>
        /// Devuelve la lista de proveedores de un organo de servicio para el control selector del formato de egreso
        /// </summary>
        /// <param name="sid_ose">Id del proveedor</param>
        /// <returns></returns>
        public IEnumerable<BEProveedor> Listarby_OSE(int sid_ose)
        {
            try
            {
                return DA.Listarby_OSE(sid_ose);
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
