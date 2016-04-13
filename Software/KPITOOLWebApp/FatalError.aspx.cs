using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class FatalError : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        // Our default error message.  Most errors are caused by an off-line SQL engine.
        string error = Resources.FatalError.UnknownError;

        if (Session["ErrorMessage"] != null)
        {
            error = Session["ErrorMessage"].ToString();

            // We are done with this error.  Make sure the it's not displayed again
            Session.Remove("ErrorMessage");
        }

        log.Error("FatalError: " + error);
        FatalErrorLabel.Text = error;
    }
}