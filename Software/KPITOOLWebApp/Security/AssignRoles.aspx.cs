using Artexacta.App.LoginSecurity;
using Artexacta.App.Security.BLL;
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
using System.Web.UI.WebControls;

public partial class Security_AssignRoles : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    string[] gRolesForUser;
    SecurityBLL theUsersAndRolesBLL = new SecurityBLL();

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InitializeControls();
        }
    }

    protected void InitializeControls()
    {
        try
        {
            RoleDropDownList.DataSource = theUsersAndRolesBLL.GetAllRolesAndNone();
            RoleDropDownList.DataBind();
            BindData();
        }
        catch (Exception exc)
        {
            log.Error("InitializeControls Error. Function InitializeControls from AssignRoles page", exc);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorGetRoles);
        }
    }

    protected void BindData()
    {
        try
        {
            //Initialize the values for the IN ROLE list box
            if (RoleDropDownList.Text == Resources.SecurityData.NoneRoleItem || string.IsNullOrEmpty(RoleDropDownList.Text))
            {
                InRoleListBox.DataSource = theUsersAndRolesBLL.UsersInNoneRole();
            }
            else
            {
                if (Roles.GetUsersInRole(RoleDropDownList.Text) == null)
                    InRoleListBox.DataSource = "";
                else
                    InRoleListBox.DataSource = Roles.GetUsersInRole(RoleDropDownList.Text);
            }
            InRoleListBox.DataBind();

            //Initialize the values for the NOT IN ROLE list box
            if (RoleDropDownList.Text == Resources.SecurityData.NoneRoleItem || string.IsNullOrEmpty(RoleDropDownList.Text))
            {
                OutRoleListBox.DataSource = theUsersAndRolesBLL.UsersNotInRoleNone();
                AddOutImageButton.Enabled = false;
                DeleteRolImageButton.Visible = false;
            }
            else
            {
                if (theUsersAndRolesBLL.GetUsersNotInRol(RoleDropDownList.Text) == null)
                    OutRoleListBox.DataSource = "";
                else
                    OutRoleListBox.DataSource = theUsersAndRolesBLL.GetUsersNotInRol(RoleDropDownList.Text);

                AddOutImageButton.Enabled = true;
                DeleteRolImageButton.Visible = false;
            }
            OutRoleListBox.DataBind();
        }
        catch (Exception q)
        {
            log.Error("Error en BindData de la pagina AssignRoles.aspx.", q);
            SystemMessages.DisplaySystemErrorMessage(Resources.SecurityData.MessageErrorGetUsersByRole + RoleDropDownList.Text);
        }
        EmployeeRolePanel.Visible = false;
    }

    protected void RoleDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        EmployeeRolePanel.Visible = false;
        BindData();
    }

    protected void DeleteRolImageButton_Click(object sender, EventArgs e)
    {
        try
        {
            log.Debug("Deleting a Role");
            string rol = RoleDropDownList.Text;
            Roles.DeleteRole(rol);
            RoleDropDownList.DataSource = theUsersAndRolesBLL.GetAllRolesAndNone();
            RoleDropDownList.DataBind();
            SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageDeletedRole, rol));
        }
        catch (Exception exc)
        {
            log.Error("Cannot delete the Role : " + RoleDropDownList.Text + " because users exist in it. Function DeleteRolImageButton_Click from AssignRoles page", exc);
            SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageErrorDeletedRole, RoleDropDownList.Text));
        }
    }

    protected bool VerifyIfIsOnlyOneUserSelected(ListBox List)
    {
        int Cont = 0;
        int Result = 0;
        Cont = List.Items.Count;
        for (int i = 0; i < Cont; i++)
        {
            if (List.Items[i].Selected)
            {
                Result = Result + 1;
            }
        }
        if (Result == 1)
        {
            return true;
        }
        else
            return false;
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

    protected void InRoleListBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            OutRoleListBox.ClearSelection();
            if (VerifyIfIsOnlyOneUserSelected(InRoleListBox))
            {
                MembershipUser theUser;
                EmployeeRolePanel.Visible = true;
                gRolesForUser = Roles.GetRolesForUser(InRoleListBox.SelectedValue);
                FillCheckBoxesForRoles(gRolesForUser);
                theUser = Membership.GetUser(InRoleListBox.SelectedValue.ToString());
                UserLabel.Text = theUser.UserName.ToString();
                UserEmailLabel.Text = theUser.Email.ToString();

                if (theUser.UserName.Equals(HttpContext.Current.User.Identity.Name))
                {
                    foreach (ListItem item in UserRoleCheckBoxList.Items)
                        item.Enabled = false;

                    SaveRolesButton.Visible = false;
                    ResetRolesButton.Visible = false;
                    AddInImageButton.Enabled = false;
                    AddOutImageButton.Enabled = false;
                }
                else
                {
                    SaveRolesButton.Visible = true;
                    ResetRolesButton.Visible = (!LoginSecurity.IsUserAuthorizedPermission("RESET_USER_ACCOUNT"));
                    AddInImageButton.Enabled = true;
                    AddOutImageButton.Enabled = (RoleDropDownList.Text != Resources.SecurityData.NoneRoleItem && !string.IsNullOrEmpty(RoleDropDownList.Text));
                }
            }
            else
            {
                EmployeeRolePanel.Visible = false;
            }
        }
        catch (Exception q)
        {
            log.Error("Function InRoleListBox_SelectedIndexChanged from AssignRoles page", q);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorGetRoles);
        }
    }

    protected void OutRoleListBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            InRoleListBox.ClearSelection();
            if (VerifyIfIsOnlyOneUserSelected(OutRoleListBox))
            {
                MembershipUser theUser;
                EmployeeRolePanel.Visible = true;
                gRolesForUser = Roles.GetRolesForUser(OutRoleListBox.SelectedValue);
                FillCheckBoxesForRoles(gRolesForUser);

                theUser = Membership.GetUser(OutRoleListBox.SelectedValue.ToString());
                UserLabel.Text = theUser.UserName.ToString();
                UserEmailLabel.Text = theUser.Email.ToString();

                if (theUser.UserName.Equals(HttpContext.Current.User.Identity.Name))
                {
                    foreach (ListItem item in UserRoleCheckBoxList.Items)
                        item.Enabled = false;

                    SaveRolesButton.Visible = false;
                    ResetRolesButton.Visible = false;
                    AddInImageButton.Enabled = false;
                    AddOutImageButton.Enabled = false;
                }
                else
                {
                    SaveRolesButton.Visible = true;
                    ResetRolesButton.Visible = (!LoginSecurity.IsUserAuthorizedPermission("RESET_USER_ACCOUNT"));
                    AddInImageButton.Enabled = true;
                    AddOutImageButton.Enabled = true;
                }
            }
            else
            {
                EmployeeRolePanel.Visible = false;
            }
        }
        catch (Exception q)
        {
            log.Error("Function OutRoleListBox_SelectedIndexChanged from AssigRole page", q);
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageErrorGetRoles);
        }
    }

    protected string[] GetUserIDs(ListBox List)
    {
        int ContUsers = 0;
        string TotalStringList = "";
        String[] FinalTotalStringList;

        ContUsers = List.Items.Count;
        for (int i = 0; i < ContUsers; i++)
        {
            if (List.Items[i].Selected)
            {
                if (string.IsNullOrEmpty(TotalStringList))
                {
                    TotalStringList = (List.Items[i].Value).Trim();
                }
                else
                {
                    TotalStringList = TotalStringList + "," + (List.Items[i].Value).Trim();
                }
            }
        }
        if (TotalStringList != null && TotalStringList.Length > 0)
        {
            FinalTotalStringList = TotalStringList.Split(',');
        }
        else
        {
            FinalTotalStringList = null;
        }
        return FinalTotalStringList;
    }

    protected void AddOutImageButton_Click(object sender, EventArgs e)
    {
        string[] ListOfUsersToDeleteFromRol;
        ListOfUsersToDeleteFromRol = GetUserIDs(InRoleListBox);
        if (ListOfUsersToDeleteFromRol == null)
        {
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageUsersNoSelected);
            return;
        }
        string userType = "Normal";
        bool CanDeleteCurrentUserFromRole = true;
        CanDeleteCurrentUserFromRole =
            SecurityBLL.CanDeleteUserFromRole(ListOfUsersToDeleteFromRol, HttpContext.Current.User.Identity.Name, RoleDropDownList.SelectedValue, ref userType);
        if (CanDeleteCurrentUserFromRole)
        {
            if (ListOfUsersToDeleteFromRol != null && ListOfUsersToDeleteFromRol.Length > 0)
            {
                Roles.RemoveUsersFromRole(ListOfUsersToDeleteFromRol, RoleDropDownList.Text);
                foreach (String UserDeleted in ListOfUsersToDeleteFromRol)
                {
                    try
                    {
                        UserBLL.DeleteUserInRoles(UserDeleted, RoleDropDownList.Text);
                        log.Debug("El Usuario " + UserDeleted + " ha sido eliminado del Rol " + RoleDropDownList.Text + ".");
                        SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageDeletedRoleUser, UserDeleted, RoleDropDownList.Text));
                    }
                    catch
                    {
                        SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.SecurityData.MessageErrorDeleteRoleUser, UserDeleted, RoleDropDownList.Text));
                    }
                }
            }
            else
            {
                SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageNoUsersInList);
            }
        }
        else
        {
            if (userType == "Normal")
            {
                log.Error("No se puede eliminar el Usuario " + HttpContext.Current.User.Identity.Name + " del rol " + RoleDropDownList.SelectedValue + " porque es el útimo con privilegios administrativos");
                SystemMessages.DisplaySystemWarningMessage(string.Format(Resources.SecurityData.MessageWarningDeleteAdministrativeUser, HttpContext.Current.User.Identity.Name, RoleDropDownList.SelectedValue));
            }
            else if (userType == "Admin")
            {
                log.Error("No se puede eliminar el Usuario " + ConfigurationManager.AppSettings.Get("AdminUser") + " del Rol " + RoleDropDownList.SelectedValue + " porque es el útimo grupo con privilegios de administración y es el Administrador del Sistema");
                SystemMessages.DisplaySystemWarningMessage(string.Format(Resources.SecurityData.MessageWarningDeleteAdminUser, ConfigurationManager.AppSettings.Get("AdminUser"), RoleDropDownList.SelectedValue));
            }
        }
        BindData();
    }

    protected void AddInImageButton_Click(object sender, EventArgs e)
    {
        string[] ListOfUsersToAddToRol;
        ListOfUsersToAddToRol = GetUserIDs(OutRoleListBox);
        if (ListOfUsersToAddToRol != null && ListOfUsersToAddToRol.Length > 0)
        {
            if (RoleDropDownList.Text == Resources.SecurityData.NoneRoleItem)
            {
                foreach (String UserAdded in ListOfUsersToAddToRol)
                {
                    string[] AllRoles = Roles.GetAllRoles();
                    foreach (String Rol in AllRoles)
                    {
                        if (Roles.IsUserInRole(UserAdded, Rol))
                        {
                            bool CanDeleteCurrentUserFromRole = true;
                            string userType = "Normal";
                            CanDeleteCurrentUserFromRole = SecurityBLL.CanDeleteUserFromRole(ListOfUsersToAddToRol, HttpContext.Current.User.Identity.Name, Rol, ref userType);
                            if (CanDeleteCurrentUserFromRole)
                            {
                                Roles.RemoveUserFromRole(UserAdded, Rol);
                                UserBLL.DeleteUserInRoles(UserAdded, Rol);
                            }
                            else
                            {
                                log.Error("No se puede eliminar el Usuario " + HttpContext.Current.User.Identity.Name + " del rol " + RoleDropDownList.SelectedValue + " porque es el útimo con privilegios administrativos");
                                SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageWarningDeleteAdministrativeUser, HttpContext.Current.User.Identity.Name, RoleDropDownList.SelectedValue));
                            }
                        }
                    }
                }
            }
            else
            {
                Roles.AddUsersToRole(ListOfUsersToAddToRol, RoleDropDownList.Text);
                foreach (String UserAdded in ListOfUsersToAddToRol)
                {
                    UserBLL.InsertUserInRoles(UserAdded, RoleDropDownList.Text);
                    log.Debug("El Usuario " + UserAdded + " ha sido adicionado al Rol " + RoleDropDownList.Text + ".");
                    SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageUserRegisteredInRole, UserAdded, RoleDropDownList.Text));
                }
            }
        }
        else
        {
            SystemMessages.DisplaySystemMessage(Resources.SecurityData.MessageUsersNoSelected);
        }
        BindData();
    }

    protected void AddNewUserLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Security/CreateUser.aspx");
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
                            log.Debug("Removed User " + UserLabel.Text + " from Role " + RoleToDelete + ". Function SaveRolesImageButton_Click from AssignRoles page");
                            SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageDeletedRoleUser, UserLabel.Text, RoleToDelete));
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
                        log.Debug("Added User " + UserLabel.Text + " to Role " + RoleToInsert + ". Function SaveRolesImageButton_Click from AssignRoles page");
                        SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageUserRegisteredInRole, UserLabel.Text, RoleToInsert));
                    }
                }
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
                        log.Debug("Removed User " + UserLabel.Text + " from Role " + RoleToDelete + ". Function SaveRolesImageButton_Click from AssignRoles page");
                        SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageDeletedRoleUser, UserLabel.Text, RoleToDelete));
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
                        SystemMessages.DisplaySystemMessage(string.Format(Resources.SecurityData.MessageUserRegisteredInRole, UserLabel.Text, RoleToInsert));
                    }
                }
            }
        }
        BindData();
    }

    protected void ResetRolesButton_Click(object sender, EventArgs e)
    {
        string selectedName = "";
        if (VerifyIfIsOnlyOneUserSelected(OutRoleListBox))
            selectedName = OutRoleListBox.SelectedValue;
        if (VerifyIfIsOnlyOneUserSelected(InRoleListBox))
            selectedName = InRoleListBox.SelectedValue;

        if (selectedName != null && selectedName.Length > 0)
        {
            MembershipUser theUser;
            EmployeeRolePanel.Visible = true;
            gRolesForUser = Roles.GetRolesForUser(selectedName);
            FillCheckBoxesForRoles(gRolesForUser);
            theUser = Membership.GetUser(selectedName);
            UserLabel.Text = theUser.UserName.ToString();
            UserEmailLabel.Text = theUser.Email.ToString();
        }
    }

    protected void AddNewRoleLinkButton_Click(object sender, EventArgs e)
    {
        Session["NRPOSTBACKPAGE"] = "~/Security/AssignRoles.aspx";
        Response.Redirect("~/Security/NewRole.aspx");
    }

}