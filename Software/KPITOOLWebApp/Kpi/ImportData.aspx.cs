using Artexacta.App.Categories;
using Artexacta.App.Categories.BLL;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Utilities.ExcelProcessing;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
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
            KPIType.Text = theData.KPITypeName;
            ReportingPeriod.Text = theData.ReportingUnitName;
            StartingDate.Text = theData.StartDate == DateTime.MinValue ? " - " : theData.StartDate.ToString("MM/dd/yyyy");
            UnitIdHiddenField.Value = theData.UnitID;

            switch (UnitIdHiddenField.Value)
            {
                case "TIME":
                    DataDescriptionLabel.Text = Resources.ImportData.TimeDataDescription;
                    break;
                case "INT":
                    DataDescriptionLabel.Text = Resources.ImportData.IntegerDataDescription;
                    break;
                default:
                    DataDescriptionLabel.Text = Resources.ImportData.DecimalDataDescription;
                    break;
            }
            
            BindGridView();
            LoadFormEnterData();
        }
    }

    private void BindGridView()
    {
        List<KPIMeasurements> theList = new List<KPIMeasurements>();
        try
        {
            if (UnitIdHiddenField.Value.Equals("TIME"))
                theList = KpiMeasurementBLL.GetKPIMeasurementCategoriesTimeByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
            else
                theList = KpiMeasurementBLL.GetKPIMeasurementCategoriesByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
        }

        KpiMeasurementGridView.DataSource = theList;
        KpiMeasurementGridView.DataBind();
        if(theList.Count > 0 && string.IsNullOrEmpty(theList[0].Detalle))
            KpiMeasurementGridView.Columns[2].Visible = false;
    }

    protected void KpiMeasurementGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPIMeasurements)
        {
            KPIMeasurements theData = (KPIMeasurements)e.Row.DataItem;
            Label valueLabel = (Label)e.Row.FindControl("ValueLabel");
            switch (UnitIdHiddenField.Value)
            {
                case "TIME":
                    valueLabel.Text = theData.DataTime.TimeDescription;
                    break;
                case "INT":
                    valueLabel.Text = Convert.ToInt32(theData.Measurement).ToString();
                    break;
                default:
                    valueLabel.Text = string.Format("{0:#,0.000}", theData.Measurement);
                    break;
            }
        }
    }

    protected void KpiMeasurementGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string measurementId = e.CommandArgument.ToString();
        if (e.CommandName.Equals("DeleteData"))
        {
            try
            {
                KpiMeasurementBLL.DeleteKpiMeasuerement(Convert.ToInt32(measurementId));
                SystemMessages.DisplaySystemMessage("The data was deleted.");
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }

        BindGridView();
    }

    protected void KpiMeasurementGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        KpiMeasurementGridView.PageIndex = e.NewPageIndex;
        KpiMeasurementGridView.DataBind();
    }

    #region EnterData Manually
    private void LoadFormEnterData()
    {
        DateTextBox.Text = DateTime.Now.ToString("MM/dd/yyyy");

        //-- get CategoriesItems in Target
        List<KPITarget> theTargetList = new List<KPITarget>();
        try
        {
            theTargetList = KPITargetBLL.GetKPITargetCategoriesByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error("Error en GetKPITargetCategoriesByKpiId para kpiId: " + KPIIdHiddenField.Value, exc);
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        if (theTargetList.Count <= 0)
        {
            theTargetList.Add(new KPITarget());
        }

        EnterDataRepeater.DataSource = theTargetList;
        EnterDataRepeater.DataBind();
    }

    protected void EnterDataRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            KPITarget theData = (KPITarget)(e.Item.DataItem);
            if (string.IsNullOrEmpty(theData.Detalle))
                e.Item.FindControl("pnlDetalle").Visible = false;

            if (UnitIdHiddenField.Value.Equals("TIME"))
            {
                e.Item.FindControl("pnlDataDecimal").Visible = false;
                e.Item.FindControl("pnlDataTime").Visible = true;
            }
            else
            {
                e.Item.FindControl("pnlDataTime").Visible = false;
                e.Item.FindControl("pnlDataDecimal").Visible = true;
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        List<KPIMeasurements> theList = new List<KPIMeasurements>();
        KPIMeasurements theData = null;
        try
        {
            foreach (RepeaterItem item in EnterDataRepeater.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    theData = new KPIMeasurements();
                    theData.Date = Convert.ToDateTime(DateTextBox.Text);

                    Label detalleLabel = (Label)item.FindControl("DetalleLabel");
                    HiddenField categoriesLabel = (HiddenField)item.FindControl("CategoriesLabel");
                    if (detalleLabel != null)
                    {
                        theData.Detalle = detalleLabel.Text;
                        theData.Categories = categoriesLabel.Value;
                    }
                    else
                    {
                        theData.Detalle = "";
                        theData.Categories = "";
                    }

                    if (UnitIdHiddenField.Value.Equals("TIME"))
                    {
                        DropDownList yearsCombobox = (DropDownList)item.FindControl("YearsCombobox");
                        DropDownList monthsCombobox = (DropDownList)item.FindControl("MonthsCombobox");
                        DropDownList daysCombobox = (DropDownList)item.FindControl("DaysCombobox");
                        DropDownList hoursCombobox = (DropDownList)item.FindControl("HoursCombobox");
                        DropDownList minutesCombobox = (DropDownList)item.FindControl("MinutesCombobox");

                        theData.DataTime = new KPIDataTime(Convert.ToInt32(yearsCombobox.SelectedValue), Convert.ToInt32(monthsCombobox.SelectedValue),
                            Convert.ToInt32(daysCombobox.SelectedValue), Convert.ToInt32(hoursCombobox.SelectedValue), Convert.ToInt32(minutesCombobox.SelectedValue));
                    }
                    else
                    {
                        TextBox valueTextBox = (TextBox)item.FindControl("ValueTextBox");
                        theData.Measurement = Convert.ToDecimal(valueTextBox.Text, CultureInfo.InvariantCulture);
                    }

                    theList.Add(theData);
                }
            }
        }
        catch (Exception exc)
        {
            log.Error("Error al obtener los datos de EnterDataRepeater", exc);
            SystemMessages.DisplaySystemErrorMessage("There was an error to read the data to save.");
            return;
        }

        try
        {
            KpiMeasurementBLL.InsertKpiMeasuerementImported(Convert.ToInt32(KPIIdHiddenField.Value), theList, "A");
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        SystemMessages.DisplaySystemMessage("The data were registered.");
        BindGridView();
        LoadFormEnterData();
    }
    #endregion

    #region UploadData Excel
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

        //-- get Categories
        List<Category> theCategoryList = new List<Category>();
        try
        {
            theCategoryList = CategoryBLL.GetCategoriesByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        //-- get CategoriesItems in Target
        List<KPITarget> theTargetList = new List<KPITarget>();
        try
        {
            theTargetList = KPITargetBLL.GetKPITargetCategoriesByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error("Error en GetKPITargetCategoriesByKpiId para kpiId: " + KPIIdHiddenField.Value, exc);
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        //-- get Measurements
        List<KPIMeasurements> theMeasurementList = new List<KPIMeasurements>();
        try
        {
            theMeasurementList = KpiMeasurementBLL.GetKPIMeasurementCategoriesByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error("Error en GetKPIMeasurementCategoriesByKpiId para kpiId: " + KPIIdHiddenField.Value, exc);
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        try
        {
            using (ExcelPackage package = new ExcelPackage(FileUpload.FileContent))
            {
                // get the first worksheet in the workbook
                ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
                if (worksheet.Dimension == null)
                {
                    SystemMessages.DisplaySystemErrorMessage("The file is empty.");
                    return;
                }
            }

            string[] dateFormats = { "MM/dd/yyyy", "dd/MM/yyyy" };
            string timeFormat = "^P(([0-9]|10)Y)(([0-9]|10|11)M)?(([0-9]|[1-2][0-9]|30)D)?(T(([0-9]|1[0-9]|2[0-3])H)?(([0-9]|[1-5][0-9])M)?)?$";
            Regex regexTime = new Regex(timeFormat);
            //-- leer Excel
            List<ExColumn> columns = new List<ExColumn>();
            columns.Add(new DateExColumn("Date", true, true));
            foreach (Category theCategory in theCategoryList)
            {
                columns.Add(new ListExColumn(theCategory.ID, true, true, theCategory.ItemsList.Split(';').ToList().FindAll(i => !string.IsNullOrEmpty(i))));
            }
            switch (UnitIdHiddenField.Value)
            {
                case "TIME":
                    columns.Add(new StringExColumn("Value", true, true, timeFormat));
                    break;
                case "INT":
                    columns.Add(new IntegerExColumn("Value", true, true, true));
                    break;
                default:
                    columns.Add(new DecimalExColumn("Value", true, true, true));
                    break;
            }

            List<String> errors = new List<string>();
            DataSet newDataSet = ExProcess.ReadExcelSpreadhseet(FileUpload.FileContent, columns, errors);
            if (errors.Count > 0)
            {
                ErrorFileRepeater.DataSource = errors;
                ErrorFileRepeater.DataBind();
                pnlErrorData.Visible = true;
                ErrorFileLabel.Text = string.Format("The following errors were found when reading the file '{0}':", FileUpload.FileName);
                return;
            }

            List<KPIMeasurements> theList = new List<KPIMeasurements>();
            KPIMeasurements theData = null;
            List<string> theItemList = null;
            string itemCategories = "";
            DateTime date = DateTime.MinValue;

            for (int i = 0; i < newDataSet.Tables[0].Rows.Count; i++)
            {
                DataRow theRow = newDataSet.Tables[0].Rows[i];
                theData = new KPIMeasurements();
                theData.Date = DateTime.Parse(theRow["Date"].ToString().Trim());

                if (UnitIdHiddenField.Value.Equals("TIME"))
                    theData.DataTime = GetMeasurementTime(theRow["Value"].ToString().Trim(), regexTime);
                else
                    theData.Measurement = Convert.ToDecimal(theRow["Value"].ToString().Trim());

                //--verifiy item categories
                if (theCategoryList.Count > 0)
                {
                    theItemList = new List<string>();
                    foreach (Category theCategory in theCategoryList)
                        theItemList.Add(theRow[theCategory.ID].ToString().Trim());
                    itemCategories = string.Join(", ", theItemList.OrderBy(item => item));

                    if (!theTargetList.Exists(t => t.Detalle.Trim().Equals(itemCategories)))
                    {
                        errors.Add("Error in row: " + (i + 2).ToString() + ", the combinations of items '" + itemCategories + "' does not exist for the KPI.");
                        continue;
                    }
                    theData.Detalle = itemCategories;
                    theData.Categories = theTargetList.Find(t => t.Detalle.Trim().Equals(itemCategories)).Categories;

                    //--verifiy if exists measurement in file
                    if (theList.Exists(m => m.Date == date && m.Detalle.Equals(theData.Detalle)))
                        continue;

                    //-- verify if exists measurement in BD
                    if (theMeasurementList.Exists(m => m.Date == theData.Date && m.Detalle.Equals(theData.Detalle)))
                    {
                        theData.TypeImport = "U";
                        theData.MeasurementID = theMeasurementList.Find(m => m.Date == theData.Date && m.Detalle.Equals(theData.Detalle)).MeasurementID;
                    }
                    else
                        theData.TypeImport = "I";
                }
                else
                {
                    theData.Detalle = "";
                    theData.Categories = "";

                    //--verifiy if exists measurement in file
                    if (theList.Exists(m => m.Date == date))
                        continue;

                    //-- verify if exists measurement in BD
                    if (theMeasurementList.Exists(m => m.Date == theData.Date))
                    {
                        theData.TypeImport = "U";
                        theData.MeasurementID = theMeasurementList.Find(m => m.Date == theData.Date).MeasurementID;
                    }
                    else
                        theData.TypeImport = "I";
                }

                theList.Add(theData);
                theItemList = null;
                itemCategories = "";
                date = DateTime.MinValue;
            }

            if (errors.Count > 0)
            {
                ErrorFileRepeater.DataSource = errors;
                ErrorFileRepeater.DataBind();
                pnlErrorData.Visible = true;
                ErrorFileLabel.Text = string.Format("The following errors were found when reading the file '{0}':", FileUpload.FileName);
                return;
            }

            if (theList.Count == 0)
            {
                SystemMessages.DisplaySystemWarningMessage("The file does not have data to register.");
                return;
            }

            pnlData.Visible = true;
            pnlMeasurement.Visible = false;
            DataGridView.DataSource = theList;
            DataGridView.DataBind();
            if (theCategoryList.Count == 0)
                DataGridView.Columns[1].Visible = false;
            Session["KpiMeasurementList"] = theList;
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
        }
    }

    protected void DataGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is KPIMeasurements)
        {
            KPIMeasurements theData = (KPIMeasurements)e.Row.DataItem;
            Label valueLabel = (Label)e.Row.FindControl("ValueLabel");
            switch (UnitIdHiddenField.Value)
            {
                case "TIME":
                    valueLabel.Text = theData.DataTime.TimeDescription;
                    break;
                case "INT":
                    valueLabel.Text = Convert.ToInt32(theData.Measurement).ToString();
                    break;
                default:
                    valueLabel.Text = string.Format("{0:#,0.000}", theData.Measurement);
                    break;
            }

            if (theData.TypeImport.Equals("I"))
            {
                e.Row.Cells[0].ForeColor = System.Drawing.Color.Green;
                e.Row.Cells[0].Font.Bold = true;
            }
            else if (theData.TypeImport.Equals("U"))
            {
                e.Row.Cells[0].ForeColor = System.Drawing.Color.Orange;
                e.Row.Cells[0].Font.Bold = true;
            }
        }
    }

    protected void SaveUploadDataButton_Click(object sender, EventArgs e)
    {
        List<KPIMeasurements> theList = null;
        try
        {
            theList = (List<KPIMeasurements>)Session["KpiMeasurementList"];
        }
        catch (Exception exc)
        {
            log.Error("Error al obtener la informacion de KpiMeasurementList en session", exc);
        }

        if (theList == null)
        {
            SystemMessages.DisplaySystemErrorMessage("There are not data in session to save.");
            return;
        }

        try
        {
            KpiMeasurementBLL.InsertKpiMeasuerementImported(Convert.ToInt32(KPIIdHiddenField.Value), theList, TypeRadioButtonList.SelectedValue);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        SystemMessages.DisplaySystemMessage("The data were registered.");
        pnlData.Visible = false;
        pnlMeasurement.Visible = true;
        DataGridView.DataSource = null;
        DataGridView.DataBind();
        BindGridView();
        Session["KpiMeasurementList"] = null;
    }

    protected void CancelUploadDataButton_Click(object sender, EventArgs e)
    {
        pnlData.Visible = false;
        pnlMeasurement.Visible = true;
        DataGridView.DataSource = null;
        DataGridView.DataBind();
        Session["KpiMeasurementList"] = null;
    }
    #endregion

    protected void UploadFileButton_Click(object sender, EventArgs e)
    {
        pnlEnterData.Visible = false;
        pnlUploadFile.Visible = true;
    }

    protected void EnterDataButton_Click(object sender, EventArgs e)
    {
        pnlUploadFile.Visible = false;
        pnlEnterData.Visible = true;

        LoadFormEnterData();
    }

    private KPIDataTime GetMeasurementTime(string value, Regex regexTime)
    {
        KPIDataTime theData = new KPIDataTime();
        Match matches = regexTime.Match(value);
        bool haveTime = false;
        if (matches.Success)
        {
            for (int g = 1; g <= matches.Groups.Count; g++)
            {
                if (string.IsNullOrEmpty(matches.Groups[g].Value))
                    continue;
                else if (matches.Groups[g].Value.Contains("T"))
                {
                    haveTime = true;
                }
                else if (matches.Groups[g].Value.Contains("Y"))
                {
                    theData.Year = Convert.ToInt32(matches.Groups[g].Value.Replace("Y", ""));
                }
                else if (matches.Groups[g].Value.Contains("M"))
                {
                    if(haveTime)
                        theData.Minute = Convert.ToInt32(matches.Groups[g].Value.Replace("M", ""));
                    else
                        theData.Month = Convert.ToInt32(matches.Groups[g].Value.Replace("M", ""));
                }
                else if (matches.Groups[g].Value.Contains("D"))
                {
                    theData.Day = Convert.ToInt32(matches.Groups[g].Value.Replace("D", ""));
                }
                else if (matches.Groups[g].Value.Contains("H"))
                {
                    theData.Hour = Convert.ToInt32(matches.Groups[g].Value.Replace("H", ""));
                }
            }
        }

        return theData;
    }

}