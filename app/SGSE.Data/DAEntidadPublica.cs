using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using SGSE.Entidad.Primitivos;
using SGSE.Entidad.Responsers;
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
    public class DAEntidadPublica : AbstractDataManager
    {
        private string sp_listar_entidad_select = "SC_COMUN.USP_ENTIDADPUBLICA_LISTAR_TOSELECT";
        private string sp_listar_entidad_cuentas_select = "SC_COMUN.USP_ENTIDADPUBLICA_LISTARCTAS_TOSELECT";

        /// <summary>
        /// Devuelve todas las entidades publicas.
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEEntidadPublica> ListarEntidad_toSelect()
        {
            List<BEEntidadPublica> EntidadPublica = new List<BEEntidadPublica>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_entidad_select, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            EntidadPublica.Add(new BEEntidadPublica
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"])
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

            return EntidadPublica;
        }


        /// <summary>
        /// Devuelve todas las entidades públicas.
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BECuentaCorriente> ListarEntidadCuentas_toSelect(int id)
        {
            List<BECuentaCorriente> CuentaCorriente = new List<BECuentaCorriente>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_entidad_cuentas_select, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            CuentaCorriente.Add(new BECuentaCorriente
                            {
                                CID = Peach.EncriptText(DataUtil.ObjectToString(dr["i_sid"])),
                                NumeroCuenta = DataUtil.ObjectToString(dr["s_nro"])
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

            return CuentaCorriente;
        }

    }
}
