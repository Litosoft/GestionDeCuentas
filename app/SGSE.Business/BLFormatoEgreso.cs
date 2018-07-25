using SGSE.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLFormatoEgreso : IDisposable
    {
        private DAFormatoEgreso DA = null;

        public BLFormatoEgreso()
        {
            DA = new DAFormatoEgreso();
        }

        /// <summary>
        /// Devuelve el maximo registro de formato de egreso
        /// </summary>
        /// <param name="sid">Id del Órgano de Servicio</param>
        /// <returns></returns>
        public int Listar_MaximoRegistro(int sid)
        {
            try
            {
                return DA.Listar_MaximoRegistro(sid);
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
