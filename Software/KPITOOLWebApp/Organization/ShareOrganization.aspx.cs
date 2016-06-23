using Artexacta.App.ObjectAction;
using Artexacta.App.Organization;
using Artexacta.App.Organization.BLL;
using Artexacta.App.PermissionObject;
using Artexacta.App.PermissionObject.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Organization_ShareOrganization : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(OrganizationIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/MainPage.aspx");

            UserTextBox.Attributes.Add("onchange", "UserTextBox_OnChange()");
            ObjectTypeIdHiddenField.Value = PermissionObject.ObjectType.ORGANIZATION.ToString();
        }
    }

    private void ProcessSessionParameteres()
    {
        int organizationId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                organizationId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["ORGANIZATIONID"] != null && !string.IsNullOrEmpty(Session["ORGANIZATIONID"].ToString()))
        {
            try
            {
                organizationId = Convert.ToInt32(Session["ORGANIZATIONID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session organizationId:" + Session["ORGANIZATIONID"]);
            }

            Session["ORGANIZATIONID"] = null;
        }

        if (organizationId > 0)
            OrganizationIdHiddenField.Value = organizationId.ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.ORGANIZATION.ToString(), Convert.ToInt32(OrganizationIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/MainPage.aspx");
        }

        if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.ShareData.UserNotOwnOrganization);
            Response.Redirect("~/MainPage.aspx");
        }

        //-- show Data
        Organization theData = null;
        try
        {
            theData = OrganizationBLL.GetOrganizationById(Convert.ToInt32(OrganizationIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/MainPage.aspx");
        }

        if (theData != null)
        {
            OrganizationNameLiteral.Text = theData.Name;
        }
    }

    protected void ObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

    protected void PermissionsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string userName = DataBinder.Eval(e.Row.DataItem, "UserName").ToString();
            if (userName.Equals(HttpContext.Current.User.Identity.Name))
            {
                LinkButton deleteButton = (LinkButton)e.Row.FindControl("DeleteButton");
                deleteButton.Visible = false;

                LinkButton editButton = (LinkButton)e.Row.FindControl("EditButton");
                editButton.Visible = false;
            }
        }
    }

    protected void PermissionsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string userName = e.CommandArgument.ToString();
        if (e.CommandName.Equals("DeleteData"))
        {
            if (string.IsNullOrEmpty(userName))
            {
                try
                {
                    PermissionObjectBLL.DeleteObjectPublic(PermissionObject.ObjectType.ORGANIZATION.ToString(), Convert.ToInt32(OrganizationIdHiddenField.Value));
                    SystemMessages.DisplaySystemMessage(Resources.ShareData.DeleteObjectPublicOk);
                }
                catch (Exception exc)
                {
                    SystemMessages.DisplaySystemErrorMessage(exc.Message);
                    return;
                }
            }
            else
            {
                try
                {
                    PermissionObjectBLL.DeleteObjectPermissions(PermissionObject.ObjectType.ORGANIZATION.ToString(), Convert.ToInt32(OrganizationIdHiddenField.Value), userName);
                    SystemMessages.DisplaySystemMessage(Resources.ShareData.DeleteObjectPermissionsOk);
                }
                catch (Exception exc)
                {
                    SystemMessages.DisplaySystemErrorMessage(exc.Message);
                    return;
                }
            }

            PermissionsGridView.DataBind();
            ObjectActionRepeater.DataBind();
        }
    }

    protected void ObjectActionRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ObjectAction theData = (ObjectAction)(e.Item.DataItem);
            CheckBox actionCheckBox = (CheckBox)e.Item.FindControl("ActionCheckBox");
            actionCheckBox.Attributes.Add("onclick", "ActionCheckBox_change(" + actionCheckBox.ClientID + ",'" + theData.ObjectActionID + "')");
        }
    }

    protected void SaveUserButton_Click(object sender, EventArgs e)
    {
        ShowInviteUserModal.Value = "true";
        string objectActionList = "";
        foreach (RepeaterItem item in ObjectActionRepeater.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                CheckBox actionCheckBox = (CheckBox)item.FindControl("ActionCheckBox");
                if (actionCheckBox.Checked)
                {
                    HiddenField actionId = (HiddenField)item.FindControl("ActionId");
                    objectActionList = string.IsNullOrEmpty(objectActionList) ? actionId.Value : (objectActionList + ";" + actionId.Value);
                }
            }
        }

        if (EveryoneCheckBox.Checked)
        {
            try
            {
                PermissionObjectBLL.InsertObjectPublic(PermissionObject.ObjectType.ORGANIZATION.ToString(), Convert.ToInt32(OrganizationIdHiddenField.Value), objectActionList);
                SystemMessages.DisplaySystemMessage(Resources.ShareData.InsertObjectPublicOk);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }
        else
        {
            try
            {
                PermissionObjectBLL.InsertObjectPermissions(PermissionObject.ObjectType.ORGANIZATION.ToString(), 
                    Convert.ToInt32(OrganizationIdHiddenField.Value), Convert.ToInt32(UserInvitedIdHiddenField.Value), objectActionList);
                SystemMessages.DisplaySystemMessage(Resources.ShareData.InsertObjectPermissionsOk + UserTextBox.Text);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }

        EveryoneCheckBox.Checked = false;
        UserTextBox.Text = "";
        UserInvitedIdHiddenField.Value = "";
        ObjectActionRepeater.DataBind();
        ShowInviteUserModal.Value = "false";
        PermissionsGridView.DataBind();
    }

    [WebMethod]
    public static bool VerifiyUser(int organizationId, int userId)
    {
        User theUser = UserBLL.GetUserById(userId);
        PermissionObject theData = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.ORGANIZATION.ToString(), organizationId, theUser.Username);
        if (theData == null)
            return false;
        else
            return true;
    }

}