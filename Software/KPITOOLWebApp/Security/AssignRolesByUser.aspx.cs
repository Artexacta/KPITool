using Artexacta.App.LoginSecurity;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Security_AssignRolesByUser : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        //Make the Search button the default button for the page
        HtmlForm mainform = this.Form;
        if (mainform != null)
        {
            mainform.DefaultButton = SearchButton.UniqueID;
        }
    }

    protected void SaveRolesButton_Click(object sender, EventArgs e)
    {
        int TotalRoles;
        string RolesToDelete = "";
        string[] FinalRolesToDelete;
        string RolesToInsert = "";
        string[] FinalRolesToInsert;

        if (!String.IsNullOrEmpty(UserLabel.Text))
        {
            TotalRoles = UserRoleCheckBoxList.Items.Count;
            for (int i = 0; i < TotalRoles; i++)
            {
                if (UserRoleCheckBoxList.Items[i].Selected)
                {
                    if (RolesToInsert == "")
                    {
                        RolesToInsert = (UserRoleCheckBoxList.Items[i].Value).ToString();
                    }
                    else
                    {
                        RolesToInsert = RolesToInsert + "," + (UserRoleCheckBoxList.Items[i].Value).ToString();
                    }
                }
                else
                {
                    if (RolesToDelete == "")
                    {
                        RolesToDelete = (UserRoleCheckBoxList.Items[i].Value).ToString();
                    }
                    else
                    {
                        RolesToDelete = RolesToDelete + "," + (UserRoleCheckBoxList.Items[i].Value).ToString();
                    }
                }
            }
        }
        bool IsTheUser = false;
        if (UserLabel.Text == ConfigurationManager.AppSettings.Get("AdminUser").ToString())
            IsTheUser = true;
        else
            IsTheUser = false;

        string adminRole = "";
        try
        {
            adminRole = ConfigurationManager.AppSettings.Get("AdminRole").ToString();
        }
        catch { }
        FinalRolesToDelete = RolesToDelete.Split(',');
        FinalRolesToInsert = RolesToInsert.Split(',');

        if (IsTheUser)
        {
            if (RolesToDelete != null && RolesToDelete.Length > 0)
            {
                foreach (String RoleToDelete in FinalRolesToDelete)
                {
                    if (RoleToDelete != adminRole)
                    {
                        if (Roles.IsUserInRole(UserLabel.Text, RoleToDelete))
                        {
                            Roles.RemoveUserFromRole(UserLabel.Text, RoleToDelete);
                            UserBLL.DeleteUserInRoles(UserLabel.Text, RoleToDelete);
                            SystemMessages.DisplaySystemMessage("El Usuario " + UserLabel.Text + " ha sido eliminado del Rol " + RoleToDelete + ".");
                            log.Debug("Removed User " + UserLabel.Text + " from Role " + RoleToDelete + ". Function SaveRolesImageButton_Click from AssignRoles page");
                        }
                    }
                }
            }
            if (RolesToInsert != null && RolesToInsert.Length > 0)
            {
                foreach (String RoleToInsert in FinalRolesToInsert)
                {
                    if (!Roles.IsUserInRole(UserLabel.Text, RoleToInsert))
                    {
                        Roles.AddUserToRole(UserLabel.Text, RoleToInsert);
                        UserBLL.InsertUserInRoles(UserLabel.Text, RoleToInsert);
                        SystemMessages.DisplaySystemMessage("El Usuario " + UserLabel.Text + " ha sido adicionado al Rol " + RoleToInsert + ".");
                        log.Debug("Added User " + UserLabel.Text + " to Role " + RoleToInsert + ". Function SaveRolesImageButton_Click from AssignRoles page");
                    }
                }
            }
            else
            {
                SystemMessages.DisplaySystemErrorMessage("No se pudo eliminar el Usuario " + UserLabel.Text + " del Rol");
            }
        }
        else
        {
            if (RolesToDelete != null && RolesToDelete.Length > 0)
            {
                foreach (String RoleToDelete in FinalRolesToDelete)
                {
                    if (Roles.IsUserInRole(UserLabel.Text, RoleToDelete))
                    {
                        Roles.RemoveUserFromRole(UserLabel.Text, RoleToDelete);
                        UserBLL.DeleteUserInRoles(UserLabel.Text, RoleToDelete);
                        SystemMessages.DisplaySystemMessage("El Usuario " + UserLabel.Text +
                            " ha sido eliminado del Rol " + RoleToDelete + ".");
                        log.Debug("Removed User " + UserLabel.Text + " from Role " + RoleToDelete + ". Function SaveRolesImageButton_Click from AssignRoles page");
                    }
                }
            }
            if (RolesToInsert != null && RolesToInsert.Length > 0)
            {
                foreach (String RoleToInsert in FinalRolesToInsert)
                {
                    if (!Roles.IsUserInRole(UserLabel.Text, RoleToInsert))
                    {
                        Roles.AddUserToRole(UserLabel.Text, RoleToInsert);
                        UserBLL.InsertUserInRoles(UserLabel.Text, RoleToInsert);
                        SystemMessages.DisplaySystemMessage("El Usuario " + UserLabel.Text + " ha sido adicionado al Rol " + RoleToInsert + ".");
                    }
                }
            }
        }
    }

    protected void ResetRolesButton_Click(object sender, EventArgs e)
    {
        ResetRoles();
    }

    protected void ResetRoles()
    {
        string[] RolesForUser = null;
        string selectedName = "";
        selectedName = UserLabel.Text.Trim();

        if (selectedName != null && selectedName.Length > 0)
        {
            MembershipUser theUser;
            EmployeeRolePanel.Visible = true;
            RolesForUser = Roles.GetRolesForUser(selectedName);
            FillCheckBoxesForRoles(RolesForUser);
            theUser = Membership.GetUser(selectedName);
            UserLabel.Text = theUser.UserName.ToString();
            UserEmailLabel.Text = theUser.Email.ToString();
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        UserNameHiddenField.Value = UserNameTextBox.Text.Trim();
        UserGridView.DataBind();
    }

    protected void FillCheckBoxesForRoles(string[] RolesForUser)
    {
        UserRoleCheckBoxList.ClearSelection();
        UserRoleCheckBoxList.DataSource = Roles.GetAllRoles();
        UserRoleCheckBoxList.DataBind();
        int TotalRoles = UserRoleCheckBoxList.Items.Count;

        string Positions = "";
        foreach (String RolForUser in RolesForUser)
        {
            for (int i = 0; i < TotalRoles; i++)
            {
                if (UserRoleCheckBoxList.Items[i].Value == RolForUser)
                {
                    if (Positions == "")
                        Positions = i.ToString();
                    else
                        Positions = Positions + "," + i.ToString();
                }
            }
        }
        if (Positions != null && Positions.Length > 0)
        {
            string[] FinalPositions;
            FinalPositions = Positions.Split(',');
            foreach (String CheckPosition in FinalPositions)
            {
                int checPosition;
                checPosition = Convert.ToInt32(CheckPosition);
                UserRoleCheckBoxList.Items[checPosition].Selected = true;
            }
        }
    }

    protected void UserGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        string[] RolesForUser = null;
        try
        {
            MembershipUser theUser;
            EmployeeRolePanel.Visible = true;
            RolesForUser = Roles.GetRolesForUser(UserGridView.SelectedValue.ToString());
            FillCheckBoxesForRoles(RolesForUser);
            theUser = Membership.GetUser(UserGridView.SelectedValue.ToString());
            UserLabel.Text = theUser.UserName.ToString();
            UserEmailLabel.Text = theUser.Email.ToString();

            if (theUser.UserName.Equals(HttpContext.Current.User.Identity.Name))
            {
                foreach (ListItem item in UserRoleCheckBoxList.Items)
                    item.Enabled = false;

                SaveRolesButton.Visible = false;
                ResetRolesButton.Visible = false;
            }
            else
            {
                SaveRolesButton.Visible = true;
                ResetRolesButton.Visible = (!LoginSecurity.IsUserAuthorizedPermission("RESET_USER_ACCOUNT"));
            }
        }
        catch (Exception q)
        {
            SystemMessages.DisplaySystemMessage("no se pudo obtener información de Roles desde la base de datos.");
            log.Error("Function InRoleListBox_SelectedIndexChanged from AssingRolesByUser page", q);
        }
    }

    protected void UsersObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Cannot load Users on AssignRolesByUser.aspx page", e.Exception);
            SystemMessages.DisplaySystemErrorMessage("No se pudo obtener información de Roles desde la base de datos.");
            UserGridView.Visible = false;
            e.ExceptionHandled = true;
        }
        else
        {
            UserGridView.Visible = true;
        }
    }

}