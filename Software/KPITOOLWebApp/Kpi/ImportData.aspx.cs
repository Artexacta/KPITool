using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Utilities.ExcelProcessing;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpi_ImportData : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(KPIIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Kpi/KpiList.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        if (!string.IsNullOrEmpty(Request["ID"]))
        {
            KPIIdHiddenField.Value = Request["ID"].ToString();
        }
        else if (Session["KPIID"] != null && !string.IsNullOrEmpty(Session["KPIID"].ToString()))
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(Session["KPIID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session kpiId:" + Session["KPIID"]);
            }

            KPIIdHiddenField.Value = kpiId.ToString();
            Session["KPIID"] = null;
        }
    }

    private void LoadData()
    {
        //-- show Data
        KPI theData = null;
        try
        {
            theData = KPIBLL.GetKPIById(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        if (theData != null)
        {
            SubtitleLabel.Text = theData.Name;
            KPIType.Text = theData.KpiTypeID;
            ReportingPeriod.Text = theData.ReportingUnit;
            StartingDate.Text = theData.StartDate.ToString("dd-MM-yyyy");
        }
    }

    protected void UploadDataButton_Click(object sender, EventArgs e)
    {
        string[] validFileTypes = { ".xlsx" };
        string ext = System.IO.Path.GetExtension(FileUpload.PostedFile.FileName);
        bool isValidFile = false;
        for (int i = 0; i < validFileTypes.Length; i++)
        {
            if (ext == validFileTypes[i])
            {
                isValidFile = true;
                break;
            }
        }

        if (!isValidFile)
        {
            ValidateFile.ForeColor = System.Drawing.Color.Red;
            ValidateFile.Text = "Invalid file. Please select a fil with the extension " + string.Join(",", validFileTypes);
            return;
        }

        try
        {
            //-- leer Excel
            List<ExColumn> columns = new List<ExColumn>();
            columns.Add(new IntegerExColumn("Date", true, true, true));
            columns.Add(new StringExColumn("Value", true, true));


        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
        }
    }

}