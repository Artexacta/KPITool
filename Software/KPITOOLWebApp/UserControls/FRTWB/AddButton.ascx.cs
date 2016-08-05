using Artexacta.App.Utilities.SystemMessages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Organization;

public partial class UserControls_FRTWB_AddButton : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            List<Organization> theOrganizations = new List<Organization>();
            try
            {
                theOrganizations = OrganizationBLL.GetOrganizationsByUser("1 = 1");
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }

            if (theOrganizations.Count > 0)
            {
                OrganizationsExists.Value = "true";
            }
            else
                addIcon.Attributes["class"] = "zmdi zmdi-plus-circle-o zmdi-hc-fw animated pulse";
        }
    }

    protected void AddOrganization_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        //Verify if exists with the same name
        OrganizationBLL theBLL = new OrganizationBLL();
        Organization theOrg = null;

        try
        {
            theOrg = theBLL.GetOrganizationByName(OrganizationName.Text);
        }
        catch {}

        if (theOrg != null)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNameExists);
            return;
        }

        //Create the organizacion in the database
        int organizationId = 0;

        try
        {
            organizationId = OrganizationBLL.InsertOrganization(OrganizationName.Text);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            return;
        }

        SystemMessages.DisplaySystemMessage(Resources.Organization.MessageCreateOk);
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

    protected void ExistsOrganizationCustomValidator_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = false;

        OrganizationBLL theBLL = new OrganizationBLL();
        Organization organization = null;

        try
        {
            organization = theBLL.GetOrganizationByName(OrganizationName.Text);
        }
        catch
        {
            return;
        }

        if (organization == null)
            args.IsValid = true;
    }



    protected void PersonButton_Click(object sender, EventArgs e)
    {
        string currentPage = Page.Request.AppRelativeCurrentExecutionFilePath;
        Session["ParentPage"] = currentPage;
        Response.Redirect("~/Personas/PeopleForm.aspx");
    }
}