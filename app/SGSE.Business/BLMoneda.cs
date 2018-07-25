using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLMoneda : IDisposable
    {
        private DAMoneda DA = null;

        public BLMoneda()
        {
            DA = new DAMoneda();
        }


        /// <summary>
        /// Devuelve las monedas vinculadas a la locación de un Órgano de Servicio
        /// </summary>
        /// <param name="id">Id del Organo de Servicio</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_Select_byOSE(int id)
        {
            try
            {
                return DA.Listar_Select_byOSE(id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve las monedas vinculadas al pais del personal local
        /// </summary>
        /// <param name="id">Id del Personal Local</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_Select_byPL(int id)
        {
            try
            {
                return DA.Listar_Select_byPL(id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Devuelve todos las monedas para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEMoneda> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            try
            {
                return DA.Listar_toDataTables(pageNumber, pageRows, search, sort, dir, ref totalRows);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de una moneda según su id
        /// </summary>
        /// <param name="id">Id de la moneda</param>
        /// <returns>BEMoneda</returns>
        public BEMoneda Listar_byId(int id)
        {
            try
            {
                return DA.Listar_byId(id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba o actualiza los datos de una moneda
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEMoneda model)
        {
            try
            {
                return DA.Grabar(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve las monedas vinculadas a un país
        /// </summary>
        /// <param name="id">Id del Pais</param>
        /// <returns>IEnumerables Moneda</returns>
        public IEnumerable<BEMoneda> Listar_byPais(int id)
        {
            try
            {
                return DA.Listar_byPais(id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todas las monedas registradas en la aplicación
        /// </summary>
        /// <returns>IEnumerable BEPais</returns>
        public IEnumerable<BEMoneda> Listar()
        {
            try
            {
                return DA.Listar();
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
