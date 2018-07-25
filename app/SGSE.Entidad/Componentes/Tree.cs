using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Componentes
{

    public class JsTreeModel
    {

        /// <summary>
        /// Id *
        /// </summary>
        public string id { get; set; }

        /// <summary>
        /// Superior *
        /// </summary>
        public string parent { get; set; }

        /// <summary>
        /// Texto del nodo
        /// </summary>
        public string text { get; set; }

        /// <summary>
        /// Icono
        /// </summary>
        public string icon { get; set; }

        public JsTreeModel_data data { get; set; }

        /// <summary>
        /// Estado de los nodos
        /// </summary>
        public JsTreeModelState state { get; set; }

        /// <summary>
        /// Atributos para el nodo LI generado
        /// </summary>
        public JsTreeModel_li_attr li_attr { get; set; }

        /// <summary>
        /// Atributos para el nodo A generado
        /// </summary>
        public JsTreeModel_a_attr a_attr { get; set; }

    }

    public class JsTreeModelState
    {
        /// <summary>
        /// Nodo abierto
        /// </summary>
        public bool opened { get; set; }

        /// <summary>
        /// Nodo deshabilitado
        /// </summary>
        public bool disabled { get; set; }

        /// <summary>
        /// Nodo seleccionado
        /// </summary>
        public bool selected { get; set; }
    }

    public class JsTreeModel_li_attr
    {
        public string data_id { get; set; }

    }

    public class JsTreeModel_a_attr
    {
        public string href { get; set; }
    }

    public class JsTreeModel_data
    {
        public string idp { get; set; }


        public string nop { get; set; }
    }

}

