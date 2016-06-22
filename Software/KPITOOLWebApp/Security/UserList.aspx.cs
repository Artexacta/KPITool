using Artexacta.App.Security.BLL;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Artexacta.App.User;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Utilities.Email;

public partial class Security_UserList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        UserSearchControl.Config = new UserSearch();
        UserSearchControl.OnSearch += new UserControls_SearchUserControl_SearchControl.OnSearchDelegate(UserSearchControl_OnSearch);
    }

    void UserSearchControl_OnSearch()
    {
        log.Debug("Binding GridView on Search");
    }

    protected void UserObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

    protected void UserGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.DataItem is User)
        {
            User theData = (User)e.Row.DataItem;

            if (theData.Username.Equals(HttpContext.Current.User.Identity.Name))
            {
                LinkButton deleteImageButton = (LinkButton)e.Row.FindControl("DeleteImageButton");
                deleteImageButton.Visible = false;
            }
        }
    }

    protected void UserGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (UserGridView.SelectedDataKey == null)
            return;

        string userName = (string)UserGridView.SelectedDataKey.Value;
        if (string.IsNullOrEmpty(userName))
            return;

        if (OperationHiddenField.Value == "EDIT")
        {
            Session["USERID"] = userName;
            Response.Redirect("~/Security/EditUser.aspx");
        }
        else if (OperationHiddenField.Value == "DELETE")
        {
            try
            {
                //Verificar que no sea el admin
                if (!SecurityBLL.CanDeleteUser(userName))
                {
                    SystemMessages.DisplaySystemMessage(Resources.UserData.MessageWarningDeleteAdmin);
                    return;
                }

                User theUser = UserBLL.GetUserByUsername(userName);
                UserBLL.DeleteUserRecord(theUser.UserId);
                Membership.DeleteUser(userName);
                SystemMessages.DisplaySystemMessage(Resources.UserData.MessageDeletedUser);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }

            UserGridView.DataBind();
        }
        else if (OperationHiddenField.Value == "BLOCK")
        {
            try
            {
                MembershipUser theUser = Membership.GetUser(userName);
                if (theUser == null)
                {
                    SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.UserData.MessageErrorGetMembership, userName));
                    return;
                }

                if (!theUser.IsLockedOut)
                {
                    SystemMessages.DisplaySystemWarningMessage(string.Format(Resources.UserData.MessageWarningUserUnlocked, userName));
                    return;
                }

                theUser.UnlockUser();
                Membership.UpdateUser(theUser);
                SystemMessages.DisplaySystemMessage(string.Format(Resources.UserData.MessageUnlockedUser, userName));
                UserGridView.DataBind();
            }
            catch (Exception exc)
            {
                log.Error("Error en UnlockUser para userName: " + userName, exc);
                SystemMessages.DisplaySystemMessage(string.Format(Resources.UserData.MessageErrorUnlockUser, userName));
            }
        }
        else if (OperationHiddenField.Value == "RESET")
        {
            try
            {
                MembershipUser theUser = Membership.GetUser(userName);
                if (theUser == null)
                {
                    SystemMessages.DisplaySystemMessage(string.Format(Resources.UserData.MessageErrorGetMembership, userName));
                    return;
                }

                string password = theUser.ResetPassword();
                if (!string.IsNullOrEmpty(password))
                {
                    string toMail = theUser.Email;
                    string link = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + 
                        HttpContext.Current.Request.ApplicationPath + "/MainPage.aspx";

                    List<EmailFileParameter> theParams = new List<EmailFileParameter>();
                    theParams.Add(new EmailFileParameter("UserName", userName));
                    theParams.Add(new EmailFileParameter("Password", password));
                    theParams.Add(new EmailFileParameter("Link", link));

                    EmailUtilities.SendEmailFile(Resources.Files.ResetPassword, Resources.UserData.SubjectResetPassword, userName, toMail, theParams);
                    SystemMessages.DisplaySystemMessage(string.Format(Resources.UserData.MessagePasswordReset, userName));
                }
                else
                {
                    SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.UserData.MessageWarningResetPassword, userName));
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en ResetPassword para userName: " + userName, exc);
                SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.UserData.MessageErrorResetPassword, userName));
            }
        }
    }

    protected void NewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Security/CreateUser.aspx");
    }

    protected void EditImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "EDIT";
    }

    protected void DeleteImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "DELETE";
    }

    protected void BlockImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "BLOCK";
    }

    protected void ResetImageButton_Click(object sender, EventArgs e)
    {
        OperationHiddenField.Value = "RESET";
    }

}