using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DAError : Abstract.AbstractDataManager
    {
        private string sp_grabar = "SC_SYSTEM.USP_ERRORLOG_INSERTAR";

        public void GrabarLog(string capa, string clase, string metodo, string error, short usr, string ipc)
        {
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_grabar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;

                    oComando.Parameters.Add("@p_cpa", SqlDbType.VarChar, 150).Value = capa;
                    oComando.Parameters.Add("@p_cls", SqlDbType.VarChar, 150).Value = clase;
                    oComando.Parameters.Add("@p_mtd", SqlDbType.VarChar, 150).Value = metodo;
                    oComando.Parameters.Add("@p_err", SqlDbType.VarChar, 150).Value = error;

                    oComando.Parameters.Add("@p_usr", SqlDbType.SmallInt).Value = usr;
                    oComando.Parameters.Add("@p_ipc", SqlDbType.VarChar, 15).Value = ipc;
                    oConexion.Open();
                    oComando.ExecuteNonQuery();
                    oConexion.Close();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
