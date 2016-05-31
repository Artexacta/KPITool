using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;

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

        DataControl.DataType = UserControls_FRTWB_AddDataControl.AddType.KPI.ToString();
        ProcessSessionParametes();
        LanguageHiddenField.Value = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();
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
        //KPIType theType = null;
        //KPITypeBLL theBLL = new KPITypeBLL();

        //try
        //{
        //    theType = theBLL.GetKPITypesByID(theKpi.KpiTypeID);
        //}
        //catch {}

        //if (theType == null)
        //{
        //    SystemMessages.DisplaySystemErrorMessage("Error to get the KPI type information.");
        //    return;
        //}

        UnitCombobox.SelectedValue = theKpi.UnitID;
        SelectedUnitHiddenField.Value = theKpi.UnitID;

        if (theKpi.UnitID == "MONEY")
        {
            CurrencyPanel.Style["display"] = "block";
            CurrencyCombobox.SelectedValue = theKpi.Currency;
            SelectedCurrencyHiddenField.Value = theKpi.Currency;
            MeasuredInCombobox.SelectedValue = theKpi.CurrencyUnitID;
        }

        DirectionCombobox.SelectedValue = theKpi.DirectionID;
        SelectedDirectionHiddenField.Value = theKpi.DirectionID;
        StrategyCombobox.SelectedValue = theKpi.StrategyID;
        SelectedStrategyHiddenFields.Value = theKpi.StrategyID;
        ReportingPeriodCombobox.SelectedValue = theKpi.ReportingUnitID;
        ReportingPeriodHiddenfield.Value = theKpi.ReportingUnitID;
        TargetPeriodTextBox.Value = theKpi.TargetPeriod;

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
                SingleTargetTextBox.Value = Convert.ToDouble(theTarget.Target);
            }
        }

        if (theKpi.AllowCategories)
        {
            //Multiple Target
            MultipleTargetPanel.Style["display"] = "block";

            //Get the targets categories

        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        //try
        //{
        //    int KpiId = this.KpiId;
        //    string KpiName = KpiNameTextBox.Text;
        //    int organizationId = Convert.ToInt32(OrganizationComboBox.SelectedValue);
        //    string area = AreaComboBox.SelectedValue;
        //    string project = ProjectComboBox.SelectedValue;
        //    string activity = ActivityComboBox.SelectedValue;

        //    Kpi objKpi = null;
        //    bool isNew = KpiId == 0;

        //    string kpiTarget = "";

        //    Artexacta.App.FRTWB.UnitType selectedUnit = (Artexacta.App.FRTWB.UnitType)Enum.Parse(typeof(Artexacta.App.FRTWB.UnitType), SelectedUnitHiddenField.Value);
        //    GroupingStrategy selectedGrouping = (GroupingStrategy)Enum.Parse(typeof(GroupingStrategy), GroupingStrategyCombobox.SelectedValue);
        //    TypeDirection selectedDirection = (TypeDirection)Enum.Parse(typeof(TypeDirection), DirectionCombobox.SelectedValue);
        //    ReportingPeriod selectedReportingPeriod = (ReportingPeriod)Enum.Parse(typeof(ReportingPeriod), ReportingPeriodCombobox.SelectedValue);
        //    ReportingPeriod selectedReportingUnits = (ReportingPeriod)Enum.Parse(typeof(ReportingPeriod), ReportingUnitsHiddenfield.Value);
        //    int reportingUnits = Convert.ToInt32(ReportingUnitsValueTextBox.Value);

        //    string kpiTypeSelected = KPITypeCombobox.SelectedValue;
        //    string[] vals = kpiTypeSelected.Split(new char[] { ';' });
        //    int kpiId = Convert.ToInt32(vals[0]);
        //    KpiType selectedType = FrtwbSystem.Instance.KpiTypes[kpiId];

        //    switch (selectedUnit)
        //    {
        //        case Artexacta.App.FRTWB.UnitType.PERCENTAGE:
        //            kpiTarget = ((int)TargetPercentageTextbox.Value).ToString();
        //            break;
        //        case Artexacta.App.FRTWB.UnitType.TIMESPAN:
        //            kpiTarget = TargetTimespanYearsCombobox.SelectedValue + ";" + TargetTimespanMonthsCombobox.SelectedValue + ";" + TargetTimespanDaysCombobox.SelectedValue + ";" + TargetTimespanHoursCombobox.SelectedValue + ";" + TargetTimespanMinutesCombobox.SelectedValue;
        //            break;
        //        case Artexacta.App.FRTWB.UnitType.MONEY:
        //            Currency selectedCurrency = (Currency)Enum.Parse(typeof(Currency), TargetMoneyCurrencyCombobox.SelectedValue);
        //            MoneyMeasurements selectedMeasurement = (MoneyMeasurements)Enum.Parse(typeof(MoneyMeasurements), TargetMoneyMeasuredInCombobox.SelectedValue);
        //            //money;currency;measurement
        //            kpiTarget = TargetMoneyValueTextbox.Value + ";" + selectedCurrency.ToString() + ";" + selectedMeasurement;
        //            break;
        //        case Artexacta.App.FRTWB.UnitType.INTEGER:
        //            kpiTarget = ((int)TargetIntegerTextbox.Value).ToString();
        //            break;
        //        case Artexacta.App.FRTWB.UnitType.DECIMAL:
        //            kpiTarget = TargetDecimalTextbox.Value.ToString();
        //            break;
        //    }

        //    if (isNew)
        //    {
        //        objKpi = new Kpi()
        //        {
        //            Name = KpiName,
        //            KpiTarget = kpiTarget,
        //            KpiUnitType = selectedUnit,
        //            KpiGroupingStrategy = selectedGrouping,
        //            KpiSelectedDirection = selectedDirection,
        //            KpiType = selectedType,
        //            KpiReportingPeriod = selectedReportingPeriod,
        //            ReportingUnitsPeriod = selectedReportingUnits,
        //            ReportingUnits = reportingUnits,
        //            WebServiceID = ReportingServicesCheckbox.Checked ? WebServiceIDTextbox.Text : ""
        //        };
        //        FrtwbSystem.Instance.Kpis.Add(objKpi.ObjectId, objKpi);
        //    }
        //    else
        //    {
        //        objKpi = FrtwbSystem.Instance.Kpis[KpiId];
        //        objKpi.Name = KpiName;
        //        objKpi.KpiTarget = kpiTarget;
        //        objKpi.KpiUnitType = selectedUnit;
        //        objKpi.KpiGroupingStrategy = selectedGrouping;
        //        objKpi.KpiSelectedDirection = selectedDirection;
        //        objKpi.KpiType = selectedType;
        //        objKpi.KpiReportingPeriod = selectedReportingPeriod;
        //        objKpi.ReportingUnitsPeriod = selectedReportingUnits;
        //        objKpi.ReportingUnits = reportingUnits;
        //        objKpi.WebServiceID = ReportingServicesCheckbox.Checked ? WebServiceIDTextbox.Text : "";
        //    }


        //    Organization objOrg = FrtwbSystem.Instance.Organizations[organizationId];
        //    if (!string.IsNullOrEmpty(activity))
        //    {
        //        int activityId = Convert.ToInt32(activity);
        //        Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
        //        if (objKpi.Owner != null && objKpi.Owner != objActivity)
        //        {
        //            RemoveKpiFromOldOwner(objKpi);
        //        }
        //        if (!objActivity.Kpis.ContainsKey(objKpi.ObjectId))
        //            objActivity.Kpis.Add(objKpi.ObjectId, objKpi);
        //        objKpi.Owner = objActivity;
        //    }
        //    else
        //    {
        //        if (!string.IsNullOrEmpty(project))
        //        {
        //            int projectId = Convert.ToInt32(project);
        //            Project objProject = FrtwbSystem.Instance.Projects[projectId];
        //            if (objKpi.Owner != null && objKpi.Owner != objProject)
        //            {
        //                RemoveKpiFromOldOwner(objKpi);
        //            }
        //            if (!objProject.Kpis.ContainsKey(objKpi.ObjectId))
        //                objProject.Kpis.Add(objKpi.ObjectId, objKpi);
        //            objKpi.Owner = objProject;
        //        }
        //        else
        //        {
        //            if (!string.IsNullOrEmpty(area))
        //            {
        //                int areaId = Convert.ToInt32(area);
        //                Area objArea = FrtwbSystem.Instance.Areas[areaId];
        //                if (objKpi.Owner != null && objKpi.Owner != objArea)
        //                {
        //                    RemoveKpiFromOldOwner(objKpi);
        //                }
        //                if (!objArea.Kpis.ContainsKey(objKpi.ObjectId))
        //                    objArea.Kpis.Add(objKpi.ObjectId, objKpi);
        //                objKpi.Owner = objArea;
        //            }
        //            else
        //            {
        //                if (objKpi.Owner != null && objKpi.Owner != objOrg)
        //                {
        //                    RemoveKpiFromOldOwner(objKpi);
        //                }
        //                if (!objOrg.Kpis.ContainsKey(objKpi.ObjectId))
        //                    objOrg.Kpis.Add(objKpi.ObjectId, objKpi);
        //                objKpi.Owner = objOrg;
        //            }

        //        }

        //    }
        //    SystemMessages.DisplaySystemMessage("The Kpi was saved correctly");
        //}
        //catch (Exception ex)
        //{
        //    log.Error("Error saving Kpi", ex);
        //    return;
        //}
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
            SystemMessages.DisplaySystemErrorMessage("Error to get the KPI Types List.");
        }
    }
    protected void UnitObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {

    }
    protected void CurrencyObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {

    }
    protected void DirectionObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {

    }
    protected void StrategyObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {

    }
}