using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLEntidadPublica : IDisposable
    {
        private DAEntidadPublica DA = new DAEntidadPublica();

        public BLEntidadPublica()
        {
            DA = new DAEntidadPublica();
        }

        /// <summary>
        /// Devuelve todas las entidades publicas.
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEEntidadPublica> ListarEntidad_toSelect()
        {
            try
            {
                return DA.ListarEntidad_toSelect();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todas cuentas de una entidad publica
        /// </summary>
        /// <param name="id">id de la entidad</param>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> ListarEntidadCuentas_toSelect(int id)
        {
            try
            {
                return DA.ListarEntidadCuentas_toSelect(id);
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
