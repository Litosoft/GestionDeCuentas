using SGSE.Data;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLUnidadOrganica : IDisposable
    {
        private DAUnidadOrganica DA = null;

        public BLUnidadOrganica()
        {
            DA = new DAUnidadOrganica();
        }

        /// <summary>
        /// Devuelve todos las unidades orgánicas para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEUnidad> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            try
            {
                return DA.Listar_toDataTables(pageNumber, pageRows, search, sort, dir, ref totalRows);
            }
            catch(Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>Devuelve los datos de una unidad orgánica</summary>
        public BEUnidad Listar_byId(int id)
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

        /// <summary>Devuelve todas las unidades orgánicas </summary>
        public IEnumerable<BEUnidad> Listar()
        {
            try
            {
                return DA.Listar();
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
