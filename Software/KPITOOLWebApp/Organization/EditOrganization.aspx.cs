using Artexacta.App.FRTWB;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Organization_EditOrganization : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int OrganizationId
    {
        set { OrganizationIdHiddenField.Value = value.ToString(); }
        get
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(OrganizationIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert OrganizationIdHiddenField.Value to integer value", ex);
            }
            return id;
        }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParametes();
            int organizationId = this.OrganizationId;
            if (organizationId <= 0)
            {
                Response.Redirect("~/MainPage.aspx");
                return;
            }
            Organization organization = FrtwbSystem.Instance.Organizations[organizationId];
            OrganizationNameLit.Text = organization.Name;
            OrganizationNameTextBox.Text = organization.Name;
            AreasRepeater.DataSource = organization.Areas;
            AreasRepeater.DataBind();
        }
    }

    private void ProcessSessionParametes()
    {
        if (Session["OrganizationId"] != null && !string.IsNullOrEmpty(Session["OrganizationId"].ToString()))
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(Session["OrganizationId"].ToString());
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert Session['OrganizationId'] to integer value", ex);
            }
            OrganizationId = id;
        }
        Session["OrganizationId"] = null;
    }


    protected void DeleteArea_Click(object sender, EventArgs e)
    {
        LinkButton btnClick = (LinkButton)sender;
        int key = Convert.ToInt32(btnClick.Attributes["data-id"]);
        Organization organization = FrtwbSystem.Instance.Organizations[OrganizationId];
        organization.Areas.Remove(key);
        AreasRepeater.DataSource = organization.Areas;
        AreasRepeater.DataBind();

        SystemMessages.DisplaySystemMessage("New Area was deleted from current Organization");
    }
    protected void AddArea_Click(object sender, EventArgs e)
    {
        Area area = new Area();
        area.Name = AreaName.Text;
        Organization organization = FrtwbSystem.Instance.Organizations[OrganizationId];
        area.Owner = organization;
        organization.Areas.Add(area.ObjectId, area);
        FrtwbSystem.Instance.Areas.Add(area.ObjectId, area);
        AreasRepeater.DataSource = organization.Areas;
        AreasRepeater.DataBind();

        SystemMessages.DisplaySystemMessage("New Area was added to current Organization");
    }
    protected void AddOrganization_Click(object sender, EventArgs e)
    {
        Organization organization = new Organization();
        organization.Name = OrganizationName.Text;
        FrtwbSystem.Instance.Organizations.Add(organization.ObjectId, organization);

        SystemMessages.DisplaySystemMessage("Organization was modified");

        Response.Redirect("~/MainPage.aspx");
    }

    protected void SaveOrganizationButton_Click(object sender, EventArgs e)
    {
        Organization obj = FrtwbSystem.Instance.Organizations[OrganizationId];
        if (obj == null)
            return;

        obj.Name = OrganizationNameTextBox.Text;
        Response.Redirect("~/MainPage.aspx");
    }
}