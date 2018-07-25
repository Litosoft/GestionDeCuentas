using SGSE.Data.Abstract;
using SGSE.Data.Helpers;
using SGSE.Entidad;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Data
{
    public class DAClasificador: AbstractDataManager
    {
        private string sp_listar = "SC_COMUN.USP_CLASIFICADORITEM_LISTAR";

        /// <summary>
        /// Devuelve todos los items de gasto del clasificador vigente
        /// </summary>
        /// <returns></returns>
        public IEnumerable<BEClasificadorItem> ListarItemsGasto()
        {
            List<BEClasificadorItem> Items = new List<BEClasificadorItem>();
            try
            {
                using (SqlConnection oConexion = new SqlConnection(DBConexion))
                {
                    SqlCommand oComando = new SqlCommand(sp_listar, oConexion);
                    oComando.CommandType = CommandType.StoredProcedure;
                    oConexion.Open();

                    using (SqlDataReader dr = oComando.ExecuteReader())
                    {
                        while (dr.Read() && dr.HasRows)
                        {
                            Items.Add(new BEClasificadorItem
                            {
                                Id = DataUtil.ObjectToInt(dr["i_sid"]),
                                Nombre = DataUtil.ObjectToString(dr["s_nom"]),
                                CodigoClase = DataUtil.ObjectToString(dr["s_cls"]),
                                ItemSuperior = DataUtil.ObjectToInt(dr["i_isp"]),
                                Nivel = DataUtil.ObjectToInt(dr["i_niv"]),
                                Tipo = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_tpo"]) },
                                EsGrupo = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_grp"]) },
                                EsCajaChica = new ItemGenerico { IntValue = DataUtil.ObjectToInt(dr["i_cch"]) }
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
            return Items;
        }
    }
}
