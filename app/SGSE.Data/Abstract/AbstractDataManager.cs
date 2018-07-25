namespace SGSE.Data.Abstract
{
    public abstract class AbstractDataManager
    {
        /// <summary>
        /// Conexion a la base de datos
        /// </summary>
        private string strConexion = ConfigurationManager.ConfigurationManager.GetConexionDB();


        /// <summary>
        /// Devuelve la cadena de conexion a la base de datos
        /// </summary>
        internal string DBConexion
        {
            get
            {
                return strConexion;
            }
        }
    }
}
