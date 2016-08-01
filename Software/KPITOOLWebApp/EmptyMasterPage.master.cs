using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class EmptyMasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadIcon();
    }

    /// <summary>
    /// In the HTML header places the script tag and the script loading
    /// </summary>
    private void LoadIcon()
    {
        StringBuilder scriptText = new StringBuilder("<link rel=\"shortcut icon\" href=\"");
        scriptText.Append(ResolveUrl("~/Images/favicon.ico"));
        scriptText.Append("\" type=\"image/x-icon\" >\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        JqueryAndMainMenuScript.Text = scriptText.ToString();
    }

}
