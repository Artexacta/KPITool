using Artexacta.App.Utilities;
using Artexacta.App.Utilities.Controls;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_TourControl : UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

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
                log.Error("Error getting tour settings", ex);
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
            string directory = ConfigurationManager.AppSettings["HelpFilesRoute"];
            string extension = ConfigurationManager.AppSettings["HelpFilesExtension"];
            if (!string.IsNullOrEmpty(directory) && !directory.EndsWith("/"))
                directory += "/";
            if (!string.IsNullOrEmpty(extension) && !extension.StartsWith("."))
                extension = "." + extension;

            string language = LanguageUtilities.GetLanguageFromContext();

            string title = item.content;
            string file = Server.MapPath(directory + item.content + "_" + language + extension);
            if (System.IO.File.Exists(file))
            {
                streamReader = new System.IO.StreamReader(file);
                item.content =  streamReader.ReadToEnd();
            }
            else
            {
                item.content = "";
            }

            item.title += " <small><span class='label label-default'>" + title + "</span></small>";
        }
        catch (Exception x)
        {
            log.Error("Error loading content from help file", x);
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