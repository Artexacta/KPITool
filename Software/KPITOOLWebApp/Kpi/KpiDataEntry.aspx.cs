using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Kpi_KpiDataEntry : System.Web.UI.Page
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

    public string KpiDataId
    {
        set { KpiDataIdHiddenField.Value = value.ToString(); }
        get
        {
            string KpiDataId = KpiDataIdHiddenField.Value;

            return KpiDataId;
        }
    }

    private Kpi currentObject;

    public string ParentPage
    {
        set { ParentPageHiddenField.Value = value; }
        get { return string.IsNullOrEmpty(ParentPageHiddenField.Value) ? "KpiList.aspx" : ParentPageHiddenField.Value; }
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
        LoadKpiData();
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
        if (Session["KpiDataId"] != null && !string.IsNullOrEmpty(Session["KpiDataId"].ToString()))
        {
            string kpiDataId = "";
            try
            {
                kpiDataId = Session["KpiDataId"].ToString();
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['KpiDataId'] to string value", ex);
            }
            KpiDataId = kpiDataId;
        }
        Session["KpiDataId"] = null;
    }

    private void LoadKpiData()
    {
        int kpiId = KpiId;
        if (kpiId <= 0)
        {
            Response.Redirect("~/Kpi/KpiList.aspx");
            return;
        }

        try
        {
            currentObject = FrtwbSystem.Instance.Kpis[KpiId];
            KpiData objData = null;
            if (!string.IsNullOrWhiteSpace(KpiDataId))
            {
                objData = currentObject.KpiValues[KpiDataId];
            }
            NameLiteral.Text = currentObject.KpiType.Name;
            if (currentObject.WebServiceID == "")
            {
                webServicePanel.Visible = false;
            }
            else
            {
                webServicePanel.Visible = true;
                WebServiceIdLael.Text = currentObject.WebServiceID;
            }
            switch (currentObject.ReportingUnitsPeriod)
            {
                case ReportingPeriod.YEAR:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " years";
                    break;
                case ReportingPeriod.SEMESTER:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " semesters";
                    break;
                case ReportingPeriod.QUARTER:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " quarters";
                    break;
                case ReportingPeriod.MONTH:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " months";
                    break;
                case ReportingPeriod.WEEK:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " weeks";
                    break;
                case ReportingPeriod.DAY:
                    ReportingPeriodLabel.Text = "Last " + currentObject.ReportingUnits + " days";
                    break;
            }
            lblStartingDate.Text = DateTime.Now.ToShortDateString();
            switch (currentObject.KpiType.KpiTypeUnitType)
            {
                case Artexacta.App.FRTWB.UnitType.MONEY:
                    string[] definitionSplitted = currentObject.KpiTarget.Split(new char[] { ';' });
                    Currency selectedCurrency = (Currency)Enum.Parse(typeof(Currency), definitionSplitted[1]);
                    MoneyMeasurements selectedMeasurement = (MoneyMeasurements)Enum.Parse(typeof(MoneyMeasurements), definitionSplitted[2]);
                    switch (selectedCurrency)
                    {
                        case Currency.US_DOLLARS:
                            CurrencyLabel.Text = "US Dollars";
                            break;
                        case Currency.EUROS:
                            CurrencyLabel.Text = "Euros";
                            break;
                    }
                    switch (selectedMeasurement)
                    {
                        case MoneyMeasurements.BILLIONS:
                            MeasuredInLabel.Text = "Billions";
                            break;
                        case MoneyMeasurements.CRORES:
                            MeasuredInLabel.Text = "Crores";
                            break;
                        case MoneyMeasurements.MILLIONS:
                            MeasuredInLabel.Text = "Millions";
                            break;
                        case MoneyMeasurements.LAKHS:
                            MeasuredInLabel.Text = "Lakhs";
                            break;
                        case MoneyMeasurements.THOUSANDS:
                            MeasuredInLabel.Text = "Thousands";
                            break;
                    }
                    if (objData != null)
                    {
                        TargetMoneyValueTextbox.Text = objData.Value;
                    }

                    break;
                case Artexacta.App.FRTWB.UnitType.DECIMAL:
                    if (objData != null)
                    {
                        TargetDecimalTextbox.Text = objData.Value;
                    }
                    break;
                case Artexacta.App.FRTWB.UnitType.INTEGER:
                    if (objData != null)
                    {
                        TargetIntegerTextbox.Text = objData.Value;
                    }
                    break;
                case Artexacta.App.FRTWB.UnitType.PERCENTAGE:
                    if (objData != null)
                    {
                        TargetPercentageTextbox.Text = objData.Value;
                    }
                    break;
                case Artexacta.App.FRTWB.UnitType.TIMESPAN:
                    if (objData != null)
                    {
                        string[] dateSplitted = objData.Value.Split(new char[] { ';' });
                        TargetTimespanYearsCombobox.SelectedValue = dateSplitted[0];
                        TargetTimespanMonthsCombobox.SelectedValue = dateSplitted[1];
                        TargetTimespanDaysCombobox.SelectedValue = dateSplitted[2];
                        TargetTimespanHoursCombobox.SelectedValue = dateSplitted[3];
                        TargetTimespanMinutesCombobox.SelectedValue = dateSplitted[4];
                    }
                    break;
            }
            if (objData != null)
            {
                ValueDatePicker.SelectedDate = objData.DateCreated;
            }
            //FYI: type = id;unit;direction;strategy
            TypeValueHiddenField.Value = currentObject.KpiType.Id + ";" + currentObject.KpiType.KpiTypeUnitType.ToString() + ";" + currentObject.KpiType.KpiTypeDirection + ";" + currentObject.KpiType.KpiGroupingStrategy;
            KpiDataRepeater.DataSource = currentObject.KpiValues.Values.OrderBy(o => o.DateCreated).ToList();
            KpiDataRepeater.DataBind();

        }
        catch (Exception ex)
        {
            log.Error("Error loading Kpi data", ex);
        }
    }

    protected void KpisRepeaterData_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string KpiDataId =
            KpiDataId = e.CommandArgument.ToString();

        if (string.IsNullOrEmpty(KpiDataId))
        {
            SystemMessages.DisplaySystemErrorMessage("Could not complete the requested action");
            return;
        }
        currentObject = FrtwbSystem.Instance.Kpis[KpiId];
        if (e.CommandName == "DeleteKpiData")
        {
            FrtwbSystem.Instance.Kpis[currentObject.ObjectId].KpiValues.Remove(KpiDataId);
            SystemMessages.DisplaySystemMessage("The Kpi Data was deleted");
            LoadKpiData();
        }
    }
    protected void EditKpiData_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        Session["KpiDataId"] = btnClick.Attributes["data-id"];
        Session["KpiId"] = btnClick.Attributes["data-kpiId"];
        Session["ParentPage"] = "~/Kpi/KpiList.aspx";
        Response.Redirect("~/Kpi/KpiDataEntry.aspx");
    }


    protected void SaveButton_Click(object sender, EventArgs e)
    {
        try
        {
            int KpiId = this.KpiId;
            currentObject = FrtwbSystem.Instance.Kpis[KpiId];
            KpiData objKpiData = null;
            bool isNew = KpiDataId == "";
            string kpiValue = "";

            string[] vals = TypeValueHiddenField.Value.Split(new char[] { ';' });
            int kpiTypeId = Convert.ToInt32(vals[0]);
            KpiType selectedType = FrtwbSystem.Instance.KpiTypes[kpiTypeId];

            switch (selectedType.KpiTypeUnitType)
            {
                case Artexacta.App.FRTWB.UnitType.PERCENTAGE:
                    kpiValue = ((int)TargetPercentageTextbox.Value).ToString();
                    break;
                case Artexacta.App.FRTWB.UnitType.TIMESPAN:
                    kpiValue = TargetTimespanYearsCombobox.SelectedValue + ";" + TargetTimespanMonthsCombobox.SelectedValue + ";" + TargetTimespanDaysCombobox.SelectedValue + ";" + TargetTimespanHoursCombobox.SelectedValue + ";" + TargetTimespanMinutesCombobox.SelectedValue;
                    break;
                case Artexacta.App.FRTWB.UnitType.MONEY:
                    kpiValue = TargetMoneyValueTextbox.Value.ToString();
                    break;
                case Artexacta.App.FRTWB.UnitType.INTEGER:
                    kpiValue = ((int)TargetIntegerTextbox.Value).ToString();
                    break;
                case Artexacta.App.FRTWB.UnitType.DECIMAL:
                    kpiValue = TargetDecimalTextbox.Value.ToString();
                    break;
            }

            if (isNew)
            {
                objKpiData = new KpiData()
                {
                    Kpi = currentObject,

                    Value = kpiValue,
                    DateCreated = (DateTime)ValueDatePicker.SelectedDate
                };
                FrtwbSystem.Instance.Kpis[KpiId].KpiValues.Add(objKpiData.DateId, objKpiData);
            }
            else
            {
                objKpiData = FrtwbSystem.Instance.Kpis[KpiId].KpiValues[KpiDataId];

                objKpiData.Value = kpiValue;
                objKpiData.DateCreated = (DateTime)ValueDatePicker.SelectedDate;
            }
            SystemMessages.DisplaySystemMessage("The Kpi Data was saved correctly");
        }
        catch (Exception ex)
        {
            log.Error("Error saving Kpi", ex);
            return;
        }
        Session["KpiId"] = currentObject.ObjectId.ToString();
        Response.Redirect("~/Kpi/KpiDataEntry.aspx");

    }

    protected void UploadFileButton_Click(object sender, EventArgs e)
    {
        int cantidadDeItemsAGenerar = 20;
        int KpiId = this.KpiId;
        currentObject = FrtwbSystem.Instance.Kpis[KpiId];

        Random rnd = new Random();

        DateTime initialDate = DateTime.Now;
        for (int i = 0; i < cantidadDeItemsAGenerar; i++)
        {
            try
            {



                KpiData objKpiData = null;
                bool isNew = KpiDataId == "";
                string kpiValue = "";

                string[] vals = TypeValueHiddenField.Value.Split(new char[] { ';' });
                int kpiTypeId = Convert.ToInt32(vals[0]);
                KpiType selectedType = FrtwbSystem.Instance.KpiTypes[kpiTypeId];
                initialDate = initialDate.AddDays(-1);
                switch (selectedType.KpiTypeUnitType)
                {
                    case Artexacta.App.FRTWB.UnitType.PERCENTAGE:

                        kpiValue = rnd.Next(0, 101).ToString();
                        break;
                    case Artexacta.App.FRTWB.UnitType.TIMESPAN:
                        kpiValue = rnd.Next(0, 5) + ";" + rnd.Next(0, 13) + ";" + rnd.Next(0, 29) + ";" + rnd.Next(0, 25) + ";" + rnd.Next(0, 61);
                        break;
                    case Artexacta.App.FRTWB.UnitType.MONEY:
                        kpiValue = rnd.Next(0, 101).ToString();
                        break;
                    case Artexacta.App.FRTWB.UnitType.INTEGER:
                        kpiValue = rnd.Next(0, 101).ToString();
                        break;
                    case Artexacta.App.FRTWB.UnitType.DECIMAL:
                        kpiValue = rnd.Next(0, 101).ToString();
                        break;
                }

                objKpiData = new KpiData()
                {
                    Kpi = currentObject,

                    Value = kpiValue,
                    DateCreated = (DateTime)initialDate
                };
                FrtwbSystem.Instance.Kpis[KpiId].KpiValues.Add(objKpiData.DateId, objKpiData);
            }
            catch (Exception ex)
            {
                log.Error("Error generating kpi data ", ex);
            }
        }
        SystemMessages.DisplaySystemMessage("The file containing KPI Data was Imported correctly");
        Session["KpiId"] = currentObject.ObjectId.ToString();
        Response.Redirect("~/Kpi/KpiDataEntry.aspx");


    }
}