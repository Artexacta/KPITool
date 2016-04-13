﻿using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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

    private Kpi currentObject;

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
        ProcessSessionParametes();

        KPITypeCombobox.DataSource = FrtwbSystem.Instance.KpiTypes.Values;
        KPITypeCombobox.DataBind();

        LoadKpiData();
        OrganizationComboBox.DataSource = FrtwbSystem.Instance.Organizations.Values;
        OrganizationComboBox.DataBind();

        ProjectComboBox.DataSource = FrtwbSystem.Instance.Projects.Values;
        ProjectComboBox.DataBind();

        AreaComboBox.DataSource = FrtwbSystem.Instance.Areas.Values;
        AreaComboBox.DataBind();

        ActivityComboBox.DataSource = FrtwbSystem.Instance.Activities.Values;
        ActivityComboBox.DataBind();


        AreaComboBox.DataSource = new List<Area>();
        AreaComboBox.DataBind();


    }

    private void ProcessSessionParametes()
    {
        if (Session["ParentPage"] != null && !string.IsNullOrEmpty(Session["ParentPage"].ToString()))
        {
            ParentPage = Session["ParentPage"].ToString();
        }
        Session["ParentPage"] = null;
        if (Session["KpiId"] != null && !string.IsNullOrEmpty(Session["KpiId"].ToString()))
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(Session["KpiId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['KpiId'] to integer value", ex);
            }
            KpiId = kpiId;
        }
        Session["KpiId"] = null;
    }

    private void LoadKpiData()
    {
        int kpiId = KpiId;
        if (kpiId <= 0)
            return;

        try
        {
            currentObject = FrtwbSystem.Instance.Kpis[KpiId];
            KpiNameTextBox.Text = currentObject.Name;
            //FYI: type = id;unit;direction;strategy
            string kpiTypeSelectedVal = currentObject.KpiType.Id + ";" + currentObject.KpiType.KpiTypeUnitType.ToString() + ";" + currentObject.KpiType.KpiTypeDirection.ToString() + ";" + currentObject.KpiType.KpiGroupingStrategy.ToString();
            KPITypeCombobox.SelectedValue = kpiTypeSelectedVal;
            GroupingStrategyCombobox.SelectedValue = currentObject.KpiGroupingStrategy.ToString();
            DirectionCombobox.SelectedValue = currentObject.KpiSelectedDirection.ToString();
            UnitCombobox.SelectedValue = currentObject.KpiUnitType.ToString();
            SelectedDirectionHiddenField.Value = currentObject.KpiSelectedDirection.ToString();
            SelectedUnitHiddenField.Value = currentObject.KpiUnitType.ToString();
            SelectedGroupingStrategyHiddenFields.Value = currentObject.KpiGroupingStrategy.ToString();
            ReportingServicesCheckbox.Checked = currentObject.WebServiceID != "";
            if (ReportingServicesCheckbox.Checked)
            {
                WebServiceIDTextbox.Text = currentObject.WebServiceID;
            }
            ReportingUnitsHiddenfield.Value = currentObject.ReportingUnits.ToString();
            ReportingUnitsValueTextBox.Value = currentObject.ReportingUnits;
            ReportingPeriodCombobox.SelectedValue = currentObject.ReportingUnitsPeriod.ToString();
            switch (currentObject.KpiUnitType)
            {
                case Artexacta.App.FRTWB.UnitType.DECIMAL:
                    TargetDecimalTextbox.Text = currentObject.KpiTarget;
                    break;
                case Artexacta.App.FRTWB.UnitType.INTEGER:
                    TargetIntegerTextbox.Text = currentObject.KpiTarget;
                    break;
                case Artexacta.App.FRTWB.UnitType.MONEY:
                    //money;currency;measurement
                    string[] value = currentObject.KpiTarget.Split(new char[] { ';' });
                    TargetMoneyValueTextbox.Text = value[0];
                    TargetMoneyCurrencyCombobox.SelectedValue = value[1];
                    TargetMoneyMeasuredInCombobox.SelectedValue = value[2];
                    break;
                case Artexacta.App.FRTWB.UnitType.PERCENTAGE:
                    TargetPercentageTextbox.Text = currentObject.KpiTarget;
                    break;
                case Artexacta.App.FRTWB.UnitType.TIMESPAN:
                    //year;month;day;hour;minute
                    value = currentObject.KpiTarget.Split(new char[] { ';' });
                    TargetTimespanYearsCombobox.SelectedValue = value[0];
                    TargetTimespanMonthsCombobox.SelectedValue = value[1];
                    TargetTimespanDaysCombobox.SelectedValue = value[2];
                    TargetTimespanHoursCombobox.SelectedValue = value[3];
                    TargetTimespanMinutesCombobox.SelectedValue = value[4];
                    break;
            }

        }
        catch (Exception ex)
        {
            log.Error("Error loading Kpi data", ex);
        }
    }

    protected void OrganizationComboBox_DataBound(object sender, EventArgs e)
    {
        OrganizationComboBox.Items.Insert(0, new ListItem("-- Select a Organization --", ""));
        if (currentObject == null)
            return;

        string organizationId = currentObject.Owner is Organization ? currentObject.Owner.ObjectId.ToString() :
            currentObject.Owner.Owner.ObjectId.ToString();
        ListItem item = OrganizationComboBox.Items.FindByValue(organizationId);
        if (item != null)
            item.Selected = true;

        string projectId = currentObject.Owner is Activity ? currentObject.Owner.Owner.ObjectId.ToString() : (currentObject.Owner is Project ? currentObject.Owner.ObjectId.ToString() : "");

        LoadAreaComboBox(organizationId);
        LoadProjectComboBox(organizationId);
        LoadActivityComboBox(organizationId, projectId);
    }

    private void LoadActivityComboBox(string organizationId, string projectId)
    {
        if (string.IsNullOrEmpty(organizationId) && string.IsNullOrEmpty(projectId))
        {
            ActivityComboBox.DataSource = new List<Activity>();
            ActivityComboBox.DataBind();
            return;
        }
        if (!string.IsNullOrWhiteSpace(projectId))
        {
            try
            {
                Project objProject = FrtwbSystem.Instance.Projects[Convert.ToInt32(projectId)];
                ActivityComboBox.DataSource = objProject.Activities.Values;
                ActivityComboBox.DataBind();
            }
            catch (Exception ex)
            {
                log.Error("Error loading areas from selected project", ex);
            }
        }
        else
        {
            try
            {
                Organization org = FrtwbSystem.Instance.Organizations[Convert.ToInt32(organizationId)];
                ActivityComboBox.DataSource = org.Activities.Values;
                ActivityComboBox.DataBind();
            }
            catch (Exception ex)
            {
                log.Error("Error loading areas from selected organization", ex);
            }
        }

    }

    private void LoadProjectComboBox(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            ProjectComboBox.DataSource = new List<Project>();
            ProjectComboBox.DataBind();
            return;
        }

        try
        {
            Organization org = FrtwbSystem.Instance.Organizations[Convert.ToInt32(value)];
            ProjectComboBox.DataSource = org.Projects.Values;
            ProjectComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading areas from selected organization", ex);
        }
    }

    protected void OrganizationComboBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAreaComboBox(OrganizationComboBox.SelectedValue);
        LoadProjectComboBox(OrganizationComboBox.SelectedValue);
        LoadActivityComboBox(OrganizationComboBox.SelectedValue, ProjectComboBox.SelectedValue);
    }

    private void LoadAreaComboBox(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            AreaComboBox.DataSource = new List<Area>();
            AreaComboBox.DataBind();
            return;
        }

        try
        {
            Organization org = FrtwbSystem.Instance.Organizations[Convert.ToInt32(value)];
            AreaComboBox.DataSource = org.Areas.Values;
            AreaComboBox.DataBind();
        }
        catch (Exception ex)
        {
            log.Error("Error loading areas from selected organization", ex);
        }
    }

    protected void AreaComboBox_DataBound(object sender, EventArgs e)
    {
        AreaComboBox.Items.Insert(0, new ListItem("-- Select an Area --", ""));

        if (currentObject == null)
            return;

        if (currentObject.Owner is Area)
        {
            string areaId = currentObject.Owner.ObjectId.ToString();
            ListItem item = OrganizationComboBox.Items.FindByValue(areaId);
            if (item != null)
                item.Selected = true;
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int KpiId = this.KpiId;
            string KpiName = KpiNameTextBox.Text;
            int organizationId = Convert.ToInt32(OrganizationComboBox.SelectedValue);
            string area = AreaComboBox.SelectedValue;
            string project = ProjectComboBox.SelectedValue;
            string activity = ActivityComboBox.SelectedValue;

            Kpi objKpi = null;
            bool isNew = KpiId == 0;

            string kpiTarget = "";

            Artexacta.App.FRTWB.UnitType selectedUnit = (Artexacta.App.FRTWB.UnitType)Enum.Parse(typeof(Artexacta.App.FRTWB.UnitType), SelectedUnitHiddenField.Value);
            GroupingStrategy selectedGrouping = (GroupingStrategy)Enum.Parse(typeof(GroupingStrategy), GroupingStrategyCombobox.SelectedValue);
            TypeDirection selectedDirection = (TypeDirection)Enum.Parse(typeof(TypeDirection), DirectionCombobox.SelectedValue);
            ReportingPeriod selectedReportingPeriod = (ReportingPeriod)Enum.Parse(typeof(ReportingPeriod), ReportingPeriodCombobox.SelectedValue);
            ReportingPeriod selectedReportingUnits = (ReportingPeriod)Enum.Parse(typeof(ReportingPeriod), ReportingUnitsHiddenfield.Value);
            int reportingUnits = Convert.ToInt32(ReportingUnitsValueTextBox.Value);

            string kpiTypeSelected = KPITypeCombobox.SelectedValue;
            string[] vals = kpiTypeSelected.Split(new char[] { ';' });
            int kpiId = Convert.ToInt32(vals[0]);
            KpiType selectedType = FrtwbSystem.Instance.KpiTypes[kpiId];

            switch (selectedUnit)
            {
                case Artexacta.App.FRTWB.UnitType.PERCENTAGE:
                    kpiTarget = ((int)TargetPercentageTextbox.Value).ToString();
                    break;
                case Artexacta.App.FRTWB.UnitType.TIMESPAN:
                    kpiTarget = TargetTimespanYearsCombobox.SelectedValue + ";" + TargetTimespanMonthsCombobox.SelectedValue + ";" + TargetTimespanDaysCombobox.SelectedValue + ";" + TargetTimespanHoursCombobox.SelectedValue + ";" + TargetTimespanMinutesCombobox.SelectedValue;
                    break;
                case Artexacta.App.FRTWB.UnitType.MONEY:
                    Currency selectedCurrency = (Currency)Enum.Parse(typeof(Currency), TargetMoneyCurrencyCombobox.SelectedValue);
                    MoneyMeasurements selectedMeasurement = (MoneyMeasurements)Enum.Parse(typeof(MoneyMeasurements), TargetMoneyMeasuredInCombobox.SelectedValue);
                    //money;currency;measurement
                    kpiTarget = TargetMoneyValueTextbox.Value + ";" + selectedCurrency.ToString() + ";" + selectedMeasurement;
                    break;
                case Artexacta.App.FRTWB.UnitType.INTEGER:
                    kpiTarget = ((int)TargetIntegerTextbox.Value).ToString();
                    break;
                case Artexacta.App.FRTWB.UnitType.DECIMAL:
                    kpiTarget = TargetDecimalTextbox.Value.ToString();
                    break;
            }

            if (isNew)
            {
                objKpi = new Kpi()
                {
                    Name = KpiName,
                    KpiTarget = kpiTarget,
                    KpiUnitType = selectedUnit,
                    KpiGroupingStrategy = selectedGrouping,
                    KpiSelectedDirection = selectedDirection,
                    KpiType = selectedType,
                    KpiReportingPeriod = selectedReportingPeriod,
                    ReportingUnitsPeriod = selectedReportingUnits,
                    ReportingUnits = reportingUnits,
                    WebServiceID = ReportingServicesCheckbox.Checked ? WebServiceIDTextbox.Text : ""
                };
                FrtwbSystem.Instance.Kpis.Add(objKpi.ObjectId, objKpi);
            }
            else
            {
                objKpi = FrtwbSystem.Instance.Kpis[KpiId];
                objKpi.Name = KpiName;
                objKpi.KpiTarget = kpiTarget;
                objKpi.KpiUnitType = selectedUnit;
                objKpi.KpiGroupingStrategy = selectedGrouping;
                objKpi.KpiSelectedDirection = selectedDirection;
                objKpi.KpiType = selectedType;
                objKpi.KpiReportingPeriod = selectedReportingPeriod;
                objKpi.ReportingUnitsPeriod = selectedReportingUnits;
                objKpi.ReportingUnits = reportingUnits;
                objKpi.WebServiceID = ReportingServicesCheckbox.Checked ? WebServiceIDTextbox.Text : "";
            }


            Organization objOrg = FrtwbSystem.Instance.Organizations[organizationId];
            if (!string.IsNullOrEmpty(activity))
            {
                int activityId = Convert.ToInt32(activity);
                Activity objActivity = FrtwbSystem.Instance.Activities[activityId];
                if (objKpi.Owner != null && objKpi.Owner != objActivity)
                {
                    RemoveKpiFromOldOwner(objKpi);
                }
                if (!objActivity.Kpis.ContainsKey(objKpi.ObjectId))
                    objActivity.Kpis.Add(objKpi.ObjectId, objKpi);
                objKpi.Owner = objActivity;
            }
            else
            {
                if (!string.IsNullOrEmpty(project))
                {
                    int projectId = Convert.ToInt32(project);
                    Project objProject = FrtwbSystem.Instance.Projects[projectId];
                    if (objKpi.Owner != null && objKpi.Owner != objProject)
                    {
                        RemoveKpiFromOldOwner(objKpi);
                    }
                    if (!objProject.Kpis.ContainsKey(objKpi.ObjectId))
                        objProject.Kpis.Add(objKpi.ObjectId, objKpi);
                    objKpi.Owner = objProject;
                }
                else
                {
                    if (!string.IsNullOrEmpty(area))
                    {
                        int areaId = Convert.ToInt32(area);
                        Area objArea = FrtwbSystem.Instance.Areas[areaId];
                        if (objKpi.Owner != null && objKpi.Owner != objArea)
                        {
                            RemoveKpiFromOldOwner(objKpi);
                        }
                        if (!objArea.Kpis.ContainsKey(objKpi.ObjectId))
                            objArea.Kpis.Add(objKpi.ObjectId, objKpi);
                        objKpi.Owner = objArea;
                    }
                    else
                    {
                        if (objKpi.Owner != null && objKpi.Owner != objOrg)
                        {
                            RemoveKpiFromOldOwner(objKpi);
                        }
                        if (!objOrg.Kpis.ContainsKey(objKpi.ObjectId))
                            objOrg.Kpis.Add(objKpi.ObjectId, objKpi);
                        objKpi.Owner = objOrg;
                    }

                }

            }
            SystemMessages.DisplaySystemMessage("The Kpi was saved correctly");
        }
        catch (Exception ex)
        {
            log.Error("Error saving Kpi", ex);
            return;
        }
        Response.Redirect(ParentPage);

    }

    private void RemoveKpiFromOldOwner(Kpi objKpi)
    {
        if (objKpi.Owner is Activity)
        {
            Activity oldActivity = (Activity)objKpi.Owner;
            oldActivity.Kpis.Remove(objKpi.ObjectId);
        }
        else if (objKpi.Owner is Project)
        {
            Project oldProject = (Project)objKpi.Owner;
            oldProject.Kpis.Remove(objKpi.ObjectId);
        }
        else if (objKpi.Owner is Area)
        {
            Area oldArea = (Area)objKpi.Owner;
            oldArea.Kpis.Remove(objKpi.ObjectId);
        }
        else if (objKpi.Owner is Organization)
        {
            Organization oldOrganization = (Organization)objKpi.Owner;
            oldOrganization.Kpis.Remove(objKpi.ObjectId);
        }
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(ParentPage);
    }

    protected void ProjectComboBox_DataBound(object sender, EventArgs e)
    {
        ProjectComboBox.Items.Insert(0, new ListItem("-- Select a Project --", ""));
        if (currentObject == null)
            return;

        string projectId = currentObject.Owner is Project ? currentObject.Owner.ObjectId.ToString() : (currentObject.Owner.Owner != null) ?
            currentObject.Owner.Owner.ObjectId.ToString() : "";
        ListItem item = ProjectComboBox.Items.FindByValue(projectId);
        if (item != null)
            item.Selected = true;
    }

    protected void KPITypeCombobox_DataBound(object sender, EventArgs e)
    {
        KPITypeCombobox.Items.Insert(0, new ListItem("-- Select a KPI Type --", ""));
        if (currentObject == null)
            return;

        string kpiTypeId = currentObject.KpiType.Id.ToString();
        ListItem item = KPITypeCombobox.Items.FindByValue(kpiTypeId);
        if (item != null)
            item.Selected = true;
    }

    protected void ActivityComboBox_DataBound(object sender, EventArgs e)
    {
        ActivityComboBox.Items.Insert(0, new ListItem("-- Select an Activity --", ""));
        if (currentObject == null)
            return;

        string activityId = currentObject.Owner is Activity ? currentObject.Owner.ObjectId.ToString() : currentObject.Owner.Owner != null ?
            currentObject.Owner.Owner.ObjectId.ToString() : "";
        ListItem item = ActivityComboBox.Items.FindByValue(activityId);
        if (item != null)
            item.Selected = true;
    }

    protected void ProjectComboBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadActivityComboBox(OrganizationComboBox.SelectedValue, ProjectComboBox.SelectedValue);
    }
}