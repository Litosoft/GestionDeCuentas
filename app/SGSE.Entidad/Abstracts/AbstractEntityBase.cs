using SGSE.Entidad.Primitivos;
using System;

namespace SGSE.Entidad.Abstracts
{
    [Serializable]
    public abstract class AbstractEntityBase
    {
        /// <summary>
        /// Numero de fila para tablas
        /// </summary>
        public int Row { get; set; }

        /// <summary>
        /// Id de la entidad
        /// </summary>
        public int Id { get; set; }


        #region Campos de Cifrado
        
        /// <summary>Código por bloques cifrado (Cipher ID)</summary>
        public string CID { get; set; }

        /// <summary>Hash</summary>
        public string Hash { get; set; }

        #endregion


        #region Campos de Auditoria
        
        /// <summary>
        ///  Auditoria del registro creación
        /// </summary>
        public IRowAudit RowAudit { get; set; }

        /// <summary>
        ///  Auditoria del registro modificación
        /// </summary>
        public IRowAudit RowAuditEdt { get; set; }

        #endregion


        #region de Campos del Visualizacion/Estado del Registro

        /// <summary>
        /// Indicador de Situacion del registro (Anulado/Aproado/Cancelado/Inhabilitado/...)
        /// </summary>
        public ItemGenerico Situacion { get; set; }

        /// <summary>
        /// Indicador de Estado del Registro (Elimado lógico *No visible*)
        /// </summary>
        public ItemGenerico Estado { get; set; }

        #endregion

    }
}
