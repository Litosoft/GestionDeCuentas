using SGSE.Entidad.Abstracts;
using System;

namespace SGSE.Entidad.Primitivos
{
    /// <summary>
    /// Clase generica para el manejo de Items. El item generico por naturaleza almacena un texto y un valor asociado, 
    /// el valor asociado generalmente es un CID para datos complejos (strValue), sin embargo para datos simples el valor asociado
    /// puede ser un valor numérico (IntValue).
    /// *(CID:  Valor cadena encriptado)
    /// </summary>
    [Serializable]
    public class ItemGenerico : AbstractEntityBase
    {
        /// <summary>
        /// Texto
        /// </summary>
        public string Texto { get; set; }

        /// <summary>
        /// Valor cadena
        /// </summary>
        public string StrValue { get; set; }

        /// <summary>
        /// Valor entero
        /// </summary>
        public int IntValue { get; set; }
    }
}
