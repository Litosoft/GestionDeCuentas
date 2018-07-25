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
    /// <summary>
    /// Capa de negocio Perfil
    /// </summary>
    public class BLPerfil : IDisposable
    {
        DAPerfil DA = null;

        public BLPerfil()
        {
            DA = new DAPerfil();
        }

        /// <summary>
        /// Devuelve todos los perfiles de la aplicación
        /// </summary>
        /// <returns>Lista BEPerfil</returns>
        public List<BEPerfil> Listar()
        {
            try
            {
                return DA.Listar().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve un solo perfil de la aplicación
        /// </summary>
        /// <returns></returns>
        public BEPerfil Listar_byId(int Id)
        {
            try
            {
                return DA.Listar_byId(Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /// <summary>
        /// Valida el acceso al controlador/metodo segun el perfil ingresado
        /// </summary>
        /// <param name="idp">Id perfil</param>
        /// <param name="ctrl">Controlador</param>
        /// <param name="mtdo">Método</param>
        /// <returns></returns>
        public bool ValidaPermisoPerfil(int idp, string ctrl, string mtdo)
        {
            try
            {
                return DA.ValidaPermisoPerfil(idp, ctrl, mtdo);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los perfiles para el control select list
        /// </summary>
        /// <param name="Id">Id de usuario</param>
        /// <returns></returns>
        public IEnumerable<BEPerfil> Listar_ToSelect()
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
        /// Graba o actualiza los datos de un perfil
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEPerfil model)
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


        public void Dispose()
        {
            if (DA != null)
            {
                DA = null;
            }
        }
    }
}
