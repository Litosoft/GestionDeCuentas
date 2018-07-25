using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    // TODO: Obsoleto
    public class DAFormatoEgreso : AbstractDataManager
    {
        private string sp_devolvermaximoregistro = "SC_COMUN.USP_GASTO_GETMAXREGISTRO";

        /// <summary>
        /// Devuelve el maximo registro de formato de egreso
        /// </summary>
        /// <param name="sid">Id del Órgano de Servicio</param>
        /// <returns></returns>
        public int Listar_MaximoRegistro(int sid)
        {
            var i = 0;
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_devolvermaximoregistro, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            i = DataUtil.ObjectToInt(dr["i_max"]);
                        };
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return i;
        }

    }
}
