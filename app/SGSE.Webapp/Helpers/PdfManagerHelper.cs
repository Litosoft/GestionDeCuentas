using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SGSE.Webapp.Helpers
{
    public class PdfContentExtend 
    {
        private const int HEIGHT_TITLE = 16;
        private const int HEIGHT_TEXT = 12;
        private const int TEXT_WIDTH = 10;
        private const float BASE_POINT = 2.834645669f;

        private static PdfContentByte cb;

        public PdfContentExtend(PdfContentByte cbp)
        {
            cb = cbp;
        }


        /// <summary>
        /// Traza una linea horizontal desde un punto
        /// </summary>
        /// <param name="x">Posición X</param>
        /// <param name="y">Posición Y</param>
        /// <param name="width">Ancho</param>
        public void HLineTo(int x, int y, int width)
        {
            cb.MoveTo(x, y);
            cb.LineTo(x + width, y);
        }

        /// <summary>
        /// Traza una linea vertical desde un punto
        /// </summary>
        /// <param name="x">Posición X</param>
        /// <param name="y">Posición Y</param>
        /// <param name="Height">Alto</param>
        public void VLineTo(int x, int y, int height)
        {
            cb.MoveTo(x, y);
            cb.LineTo(x, y + height);
        }

        /// <summary>
        /// Establece un texto segun coordenadas absolutas
        /// </summary>
        /// <param name="xpos">Posición X</param>
        /// <param name="ypos">Posición Y</param>
        /// <param name="text">Cadena de texto</param>
        public void SetText(float xpos, float ypos, string text)
        {
            cb.BeginText();
            cb.SetTextMatrix(xpos, ypos);
            cb.ShowText(text);
            cb.EndText();
        }

        /// <summary>
        /// Establece un texto segun coordenadas absolutas
        /// </summary>
        /// <param name="xpos">Posición X</param>
        /// <param name="ypos">Posición Y</param>
        /// <param name="text">Cadena de texto</param>
        /// <param name="bf">BaseFont</param>
        /// <param name="fontSize">Tamaño del texto</param>
        public void SetText(float xpos, float ypos, string text, int fontSize)
        {
            cb.SaveState();

            BaseFont f_cn = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            cb.SetFontAndSize(f_cn, fontSize);

            cb.BeginText();
            cb.SetTextMatrix(xpos, ypos);
            cb.ShowText(text);
            cb.EndText();

            cb.RestoreState();
        }

        /// <summary>
        /// Dibuja un rectángulo punteado basado en coordenadas absolutas
        /// </summary>
        /// <param name="x">Posición X</param>
        /// <param name="y">Posición Y</param>
        /// <param name="width">Ancho</param>
        /// <param name="height">Alto</param>
        public void RectangleDashed(float x, float y, float width, float height)
        {
            cb.SaveState();
            cb.SetLineWidth(1);
            cb.SetLineDash(2, 2);
            cb.Rectangle(x, y, width, height);
            cb.Stroke();
            cb.RestoreState();
        }

        public void RectanglewTitle(int x, int y, int width, int height, string title, float mm, int adjust = 0)
        {
            int lnY = (y + height) - HEIGHT_TITLE;
            int stY = (y + height) - HEIGHT_TEXT;

            float posTextY = x + ((width - (mm * BASE_POINT)) / 2);

            int lenStr = title.Length * TEXT_WIDTH;
            int stX = (int)posTextY + adjust;
            
            cb.Rectangle(x, y, width, height);
            HLineTo(x, lnY, width);

            SetText(stX, stY, title);
        }
    }
}