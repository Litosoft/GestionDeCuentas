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
    public class BLBanco : IDisposable
    {
        private DABanco DA = null;

        public BLBanco()
        {
            DA = new DABanco();
        }

        //: Banco

        /// <summary>
        /// Devuelve todos los bancos para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public IEnumerable<BEBanco> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
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
        /// Devuelve los datos de un banco según su id
        /// </summary>
        /// <param name="id">Id del banco</param>
        /// <returns>BEBanco</returns>
        public BEBanco Listar_byId(int id)
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
        /// Graba o actualiza los datos de un banco
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEBanco model)
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

        //: Agencias

        /// <summary>
        /// Devuelve todas las agencias bancarias asociadas a un banco o solo una.
        /// </summary>
        /// <param name="idb">Id banco</param>
        public IEnumerable<BEAgenciaBancaria> ListarAgencias(int idb)
        {
            try
            {
                return DA.ListarAgencias(idb);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba o actualiza los datos de una agencia bancaria
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData GrabarAgencia(BEBanco model)
        {
            try
            {
                return DA.GrabarAgencia(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de una agencia especificada por su Id.
        /// </summary>
        /// <param name="ida">Id agencia</param>
        public BEAgenciaBancaria ListarAgencia(int ida)
        {
            try
            {
                return DA.ListarAgencia(ida);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve las agencias bancarias asociadas a un organo de servicio
        /// </summary>
        /// <param name="sid">Id de agencia bancaria</param>
        public IEnumerable<BEAgenciaBancaria> ListarAgencia_ToSelect_ByOse(int sid)
        {
            try
            {
                return DA.ListarAgencia_ToSelect_ByOse(sid);
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }

        //: Selector agencias de bancos intermedios
        /// <summary>
        /// Devuelves todas las agencias de uso intermedio para transferencias bancarias.
        /// </summary>
        public IEnumerable<BEAgenciaBancaria> ListarAgencias_BancoIntermedios_toSelect()
        {
            try
            {
                return DA.ListarAgencias_BancoIntermedios_toSelect();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        #region Reportes

        /// <summary>
        /// Devuelve todos los bancos y agencias para un reporte en excel
        /// </summary>
        public IEnumerable<BancoAgenciaXls> ExpBancoAgencia()
        {
            try
            {
                return DA.ExpBancoAgencia();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Devuelve todos los bancos, agencias, cuentas y misiones para un reporte en excel
        /// </summary>
        public IEnumerable<BancoCuentaMisionXls> ExpBancoAgenciaCuentaMision()
        {
            try
            {
                return DA.ExpBancoAgenciaCuentaMision();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        #endregion


        public void Dispose()
        {
            if (DA != null)
            {
                DA = null;
            }
        }
    }
}
