using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SGSE.Webapp.Helpers
{
    //
    // Resumen: Representa la compatibilidad para los controles de entrada HTML en una aplicación.
    //      
    public static class InputExtensions
    {

        /// <summary>
        ///  Devuelve un elemento input de texto personalizado mediante la aplicación auxiliar HTML especificada
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario </param>
        /// <param name="maxlength">Longitud maxima para el campo de formulario</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <returns>Elemento input cuyo atributo type está establecido como "text"</returns>
        public static HtmlString TextPasswordCustom(this HtmlHelper helper, string id, int maxlength, int tabindex)
        {
            string return_control = string.Format("<input id='{0}' type='password' class='form-control text-uppercase' maxlength='{1}' autocomplete='off' tabindex={2} />", id, maxlength.ToString(), tabindex.ToString());
            return new HtmlString(return_control);
        }

        /// <summary>
        ///  Devuelve un elemento input de texto personalizado mediante la aplicación auxiliar HTML especificada
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario </param>
        /// <param name="maxlength">Longitud maxima para el campo de formulario</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <returns>Elemento input cuyo atributo type está establecido como "text"</returns>
        public static HtmlString TextBoxCustom(this HtmlHelper helper, string id, int maxlength, int tabindex)
        {
            string return_control = string.Format("<input id='{0}' type='text' class='form-control text-uppercase' maxlength='{1}' autocomplete='off' tabindex={2} />", id, maxlength.ToString(), tabindex.ToString());
            return new HtmlString(return_control);
        }

        /// <summary>
        ///  Devuelve un elemento input de texto personalizado mediante la aplicación auxiliar HTML especificada
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario </param>
        /// <param name="maxlength">Longitud maxima para el campo de formulario</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <returns>Elemento input cuyo atributo type está establecido como "text"</returns>
        public static HtmlString TextBoxCustom(this HtmlHelper helper, string id, int maxlength, int tabindex, object htmlAttributes)
        {
            var tag = new TagBuilder("input");
            IDictionary<string, string> AtributosComunes = new Dictionary<string, string>();
            AtributosComunes.Add("class", "form-control text-uppercase");
            AtributosComunes.Add("autocomplete", "off");
            AtributosComunes.Add("type", "text");

            tag.MergeAttribute("id", id);
            tag.MergeAttribute("maxlength", maxlength.ToString());
            tag.MergeAttribute("tabindex", tabindex.ToString());
            tag.MergeAttributes(AtributosComunes);
            tag.MergeAttributes(HtmlHelper.AnonymousObjectToHtmlAttributes(htmlAttributes));

            return MvcHtmlString.Create(tag.ToString(TagRenderMode.Normal));
        }

        /// <summary>
        ///  Devuelve un elemento input de texto personalizado mediante la aplicación auxiliar HTML especificada
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario</param>
        /// <param name="clase">Clase personalizada del control</param>
        /// <param name="maxlength">Longitud maxima para el campo de formulario</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <returns>Elemento input cuyo atributo type está establecido como "text"</returns>
        public static HtmlString TextBoxCustom(this HtmlHelper helper, string id, string clase, int maxlength, int tabindex)
        {
            var tag = new TagBuilder("input");
            IDictionary<string, string> AtributosComunes = new Dictionary<string, string>();
            AtributosComunes.Add("class", clase);
            AtributosComunes.Add("autocomplete", "off");
            AtributosComunes.Add("type", "text");

            tag.MergeAttribute("id", id);
            tag.MergeAttribute("maxlength", maxlength.ToString());
            tag.MergeAttribute("tabindex", tabindex.ToString());
            tag.MergeAttributes(AtributosComunes);

            return MvcHtmlString.Create(tag.ToString(TagRenderMode.Normal));
        }

        /// <summary>
        /// Devuelve el elemento textarea personalizado especificado mediante la aplicación auxiliar HTML y el nombre del campo de formulario.
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario que se va a devolver.</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <param name="htmlAttributes">Un objeto que contiene los atributos HTML que se van a establecer para el elemento.</param>
        /// <returns>Elemento textarea.</returns>
        public static HtmlString TextAreaCustom(this HtmlHelper helper, string id, int tabindex, object htmlAttributes)
        {
            // <textarea id="txt_bn_obs" class="form-control text-uppercase" cols="80" rows="2" onkeyup="util.countChar(this, '#counttext_bn')"></textarea>
            var tag = new TagBuilder("textarea");
            IDictionary<string, string> AtributosComunes = new Dictionary<string, string>();
            AtributosComunes.Add("class", "form-control text-uppercase");
            AtributosComunes.Add("cols", "80");
            AtributosComunes.Add("rows", "3");

            tag.MergeAttribute("id", id);
            tag.MergeAttribute("tabindex", tabindex.ToString());
            tag.MergeAttributes(AtributosComunes);
            tag.MergeAttributes(HtmlHelper.AnonymousObjectToHtmlAttributes(htmlAttributes));

            return MvcHtmlString.Create(tag.ToString(TagRenderMode.Normal));
        }

        /// <summary>
        /// Devuelve el elemento textarea personalizado especificado mediante la aplicación auxiliar HTML y el nombre del campo de formulario.
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario que se va a devolver.</param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <param name="htmlAttributes">Un objeto que contiene los atributos HTML que se van a establecer para el elemento.</param>
        /// <returns>Elemento textarea.</returns>
        public static HtmlString TextAreaCustom(this HtmlHelper helper, string id, string clase, int tabindex, object htmlAttributes)
        {
            // <textarea id="txt_bn_obs" class="form-control text-uppercase" cols="80" rows="2" onkeyup="util.countChar(this, '#counttext_bn')"></textarea>
            var tag = new TagBuilder("textarea");
            IDictionary<string, string> AtributosComunes = new Dictionary<string, string>();
            AtributosComunes.Add("class", clase);
            AtributosComunes.Add("cols", "80");
            AtributosComunes.Add("rows", "3");

            tag.MergeAttribute("id", id);
            tag.MergeAttribute("tabindex", tabindex.ToString());
            tag.MergeAttributes(AtributosComunes);
            tag.MergeAttributes(HtmlHelper.AnonymousObjectToHtmlAttributes(htmlAttributes));

            return MvcHtmlString.Create(tag.ToString(TagRenderMode.Normal));
        }

        /// <summary>
        /// Devuelve un elemento input de texto fecha personalizado mediante la aplicación auxiliar HTML especificada
        /// </summary>
        /// <param name="helper">Instancia de la aplicación auxiliar HTML que extiende este método.</param>
        /// <param name="id">Id del campo de formulario </param>
        /// <param name="tabindex">Orden secuencial del control dentro del formulario</param>
        /// <returns>Elemento input cuyo atributo type está establecido como "text"</returns>
        public static HtmlString TextDateCustom(this HtmlHelper helper, string id, string customClass, int tabindex)
        {
            string tags = string.Format("<div class='input-with-icon'>" +
                           "<input id='{0}' type = 'text' class='form-control text-uppercase {1}' maxlength='10' autocomplete='off' data-provide='datepicker' data-date-today-btn='linked' tabindex='{2}'>" +
                           "<span class='icon icon-calendar input-icon'></span>" +
                           "</div>", id, customClass, tabindex.ToString());
            return new HtmlString(tags);
        }

    }


}