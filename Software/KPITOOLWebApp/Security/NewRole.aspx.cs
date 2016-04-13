using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Security_NewRole : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameters();
        }
    }

    private void ProcessSessionParameters()
    {
        if (Session["NRPOSTBACKPAGE"] != null)
        {
            string initPostBackPage = Session["NRPOSTBACKPAGE"].ToString();
            if (!string.IsNullOrEmpty(initPostBackPage))
            {
                PostBackPageHiddenField.Value = initPostBackPage;
            }
        }
        Session["NRPOSTBACKPAGE"] = null;
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {
        log.Debug("Creating a new Role");
        Roles.CreateRole(RoleNameTextBox.Text.Trim());
        Response.Redirect("~/Security/AssignRoles.aspx");
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(PostBackPageHiddenField.Value);
    }

}