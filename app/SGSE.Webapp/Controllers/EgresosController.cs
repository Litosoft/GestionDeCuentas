using Gma.QrCodeNet.Encoding;
using Gma.QrCodeNet.Encoding.Windows.Render;
using iTextSharp.text;
using iTextSharp.text.pdf;
using SGSE.Business;
using SGSE.Entidad;
using SGSE.Entidad.Enumeradores;
using SGSE.Security;
using SGSE.Webapp.App_Base;
using SGSE.Webapp.Helpers;
using SGSE.Webapp.Models.Egresos;
using SGSE.Webapp.Models.Gasto;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web.Mvc;

namespace SGSE.Webapp.Controllers
{
    public class EgresosController : BaseController
    {
        // GET: Egresos

        public ActionResult RegistroGastos()
        {
            try
            {
                return View();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public ActionResult Formato()
        {
            var strControlador = this.ControllerContext.RouteData.Values["controller"].ToString();
            var strMetodo = this.ControllerContext.RouteData.Values["action"].ToString();

            if (User != null)
            {
                if (this.IsPermitido())
                {
                    RegistroGastoViewModel model = new RegistroGastoViewModel();
                    var OSE_CID = Peach.DecriptText(User.OrganoServicio_CID);
                    if (OSE_CID == string.Empty)
                    {
                        AddToastMessage("Restricción", "El usuario no esta asociado a un Órgano de Servicio.", BootstrapAlertType.danger);
                        return View(model);
                    }

                    int sid_usr = Convert.ToInt16(Peach.DecriptText(User.CID));
                    string ose = User.OrganoServicio_Nombre;
                    
                    int sid_ose = Convert.ToInt16( Peach.DecriptText(User.OrganoServicio_CID));

                    model.MaxRegistro = new BLFormatoEgreso().Listar_MaximoRegistro(sid_ose) + 1;

                    model.CuentasOse = new BLCuentaCorriente().ListarCuentasCargo(sid_usr)
                        .Select(q => new SelectListItem { Value = q.CID, Text = q.NumeroCuenta })
                        .ToList();

                    model.Proveedores = new BLProveedor().Listarby_OSE(sid_ose)
                        .Select(p => new SelectListItem { Value = p.CID, Text = p.Nombre })
                        .ToList();

                    model.ItemsClasificador = new BLClasificador().ListarItemsGasto();

                    model.ItemsFormaPago = new BLParametro().ListarItems_byGrupo("FORMATO_FORMA_PAGO")
                        .Select(p => new SelectListItem { Value = p.Valor, Text = p.Texto })
                        .ToList();

                    model.ItemsDestinoGasto = new BLParametro().ListarItems_byGrupo("FORMATO_DESTINO_GASTO")
                        .Select(p => new SelectListItem { Value = p.Valor, Text = p.Texto })
                        .ToList();

                    model.ItemsProgramasPoliticos = new BLProgramaPolitico().Listar_byOSE(OrganosServicioType.Consulado)
                        .Select(p => new SelectListItem { Text = p.Nombre, Value = p.CID })
                        .ToList();

                    //var e = Request.ClientCertificate;
                    //X509CertificateStore store = X509CertificateStore.LocalMachineStore(X509CertificateStore.MyStore);
                    //store.OpenRead();

                    return View(model);
                }
                else
                {
                    AddToastMessage("No permitido", "Esta opcion no esta permitida para su perfil.", BootstrapAlertType.danger);
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                return RedirectToAction("Login", "Account", new { act = "timeout" });
            }
        }

        public static X509Certificate2 selectCert(string windowTitle, string windowMsg)
        {
            X509Certificate2 certSelected = null;
            X509Store x509Store = new X509Store("MY", StoreLocation.CurrentUser);
            x509Store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);

            X509Certificate2Collection col = x509Store.Certificates;
            X509Certificate2Collection sel = X509Certificate2UI.SelectFromCollection(col, windowTitle, windowMsg, X509SelectionFlag.SingleSelection);

            if (sel.Count > 0)
            {
                X509Certificate2Enumerator en = sel.GetEnumerator();
                en.MoveNext();
                certSelected = en.Current;
            }

            x509Store.Close();

            return certSelected;
        }

        /*
        private static X509Certificate2Collection GetCertificateFromStore(string certName)
        {

            // Get the certificate store for the current user.
            X509Store store = new X509Store(StoreLocation.CurrentUser);
            try
            {
                store.Open(OpenFlags.ReadOnly);

                X509Certificate2Collection col = store.Certificates;
                X509Certificate2Collection sel = X509Certificate2UI.SelectFromCollection(col, windowTitle, windowMsg, X509SelectionFlag.SingleSelection);



                // Place all certificates in an X509Certificate2Collection object.
                X509Certificate2Collection certCollection = store.Certificates;
                // If using a certificate with a trusted root you do not need to FindByTimeValid, instead:
                // currentCerts.Find(X509FindType.FindBySubjectDistinguishedName, certName, true);
                X509Certificate2Collection currentCerts = certCollection.Find(X509FindType.FindByTimeValid, DateTime.Now, false);
                X509Certificate2Collection signingCert = currentCerts.Find(X509FindType.FindBySubjectDistinguishedName, certName, false);
                if (signingCert.Count == 0)
                    return null;
                // Return the first certificate in the collection, has the right name and is current.
                //return signingCert[0];
                return currentCerts;
            }
            finally
            {
                store.Close();
            }

        } */

        public FileResult generaFormatoEgreso(string sid)
        {
            
            //var _mision = Usuario.OrganoServicio.Nombre;

            // Data
            var _nro = "01";
            var _dia = "09";
            var _mes = "04";
            var _ano = "2018";

            var _prv = "CARITO SANCHEZ";
            var _let = "DOS MIL TRESCIENTOS CINCUENTA Y DOS Y 96/100 DOLARES AMERICANOS";

            MemoryStream workStream = new MemoryStream();
            string strPDFFileName = string.Concat("FE-", sid, ".pdf");
            string strAttachment = Server.MapPath("~/Pdf/" + strPDFFileName);

            // Documento
            Document doc = new Document(PageSize.A4, 25, 25, 30, 30);
            PdfWriter Writer = PdfWriter.GetInstance(doc, workStream);
            Writer.CloseStream = false;
            doc.Open();
            BaseFont f_cn = BaseFont.CreateFont("c:\\windows\\fonts\\Arial.ttf", BaseFont.CP1252, BaseFont.NOT_EMBEDDED);

            // Info del archivo
            #region Info
            doc.AddAuthor("Víctor Daniel Neyra - mail:danielneyra@gmail.com");
            doc.AddCreationDate();
            doc.AddSubject("Formato de Egreso");
            doc.AddTitle("Sistema Integrado de Rendición de Cuentas");
            #endregion

            #region Logo MRE
            iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(Server.MapPath("~/Content/img/mre/patron.png"));
            logo.SetAbsolutePosition(34, 750);
            logo.ScalePercent(54f);
            doc.Add(logo);
            #endregion

            PdfContentByte cb = Writer.DirectContent;
            cb.SetFontAndSize(f_cn, 8);

            PdfContentExtend ce = new PdfContentExtend(cb);

            // Borde pagina
            cb.Rectangle(30, 90, 540, 700);
            cb.Stroke();

            Chunk n = new Chunk("ANEXO N°3 - FORMATO DE EGRESOS", new iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 12, iTextSharp.text.Font.BOLD, iTextSharp.text.Color.GRAY));
            Paragraph p = new Paragraph();
            p.Add(n);
            p.Alignment = Element.ALIGN_CENTER;
            doc.Add(p);

            #region Encabezado del documento
            ce.SetText(38, 720, User.OrganoServicio_Nombre, 10);
            ce.RectanglewTitle(414, 741, 148, 40, "N°           DIA          MES          AÑO", 42f);
            ce.SetText(426, 748, _nro, 11);
            ce.VLineTo(451, 741, 40);
            ce.SetText(463, 748, _dia, 11);
            ce.VLineTo(488, 741, 40);
            ce.SetText(500, 748, _mes, 11);
            ce.VLineTo(525, 741, 40);
            ce.SetText(532, 748, _ano, 11);
            #endregion

            #region Encabezado de gasto
            ce.SetText(38, 690, "NOMBRE DEL PROVEEDOR");
            ce.SetText(38, 660, "CANTIDAD EN MONEDA LOCAL");

            ce.SetText(160, 690, string.Concat(": ", _prv));
            ce.SetText(160, 660, string.Concat(": ", _let));
            #endregion

            #region Detalle del Gasto
            ce.RectanglewTitle(38, 538, 524, 100, "DETALLE DEL GASTO", 31.5f);
            cb.Stroke();
            #endregion

            #region Forma de Pago
            ce.RectanglewTitle(38, 421, 208, 110, "FORMA DE PAGO", 23.5f);
            cb.Stroke();
            #endregion

            #region Destino de Gasto
            // Referencia
            cb.Rectangle(252, 304, 310, 227);
            ce.HLineTo(252, 515, 310);
            ce.HLineTo(252, 324, 310);

            ce.SetText(256, 520, "DESTINO DE GASTO", 6);

            // Test (16 Heigt)
            ce.SetText(256, 504, "CANCILLERIA", 6);
            ce.SetText(256, 492, "RESIDENCIA", 6);

            ce.VLineTo(320, 324, 207);
            ce.SetText(324, 520, "PROGRAMA", 6);
            ce.SetText(416, 312, "TOTAL EN MONEDA LOCAL", 6);

            // Test
            ce.SetText(324, 504, "PRG.AS.LEG.HUM.-SS.CC.", 6);
            ce.SetText(324, 492, "GASTOS DE FUNC. GEST.", 6);

            ce.VLineTo(404, 324, 207);
            ce.SetText(408, 520, "RUBRO", 6);

            // Test
            ce.SetText(408, 504, "2.1.3.1-OTR.OBLIG.SEG.L.L.L.L.", 6);
            ce.SetText(408, 492, "3.5-OTROS SERV. PUB.", 6);

            ce.VLineTo(500, 304, 227);
            ce.SetText(522, 520, "IMPORTE", 6);

            // Test
            var monto = "2,352.96".PadLeft(17, ' ');
            ce.SetText(508, 504, monto.Substring(0, 17), 7);

            // Test2
            var monto2 = "128.73".PadLeft(17, ' ');
            ce.SetText(508, 492, monto2.Substring(0, 17), 7);


            // Test - Total
            var total = "2,352.96".PadLeft(17, ' ');
            ce.SetText(506, 312, monto.Substring(0, 17), 8);

            #endregion

            #region Visación
            ce.RectanglewTitle(38, 304, 208, 110, "VISACIÓN", 12f);
            ce.HLineTo(48, 324, 80);
            ce.HLineTo(155, 324, 80);


            ce.SetText(53, 313, "ADM. DE FONDOS");
            ce.SetText(163, 313, "JEFE DE MISIÓN");

            cb.Stroke();
            #endregion

            #region Adjuntar y Pegar Cheque

            ce.RectangleDashed(38, 98, 524, 198);
            ce.SetText(230, 186, "ADJUNTAR Y PEGAR CHEQUE");

            #endregion

            // QRCode
            string imageDataURL = string.Empty;
            byte[] ImageQr = null;

            try
            {
                var qrEncoder = new QrEncoder(ErrorCorrectionLevel.H);
                var qrCode = qrEncoder.Encode("http://www.rree.gob.pe/");
                var renderer = new GraphicsRenderer(new FixedModuleSize(5, QuietZoneModules.Two), Brushes.Black, Brushes.White);
                using (MemoryStream ms = new MemoryStream())
                {
                    renderer.WriteToStream(qrCode.Matrix, ImageFormat.Png, ms);
                    ImageQr = ms.ToArray();
                }
                string imageBase64Data = Convert.ToBase64String(ImageQr);
                imageDataURL = string.Format("data:image/png;base64,{0}", imageBase64Data);

                iTextSharp.text.Image pic = iTextSharp.text.Image.GetInstance(ImageQr);
                pic.SetAbsolutePosition(526, 700);
                pic.ScalePercent(21f);
                doc.Add(pic);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            doc.Close();

            byte[] byteInfo = workStream.ToArray();
            workStream.Write(byteInfo, 0, byteInfo.Length);
            workStream.Position = 0;
            System.IO.File.WriteAllBytes(strAttachment, byteInfo);

            return File(workStream, "application/pdf", strAttachment);
        }



        public FileResult generaFormatoEgreso2()
        {
            //var cert = selectCert("Certificado Digital", "SIRC.NET - Seleccione el certificado.");

            DateTime dTime = DateTime.Now;
            MemoryStream workStream = new MemoryStream();
            string strPDFFileName = string.Concat("FE", Guid.NewGuid().ToString("D").ToUpper().Substring(0, 8), ".pdf");
            string strAttachment = Server.MapPath("~/Pdf/" + strPDFFileName);

            BaseFont f_cn = BaseFont.CreateFont("c:\\windows\\fonts\\Arial.ttf", BaseFont.CP1252, BaseFont.NOT_EMBEDDED);


            // Documento
            Document doc = new Document(PageSize.A4, 25, 25, 30, 30);
            PdfWriter Writer = PdfWriter.GetInstance(doc, workStream);
            Writer.CloseStream = false;
            doc.Open();

            // Info del archivo
            doc.AddAuthor("Víctor Daniel Neyra - mail:danielneyra@gmail.com");
            doc.AddCreationDate();
            doc.AddSubject("Formato de Egreso N°1 del 01/01/2017");
            doc.AddTitle("Formato de Egreso");

            #region Logo MRE
            iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(Server.MapPath("~/Content/img/mre/patron.png"));
            logo.SetAbsolutePosition(34, 750);
            logo.ScalePercent(54f);
            doc.Add(logo);
            #endregion

            PdfContentByte cb = Writer.DirectContent;
            PdfContentExtend ce = new PdfContentExtend(cb);

            cb.SetFontAndSize(f_cn, 8);

            // Borde pagina
            cb.Rectangle(30, 90, 540, 700);
            cb.Stroke();

            /*

            // Destino del gasto
            cb.Rectangle(304, 308, 258, 228);
            cb.Stroke();
            */
            Chunk n = new Chunk("ANEXO N°3 - FORMATO DE EGRESOS", new iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 12, iTextSharp.text.Font.BOLD, iTextSharp.text.Color.GRAY));
            Paragraph p = new Paragraph();
            p.Add(n);
            p.Alignment = Element.ALIGN_CENTER;

            doc.Add(p);

            ce.SetText(38, 720, "EMBAJADA DEL PERU EN ESTADOS UNIDOS DE AMÉRICA", 10);
            ce.RectanglewTitle(414, 741, 148, 40, "N°           DIA          MES          AÑO", 42f);
            cb.MoveTo(451, 741);
            cb.LineTo(451, 781);

            cb.MoveTo(488, 741);
            cb.LineTo(488, 781);

            cb.MoveTo(525, 741);
            cb.LineTo(525, 781);

            ce.SetText(160, 690, ":");
            ce.SetText(160, 660, ":");

            ce.SetText(38, 690, "NOMBRE DEL PROVEEDOR");
            ce.SetText(38, 660, "CANTIDAD EN MONEDA LOCAL");

            #region Detalle del Gasto
            ce.RectanglewTitle(38, 538, 524, 100, "DETALLE DEL GASTO", 31.5f);
            cb.Stroke();
            #endregion


            #region Forma de Pago
            ce.RectanglewTitle(38, 421, 208, 110, "FORMA DE PAGO", 23.5f);
            cb.Stroke();
            #endregion

            cb.Rectangle(252, 304, 310, 227);

            #region Visación
            ce.RectanglewTitle(38, 304, 208, 110, "VISACIÓN", 12f);
            ce.HLineTo(48, 324, 80);
            ce.HLineTo(155, 324, 80);


            ce.SetText(53, 313, "ADM. DE FONDOS");
            ce.SetText(163, 313, "JEFE DE MISIÓN");

            cb.Stroke();
            #endregion

            #region Adjuntar y Pegar Cheque

            ce.RectangleDashed(38, 98, 524, 198);
            ce.SetText(230, 186, "ADJUNTAR Y PEGAR CHEQUE");

            #endregion






            /*
            var altura = doc.PageSize.Height;
            while (altura > 0)
            {
                cb.MoveTo(0, altura);
                cb.LineTo(doc.PageSize.Width, altura);
                cb.Stroke();

                cb.BeginText();
                cb.SetTextMatrix(5, altura+1);  //(xPos, yPos)
                cb.ShowText("y:" + altura.ToString());
                cb.EndText();
                altura -= 20;
            }

            var ancho = doc.PageSize.Width;
            while(ancho > 0)
            {
                cb.MoveTo(ancho, 0);
                cb.LineTo(ancho, doc.PageSize.Height);
                cb.Stroke();

                cb.BeginText();
                cb.SetTextMatrix(ancho +1, 22);  //(xPos, yPos)
                cb.ShowText("x:" + ancho.ToString());
                cb.EndText();

                ancho -= 20;
            }
            */
            //
            //doc.Add(new Paragraph("Formato de Egreso"));

            //doc.Add(Add_Content_To_PDF(tableLayout));
            doc.Close();

            byte[] byteInfo = workStream.ToArray();
            workStream.Write(byteInfo, 0, byteInfo.Length);
            workStream.Position = 0;
            System.IO.File.WriteAllBytes(strAttachment, byteInfo);

            return File(workStream, "application/pdf", strAttachment);

            /*

            DateTime dTime = DateTime.Now;
            string   PDFFileName = string.Concat("FE", Guid.NewGuid().ToString("D").ToUpper().Substring(0, 8), ".pdf");
            string  Attachment = Server.MapPath("~/Pdf/" + PDFFileName);

            Document doc = new Document(PageSize.A4);
            doc.AddAuthor("Víctor Neyra");
            doc.AddCreationDate();
            doc.SetMargins(10f, 10f, 10f, 10f);

            //PdfWriter.GetInstance(doc, new FileStream(PDFFileName, FileMode.Create));

            MemoryStream workStream = new MemoryStream();
            //PdfWriter.GetInstance(doc, workStream).CloseStream = false;
            //doc.Open();

            PdfWriter writer = PdfWriter.GetInstance(doc, workStream);
            doc.Open();

            Rectangle rectangle = new Rectangle(10, 10, 150, 15);
            rectangle.BorderColor = Color.BLACK;

            Chunk n = new Chunk("N", new Font(Font.COURIER, 12, Font.BOLD, Color.WHITE));
            n.SetBackground(Color.LIGHT_GRAY);
            n.SetUnderline(1, 1);

            Chunk o = new Chunk("o", new Font(Font.COURIER, 9, Font.BOLD, Color.BLACK));
            o.SetTextRise(6);
            Chunk name = new Chunk("Name", new Font(Font.COURIER, 12, Font.BOLD, Color.WHITE));
            name.SetBackground(Color.LIGHT_GRAY);
            name.SetUnderline(1, 1);

            Phrase header = new Phrase();
            header.Add(n);
            header.Add(o);
            header.Add(new Chunk(" "));
            header.Add(name);
            header.Add(Chunk.NEWLINE);
            doc.Add(header);

            doc.Close();
            byte[] byteInfo = workStream.ToArray();
            workStream.Write(byteInfo, 0, byteInfo.Length);
            workStream.Position = 0;

            return File(byteInfo, "application/pdf", Attachment); */
        }

        #region Sg
        /*
        public FileResult CrearFormatoEgreso()
        {
            DateTime dTime = DateTime.Now;
            MemoryStream workStream = new MemoryStream();
            //string strPDFFileName = string.Concat("FE", (Guid.NewGuid().ToString("D").ToUpper() + ".pdf"));
            string strPDFFileName = string.Concat("FE", Guid.NewGuid().ToString("D").ToUpper().Substring(0,8),  ".pdf");

            Document doc = new Document();
            doc.AddAuthor("Víctor Neyra");
            doc.AddCreationDate();
            doc.SetMargins(0f, 0f, 0f, 0f);

            PdfPTable tableLayout = new PdfPTable(5);
            doc.SetMargins(0f, 0f, 0f, 0f);

            string strAttachment = Server.MapPath("~/Pdf/" + strPDFFileName);
            PdfWriter.GetInstance(doc, workStream).CloseStream = false;
            doc.Open();

            doc.Add(Add_Content_To_PDF(tableLayout));
            doc.Close();

            byte[] byteInfo = workStream.ToArray();
            workStream.Write(byteInfo, 0, byteInfo.Length);
            workStream.Position = 0;

            //var FileFE = File(workStream, "application/pdf", strPDFFileName);
            
            PdfSignature ps = new PdfSignature("serial number");
            ps.LoadPdfDocument(byteInfo);
            ps.SignaturePosition = SignaturePosition.BottomRight;
            ps.SigningReason = "Estoy aprobando el documento";

            //Carga el certificado MCS
            ps.DigitalSignatureCertificate = DigitalCertificate.LoadCertificate(false, "", "Seleccione el Certificado Digital", "Ministerio de Relaciones Exteriores del Perú");

            //W
            System.IO.File.WriteAllBytes(strAttachment, ps.ApplyDigitalSignature());
            //return File(strPDFFileName, "application/pdf");
            return File(strAttachment, "application/pdf");
        }

        protected PdfPTable Add_Content_To_PDF(PdfPTable tableLayout)
        {
            float[] headers = { 50, 24, 45, 35, 50 }; //Header Widths  
            tableLayout.SetWidths(headers); //Set the pdf headers  
            tableLayout.WidthPercentage = 80; //Set the PDF File witdh percentage  
            tableLayout.HeaderRows = 1;

            List<BEMoneda> Monedas = new BLMoneda().Listar()
                .Where(p => p.Asignable.IntValue == 1)
                .ToList();
                

            tableLayout.AddCell(
                new PdfPCell(
                    new Phrase("FORMATO DE EGRESOS",
                        new Font(Font.HELVETICA, 7, 1, new iTextSharp.text.Color(0, 0, 0))))
                {
                    Colspan = 12,
                    Border = 10,
                    PaddingBottom = 5,
                    HorizontalAlignment = Element.ALIGN_CENTER
                });
            
            AddCellToHeader(tableLayout, "CID");
            AddCellToHeader(tableLayout, "Nombre");
            AddCellToHeader(tableLayout, "Abreviatura");
            AddCellToHeader(tableLayout, "ISO");
            AddCellToHeader(tableLayout, "Sufijo contable");

            foreach (var mon in Monedas)
            {

                AddCellToBody(tableLayout, mon.CID);
                AddCellToBody(tableLayout, mon.Nombre);
                AddCellToBody(tableLayout, mon.Abreviatura);
                AddCellToBody(tableLayout, mon.ISO4217);
                AddCellToBody(tableLayout, mon.SufijoContable);
            }

            return tableLayout;
        }

        private static void AddCellToHeader(PdfPTable tableLayout, string cellText)
        {
            tableLayout.AddCell(new PdfPCell(new Phrase(cellText, new Font(Font.HELVETICA, 7, 1, iTextSharp.text.Color.WHITE)))
            {
                HorizontalAlignment = Element.ALIGN_LEFT,
                Padding = 5,
                BackgroundColor = new iTextSharp.text.Color(Color.LIGHT_GRAY.ToArgb())
            });
        }

        private static void AddCellToBody(PdfPTable tableLayout, string cellText)
        {
            tableLayout.AddCell(new PdfPCell(new Phrase(cellText, new Font(Font.HELVETICA, 7, 1, iTextSharp.text.Color.BLACK)))
            {
                HorizontalAlignment = Element.ALIGN_LEFT,
                Padding = 5,
                BackgroundColor = new iTextSharp.text.Color(255, 255, 255)
            });
        }
        */
        #endregion
    }
}