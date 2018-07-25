using SGSE.Entidad.Abstracts;
using SGSE.Entidad.Primitivos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad
{
    public class BEPersonalLocal : AbstractEntityBase
    {
        public ItemGenerico OrganoServicio { get; set; }

        public string Apellidos { get; set; }

        public string Nombres { get; set; }

        public ItemGenerico TipoDocumento { get; set; }

        public string NumeroDocumento { get; set; }

        public ItemGenerico TipoPersonal { get; set; }

        /// <summary>
        /// Lugar de desempeño
        /// </summary>
        public ItemGenerico LugarDesempeno { get; set; }

        public string FechaNacimiento { get; set; }

        public ItemGenerico Nacionalidad { get; set; }

        public ItemGenerico EstadoCivil { get; set; }

        public string Email { get; set; }

        public ItemGenerico Genero { get; set; }

        public ItemGenerico Discapacidad { get; set; }

        public ItemGenerico GradoProfesional { get; set; }

        public ItemGenerico Especialidad { get; set; }

        public string Observacion { get; set; }

        /// <summary>
        /// Fecha de inicio de funciones
        /// </summary>
        public string InicioFunciones { get; set; }

        public ItemGenerico SituacionLaboral { get; set; }

        public IEnumerable<BEContrato> Contratos { get; set; }

        public BEContrato Contrato { get; set; }
    }

    /// <summary>
    /// Clase para el manejo del DataTable de la vista de Administrador.
    /// </summary>
    public class BEPersonalLocal_DTAdmin : AbstractEntityBase
    {
        public string Pais { get; set; }

        /// <summary>
        /// Tipo de Mision
        /// </summary>
        public string Tipo { get; set; }

        /// <summary>
        /// Órgano de Servicio
        /// </summary>
        public string OSE { get; set; }

        /// <summary>
        /// Situación laboral
        /// </summary>
        public string SitLab { get; set; }

        /// <summary>
        /// Apellidos y nombres del personal local
        /// </summary>
        public string Personal { get; set; }

        public string Sueldo { get; set; }

        public string Moneda { get; set; }
    }


}
