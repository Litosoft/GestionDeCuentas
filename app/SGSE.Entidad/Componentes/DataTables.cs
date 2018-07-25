using System;
using System.Collections.Generic;

namespace SGSE.Entidad.Componentes
{
    /// <summary>Maneja los datos enviados al control DataTable</summary>
    [Serializable]
    public class JsonDataTable
    {
        public JsonDataTable()
        {
            List<string> stringEmptyList = new List<string>();
            draw = 0;
            recordsTotal = 0;
            recordsFiltered = 0;
            data = stringEmptyList;
        }

        public int draw { get; set; }

        public int recordsTotal { get; set; }

        public int recordsFiltered { get; set; }

        public IEnumerable<object> data { get; set; }
    }
}
