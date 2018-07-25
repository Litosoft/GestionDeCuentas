using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DAAuditoria : AbstractDataManager
    {
        private string sp_listar_pormoduloyusuario = "SC_SYSTEM.USP_AUDITORIA_LISTAR_BYMODUSR";

        /// <summary>
        /// Devuelve los registros de auditoria por modulo y usuario
        /// </summary>
        /// <param name="Modulo">Modulo</param>
        /// <param name="IUsr">Usuario</param>
        /// <returns></returns>
        public IEnumerable<BEAuditoria> Listar_byModuloyUser(ModulosAuditoria Modulo, int Sid, int IUsr)
        {
            List<BEAuditoria> Registros = new List<BEAuditoria>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar_pormoduloyusuario, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oComando.Parameters.Add("@p_mod", SqlDbType.Int).Value = (int)Modulo;
                    oComando.Parameters.Add("@p_sid", SqlDbType.Int).Value = Sid;
                    oComando.Parameters.Add("@p_usr", SqlDbType.Int).Value = IUsr;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Registros.Add(new BEAuditoria
                            {
                                Fecha = DataUtil.ObjectToString(dr["s_fec"]),
                                Elemento = DataUtil.ObjectToString(dr["s_cam"]),
                                ValorAnterior = DataUtil.ObjectToString(dr["s_old"]),
                                ValorNuevo = DataUtil.ObjectToString(dr["s_new"]),
                                Registro = DataUtil.ObjectToString(dr["s_all"])
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
            return Registros;
        }

        public string GetDBInfo()
        {
            return DBConexion;
        }
    }
}
