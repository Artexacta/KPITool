using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Authentication_ConfirmarReseteo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected override void InitializeCulture()
    {
        base.InitializeCulture();
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();

    }

    protected void LoginLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Authentication/Login.aspx");
    }

}