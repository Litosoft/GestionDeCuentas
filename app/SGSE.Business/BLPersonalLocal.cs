using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Reportes;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;

namespace SGSE.Business
{
    /// <summary>
    /// Capa de Negocio
    /// </summary>
    public class BLPersonalLocal : IDisposable
    {
        private DAPersonalLocal DA = null;

        public BLPersonalLocal()
        {
            DA = new DAPersonalLocal();
        }


        #region Listas de Personal hacia el DT

        /// <summary>
        /// Devuelve la lista del personal local, para el usuario administrador hacia el DataTable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPersonalLocal_DTAdmin> Listar_byAdm_ToDT(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            try
            {
                return DA.Listar_byAdm_ToDT(pageNumber, pageRows, search, sort, dir, ref totalRows);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Devuelve la lista del personal para el usuario de mision
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="flt">Id del OSE</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEPersonalLocal> Listar_byOSE_ToDT(int pageNumber, int pageRows, string search, int sort, string dir, int flt, ref int totalRows)
        {
            try
            {
                return DA.Listar_byOSE_ToDT(pageNumber, pageRows, search, sort, dir, flt, ref totalRows);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion


        /// <summary>
        /// Devuelve el personal directivo de una mision (diplomaticos y administrativos lima)
        /// </summary>
        /// <param name="id">Id de la cuenta corriente</param>
        /// <returns>BECuentaCorriente</returns>
        public IEnumerable<BEPersonalLocal> Listar_Directivo_toSelect_byOse(int id)
        {
            try
            {
                return DA.Listar_Directivo_toSelect_byOse(id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Lista los datos de un personal de servicio exterior por su id
        /// </summary>
        /// <param name="sid">Id del personal de servicio exterior</param>
        /// <returns></returns>
        public BEPersonalLocal Listar_byID(int sid)
        {
            try
            {
                return DA.Listar_byID(sid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        /// <summary>
        /// Devuelve la lista de aportes y descuentos para el trabajador del OSE
        /// </summary>
        /// <param name="IdContrato"></param>
        /// <returns></returns>
        public IEnumerable<BEAporteDeduccion> Listar_AportesDescuentos(int IdContrato)
        {
            try
            {
                return DA.Listar_AportesDescuentos(IdContrato);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Graba o actualiza los datos de un trabajador local
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPersonalLocal model)
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
        /// Graba o actualiza los datos del contrato de un trabajador 
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarContrato(BEPersonalLocal model)
        {
            try
            {
                return DA.GrabarContrato(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Esporta todos los datos del personal local
        /// </summary>
        /// <returns></returns>
        public IEnumerable<RPPersonal> ExportarPersonalLocal(int sid = 0)
        {
            try
            {
                return DA.ExportarPersonalLocal(sid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Lista simple de contratos
        /// </summary>
        /// <param name="sid">Id del personal</param>
        /// <returns></returns>
        public IEnumerable<ItemGenerico> ListarContratos(int sid)
        {
            try
            {
                return DA.ListarContratos(sid);
            }
            catch (Exception ex)
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
