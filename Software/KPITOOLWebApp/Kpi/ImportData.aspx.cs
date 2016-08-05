using Artexacta.App.Categories;
using Artexacta.App.Categories.BLL;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.Utilities;
using Artexacta.App.Utilities.ExcelProcessing;
using Artexacta.App.Utilities.SystemMessages;
using Artexacta.App.Utilities.Text;
using log4net;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpi_ImportData : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

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
        //-- verify is user has permissions
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.KPI.ToString(), Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        if (theUser == null)
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.ShareData.UserNotOwnKpi);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

        if (theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            pnlUploadFile.Visible = true;
            pnlEnterData.Visible = false;
            KpiMeasurementGridView.Columns[0].Visible = true;
        }
        else if (theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("ENTER_DATA")))
        {
            pnlUploadFile.Visible = true;
            pnlEnterData.Visible = false;
            KpiMeasurementGridView.Columns[0].Visible = false;
        }
        else if (theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("VIEW_KPI")))
        {
            pnlUploadFile.Visible = false;
            pnlEnterData.Visible = false;
            KpiMeasurementGridView.Columns[0].Visible = false;
        }
        else 
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.ShareData.UserNotOwnKpi);
            Response.Redirect("~/Kpi/KpiList.aspx");
        }

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
            StartingDate.Text = theData.StartDate == DateTime.MinValue ? " - " : TextUtilities.GetDateTimeToString(theData.StartDate);
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

        if(theList.FindAll(i => !string.IsNullOrEmpty(i.Detalle)).Count > 0)
            KpiMeasurementGridView.Columns[2].Visible = true;
        else
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
                    valueLabel.Text = theData.Measurement.ToString(CultureInfo.InvariantCulture);
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
                SystemMessages.DisplaySystemMessage(Resources.ImportData.DeletedData);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }

            BindGridView();
        }
    }

    protected void KpiMeasurementGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        KpiMeasurementGridView.PageIndex = e.NewPageIndex;
        BindGridView();
    }

    #region EnterData Manually
    private void LoadFormEnterData()
    {
        DateTextBox.Text = DateTime.Today.ToString("yyyy-MM-dd");
        DateTextBox.Attributes.Add("onchange", "DateTextBox_OnChange()");

        //-- get CategoriesItems combinated
        List<KPICategoyCombination> theCombinatedList = new List<KPICategoyCombination>();
        try
        {
            theCombinatedList = KPICategoryCombinationBLL.GetCategoryItemsCombinatedByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error("Error en GetCategoryItemsCombinatedByKpiId para kpiId: " + KPIIdHiddenField.Value, exc);
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        if (theCombinatedList.Count <= 0)
        {
            theCombinatedList.Add(new KPICategoyCombination());
        }

        EnterDataRepeater.DataSource = theCombinatedList;
        EnterDataRepeater.DataBind();
    }

    protected void EnterDataRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            KPICategoyCombination theData = (KPICategoyCombination)(e.Item.DataItem);
            if (string.IsNullOrEmpty(theData.ItemsList))
                e.Item.FindControl("pnlDetalle").Visible = false;

            if (UnitIdHiddenField.Value.Equals("TIME"))
            {
                e.Item.FindControl("pnlDataDecimal").Visible = false;
                e.Item.FindControl("pnlDataTime").Visible = true;

                DropDownList yearsCombobox = (DropDownList)e.Item.FindControl("YearsCombobox");
                DropDownList monthsCombobox = (DropDownList)e.Item.FindControl("MonthsCombobox");
                DropDownList daysCombobox = (DropDownList)e.Item.FindControl("DaysCombobox");
                DropDownList hoursCombobox = (DropDownList)e.Item.FindControl("HoursCombobox");
                DropDownList minutesCombobox = (DropDownList)e.Item.FindControl("MinutesCombobox");
                HiddenField measurementIDsHiddenField = (HiddenField)e.Item.FindControl("MeasurementIDsHiddenField");
                Label imageTimeUpdate = (Label)e.Item.FindControl("ImageTimeUpdate");

                yearsCombobox.Attributes.Add("onchange", "TimeComboBox_OnChange('" + yearsCombobox.ClientID + "', '" + monthsCombobox.ClientID + "', '" + daysCombobox.ClientID
                    + "', '" + hoursCombobox.ClientID + "', '" + minutesCombobox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" + imageTimeUpdate.ClientID 
                    + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
                monthsCombobox.Attributes.Add("onchange", "TimeComboBox_OnChange('" + yearsCombobox.ClientID + "', '" + monthsCombobox.ClientID + "', '" + daysCombobox.ClientID
                    + "', '" + hoursCombobox.ClientID + "', '" + minutesCombobox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" + imageTimeUpdate.ClientID
                    + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
                daysCombobox.Attributes.Add("onchange", "TimeComboBox_OnChange('" + yearsCombobox.ClientID + "', '" + monthsCombobox.ClientID + "', '" + daysCombobox.ClientID
                    + "', '" + hoursCombobox.ClientID + "', '" + minutesCombobox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" + imageTimeUpdate.ClientID
                    + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
                hoursCombobox.Attributes.Add("onchange", "TimeComboBox_OnChange('" + yearsCombobox.ClientID + "', '" + monthsCombobox.ClientID + "', '" + daysCombobox.ClientID
                    + "', '" + hoursCombobox.ClientID + "', '" + minutesCombobox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" + imageTimeUpdate.ClientID
                    + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
                minutesCombobox.Attributes.Add("onchange", "TimeComboBox_OnChange('" + yearsCombobox.ClientID + "', '" + monthsCombobox.ClientID + "', '" + daysCombobox.ClientID
                    + "', '" + hoursCombobox.ClientID + "', '" + minutesCombobox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" + imageTimeUpdate.ClientID
                    + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
            }
            else
            {
                e.Item.FindControl("pnlDataTime").Visible = false;
                e.Item.FindControl("pnlDataDecimal").Visible = true;
                TextBox valueTextBox = (TextBox)e.Item.FindControl("ValueTextBox");
                HiddenField measurementIDsHiddenField = (HiddenField)e.Item.FindControl("MeasurementIDsHiddenField");
                Label valueRequiredFileValidator = (Label)e.Item.FindControl("ValueRequiredFileValidator");
                Label imageUpdate = (Label)e.Item.FindControl("ImageUpdate");

                valueTextBox.Attributes.Add("onchange", "ValueTextBox_OnChange('" + valueTextBox.ClientID + "', '" + measurementIDsHiddenField.ClientID + "', '" 
                    + valueRequiredFileValidator.ClientID + "', '" + imageUpdate.ClientID + "', '" + theData.ItemsList + "', '" + theData.CategoriesList + "')");
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

                    HiddenField measurementIDsHiddenField = (HiddenField)item.FindControl("MeasurementIDsHiddenField");
                    theData.MeasurementIDsToReplace = measurementIDsHiddenField.Value;

                    if (UnitIdHiddenField.Value.Equals("TIME"))
                    {
                        DropDownList yearsCombobox = (DropDownList)item.FindControl("YearsCombobox");
                        DropDownList monthsCombobox = (DropDownList)item.FindControl("MonthsCombobox");
                        DropDownList daysCombobox = (DropDownList)item.FindControl("DaysCombobox");
                        DropDownList hoursCombobox = (DropDownList)item.FindControl("HoursCombobox");
                        DropDownList minutesCombobox = (DropDownList)item.FindControl("MinutesCombobox");

                        if (!yearsCombobox.SelectedValue.Equals("0") || !monthsCombobox.SelectedValue.Equals("0") ||
                            !daysCombobox.SelectedValue.Equals("0") || !hoursCombobox.SelectedValue.Equals("0") ||
                            !minutesCombobox.SelectedValue.Equals("0"))
                            theData.DataTime = new KPIDataTime(Convert.ToInt32(yearsCombobox.SelectedValue), Convert.ToInt32(monthsCombobox.SelectedValue),
                                Convert.ToInt32(daysCombobox.SelectedValue), Convert.ToInt32(hoursCombobox.SelectedValue), Convert.ToInt32(minutesCombobox.SelectedValue));
                    }
                    else
                    {
                        TextBox valueTextBox = (TextBox)item.FindControl("ValueTextBox");
                        if (!string.IsNullOrEmpty(valueTextBox.Text))
                            theData.Measurement = Convert.ToDecimal(valueTextBox.Text, CultureInfo.InvariantCulture);
                    }

                    if (theData.Measurement > 0 || theData.DataTime != null)
                        theList.Add(theData);
                }
            }
        }
        catch (Exception exc)
        {
            log.Error("Error al obtener los datos de EnterDataRepeater", exc);
            SystemMessages.DisplaySystemErrorMessage(Resources.ImportData.ErrorToObtainData);
            return;
        }

        try
        {
            KpiMeasurementBLL.InsertKpiMeasuerementImported(Convert.ToInt32(KPIIdHiddenField.Value), theList, TypeRadioButtonList1.SelectedValue);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        SystemMessages.DisplaySystemMessage(Resources.ImportData.RegisteredData);
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
            ValidateFile.Text = Resources.ImportData.InvalidaFile + string.Join(",", validFileTypes);
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

        //-- get CategoriesItems combinated
        List<KPICategoyCombination> theCombinatedList = new List<KPICategoyCombination>();
        try
        {
            theCombinatedList = KPICategoryCombinationBLL.GetCategoryItemsCombinatedByKpiId(Convert.ToInt32(KPIIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            log.Error("Error en GetCategoryItemsCombinatedByKpiId para kpiId: " + KPIIdHiddenField.Value, exc);
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
                    SystemMessages.DisplaySystemErrorMessage(Resources.ImportData.EmptyFile);
                    return;
                }
            }

            string timeFormat = Resources.Validations.TimeDataFormat;
            Regex regexTime = new Regex(timeFormat);
            //-- leer Excel
            List<ExColumn> columns = new List<ExColumn>();
            columns.Add(new DateExColumn(Resources.ImportData.DateColumn, true, true));
            foreach (Category theCategory in theCategoryList)
            {
                columns.Add(new ListExColumn(theCategory.ID, true, true, theCategory.ItemsList.Split(';').ToList().FindAll(i => !string.IsNullOrEmpty(i))));
            }
            switch (UnitIdHiddenField.Value)
            {
                case "TIME":
                    columns.Add(new StringExColumn(Resources.ImportData.ValueColumn, true, true, timeFormat));
                    break;
                case "INT":
                    columns.Add(new IntegerExColumn(Resources.ImportData.ValueColumn, true, true, true));
                    break;
                default:
                    columns.Add(new DecimalExColumn(Resources.ImportData.ValueColumn, true, true, true));
                    break;
            }

            List<String> errors = new List<string>();
            DataSet newDataSet = ExProcess.ReadExcelSpreadhseet(FileUpload.FileContent, columns, errors);
            if (errors.Count > 0)
            {
                ErrorFileRepeater.DataSource = errors;
                ErrorFileRepeater.DataBind();
                pnlErrorData.Visible = true;
                ErrorFileLabel.Text = string.Format(Resources.ImportData.ErrorsInFile, FileUpload.FileName);
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
                theData.Date = DateTime.Parse(theRow[Resources.ImportData.DateColumn].ToString().Trim());

                if (UnitIdHiddenField.Value.Equals("TIME"))
                    theData.DataTime = GetMeasurementTime(theRow[Resources.ImportData.ValueColumn].ToString().Trim(), regexTime);
                else
                    theData.Measurement = Convert.ToDecimal(theRow[Resources.ImportData.ValueColumn].ToString().Trim());

                //--verifiy item categories
                if (theCategoryList.Count > 0)
                {
                    theItemList = new List<string>();
                    foreach (Category theCategory in theCategoryList)
                        theItemList.Add(theRow[theCategory.ID].ToString().Trim());
                    itemCategories = string.Join(", ", theItemList.Select(item => item));

                    if (!theCombinatedList.Exists(t => t.ItemsList.Equals(itemCategories)))
                    {
                        errors.Add(string.Format(Resources.ImportData.ErrorDataInFile, (i + 2).ToString(), itemCategories));
                        continue;
                    }
                    theData.Detalle = itemCategories;
                    theData.Categories = theCombinatedList.Find(t => t.ItemsList.Trim().Equals(itemCategories)).CategoriesList;

                    //--verifiy if exists measurement in file
                    if (theList.Exists(m => m.Date == date && m.Detalle.Equals(theData.Detalle) && m.Categories.Equals(theData.Categories)))
                        continue;

                    //-- verify if exists measurement in BD
                    if (theMeasurementList.Exists(m => m.Date == theData.Date && m.Detalle.Equals(theData.Detalle) && m.Categories.Equals(theData.Categories)))
                    {
                        theData.TypeImport = "U";
                        theData.MeasurementIDsToReplace = string.Join(";", theMeasurementList.FindAll(m => m.Date == theData.Date && m.Detalle.Equals(theData.Detalle) && m.Categories.Equals(theData.Categories)).Select(d => d.MeasurementID));
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
                        theData.MeasurementIDsToReplace = string.Join(";", theMeasurementList.FindAll(m => m.Date == theData.Date).Select(d => d.MeasurementID));
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
                ErrorFileLabel.Text = string.Format(Resources.ImportData.ErrorsInFile, FileUpload.FileName);
                return;
            }

            if (theList.Count == 0)
            {
                SystemMessages.DisplaySystemWarningMessage(Resources.ImportData.NoDataInFile);
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
                    valueLabel.Text = theData.Measurement.ToString(CultureInfo.InvariantCulture);
                    break;
            }

            Label imageUpdate = (Label)e.Row.FindControl("ImageUpdate");
            if (theData.TypeImport.Equals("U"))
                imageUpdate.Style["display"] = "inline";
            else
                imageUpdate.Style["display"] = "none";
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
            SystemMessages.DisplaySystemErrorMessage(Resources.ImportData.NoDataInSession);
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

        SystemMessages.DisplaySystemMessage(Resources.ImportData.RegisteredData);
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
                    if (haveTime)
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

    [WebMethod]
    public static string VerifiyData(int kpiId, string date, string detalle, string categories)
    {
        string listIds = KpiMeasurementBLL.VerifyKPIMeasurements(kpiId, Convert.ToDateTime(date), detalle, categories);
        return listIds;
    }

}