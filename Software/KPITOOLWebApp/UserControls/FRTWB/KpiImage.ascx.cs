using Artexacta.App.FRTWB;
using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_FRTWB_KpiImage : System.Web.UI.UserControl
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

    protected void Page_Load(object sender, EventArgs e)
    {
        MyImage.ImageUrl = "~/UserControls/FRTWB/KpiImageHandler.ashx?kpiId=" + KpiId;
    }

    

}