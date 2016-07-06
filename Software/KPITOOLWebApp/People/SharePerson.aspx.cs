using Artexacta.App.ObjectAction;
using Artexacta.App.People;
using Artexacta.App.People.BLL;
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

public partial class People_SharePerson : System.Web.UI.Page
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
            if (!string.IsNullOrEmpty(PersonIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Personas/ListaPersonas.aspx");

            UserTextBox.Attributes.Add("onchange", "UserTextBox_OnChange()");
            ObjectTypeIdHiddenField.Value = PermissionObject.ObjectType.PERSON.ToString();
        }
    }

    private void ProcessSessionParameteres()
    {
        int personId = 0;
        if (Request["ID"] != null && !string.IsNullOrEmpty(Request["ID"].ToString()))
        {
            try
            {
                personId = Convert.ToInt32(Request["ID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion del parametro ID");
            }
        }
        else if (Session["PERSONID"] != null && !string.IsNullOrEmpty(Session["PERSONID"].ToString()))
        {
            try
            {
                personId = Convert.ToInt32(Session["PERSONID"].ToString());
            }
            catch
            {
                log.Error("no se pudo realizar la conversion de la session personId:" + Session["PERSONID"]);
            }

            Session["PERSONID"] = null;
        }

        if (personId > 0)
            PersonIdHiddenField.Value = personId.ToString();
    }

    private void LoadData()
    {
        //-- verify is user is OWNER
        PermissionObject theUser = new PermissionObject();
        try
        {
            theUser = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }

        if (theUser == null || !theUser.TheActionList.Exists(i => i.ObjectActionID.Equals("OWN")))
        {
            SystemMessages.DisplaySystemWarningMessage(Resources.ShareData.UserNotOwnPerson);
            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }

        //-- show Data
        People theData = null;
        try
        {
            theData = PeopleBLL.GetPeopleById(Convert.ToInt32(PersonIdHiddenField.Value));
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
            Response.Redirect("~/Personas/ListaPersonas.aspx");
        }

        if (theData != null)
        {
            PersonNameLiteral.Text = theData.Name;
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
                    PermissionObjectBLL.DeleteObjectPublic(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value));
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
                    PermissionObjectBLL.DeleteObjectPermissions(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value), userName);
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
                PermissionObjectBLL.InsertObjectPublic(PermissionObject.ObjectType.PERSON.ToString(), Convert.ToInt32(PersonIdHiddenField.Value), objectActionList);
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
                PermissionObjectBLL.InsertObjectPermissions(PermissionObject.ObjectType.PERSON.ToString(),
                    Convert.ToInt32(PersonIdHiddenField.Value), Convert.ToInt32(UserInvitedIdHiddenField.Value), objectActionList);
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
    public static bool VerifiyUser(int personId, int userId)
    {
        User theUser = UserBLL.GetUserById(userId);
        PermissionObject theData = PermissionObjectBLL.GetPermissionsByUser(PermissionObject.ObjectType.PERSON.ToString(), personId, theUser.Username);
        if (theData == null)
            return false;
        else
            return true;
    }

    [WebMethod]
    public static bool VerifiyActualUser(int userId)
    {
        User theData = UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);
        if (theData != null && theData.UserId == userId)
            return true;
        else
            return false;
    }

}