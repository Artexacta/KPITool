using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Activities.BLL;
using Artexacta.App.KPI.BLL;
using Artexacta.App.Organization.BLL;
using Artexacta.App.People.BLL;
using Artexacta.App.PermissionObject;
using Artexacta.App.Project.BLL;
using Artexacta.App.Trash;
using Artexacta.App.Trash.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;

public partial class Trash_TrashList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            OrganizationHF.Value = PermissionObject.ObjectType.ORGANIZATION.ToString();
            ProjectHF.Value = PermissionObject.ObjectType.PROJECT.ToString();
            PersonHF.Value = PermissionObject.ObjectType.PERSON.ToString();
            ActivityHF.Value = PermissionObject.ObjectType.ACTIVITY.ToString();
            KpiHF.Value = PermissionObject.ObjectType.KPI.ToString();
        }
    }
    protected void ORGRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Trash item = (Trash)e.Item.DataItem;

        if (item == null)
            return;

        //Change the text of confirmation message of delete button
        Label detailLabel = (Label)e.Item.FindControl("DetailLabel");
        if (detailLabel != null)
            detailLabel.Text = Resources.Trash.LabelDeleteOn + " " + item.DateDelete.ToString("d") + " " + Resources.Trash.LabelBy + " " + item.User;
    }
    protected void ProjectRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Trash item = (Trash)e.Item.DataItem;

        if (item == null)
            return;

        //Change the text of confirmation message of delete button
        Label detailLabel = (Label)e.Item.FindControl("DetailLabel");
        if (detailLabel != null)
            detailLabel.Text = Resources.Trash.LabelDeleteOn + " " + item.DateDelete.ToString("d") + " " + Resources.Trash.LabelBy + " " + item.User;
    }
    protected void PersonRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Trash item = (Trash)e.Item.DataItem;

        if (item == null)
            return;

        //Change the text of confirmation message of delete button
        Label detailLabel = (Label)e.Item.FindControl("DetailLabel");
        if (detailLabel != null)
            detailLabel.Text = Resources.Trash.LabelDeleteOn + " " + item.DateDelete.ToString("d") + " " + Resources.Trash.LabelBy + " " + item.User;
    }
    protected void ActivityRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Trash item = (Trash)e.Item.DataItem;

        if (item == null)
            return;

        //Change the text of confirmation message of delete button
        Label detailLabel = (Label)e.Item.FindControl("DetailLabel");
        if (detailLabel != null)
            detailLabel.Text = Resources.Trash.LabelDeleteOn + " " + item.DateDelete.ToString("d") + " " + Resources.Trash.LabelBy + " " + item.User;
    }
    protected void KpiRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        Trash item = (Trash)e.Item.DataItem;

        if (item == null)
            return;

        //Change the text of confirmation message of delete button
        Label detailLabel = (Label)e.Item.FindControl("DetailLabel");
        if (detailLabel != null)
            detailLabel.Text = Resources.Trash.LabelDeleteOn + " " + item.DateDelete.ToString("d") + " " + Resources.Trash.LabelBy + " " + item.User;
    }
    protected void ORGRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int organizationId = 0;
        try
        {
            organizationId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (organizationId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "Restore")
        {
            try
            {
                TrashBLL.RestoreTrash(OrganizationHF.Value, organizationId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ORGRepeater.DataBind();
        }
        if (e.CommandName == "DeleteOrg")
        {
            try
            {
                OrganizationBLL.DeletePermanently(organizationId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ORGRepeater.DataBind();
        }
    }
    protected void ProjectRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int projectId = 0;
        try
        {
            projectId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (projectId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "Restore")
        {
            try
            {
                TrashBLL.RestoreTrash(ProjectHF.Value, projectId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ProjectRepeater.DataBind();
        }
        if (e.CommandName == "DeleteProject")
        {
            try
            {
                ProjectBLL.DeletePermanently(projectId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ProjectRepeater.DataBind();
        }
    }
    protected void PersonRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int personId = 0;
        try
        {
            personId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (personId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "Restore")
        {
            try
            {
                TrashBLL.RestoreTrash(PersonHF.Value, personId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            PersonRepeater.DataBind();
        }
        if (e.CommandName == "DeletePerson")
        {
            try
            {
                PeopleBLL.DeletePermanently(personId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            PersonRepeater.DataBind();
        }
    }
    protected void ActivityRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int activityId = 0;
        try
        {
            activityId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (activityId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "Restore")
        {
            try
            {
                TrashBLL.RestoreTrash(ActivityHF.Value, activityId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ActivityRepeater.DataBind();
        }
        if (e.CommandName == "DeleteActivity")
        {
            try
            {
                ActivityBLL.DeletePermanently(activityId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            ActivityRepeater.DataBind();
        }
    }
    protected void KpiRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int kpiId = 0;
        try
        {
            kpiId = Convert.ToInt32(e.CommandArgument);
        }
        catch (Exception ex)
        {
            log.Error("Error getting object id", ex);
        }
        if (kpiId <= 0)
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.Organization.MessageNoComplete);
            return;
        }

        if (e.CommandName == "Restore")
        {
            try
            {
                TrashBLL.RestoreTrash(KpiHF.Value, kpiId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            KpiRepeater.DataBind();
        }
        if (e.CommandName == "DeleteKpi")
        {
            try
            {
                KPIBLL.DeletePermanentlyKPI(kpiId);
            }
            catch (Exception ex)
            {
                SystemMessages.DisplaySystemErrorMessage(ex.Message);
                return;
            }
            KpiRepeater.DataBind();
        }
    }
}