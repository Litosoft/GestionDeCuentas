using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    /// <summary>Entidad Banco</summary>
    public class BEBanco : AbstractEntityBase
    {
        public BEBanco()
        {
            this.Agencia = new BEAgenciaBancaria();
            this.Situacion = new ItemGenerico { IntValue = 0 };
        }

        public string Nombre { get; set; }

        /// <summary>
        ///  Url del banco
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// Agencia
        /// </summary>
        public BEAgenciaBancaria Agencia { get; set; }

        /// <summary>
        ///  Agencias
        /// </summary>
        public IEnumerable<BEAgenciaBancaria> Agencias { get; set; }

    }

    /// <summary>Agencia Bancaria</summary>
    public class BEAgenciaBancaria : AbstractEntityBase
    {
        public BEAgenciaBancaria()
        {
            this.Pais = new BEPais();
        }

        public string Nombre { get; set; }

        public string Direccion1 { get; set; }

        public string Direccion2 { get; set; }

        /// <summary>Tipo de Operaciones</summary>
        public ItemGenerico Tipo { get; set; }

        public BEPais Pais { get; set; }
    }
}
