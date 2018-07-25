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
    public class DAProveedor : AbstractDataManager
    {
        private string sp_listar_proveedores_ose = "SC_COMUN.USP_PROVEEDOR_LISTAR_byOSE";

        /// <summary>
        /// Devuelve la lista de proveedores de un organo de servicio para el control selector del formato de egreso
        /// </summary>
        /// <param name="sid_ose">Id del proveedor</param>
        /// <returns></returns>
        public IEnumerable<BEProveedor> Listarby_OSE (int sid_ose)
        {
            List<BEProveedor> Proveedores = new List<BEProveedor>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_proveedores_ose, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_sid", SqlDbType.SmallInt).Value = sid_ose;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Proveedores.Add(new BEProveedor
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_pro"])
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
            return Proveedores;
        }

    }
}
