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
    public class BLParametro : IDisposable
    {
        private DAParametro DA = null;

        public BLParametro()
        {
            DA = new DAParametro();
        }


        /// <summary>
        /// Devuelve los parametros segun el texto de su grupo
        /// </summary>
        /// <param name="Parametro"></param>
        /// <returns></returns>
        public IEnumerable<BEParametroItem> ListarItems_byGrupo(string Grupo)
        {
            try
            {
                return DA.ListarItems_byGrupo(Grupo);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Lista los items correspondientes a un parámetro especificado en el enumerador
        /// </summary>
        /// <param name="Parametro">Enumerador parámetro</param>
        /// <returns>Lista de items pertenecientes al parámetro</returns>
        public IEnumerable<BEParametroItem> ListarDetalle(Parametros Parametro)
        {
            try
            {
                return DA.ListarDetalle(Parametro);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Lista los grupos de los parámetros
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEParametroGrupo> ListarGrupo()
        {
            try
            {
                return DA.ListarGrupo();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Lista todos los parametros de la aplicación
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEParametro> Listar()
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
        /// Lista todos los detalles de los parametros de la aplicación
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public IEnumerable<BEParametroItem> ListarDetalle(BEParametro model)
        {
            try
            {
                return DA.ListarDetalle(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de un parametro
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public BEParametro Listar_byId(int id)
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
        /// Agrega/actualiza un parámetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEParametro model)
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
        /// Elimina un parámetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Eliminar(BEParametro model)
        {
            try
            {
                return DA.Eliminar(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Agrega/Actualiza un detalle
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData GrabarDetalle(BEParametro model)
        {
            try
            {
                return DA.GrabarDetalle(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de un detalle
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public BEParametroItem ListarDetalle_byId(BEParametro model)
        {
            try
            {
                return DA.ListarDetalle_byId(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Elimina un detalle del parámetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData EliminarDetalle(BEParametroItem model)
        {
            try
            {
                return DA.EliminarDetalle(model);
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
