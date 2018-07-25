using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    /// <summary>
    /// Capa de datos manejador de gastos
    /// </summary>
    public class DAGasto : AbstractDataManager
    {
        private string sp_devolvermaximoregistro = "SC_COMUN.USP_GASTO_GETMAXREGISTRO";
        private string sp_devolverlistapersonal = "SC_COMUN.USP_GASTO_GETPERSONAL";

        /// <summary>
        /// Devuelve el maximo registro de gasto
        /// </summary>
        /// <param name="sid">Id del Órgano de Servicio</param>
        /// <returns></returns>
        public int Get_MaximoRegistroGasto(int sid)
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


        /// <summary>
        /// Devuelve lista de personal local para el registro de gastos
        /// </summary>
        /// <param name="sid">Id del OSE</param>
        /// <returns></returns>
        public List<BEPersonalLocal> Get_PersonalGasto(int sid)
        {
            List<BEPersonalLocal> Personal = new List<BEPersonalLocal>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_devolverlistapersonal, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = sid;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Personal.Add(new BEPersonalLocal
                            {
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["sid"])),
                                Apellidos = DataUtil.ObjectToString(dr["nom"])
                            });
                        };
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Personal;
        }
    }
}
