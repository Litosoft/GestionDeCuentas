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
    public class BLPais : IDisposable
    {
        private DAPais DA = null;

        public BLPais()
        {
            DA = new DAPais();
        }


        /// <summary>
        /// Devuelve la lista completa de paises
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar()
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


        /// <summary>
        /// Devuelve la lista completa de paises para el control selector
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar_ToSelect()
        {
            try
            {
                return DA.Listar_ToSelect();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve la lista completa de paises para el control selector
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar_ToSelect_Base64()
        {
            try
            {
                return DA.Listar_ToSelect_Base64();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los paises para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPais> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
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
        /// Devuelve los datos de un Pais
        /// </summary>
        /// <param name="sid">Id del País</param>
        /// <returns></returns>
        public BEPais Listar_byId(int sid)
        {
            try
            {
                return DA.Listar_byId(sid);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba o actualiza los datos de un pais
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPais model)
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
        /// Devuelve las regiones asociadas a un continente registrados en la aplicación
        /// </summary>
        /// <returns>IEnumerable BERegion</returns>
        public IEnumerable<BERegion> Listar_Regiones_byContinente(int sid)
        {
            try
            {
                return DA.Listar_Regiones_byContinente(sid);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los continentes registrados en la aplicación
        /// </summary>
        /// <returns>IEnumerable BEContinente</returns>
        public IEnumerable<BEContinente> Listar_Continentes()
        {
            try
            {
                return DA.Listar_Continentes();
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
