using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Responsers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLMenu : IDisposable
    {
        private DAMenu DA = null;

        public BLMenu()
        {
            DA = new DAMenu();
        }


        /// <summary>
        /// Lista todos los elementos del menú
        /// </summary>
        /// <returns>IEnumerable BEMenuItem</returns>
        public List<BEMenuItem> Listar()
        {
            try
            {
                return DA.Listar().ToList();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los items de menu permitidos para el pefil
        /// </summary>
        /// <param name="Id">Id del perfil</param>
        /// <returns></returns>
        public IEnumerable<BEMenuItem> getMenu_byPerfil(int Id)
        {
            try
            {
                IEnumerable<BEMenuItem> Items = DA.ListarItems_byPerfil(Id);

                List<BEMenuItem> Items_Show = new List<BEMenuItem>();
                Items_Show.AddRange(Items.Where(p => p.IsAuth.IntValue == 1).ToList());

                List<BEMenuItem> m = Items.Where(p => p.IsAuth.IntValue == 1).ToList();
                foreach (var e in m)
                {
                    var padre = Items.Where(p => p.Id == e.Padre.IntValue).ToList();
                    Items_Show.AddRange(padre);
                }

                var T = Items_Show.Distinct().OrderBy(p => p.IsGrupo.IntValue).OrderBy(p => p.Orden);
                return T;
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve los datos de un elemento de menu por su Id
        /// </summary>
        /// <param name="Id">Id Item</param>
        /// <returns>BEMenuItem elemento</returns>
        public BEMenuItem Listar_byId(int Id)
        {
            try
            {
                return DA.Listar_byId(Id);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba o actualiza los datos de un elemento de menu (opcion)
        /// </summary>
        /// <param name="model">modelo</param>
        /// <returns>ResponserData</returns>
        public ResponserData Grabar(BEMenuItem model)
        {
            try
            {
                return DA.Grabar(model);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Devuelve todos los elementos del menú, con los elementos autorizados para el perfil seleccionados.
        /// Es utilizado para asociar los elementos de un menu a un perfil en el administrador de perfiles.
        /// </summary>
        /// <param name="IdPerfil"></param>
        /// <returns></returns>
        public List<BEMenuItem> ListarInterfaz(int IdPerfil)
        {
            try
            {
                return DA.ListarItems_byPerfil(IdPerfil).ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Graba un conjunto de opciones del menú asociados a un perfil
        /// </summary>
        /// <param name="model">BEPerfil</param>
        /// <returns></returns>
        public ResponserData Grabar_byPerfil(BEPerfil model)
        {
            try
            {
                return DA.Grabar_byPerfil(model);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public void Dispose()
        {
            if (DA != null)
            {
                DA = null;
            }
        }


    }
}
