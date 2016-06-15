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

                foreach (var item in items)
                {
                    if(item.SourceType == TourItem.SourceTypeOption.HelpFile)
                    {
                        setContentFromFile(item);
                    }
                }
            }
            catch (Exception ex)
            {
                items = new List<TourItem>();
            }
        }

        ItemsHiddenField.Value = js.Serialize(items);
    }

    private void setContentFromFile(TourItem item)
    {
        System.IO.StreamReader streamReader = null;
        try
        {
            if (System.IO.File.Exists(Server.MapPath("" + "/" + file)))
            {
                streamReader = new System.IO.StreamReader(Server.MapPath(lblHelpFilesRoute.Text + "/" + file));
                this.ViewState["state"] = "update";
                item.content =  streamReader.ReadToEnd();
            }
            else
            {
                this.ViewState["state"] = "new";
                return string.Empty;
            }
        }
        catch (Exception x)
        {
            throw x;
        }
        finally
        {
            if (streamReader != null)
                streamReader.Close();
        }
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