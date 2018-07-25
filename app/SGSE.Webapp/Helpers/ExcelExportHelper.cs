using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;

namespace SGSE.Webapp.Helpers
{
    public class ExcelExportHelper
    {
        public static string ExcelContentType
        {
            get
            { return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; }
        }

        /// <summary>
        /// Devuelve un datatable T a partir de una Lista T
        /// </summary>
        /// <typeparam name="T">Tipo de dato</typeparam>
        /// <param name="data">Datos</param>
        /// <returns>DataTable</returns>
        public static DataTable ListToDataTable<T>(List<T> data)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));
            DataTable dataTable = new DataTable();

            for (int i = 0; i < properties.Count; i++) {
                PropertyDescriptor property = properties[i];
                dataTable.Columns.Add(property.Name, Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }

            object[] values = new object[properties.Count];
            foreach (T item in data) {
                for (int i = 0; i < values.Length; i++) {
                    values[i] = properties[i].GetValue(item);
                }
                dataTable.Rows.Add(values);
            }
            return dataTable;
        }

        /// <summary>
        /// Devuelve los datos del contenido del archivo de excel
        /// </summary>
        /// <param name="dataTable">DataTable</param>
        /// <param name="heading">Encabezado</param>
        /// <param name="showNroItem">Mostrar el número de item</param>
        /// <param name="columnsToTake">Columnas</param>
        /// <returns>byte[]</returns>
        public static byte[] ExportExcel(DataTable dataTable, string heading = "", string footer = "", bool showNroItem = false, params string[] columnsToTake)
        {
            byte[] result = null;


            using (ExcelPackage package = new ExcelPackage())
            {
                // Nombre del Worksheet
                ExcelWorksheet workSheet = package.Workbook.Worksheets.Add(heading);
                int ROWSTART = String.IsNullOrEmpty(heading) ? 1 : 3;
                var CELLSTART = "A" + (ROWSTART.ToString());
                var CELLENDIN = "A" + (ROWSTART + dataTable.Rows.Count + 2).ToString();

                int FONTSIZE = 10;

                if (showNroItem)
                {
                    DataColumn dataColumn = dataTable.Columns.Add("N°", typeof(int));
                    dataColumn.SetOrdinal(0);
                    
                    int index = 1;
                    foreach (DataRow item in dataTable.Rows)
                    {
                        item[0] = index;
                        index++;
                    }
                }
                // Estilo global
                workSheet.Cells.Style.Font.Size = FONTSIZE;

                // adiciona el contenido en el archivo
                workSheet.Cells[CELLSTART].LoadFromDataTable(dataTable, true);

                // ajuste automatico de columnas
                int columnIndex = 1;
                foreach (DataColumn column in dataTable.Columns)
                {
                    if (workSheet.Dimension != null)
                    {
                        ExcelRange columnCells = workSheet.Cells[workSheet.Dimension.Start.Row, columnIndex, workSheet.Dimension.End.Row, columnIndex];
                        int maxLength = columnCells.Max(cell => (cell.Value == null) ? 0 : cell.Value.ToString().Count());
                        if (maxLength < 100)
                        {
                            workSheet.Column(columnIndex).AutoFit();
                        }
                    }
                    else
                    {
                        workSheet.Column(columnIndex).AutoFit();
                    }

                    if (columnIndex == 1 && showNroItem)
                    {
                        workSheet.Cells[ROWSTART, columnIndex, (ROWSTART + dataTable.Rows.Count), columnIndex].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    }

                    columnIndex++;
                }

                // Formato de encabezado

                Color LineColor = Color.FromArgb(169, 169, 169);

                using (ExcelRange r = workSheet.Cells[ROWSTART, 1, ROWSTART, dataTable.Columns.Count])
                {
                    r.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Right.Style = ExcelBorderStyle.Thin;

                    r.Style.Border.Top.Color.SetColor(LineColor);
                    r.Style.Border.Bottom.Color.SetColor(LineColor);
                    r.Style.Border.Left.Color.SetColor(LineColor);
                    r.Style.Border.Right.Color.SetColor(LineColor);

                    r.Style.Font.Color.SetColor(Color.Black);
                    r.Style.Font.Bold = true;
                    r.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    r.Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml("#EBF1DE"));
                }

                // Formato de celdas
                using (ExcelRange r = workSheet.Cells[ROWSTART + 1, 1, ROWSTART + dataTable.Rows.Count, dataTable.Columns.Count])
                {
                    r.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    r.Style.Border.Right.Style = ExcelBorderStyle.Thin;

                    r.Style.Border.Top.Color.SetColor(LineColor);
                    r.Style.Border.Bottom.Color.SetColor(LineColor);
                    r.Style.Border.Left.Color.SetColor(LineColor);
                    r.Style.Border.Right.Color.SetColor(LineColor);
                }

                // Pie de página
                workSheet.Cells[CELLENDIN].Value = footer;
                workSheet.Cells[CELLENDIN].Style.Font.Size = 8;

                // Encabezado
                if (!String.IsNullOrEmpty(heading))
                {
                    workSheet.Cells["A1"].Value = heading;
                    workSheet.Cells["A1"].Style.Font.Size = 12;
                    workSheet.Cells["A1"].Style.Font.Bold = true;

                    workSheet.InsertColumn(1, 1);
                    workSheet.InsertRow(1, 1);
                    workSheet.Column(1).Width = 5;
                }

                result = package.GetAsByteArray();
            }

            return result;
        }


        /// <summary>
        /// Exporta datos a un libro de excel
        /// </summary>
        /// <typeparam name="T">Entidad</typeparam>
        /// <param name="data">Lista de datos del Tipo Entidad</param>
        /// <param name="Heading">Encabezado</param>
        /// <param name="showSlno">Mostrar número de item</param>
        /// <param name="ColumnsToTake">Columnas del reporte</param>
        /// <returns></returns>
        public static byte[] ExportExcel<T>(List<T> data, string Heading = "", string Footer = "", bool showSlno = false, params string[] ColumnsToTake)
        {
            return ExportExcel(ListToDataTable<T>(data), Heading, Footer, showSlno, ColumnsToTake);
        }
    }
}