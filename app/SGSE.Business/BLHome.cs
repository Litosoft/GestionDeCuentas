using SGSE.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Business
{
    public class BLHome : IDisposable
    {
        private DAHome DA = null;

        public BLHome()
        {
            DA = new DAHome();
        }

        public List<string> HelpUsExecute(string T)
        {
            try
            {
                return DA.HelpUsExecute(T);
            }
            catch(Exception ex)
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
