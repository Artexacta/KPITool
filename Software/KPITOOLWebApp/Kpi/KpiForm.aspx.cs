﻿using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Categories.BLL;
using Artexacta.App.Categories;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;

public partial class Kpi_KpiForm : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set { KpiIdHiddenField.Value = value.ToString(); }
        get
        {
            int KpiId = 0;
            try
            {
                KpiId = Convert.ToInt32(KpiIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert KpiIdHiddenField.Value to integer value", ex);
            }
            return KpiId;
        }
    }

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "~/Kpi/KpiList.aspx" : ParentPageHiddenField.Value; }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        LanguageHiddenField.Value = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();
        DataControl.DataType = UserControls_FRTWB_AddDataControl.AddType.KPI.ToString();
        Session["LIST_CATEGORIES"] = null;
        ProcessSessionParametes();
        LoadKpiData();
    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;

        if (Session["KPI_ID"] != null && !string.IsNullOrEmpty(Session["KPI_ID"].ToString()))
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(Session["KPI_ID"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['KpiId'] to integer value", ex);
            }
            KpiId = kpiId;
        }
        Session["KPI_ID"] = null;
    }

    private void LoadKpiData()
    {
        int kpiId = KpiId;
        if (kpiId <= 0)
            return;

        KPI theKpi = null;

        try
        {
            theKpi = KPIBLL.GetKPIById(kpiId);
        }
        catch { }

        if (theKpi == null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to obtain the Kpi information.");
            return;
        }

        KpiNameTextBox.Text = theKpi.Name;
        DataControl.OrganizationId = theKpi.OrganizationID;
        DataControl.AreaId = theKpi.AreaID;
        DataControl.ProjectId = theKpi.ProjectID;
        DataControl.ActivityId = theKpi.ActivityID;
        DataControl.PersonId = theKpi.PersonID;
        KPITypeCombobox.SelectedValue = theKpi.KpiTypeID;

        //Get de KPI Type information for enable controls
        KPIType theType = null;
        KPITypeBLL theBLL = new KPITypeBLL();

        try
        {
            theType = theBLL.GetKPITypesByID(theKpi.KpiTypeID, LanguageHiddenField.Value);
        }
        catch { }

        if (theType == null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get the KPI type information.");
            return;
        }

        UnitCombobox.SelectedValue = theKpi.UnitID;
        SelectedUnitHiddenField.Value = theKpi.UnitID;

        if (theType.UnitID.Trim() != "NA")
            UnitCombobox.Enabled = false;

        if (theKpi.UnitID == "MONEY")
        {
            CurrencyPanel.Style["display"] = "block";
            CurrencyCombobox.SelectedValue = theKpi.Currency;
            SelectedCurrencyHiddenField.Value = theKpi.Currency;
            MeasuredInCombobox.SelectedValue = theKpi.CurrencyUnitID;
            UnitTargetLabel.Text = MeasuredInCombobox.SelectedItem.Text + " of " + CurrencyCombobox.SelectedItem.Text;
        }
        if (theKpi.UnitID == "PERCENT")
        {
            UnitTargetLabel.Text = "%";
            SingleTargetRangeValidator.MaximumValue = "100";
            SingleTargetRangeValidator.Type = ValidationDataType.Double;
        }

        DirectionCombobox.SelectedValue = theKpi.DirectionID;
        SelectedDirectionHiddenField.Value = theKpi.DirectionID;
        if (theType.DirectionID.Trim() != "NA")
            DirectionCombobox.Enabled = false;

        StrategyCombobox.SelectedValue = theKpi.StrategyID;
        SelectedStrategyHiddenFields.Value = theKpi.StrategyID;
        if (theType.StrategyID.Trim() != "NA")
            StrategyCombobox.Enabled = false;

        ReportingPeriodCombobox.SelectedValue = theKpi.ReportingUnitID;
        ReportingPeriodHiddenfield.Value = theKpi.ReportingUnitID;
        UnitLabel.Text = theKpi.ReportingUnitID;
        TargetPeriodTextBox.Text = theKpi.TargetPeriod.ToString();

        if (theKpi.StartDate > DateTime.MinValue)
        {
            StartingDatePicker.SelectedDate = theKpi.StartDate;
        }
        else
        {
            StartingDatePicker.SelectedDate = null;
        }

        categoryCheckBox.Checked = theKpi.AllowCategories;

        //Get the single target Value
        KPITarget theTarget = null;

        try
        {
            theTarget = KPITargetBLL.GetKPITargetByKpiId(theKpi.KpiID);
        }
        catch { }

        if (theKpi.UnitID.Trim() == "TIME")
        {
            NumericSingleTargetPanel.Style["display"] = "none";
            TimeSingleTargetPanel.Style["display"] = "block";
        }
        else
        {
            NumericSingleTargetPanel.Style["display"] = "block";
            TimeSingleTargetPanel.Style["display"] = "none";
            SingleTargetTextBox.Text = "0";
        }

        if (theTarget != null && !theKpi.AllowCategories)
        {
            //Single Target
            SingleTargetPanel.Style["display"] = "block";

            if (theKpi.UnitID == "TIME")
            {
                NumericSingleTargetPanel.Style["display"] = "none";
                TimeSingleTargetPanel.Style["display"] = "block";

                //Get the target in time format
                KPITargetTime theTime = null;
                try
                {
                    theTime = KPITargetTimeBLL.GetKPITargetTimeByKpi(theKpi.KpiID);
                }
                catch { }

                if (theTime != null)
                {
                    YearsSingleCombobox.SelectedValue = theTime.Year.ToString();
                    MonthsSingleCombobox.SelectedValue = theTime.Month.ToString();
                    DaysSingleCombobox.SelectedValue = theTime.Day.ToString();
                    HoursSingleCombobox.SelectedValue = theTime.Hour.ToString();
                    MinutesSingleCombobox.SelectedValue = theTime.Minute.ToString();
                }
            }
            else
            {
                NumericSingleTargetPanel.Style["display"] = "block";
                TimeSingleTargetPanel.Style["display"] = "none";

                try
                {
                    SingleTargetTextBox.Text = theTarget.Target.ToString();
                }
                catch
                {
                    SystemMessages.DisplaySystemErrorMessage("No se pudo obtener el valor del target, es inválido.");
                }
            }
        }

        if (theTarget != null && theKpi.AllowCategories)
        {
            //Multiple Target
            SingleTargetPanel.Style["display"] = "none";
            MultipleTargetPanel.Style["display"] = "block";

            //Get the targets categories
            List<Category> theCList = new List<Category>();

            try
            {
                theCList = CategoryBLL.GetCategoriesByKpiId(kpiId);
            }
            catch
            {
                SystemMessages.DisplaySystemErrorMessage("Error to obtain the categories from the KPI.");
            }

            Session["LIST_CATEGORIES"] = theCList;
            CategoriesRepeater.DataSource = theCList;
            CategoriesRepeater.DataBind();

            //Load the Items of the categories
            List<KPITarget> theItems = new List<KPITarget>();
            try
            {
                theItems = KPITargetBLL.GetKPITargetCategoriesByKpiId(kpiId);
            }
            catch
            {
                SystemMessages.DisplaySystemErrorMessage("Error to obtain the categories items from the KPI.");
            }

            Session["LIST_ITEMS"] = theItems;
            targetsRepeater.DataSource = theItems;
            targetsRepeater.DataBind();
        }
    }


    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        KPI theKpi = new KPI();

        theKpi.Name = KpiNameTextBox.Text;
        theKpi.OrganizationID = DataControl.OrganizationId;
        theKpi.AreaID = DataControl.AreaId;
        theKpi.ProjectID = DataControl.ProjectId;
        theKpi.ActivityID = DataControl.ActivityId;
        theKpi.PersonID = DataControl.PersonId;
        theKpi.KpiTypeID = KPITypeCombobox.SelectedValue;
        theKpi.UnitID = UnitCombobox.SelectedValue;
        theKpi.DirectionID = DirectionCombobox.SelectedValue;
        theKpi.StrategyID = StrategyCombobox.SelectedValue;
        theKpi.ReportingUnitID = ReportingPeriodCombobox.SelectedValue;

        if (UnitCombobox.SelectedValue == "MONEY")
        {
            theKpi.Currency = CurrencyCombobox.SelectedValue;
            theKpi.CurrencyUnitID = MeasuredInCombobox.SelectedValue;
        }

        try
        {
            theKpi.TargetPeriod = Convert.ToInt32(TargetPeriodTextBox.Text);
        }
        catch
        {
            SystemMessages.DisplaySystemErrorMessage("El Target Period no es un valor númerico válido.");
            return;
        }

        if (StartingDatePicker.SelectedDate != null && StartingDatePicker.SelectedDate > DateTime.MinValue)
            theKpi.StartDate = Convert.ToDateTime(StartingDatePicker.SelectedDate);
        else
            theKpi.StartDate = DateTime.MinValue;

        theKpi.AllowCategories = categoryCheckBox.Checked;

        KPITarget theTarget = new KPITarget();
        List<KPITarget> theItems = new List<KPITarget>();

        if (!categoryCheckBox.Checked)
        {
            //Single Target
            if (UnitCombobox.SelectedValue == "TIME")
            {
                int years = Convert.ToInt32(YearsSingleCombobox.SelectedValue);
                int months = Convert.ToInt32(MonthsSingleCombobox.SelectedValue);
                int days = Convert.ToInt32(DaysSingleCombobox.SelectedValue);
                int hours = Convert.ToInt32(HoursSingleCombobox.SelectedValue);
                int minutes = Convert.ToInt32(MinutesSingleCombobox.SelectedValue);

                decimal targetTime = 0;
                try
                {
                    targetTime = KPITargetTimeBLL.GetNumberFromTime(years, months, days, hours, minutes);
                }
                catch
                {
                    SystemMessages.DisplaySystemErrorMessage("Error to get the target from the time values.");
                }

                theTarget.Target = targetTime;
            }
            else
            {
                theTarget.Target = Convert.ToDecimal(SingleTargetTextBox.Text);
            }
        }
        else
        {
            //Multiple Target

            if (Session["LIST_ITEMS"] != null)
            {
                try
                {
                    theItems = (List<KPITarget>)Session["LIST_ITEMS"];
                }
                catch (Exception ex)
                {
                    log.Error("Error to get the targets by categories.", ex);
                    SystemMessages.DisplaySystemErrorMessage("Error to get the categories.");
                    return;
                }
            }

            foreach (RepeaterItem itemRepeater in targetsRepeater.Items)
            {
                Label ItemsLabel = (Label)itemRepeater.FindControl("ItemsLabel");
                TextBox targetControl = null;
                DropDownList theYear = null;
                DropDownList theMonth = null;
                DropDownList theDay = null;
                DropDownList theHour = null;
                DropDownList theMinute = null;
                decimal valueTarget = 0;

                if (SelectedUnitHiddenField.Value == "TIME")
                {
                    theYear = (DropDownList)itemRepeater.FindControl("YearsCombobox");
                    theMonth = (DropDownList)itemRepeater.FindControl("MonthsCombobox");
                    theDay = (DropDownList)itemRepeater.FindControl("DaysCombobox");
                    theHour = (DropDownList)itemRepeater.FindControl("HoursCombobox");
                    theMinute = (DropDownList)itemRepeater.FindControl("MinutesCombobox");
                    if (theYear != null && theMonth != null && theDay != null && theHour != null && theMinute != null)
                    {
                        try
                        {
                            valueTarget = KPITargetTimeBLL.GetNumberFromTime(Convert.ToInt32(theYear.SelectedValue),
                                Convert.ToInt32(theMonth.SelectedValue),
                                Convert.ToInt32(theDay.SelectedValue),
                                Convert.ToInt32(theHour.SelectedValue),
                                Convert.ToInt32(theMinute.SelectedValue));
                        }
                        catch (Exception ex)
                        {
                            log.Error("Error to get the target from the time values.", ex);
                        }
                    }
                }
                else
                {
                    targetControl = (TextBox)itemRepeater.FindControl("TargetTextBox");
                    try
                    {
                        if (targetControl != null && Convert.ToDecimal(targetControl.Text) > 0)
                            valueTarget = Convert.ToDecimal(targetControl.Text);
                    }
                    catch { }
                }

                if (ItemsLabel != null && valueTarget > 0)
                {
                    KPITarget result = theItems.Find(delegate(KPITarget tg) { return tg.Detalle == ItemsLabel.Text; });
                    result.Target = valueTarget;
                }
            }
        }

        if (KpiId > 0)
        {
            //Update the KPI
            theKpi.KpiID = KpiId;
            theTarget.KpiID = KpiId;

            try
            {
                KPIBLL.UpdateKPI(theKpi, theTarget, theItems);
            }
            catch
            {
                SystemMessages.DisplaySystemErrorMessage("Error to update the KPI.");
                return;
            }
        }
        else
        {
            //Insert the KPI
            string username = HttpContext.Current.User.Identity.Name;

            try
            {
                KpiId = KPIBLL.CreateKPI(theKpi, theTarget, theItems, username);
            }
            catch
            {
                SystemMessages.DisplaySystemErrorMessage("Error to create the KPI.");
                return;
            }
        }

        Response.Redirect(ParentPage);

    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }
    protected void KPITypeObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorTypesList);
        }
    }
    protected void UnitObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorUnitList);
            e.ExceptionHandled = true;
        }
    }
    protected void CurrencyObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorCurrencyList);
            e.ExceptionHandled = true;
        }
    }
    protected void DirectionObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorDirectionList);
            e.ExceptionHandled = true;
        }
    }
    protected void StrategyObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorStrategyList);
            e.ExceptionHandled = true;
        }
    }
    protected void KPITypeCombobox_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(KPITypeCombobox.SelectedValue))
            return;

        KPIType theType = null;
        KPITypeBLL theBLL = new KPITypeBLL();

        try
        {
            theType = theBLL.GetKPITypesByID(KPITypeCombobox.SelectedValue, LanguageHiddenField.Value);
        }
        catch { }

        if (theType == null)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get the KPI type information.");
            return;
        }

        if (theType.UnitID.Trim() != "NA")
        {
            UnitCombobox.SelectedValue = theType.UnitID.Trim();
            UnitCombobox.Enabled = false;
            SelectedUnitHiddenField.Value = theType.UnitID.Trim();
            UnitTargetLabel.Text = "";
            switch (theType.UnitID.Trim().ToUpper())
            {
                case "PERCENT":
                    NumericSingleTargetPanel.Style["display"] = "block";
                    TimeSingleTargetPanel.Style["display"] = "none";
                    UnitTargetLabel.Text = "%";
                    SingleTargetRangeValidator.MaximumValue = "100";
                    SingleTargetRangeValidator.Type = ValidationDataType.Double;
                    CurrencyPanel.Style["display"] = "none";
                    break;
                case "TIME":
                    NumericSingleTargetPanel.Style["display"] = "none";
                    TimeSingleTargetPanel.Style["display"] = "block";
                    CurrencyPanel.Style["display"] = "none";
                    break;
                case "INT":
                    NumericSingleTargetPanel.Style["display"] = "block";
                    TimeSingleTargetPanel.Style["display"] = "none";
                    SingleTargetRangeValidator.Type = ValidationDataType.Integer;
                    CurrencyPanel.Style["display"] = "none";
                    break;
                case "DECIMAL":
                    NumericSingleTargetPanel.Style["display"] = "block";
                    TimeSingleTargetPanel.Style["display"] = "none";
                    SingleTargetRangeValidator.Type = ValidationDataType.Double;
                    CurrencyPanel.Style["display"] = "none";
                    break;
                case "MONEY":
                    NumericSingleTargetPanel.Style["display"] = "block";
                    TimeSingleTargetPanel.Style["display"] = "none";
                    SingleTargetRangeValidator.Type = ValidationDataType.Double;
                    CurrencyPanel.Style["display"] = "block";
                    CurrencyRequiredFieldValidator.ValidationGroup = "AddData";
                    MeasuredRequiredFieldValidator.ValidationGroup = "AddData";
                    break;
            }
        }

        if (theType.DirectionID.Trim() != "NA")
        {
            DirectionCombobox.SelectedValue = theType.DirectionID.Trim();
            DirectionCombobox.Enabled = false;
        }

        if (theType.StrategyID.Trim() != "NA")
        {
            StrategyCombobox.SelectedValue = theType.StrategyID.Trim();
            StrategyCombobox.Enabled = false;
        }
    }
    protected void CurrencyCombobox_SelectedIndexChanged(object sender, EventArgs e)
    {
        SelectedCurrencyHiddenField.Value = CurrencyCombobox.SelectedValue;
        MeasuredInCombobox.Items.Clear();
        MeasuredInCombobox.DataBind();

        UnitLabel.Text = ReportingPeriodCombobox.SelectedItem.Text;

        //MeasuredInCombobox.SelectedValue = "";
    }
    protected void CategoryObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Kpi.MessageErrorCategoryList);
            e.ExceptionHandled = true;
        }
    }
    protected void AddCategory_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(CategoryComboBox.SelectedValue))
            return;

        //Get the list of Categories
        List<Category> theCategories = new List<Category>();

        if (Session["LIST_CATEGORIES"] != null)
        {
            try
            {
                theCategories = (List<Category>)Session["LIST_CATEGORIES"];
            }
            catch { }

            if (theCategories == null)
                theCategories = new List<Category>();
        }

        Category result = theCategories.Find(delegate(Category bk) { return bk.ID == CategoryComboBox.SelectedValue; });

        if (result == null)
        {
            Category theNewCategory = new Category(CategoryComboBox.SelectedValue, CategoryComboBox.SelectedItem.Text);
            theCategories.Add(theNewCategory);
        }

        Session["LIST_CATEGORIES"] = theCategories;
        CategoriesRepeater.DataSource = theCategories;
        CategoriesRepeater.DataBind();

        //Obtener la nueva combinacion de items
        List<KPICategoyCombination> theCombinations = new List<KPICategoyCombination>();
        try
        {
            theCombinations = KPICategoryCombinationBLL.GetKPITargetCategoriesByKpiId(theCategories);
        }
        catch (Exception)
        {
            SystemMessages.DisplaySystemErrorMessage("Error to get the new combination of items categories.");
            return;
        }

        //Crear la nueva lista de items para registrar target
        List<KPITarget> theItems = new List<KPITarget>();
        foreach (KPICategoyCombination item in theCombinations)
        {
            KPITarget theTarget = new KPITarget(0, KpiId, 0);
            theTarget.Detalle = item.ItemsList;
            theTarget.Categories = item.CategoriesList;
            theItems.Add(theTarget);
        }
        Session["LIST_ITEMS"] = theItems;
        targetsRepeater.DataSource = theItems;
        targetsRepeater.DataBind();
    }
    protected void CategoriesRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string categoryId = "";
        try
        {
            categoryId = e.CommandArgument.ToString();
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id from category repeater", ex);
        }

        if (string.IsNullOrEmpty(categoryId))
        {
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }

        if (e.CommandName == "Remove")
        {
            List<Category> theCategories = new List<Category>();

            if (Session["LIST_CATEGORIES"] != null)
            {
                try
                {
                    theCategories = (List<Category>)Session["LIST_CATEGORIES"];
                }
                catch { }

                if (theCategories == null)
                {
                    return;
                }
            }

            Category result = theCategories.Find(delegate(Category bk) { return bk.ID == categoryId; });

            if (result != null)
            {
                theCategories.Remove(result);
            }
            else
            {
                return;
            }

            Session["LIST_CATEGORIES"] = theCategories;
            CategoriesRepeater.DataSource = theCategories;
            CategoriesRepeater.DataBind();

            //Obtener la nueva combinacion de items
            List<KPICategoyCombination> theCombinations = new List<KPICategoyCombination>();

            if (theCategories.Count > 0)
            {
                try
                {
                    theCombinations = KPICategoryCombinationBLL.GetKPITargetCategoriesByKpiId(theCategories);
                }
                catch (Exception)
                {
                    SystemMessages.DisplaySystemErrorMessage("Error to get the new combination of items categories.");
                    return;
                }
            }

            //Crear la nueva lista de items para registrar target
            List<KPITarget> theItems = new List<KPITarget>();
            foreach (KPICategoyCombination item in theCombinations)
            {
                KPITarget theTarget = new KPITarget(0, KpiId, 0);
                theTarget.Detalle = item.ItemsList;
                theTarget.Categories = item.CategoriesList;
                theItems.Add(theTarget);
            }
            Session["LIST_ITEMS"] = theItems;
            targetsRepeater.DataSource = theItems;
            targetsRepeater.DataBind();
        }
    }
    protected void targetsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        if (SelectedUnitHiddenField.Value == "TIME")
        {
            //Numeric
            HtmlGenericControl divNumeric = (HtmlGenericControl)e.Item.FindControl("numericTarget");
            if (divNumeric != null)
            {
                divNumeric.Style["display"] = "none";
            }

            //Time
            HtmlGenericControl divTime = (HtmlGenericControl)e.Item.FindControl("timeTarget");
            if (divTime != null)
            {
                divTime.Style["display"] = "block";
            }

            //Valor
            HiddenField hfTarget = (HiddenField)e.Item.FindControl("IDHiddenField");
            if (hfTarget != null)
            {
                int targetValue = 0;
                try
                {
                    targetValue = Convert.ToInt32(hfTarget.Value);
                }
                catch
                {
                    log.Error("Error to get the value of the target of a category.");
                }

                if (targetValue > 0)
                {
                    //Get the target in time format
                    KPITargetTime theTime = null;
                    try
                    {
                        theTime = KPITargetTimeBLL.GetKPITargetTimeByTargetId(targetValue);
                    }
                    catch { }

                    if (theTime != null)
                    {
                        DropDownList theYear = (DropDownList)e.Item.FindControl("YearsCombobox");
                        if (theYear != null)
                            theYear.SelectedValue = theTime.Year.ToString();

                        DropDownList theMonth = (DropDownList)e.Item.FindControl("MonthsCombobox");
                        if (theMonth != null)
                            theMonth.SelectedValue = theTime.Month.ToString();

                        DropDownList theDay = (DropDownList)e.Item.FindControl("DaysCombobox");
                        if (theDay != null)
                            theDay.SelectedValue = theTime.Day.ToString();

                        DropDownList theHour = (DropDownList)e.Item.FindControl("HoursCombobox");
                        if (theHour != null)
                            theHour.SelectedValue = theTime.Hour.ToString();

                        DropDownList theMinute = (DropDownList)e.Item.FindControl("MinutesCombobox");
                        if (theMinute != null)
                            theMinute.SelectedValue = theTime.Minute.ToString();
                    }
                }
            }
        }

        if (SelectedUnitHiddenField.Value != "TIME")
        {
            HtmlGenericControl divNumeric = (HtmlGenericControl)e.Item.FindControl("numericTarget");
            if (divNumeric != null)
            {
                divNumeric.Style["display"] = "block";
            }

            //Time
            HtmlGenericControl divTime = (HtmlGenericControl)e.Item.FindControl("timeTarget");
            if (divTime != null)
            {
                divTime.Style["display"] = "none";
            }

            //Percent

            TextBox theTarget = (TextBox)e.Item.FindControl("TargetTextBox");
            RangeValidator theValidation = (RangeValidator)e.Item.FindControl("TargetRangeValidator");

            if (theTarget != null && theValidation != null)
            {
                if (SelectedUnitHiddenField.Value == "PERCENT")
                {
                    theValidation.MaximumValue = "100";
                    theValidation.Type = ValidationDataType.Double;
                }
                else if (SelectedUnitHiddenField.Value == "INT")
                {
                    theValidation.Type = ValidationDataType.Integer;
                }
                else
                {
                    theValidation.Type = ValidationDataType.Double;
                }
            }

            //Value
            HiddenField hfTarget = (HiddenField)e.Item.FindControl("ValueHiddenField");
            if (hfTarget != null)
            {
                double valuetarget = 0;

                try
                {
                    valuetarget = Convert.ToDouble(hfTarget.Value);

                    if (valuetarget > 0 && theTarget != null)
                    {
                        theTarget.Text = valuetarget.ToString();
                    }
                }
                catch { }
            }

            //Percent label
            if (SelectedUnitHiddenField.Value == "PERCENT")
            {
                Label UnitLabel = (Label)e.Item.FindControl("UnitTargetLabel");
                if (UnitLabel != null)
                    UnitLabel.Text = "%";
            }

            //Currency Label
            if (SelectedUnitHiddenField.Value == "MONEY" && !string.IsNullOrEmpty(CurrencyCombobox.SelectedValue) && !string.IsNullOrEmpty(MeasuredInCombobox.SelectedValue))
            {
                Label UnitLabel = (Label)e.Item.FindControl("UnitTargetLabel");
                if (UnitLabel != null)
                    UnitLabel.Text = MeasuredInCombobox.SelectedItem.Text + " of " + CurrencyCombobox.SelectedItem.Text;
            }
        }
    }
    protected void TargetCustomValidator_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (StartingDatePicker.SelectedDate == null)
        {
            args.IsValid = true;
            return;
        }

        if (!categoryCheckBox.Checked)
        {
            if (SelectedUnitHiddenField.Value == "TIME")
            {
                if (Convert.ToInt32(YearsSingleCombobox.SelectedValue) == 0 &&
                    Convert.ToInt32(MonthsSingleCombobox.SelectedValue) == 0 &&
                    Convert.ToInt32(DaysSingleCombobox.SelectedValue) == 0 &&
                    Convert.ToInt32(HoursSingleCombobox.SelectedValue) == 0 &&
                    Convert.ToInt32(MinutesSingleCombobox.SelectedValue) == 0)
                {
                    args.IsValid = false;
                    return;
                }
            }
            else
            {
                if (string.IsNullOrEmpty(SingleTargetTextBox.Text) || Convert.ToDecimal(SingleTargetTextBox.Text) <= 0)
                {
                    args.IsValid = false;
                    return;
                }
            }
        }
        else
        {
            //Verify if select a categories
            if (CategoriesRepeater.Items.Count <= 0)
            {
                args.IsValid = false;
                return;
            }

            bool exitsValue = false;

            foreach (RepeaterItem itemRepeater in targetsRepeater.Items)
            {
                TextBox targetControl = null;
                DropDownList theYear = null;
                DropDownList theMonth = null;
                DropDownList theDay = null;
                DropDownList theHour = null;
                DropDownList theMinute = null;
                decimal valueTarget = 0;

                if (SelectedUnitHiddenField.Value == "TIME")
                {
                    theYear = (DropDownList)itemRepeater.FindControl("YearsCombobox");
                    theMonth = (DropDownList)itemRepeater.FindControl("MonthsCombobox");
                    theDay = (DropDownList)itemRepeater.FindControl("DaysCombobox");
                    theHour = (DropDownList)itemRepeater.FindControl("HoursCombobox");
                    theMinute = (DropDownList)itemRepeater.FindControl("MinutesCombobox");

                    if (theYear != null && theMonth != null && theDay != null && theHour != null && theMinute != null)
                    {
                        if (Convert.ToInt32(theYear.SelectedValue) == 0 &&
                            Convert.ToInt32(theMonth.SelectedValue) == 0 &&
                            Convert.ToInt32(theDay.SelectedValue) == 0 &&
                            Convert.ToInt32(theHour.SelectedValue) == 0 &&
                            Convert.ToInt32(theMinute.SelectedValue) == 0)
                        {
                            valueTarget = 0;
                        }
                        else
                        {
                            valueTarget = 1;
                        }
                    }
                }
                else
                {
                    targetControl = (TextBox)itemRepeater.FindControl("TargetTextBox");
                    try
                    {
                        if (targetControl != null && Convert.ToDecimal(targetControl.Text) > 0)
                            valueTarget = Convert.ToDecimal(targetControl.Text);
                    }
                    catch { }
                }

                if (valueTarget > 0)
                {
                    exitsValue = true;
                    break;
                }
            }

            if (!exitsValue)
            {
                args.IsValid = false;
                return;
            }
        }

        args.IsValid = true;
    }
    protected void StartingDateCustomValidator_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (StartingDatePicker.SelectedDate != null && StartingDatePicker.SelectedDate > DateTime.MinValue)
        {
            args.IsValid = true;
            return;
        }

        //Verify if exists target
        bool existsTarget = false;

        if (!categoryCheckBox.Checked)
        {
            if (SelectedUnitHiddenField.Value == "TIME")
            {
                if (Convert.ToInt32(YearsSingleCombobox.SelectedValue) > 0 ||
                    Convert.ToInt32(MonthsSingleCombobox.SelectedValue) > 0 ||
                    Convert.ToInt32(DaysSingleCombobox.SelectedValue) > 0 ||
                    Convert.ToInt32(HoursSingleCombobox.SelectedValue) > 0 ||
                    Convert.ToInt32(MinutesSingleCombobox.SelectedValue) > 0)
                    existsTarget = true;
            }
            else
            {
                if (Convert.ToDecimal(SingleTargetTextBox.Text) > 0)
                    existsTarget = true;
            }
        }
        else
        {
            //Verify if select a categories
            if (CategoriesRepeater.Items.Count > 0)
            {
                foreach (RepeaterItem itemRepeater in targetsRepeater.Items)
                {
                    TextBox targetControl = null;
                    DropDownList theYear = null;
                    DropDownList theMonth = null;
                    DropDownList theDay = null;
                    DropDownList theHour = null;
                    DropDownList theMinute = null;
                    decimal valueTarget = 0;

                    if (SelectedUnitHiddenField.Value == "TIME")
                    {
                        theYear = (DropDownList)itemRepeater.FindControl("YearsCombobox");
                        theMonth = (DropDownList)itemRepeater.FindControl("MonthsCombobox");
                        theDay = (DropDownList)itemRepeater.FindControl("DaysCombobox");
                        theHour = (DropDownList)itemRepeater.FindControl("HoursCombobox");
                        theMinute = (DropDownList)itemRepeater.FindControl("MinutesCombobox");

                        if (theYear != null && theMonth != null && theDay != null && theHour != null && theMinute != null)
                        {
                            if (Convert.ToInt32(theYear.SelectedValue) > 0 ||
                                Convert.ToInt32(theMonth.SelectedValue) > 0 ||
                                Convert.ToInt32(theDay.SelectedValue) > 0 ||
                                Convert.ToInt32(theHour.SelectedValue) > 0 |
                                Convert.ToInt32(theMinute.SelectedValue) > 0)
                            {
                                existsTarget = true;
                                break;
                            }
                        }
                    }
                    else
                    {
                        targetControl = (TextBox)itemRepeater.FindControl("TargetTextBox");
                        try
                        {
                            if (targetControl != null && Convert.ToDecimal(targetControl.Text) > 0)
                                valueTarget = Convert.ToDecimal(targetControl.Text);
                        }
                        catch { }
                    }

                    if (valueTarget > 0)
                    {
                        existsTarget = true;
                        break;
                    }
                }
            }
        }

        if (existsTarget)
            args.IsValid = false;
        else
            args.IsValid = true;

    }
    protected void MeasuredInCombobox_SelectedIndexChanged(object sender, EventArgs e)
    {
        UnitTargetLabel.Text = MeasuredInCombobox.SelectedItem.Text + Resources.Kpi.LabelOf + CurrencyCombobox.SelectedItem.Text;

        List<KPITarget> theItems = new List<KPITarget>();

        if (Session["LIST_ITEMS"] != null)
        {
            try
            {
                theItems = (List<KPITarget>)Session["LIST_ITEMS"];
            }
            catch (Exception ex)
            {
                log.Error("Error to get the targets by categories.", ex);
                SystemMessages.DisplaySystemErrorMessage("Error to get the categories.");
                return;
            }

            targetsRepeater.DataSource = theItems;
            targetsRepeater.DataBind();
        }

        UnitLabel.Text = ReportingPeriodCombobox.SelectedItem.Text;
    }
}