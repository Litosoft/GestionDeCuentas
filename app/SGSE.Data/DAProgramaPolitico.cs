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
    public class DAProgramaPolitico : AbstractDataManager
    {
        private string sp_listar_byOSE = "SC_COMUN.USP_PROGRAMAITEM_LISTAR_byOSE";

        /// <summary>
        /// Devuelve la lista de los programas de política exterior según el Tipo de Órgano de Servicio
        /// </summary>
        /// <param name="Tipo">Tipo de Órgano de Servicio</param>
        /// <returns></returns>
        public IEnumerable<BEPrograma> Listar_byOSE(OrganosServicioType Tipo)
        {
            List<BEPrograma> Programas = new List<BEPrograma>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_byOSE, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = (int)Tipo;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Programas.Add(new BEPrograma
                            {
                                CID = Peach.EncriptToBase64(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                Abreviatura = DataUtil.ObjectToString(dr["s_abr"])
                            });
                        }
                    }
                    oComando.Dispose();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Programas;
        }

    }
}
