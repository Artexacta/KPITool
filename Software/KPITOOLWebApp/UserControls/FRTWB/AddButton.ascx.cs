using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_FRTWB_AddButton : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (FrtwbSystem.Instance.Organizations.Count > 0)
        {
            OrganizationsExists.Value = "true";
        }
        else
            addIcon.Attributes["class"] = "zmdi zmdi-plus-circle-o zmdi-hc-fw animated pulse";
    }

    protected void AddOrganization_Click(object sender, EventArgs e)
    {
        Organization organization = new Organization();
        organization.Name = OrganizationName.Text;
        FrtwbSystem.Instance.Organizations.Add(organization.ObjectId, organization);
        SystemMessages.DisplaySystemMessage("Organization was created");
        Response.Redirect("~/MainPage.aspx");
    }

    protected void ProjectButton_Click(object sender, EventArgs e)
    {
        string currentPage = Page.Request.AppRelativeCurrentExecutionFilePath;
        Session["ParentPage"] = currentPage;
        Response.Redirect("~/Project/ProjectForm.aspx");
    }

    protected void ActivityButton_Click(object sender, EventArgs e)
    {
       
        string currentPage = Page.Request.AppRelativeCurrentExecutionFilePath;
        Session["ParentPage"] = currentPage;
        Response.Redirect("~/Activity/AddActivity.aspx");
    }
}