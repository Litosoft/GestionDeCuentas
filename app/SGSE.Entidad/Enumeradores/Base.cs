using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGSE.Entidad.Enumeradores
{
    /// <summary>
    /// Entorno de base de datos. Se corresponde con la sección conexiones en el archivo Web.Config
    /// </summary>
    [Serializable]
    public enum DataBaseEnvironment : byte
    {
        Local = 1,
        Desarrollo = 2,
        Testing = 3,
        Produccion = 4
    }

    /// <summary>Tipos Bootstrap</summary>
    [Serializable]
    public enum BootstrapAlertType : byte
    {
        /// <summary>Satisfactorio</summary>
        success = 1,

        /// <summary>Información</summary>
        info = 2,

        /// <summary>Cuidado</summary>
        warning = 3,

        /// <summary>Peligro</summary>
        danger = 4
    }

    // Estado de la respuesta
    [Serializable]
    public enum ResponserEstado : byte
    {
        /// <summary>
        /// Ok 
        /// </summary>
        Ok = 1,
        /// <summary>
        /// Fallo
        /// </summary>
        Fallo = 0
    }

    /// <summary>
    /// Entorno de Directorio Activo. Se corresponde con [key="AD"] an [appSettings] en el archivo Web.Config
    /// </summary>
    public enum ActiveDirectoryEnvironment: byte
    {
        Desarrollo = 1,
        Pruebas = 2,
        Produccion = 3
    }

    /// <summary>
    /// Módulos auditados
    /// </summary>
    public enum ModulosAuditoria
    {
        CuentasBancarias = 1,
        PersonalLocal = 2
    }

    /// <summary>
    /// Eventos sobre el módulo
    /// </summary>
    public enum ModuloAuditoriaEventos
    {
        Registro = 1,
        Actualizacion = 2
    }

    /// <summary>
    /// Eventos sobre los registros de datos
    /// </summary>
    public enum RowsAuditoriaEventos
    {
        Insert = 1,
        Update = 2
    }

}
