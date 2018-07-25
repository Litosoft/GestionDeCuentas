using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.DirectoryServices;
using System.Linq;

namespace SGSE.Business
{
    /// <summary>
    /// Capa de negocio Usuario
    /// </summary>
    public class BLUsuario : IDisposable
    {
        private DAUsuario DA = null;


        public BLUsuario()
        {
            DA = new DAUsuario();
        }

        /// <summary>
        /// Devuelve los datos de un usuario según sus credenciales de acceso
        /// </summary>
        /// <param name="usr">usuario</param>
        /// <param name="pwd">contraseña</param>
        /// <returns>BEUsuario object</returns>
        public ResponserData getUsuario_byLogin(string usr, string pwd)
        {
            try
            {
                return DA.getUsuario_byLogin(usr, pwd);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los usuarios para llenar el control datatable
        /// </summary>
        /// <param name="pageNumber">Número de página</param>
        /// <param name="pageRows">Cantidad de registros por página</param>
        /// <param name="search">Buscador</param>
        /// <param name="sort">Orden</param>
        /// <param name="dir">Dirección del orden</param>
        /// <param name="totalRows">Total de registros</param>
        /// <returns></returns>
        public List<BEUsuario> Listar_toDataTables(int pageNumber, int pageRows, string search, int sort, string dir, ref int totalRows)
        {
            try
            {
                return DA.Listar_toDataTables(pageNumber, pageRows, search, sort, dir, ref totalRows).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de un usuario
        /// </summary>
        /// <param name="Id">Id del usuario</param>
        /// <returns>Objeto Usuario</returns>
        public BEUsuario Listar_byId(int Id)
        {
            try
            {
                BEUsuario Usuario = DA.Listar_byId(Id); 
                Usuario.Perfiles = new DAPerfil().Listar_byUsuario(Id);

                return Usuario;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba/actualiza los datos de un usuario
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData Grabar(BEUsuario model)
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
        /// Graba las solicitudes de acceso al aplicativo
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ResponserData GrabarSolicitud(BEUsuario model)
        {
            try
            {
                return DA.GrabarSolicitud(model);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Valida el acceso por AD al usuario
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public static bool ValidaDominio(BELogin login)
        {
            try
            {
                var dominioConfig = ConfigurationManager.ConfigurationManager.GetActiveDirectory();

                DirectoryEntry rootDSE = new DirectoryEntry("LDAP://RootDSE");
                string configurationNamingContext = (string)rootDSE.Properties["configurationNamingContext"].Value;
                string defaultNamingContext = (string)rootDSE.Properties["defaultNamingContext"].Value;
                string strDominio = string.Empty;
                int i = 0;
                
                string[] arrDomain = dominioConfig.Split('.');
                strDominio = "LDAP://DC=" + arrDomain[0];
                for (i = 0 + 1; i <= arrDomain.Length - 1; i++)
                {
                    strDominio = (strDominio + ",DC=") + arrDomain[i];
                }
                DirectoryEntry objUser = default(DirectoryEntry);
                DirectoryEntry objDirectoryEntry = new DirectoryEntry(strDominio, login.user, login.pass);
                DirectorySearcher objDirectorySearcher = new DirectorySearcher(objDirectoryEntry);
                SearchResult objSearchResult = default(SearchResult);
                objDirectorySearcher.Filter = "(SAMAccountName=" + login.user + ")";
                try
                {
                    objSearchResult = objDirectorySearcher.FindOne();
                }
                catch (Exception ex)
                {
                    return false;
                }
                objUser = objSearchResult.GetDirectoryEntry();
                return true;
            }
            catch (Exception)
            {
                return false;
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
