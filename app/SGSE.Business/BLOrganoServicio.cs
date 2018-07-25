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
    public class BLOrganoServicio : IDisposable
    {
        private DAOrganoServicio DA = null;

        public BLOrganoServicio()
        {
            DA = new DAOrganoServicio();
        }

        /// <summary>
        /// Devuelve los datos de organos de servicio para un control select
        /// </summary>
        /// <param name="Tipo">0: Todos, [1-4] Tipos de Órganos de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_ToSelect(OrganosServicioType Tipo)
        {
            try
            {
                return DA.Listar_ToSelect(Tipo);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los organos de servicio para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
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


        /// <summary>
        /// Devuelve un órgano de servicio especificado por el Id
        /// </summary>
        /// <param name="IdOrganoServicio">Id principal</param>
        /// <returns></returns>
        public BEOrganoServicio Listar_byId(int Id)
        {
            try
            {
                return DA.Listar_byId(Id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los consulados disponibles en el pais del órgano de servicio
        /// </summary>
        /// <param name="IdOrganoServicio">[1-n] Órganos de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_JefaturaServicio_byOSE_ToSelect(int Id)
        {
            try
            {
                return DA.Listar_JefaturaServicio_byOSE_ToSelect(Id);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba/actualiza los datos de un órgano de servicio
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEOrganoServicio model)
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
        /// Devuelve los datos de una o de todas los organos de servicio por tipo y pais
        /// </summary>
        /// <param name="Tipo">0: Todos, [1-4] Tipos de Órganos de Servicio</param>
        /// <param name="Pais">[1-n] Códigos de país</param>
        /// <returns></returns>
        public IEnumerable<BEOrganoServicio> Listar_byTipoPais_ToSelect(OrganosServicioType Tipo, int IdPais)
        {
            try
            {
                return DA.Listar_byTipoPais_ToSelect(Tipo, IdPais);
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
