using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Reportes;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLCuentaCorriente : IDisposable
    {

        private DACuentaCorriente DA = null;

        public BLCuentaCorriente()
        {
            DA = new DACuentaCorriente();
        }

        /// <summary>
        /// Devuelve todos la cuentas corrientes para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, int flt, ref int totalRows)
        {
            try
            {
                return DA.Listar_toDataTables(pageNumber, pageRows, search, sort, dir, flt, ref totalRows);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de una cuenta corriente según su id
        /// </summary>
        /// <param name="id">Id de la cuenta corriente</param>
        /// <returns>BECuentaCorriente</returns>
        public BECuentaCorriente Listar_byId(int id)
        {
            try
            {
                return DA.Listar_byId(id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba o actualiza los datos de una cuenta corriente
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BECuentaCorriente model)
        {
            try
            {
                return DA.Grabar(model);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Actualiza la observacion de una cuenta corriente
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarObservacion(BECuentaCorriente model)
        {
            try
            {
                return DA.GrabarObservacion(model);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Esporta todos los datos de las cuentas
        /// </summary>
        /// <returns></returns>
        public IEnumerable<RPCuentasCorrientes> ExportarCuentas(int sid = 0)
        {
            try
            {
                return DA.ExportarCuentas(sid);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve las cuentas de cargo para el formato de egreso
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> ListarCuentasCargo(int sid_usr)
        {
            try
            {
                return DA.ListarCuentasCargo(sid_usr);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}
