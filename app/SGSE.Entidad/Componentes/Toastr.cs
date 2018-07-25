using System;
using System.Collections.Generic;

namespace SGSE.Entidad.Componentes
{
    /// <summary>
    /// Tipo de mensaje
    /// </summary>
    [Serializable]
    public enum ToastType
    {
        Error,
        Info,
        Success,
        Warning
    }

    /// <summary>
    /// Posición del mensaje
    /// </summary>
    [Serializable]
    public enum ToastPosition
    {
        toast_top_full_width,
        toast_bottom_full_width,
        toast_top_left,
        toast_top_right,
        toast_bottom_right,
        toast_bottom_left
    }

    /// <summary>
    /// Mesaje
    /// </summary>
    [Serializable]
    public class ToastMessage
    {
        /// <summary>
        /// Titulo
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// Mensaje
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Tipo de mensaje
        /// </summary>
        public ToastType ToastType { get; set; }

        /// <summary>
        /// Indica si el mensaje permanecera visible 
        /// </summary>
        public bool IsSticky { get; set; }
    }

    /// <summary>
    /// Contenedor de mensajes
    /// </summary>
    [Serializable]
    public class Toastr
    {
        /// <summary>
        /// Posición del mensaje
        /// </summary>
        public string Position { get; set; }

        /// <summary>
        /// Indica si el mensaje se muestra superpuesto sobre otros objetos
        /// </summary>
        public bool ShowNewestOnTop { get; set; }

        /// <summary>
        /// Indica si muestra el botón cerrar
        /// </summary>
        public bool ShowCloseButton { get; set; }

        /// <summary>
        /// Mesanjes
        /// </summary>
        public List<ToastMessage> ToastMessages { get; set; }

        /// <summary>
        /// Notificaciones
        /// </summary>
        /// <param name="title">Titulo</param>
        /// <param name="message">Mensaje</param>
        /// <param name="toastType">Tipo</param>
        /// <param name="isSticky"></param>
        /// <param name="position">Posición</param>
        /// <returns></returns>
        public ToastMessage AddToastMessage(string title, string message, ToastType toastType, bool isSticky)
        {
            var toast = new ToastMessage()
            {
                Title = title,
                Message = message,
                ToastType = toastType,
                IsSticky = isSticky
            };
            ToastMessages.Add(toast);
            return toast;
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public Toastr()
        {
            ToastMessages = new List<ToastMessage>();
            ShowNewestOnTop = false;
            ShowCloseButton = true;
            Position = "toast-top-center";
        }
    }
}
