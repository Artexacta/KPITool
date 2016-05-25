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

    public enum OwnerTypeValue
    {
        KPI,
        ACTIVITY,
        ORGANIZATION,
        AREA,
        PROJECT,
        PERSON
    }

    public OwnerTypeValue OwnerType
    {
        set { OwnerTypeHiddenField.Value = value.ToString(); }
        get
        {
            OwnerTypeValue owner = OwnerTypeValue.KPI;
            try
            {
                owner = (OwnerTypeValue)Enum.Parse(typeof(OwnerTypeValue), OwnerTypeHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert OwnerTypeHiddenField.Value to OwnerTypeValue value", ex);
            }
            return owner;
        }
    }

    public int OwnerId
    {
        set { OwnerIdHiddenField.Value = value.ToString(); }
        get
        {
            int ownerId = 0;
            try
            {
                ownerId = Convert.ToInt32(OwnerIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert KpiIdHiddenField.Value to integer value", ex);
            }
            return ownerId;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    // Override the OnPreRender method to set _message to
    // a default value if it is null.
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        string userName = "";
        if (HttpContext.Current.User.Identity.IsAuthenticated)
            userName = HttpContext.Current.User.Identity.Name;
        MyImage.ImageUrl = "~/UserControls/FRTWB/KpiImageHandler.ashx?ownerId=" + OwnerIdHiddenField.Value + 
            "&ownerType=" + OwnerTypeHiddenField.Value + 
            "&userName=" + userName;
    }

    

}