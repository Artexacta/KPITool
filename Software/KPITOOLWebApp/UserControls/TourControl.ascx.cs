using Artexacta.App.Utilities.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_TourControl : UserControl
{

    public string CssClass
    {
        set { showTourBtn.CssClass = value; }
        get { return showTourBtn.CssClass; }
    }

    public string TourSettingsId
    {
        set { ControlSettingsControlName.Text = value; }
        get { return ControlSettingsControlName.Text; }
    }

    protected override void OnPreRender(EventArgs e)
    {
 	    base.OnPreRender(e);
        JavaScriptSerializer js = new JavaScriptSerializer();
        List<TourItem> items = null;
        if (string.IsNullOrEmpty(TourSettingsId))
            items = new List<TourItem>();
        else
        {
            try
            {
                TourSettings settings = (TourSettings)Parent.FindControl(TourSettingsId);
                items = settings.Items;
            }
            catch (Exception ex)
            {
                items = new List<TourItem>();
            }
        }

        ItemsHiddenField.Value = js.Serialize(items);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    public void Show()
    {
        ShowTourHiddenField.Value = "true";
    }

    public void Hide()
    {
        ResetTourHiddenField.Value = "true";
        showTourBtn.Visible = false;
    }

    
}