using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Componentes
{
    public class AutocompleteSuggestion
    {
        public string value { get; set; }
        public string data { get; set; }
    }

    public class AutocompleteResponse
    {
        public IEnumerable<AutocompleteSuggestion> suggestions { get; set; }
    }
}
