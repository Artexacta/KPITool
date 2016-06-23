using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiSummary_KpiMeasurements : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set
        {
            KpiIdHiddenField.Value = value.ToString();
            
        }
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

    public string Unit
    {
        set
        {
            UnitHiddenField.Value = value;
        }
        get
        {
            return UnitHiddenField.Value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
       // LoadMeasurements();
    }

    protected void MeasurementsGridView_DataBound(object sender, EventArgs e)
    {
       // MeasurementsGridView.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void MeasurementsDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception == null)
            return;

        log.Error("Error loading measurements", e.Exception);
        e.ExceptionHandled = true;
    }
}