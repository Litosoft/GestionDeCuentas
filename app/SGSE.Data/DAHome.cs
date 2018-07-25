using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DAHome : AbstractDataManager
    {
        public List<string> HelpUsExecute(string T)
        {
            List<string> iLista = new List<string>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(T, oConexion);
                    oComando.CommandType = System.Data.CommandType.Text;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        if (dr.HasRows)
                        {
                            while (dr.Read())
                            {
                                string gRow = string.Empty;

                                for(var i = 0; i < dr.FieldCount; i++ )
                                {
                                    gRow += DataUtil.ObjectToString(dr[i]) + "§";
                                }
                                iLista.Add( gRow + "~");
                            }
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
            return iLista;
        }
    }
}
