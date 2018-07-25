using SGSE.Entidad.Enumeradores;
using SGSE.Security;
using System;

namespace SGSE.ConfigurationManager
{
    /// <summary>
    /// Administración de las conexiones al archivo de configuración
    /// </summary>
    public class ConfigurationManager
    {
        #region Base de datos

        /// <summary>
        /// Cadena de conexion principal
        /// </summary>
        /// <returns></returns>
        public static string GetConexionDB()
        {
            string Key = string.Empty;
            try
            {
                Key = getConexionKey(getEntorno());
                return Peach.DecriptText(Convert.ToString(System.Configuration.ConfigurationManager.AppSettings.Get(Key)));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Devuelve el indicador del tipo de entorno configurado (Desarrollo, Testing, Producción) 
        /// El entorno se establece en la variable APP_ENTORNO en el archivo web.config
        /// </summary>
        /// <returns></returns>
        private static DataBaseEnvironment getEntorno()
        {
            var p = Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings.Get("APP_ENTORNO_DB"));
            return (DataBaseEnvironment)Convert.ToByte(p);
        }

        /// <summary>
        /// Devuelve el Key correspondiente al entorno
        /// </summary>
        /// <param name="Entorno"></param>
        /// <returns></returns>
        private static string getConexionKey(DataBaseEnvironment Entorno)
        {
            string strKey = string.Empty;

            switch (Entorno)
            {
                case DataBaseEnvironment.Local:
                    strKey = "DB_LOC";
                    break;

                case DataBaseEnvironment.Desarrollo:
                    strKey = "DB_DES";
                    break;

                case DataBaseEnvironment.Testing:
                    strKey = "DB_TES";
                    break;

                case DataBaseEnvironment.Produccion:
                    strKey = "DB_PRO";
                    break;
            };

            return strKey;
        }

        #endregion

        #region Active Directory

        /// <summary>
        /// Devuelve una cadena con el nombre del directorio activo configurado desde el Web.Config
        /// </summary>
        /// <returns></returns>
        public static string GetActiveDirectory()
        {
            string Key = string.Empty;
            try
            {
                Key = getActiveDirectoryKey(getActiveDirectoryEntorno());
                return Peach.DecriptText(Convert.ToString(System.Configuration.ConfigurationManager.AppSettings.Get(Key)));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve el indicado del tipo de entorno configurado
        /// </summary>
        /// <returns>ActiveDirectoryEnvironment</returns>
        private static ActiveDirectoryEnvironment getActiveDirectoryEntorno()
        {
            var p = Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings.Get("APP_ENTORNO_AD"));
            return (ActiveDirectoryEnvironment)Convert.ToByte(p);
        }


        /// <summary>
        /// Devuelve el Key correspondiente al entorno de Active Directory
        /// </summary>
        /// <param name="Entorno">ActiveDirectoryEnvironment</param>
        /// <returns>Key string</returns>
        private static string getActiveDirectoryKey(ActiveDirectoryEnvironment Entorno)
        {
            string strKey = string.Empty;

            switch (Entorno)
            {
                case ActiveDirectoryEnvironment.Desarrollo:
                    strKey = "AD_DEV";
                    break;

                case ActiveDirectoryEnvironment.Pruebas:
                    strKey = "AD_TES";
                    break;

                case ActiveDirectoryEnvironment.Produccion:
                    strKey = "AD_PRD";
                    break;
            };
            return strKey;
        }


        #endregion

        #region Otras configuraciones

        public static int GetCaptchaConfig()
        {
            int p = Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings.Get("APP_CAPTCHA"));
            return p;
        }

        public static string GetServerConfig()
        {
            var p = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings.Get("APP_FILESRV"));
            return p;
        }

        public static string GetFileConfig()
        {
            var p = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings.Get("APP_FILEDIR"));
            return p;
        }

        #endregion
    }
}
