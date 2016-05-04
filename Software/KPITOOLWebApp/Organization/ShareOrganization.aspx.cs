using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Organization_ShareOrganization : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(OrganizationIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/MainPage.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        if (Session["ORGANIZATIONID"] != null && !string.IsNullOrEmpty(Session["ORGANIZATIONID"].ToString()))
        {
            int organizationId = 0;
            try
            {
                organizationId = Convert.ToInt32(Session["ORGANIZATIONID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session organizationId:" + Session["ORGANIZATIONID"]);
            }

            OrganizationIdHiddenField.Value = Session["ORGANIZATIONID"].ToString();
        }
        Session["ORGANIZATIONID"] = null;
    }

    private void LoadData()
    {
        Organization organization = null;
        try
        {
            organization = OrganizationBLL.GetOrganizationById(Convert.ToInt32(OrganizationIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/MainPage.aspx");
        }

        if (organization != null)
        {
            OrganizationNameLiteral.Text = organization.Name;
        }
    }

}