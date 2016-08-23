using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiCharts_ExcelExportKpiChart : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set { KpiIdHiddenField.Value = value.ToString(); }
        get
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error getting ", ex);
            }
            return kpiId;
        }
    }

    public string CategoryId
    {
        set
        {
            CategoryIdHiddenField.Value = value;
        }
        get
        {
            return CategoryIdHiddenField.Value;
        }
    }

    public string CategoryItemId
    {
        set
        {
            CategoryItemIdHiddenField.Value = value;
        }
        get
        {
            return CategoryItemIdHiddenField.Value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ExportButton_Click(object sender, EventArgs e)
    {
        byte[] excelByteArray = null;
        try
        {
            decimal target = 0;
            string strategy = "";
            string startingPeriod = "";
            string endingPeriod = "";
            int firstDayOfWeek = Artexacta.App.Configuration.Configuration.GetFirstDayOfWeek();
            List<KpiChartData> kpiSeries = KpiMeasurementBLL.GetKPIMeasurementForChart(KpiId, CategoryId, CategoryItemId, firstDayOfWeek, ref strategy, ref target, ref startingPeriod, ref endingPeriod);
            bool hasTarget = target > -1;
            excelByteArray = GetChartAsExcelByteArray(kpiSeries, target, hasTarget);
        }
        catch (Exception ex)
        {
            log.Error("Error exporting chart data", ex);
        }

        if (excelByteArray == null)
            return;

        try
        {
            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=\"KPIChart_" + KpiId + ".xlsx\"");
            Response.BinaryWrite(excelByteArray);
        }
        catch (Exception q)
        {
            log.Error("Error al exportar", q);
            SystemMessages.DisplaySystemErrorMessage("Error al exportar el libro de venta a Excel.");
        }
        finally
        {
            Response.Flush();
            Response.End();
        }
    }

    public byte[] GetChartAsExcelByteArray(List<KpiChartData> data, decimal  target, bool hasTarget)
    {
        DataTable theTable = new DataTable();

        StringBuilder result = new StringBuilder();

        byte[] arrayData = new byte[0];

        Type decimalType = Type.GetType("System.Decimal");
        Type longType = Type.GetType("System.Int64");

        theTable.Columns.Add("period", typeof(string));
        theTable.Columns.Add("measurement", decimalType);
        if(hasTarget)
            theTable.Columns.Add("target", decimalType);

        foreach (var obj in data)
        {
            DataRow row = theTable.NewRow();

            row["period"] = obj.Period;
            row["measurement"] = obj.Measurement;
            if(hasTarget)
                row["target"] = target;

            theTable.Rows.Add(row);
        }

        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("LV");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(theTable, true);

            //    theTable.Columns.Count - 4].Style.Numberformat.Format = @"yyyy-MM-dd HH:mm:ss";
            ws.Cells["I:P"].Style.Numberformat.Format = "0.00";
            ws.Cells[ws.Dimension.Address.ToString()].AutoFitColumns();

            arrayData = pck.GetAsByteArray();
        }

        return arrayData;
    }
}