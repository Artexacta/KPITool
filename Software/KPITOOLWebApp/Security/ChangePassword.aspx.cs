using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Security_ChangePassword : System.Web.UI.Page
{

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ChangePassword1.Visible = true;
    }

    protected void ChangePassword1_CancelButtonClick(object sender, EventArgs e)
    {
        Response.Redirect("~/MainPage.aspx");
    }

}