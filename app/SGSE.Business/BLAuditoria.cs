using SGSE.Data;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLAuditoria : IDisposable
    {
        private DAAuditoria DA = null;

        public BLAuditoria()
        {
            DA = new DAAuditoria();
        }

        /// <summary>
        /// Devuelve los registros de auditoria por modulo y usuario
        /// </summary>
        /// <param name="Modulo">Modulo</param>
        /// <param name="IUsr">Usuario</param>
        /// <returns></returns>
        public IEnumerable<BEAuditoria> Listar_byModuloyUser(ModulosAuditoria Modulo, int Sid, int IUsr)
        {
            try
            {
                return DA.Listar_byModuloyUser(Modulo, Sid, IUsr);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public string GetDBInfo()
        {
            return DA.GetDBInfo();
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
