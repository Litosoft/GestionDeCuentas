using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLGasto : IDisposable
    {
        DAGasto DA = null;

        public BLGasto()
        {
            DA = new DAGasto();
        }

        /// <summary>
        /// Devuelve el maximo registro de gasto
        /// </summary>
        /// <param name="sid">Id del Órgano de Servicio</param>
        /// <returns></returns>
        public int Get_MaximoRegistroGasto(int sid)
        {
            try
            {
                return DA.Get_MaximoRegistroGasto(sid);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Devuelve lista de personal local para el registro de gastos
        /// </summary>
        /// <param name="sid">Id del OSE</param>
        /// <returns></returns>
        public List<BEPersonalLocal> Get_PersonalGasto(int sid)
        {
            try
            {
                return DA.Get_PersonalGasto(sid);
            }
            catch (Exception ex)
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
