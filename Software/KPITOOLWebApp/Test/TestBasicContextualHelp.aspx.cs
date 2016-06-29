using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test_TestBasicContextualHelp : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadMainMenuScript();
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    private void LoadMainMenuScript()
    {
        StringBuilder scriptText = new StringBuilder("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.mCustomScrollbar.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/functions.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<link rel=\"icon\" href=\"");
        scriptText.Append(ResolveUrl("~/Images/favicon.png"));
        scriptText.Append("\" type=\"image/png\" >\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/aehelper.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/toastr.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/highcharts.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/highcharts-more.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/exporting.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.sparkline.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.pie.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.flot.tooltip.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.easypiechart.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap-tour.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/bootstrap3-typeahead.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        //scriptText.Append("<script src=\"");
        //scriptText.Append(ResolveClientUrl("~/Scripts/typeahead.bundle.min.js"));
        //scriptText.Append("\" type=\"text/javascript\"></script>\n");

        /*scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.caretPosition.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.tipTip.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");


        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery-cookie.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.slimscroll.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/jquery.metisMenu.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/inspinia.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/pace.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        scriptText.Append("<script src=\"");
        scriptText.Append(ResolveClientUrl("~/Scripts/icheck.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");*/

        JqueryAndMainMenuScript.Text = scriptText.ToString();
    }
}