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
            log.Error("Function UserObjectDataSource_Selected on page UserList.aspx", e.Exception);
            e.ExceptionHandled = true;
        }
    }

    protected void UserGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string userName = DataBinder.Eval(e.Row.DataItem, "UserName").ToString();
            if (userName.Equals(HttpContext.Current.User.Identity.Name))
            {
                LinkButton deleteImageButton = (LinkButton)e.Row.FindControl("DeleteImageButton");
                deleteImageButton.Visible = false;
            }
        }
    }

    protected void UserGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (UserGridView.SelectedDataKey == null)
        {
            return;
        }

        string userName = (string)UserGridView.SelectedDataKey.Value;
        if (string.IsNullOrEmpty(userName))
        {
            return;
        }

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
                    SystemMessages.DisplaySystemMessage("No se puede eliminar al usuario administrador.");
                    return;
                }

                Membership.DeleteUser(userName);

                User theUser = UserBLL.GetUserByUsername(userName);

                if (theUser != null)
                    UserBLL.DeleteUserRecord(theUser.UserId);

            }
            catch (Exception q)
            {
                log.Error("Error al eliminar el usuario: " + q.Message);
                SystemMessages.DisplaySystemMessage("Error al eliminar el usuario.");
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
                    SystemMessages.DisplaySystemMessage("Error al obtener al usuario: " + userName + " de ASPNETDB.");
                    return;
                }

                if (!theUser.IsLockedOut)
                {
                    SystemMessages.DisplaySystemMessage("El usuario: " + userName + " no se encuentra bloqueado.");
                    return;
                }

                theUser.UnlockUser();
                Membership.UpdateUser(theUser);
                SystemMessages.DisplaySystemMessage("El Usuario " + userName + " ha sido desbloqueado.");
                UserGridView.DataBind();
            }
            catch (Exception q)
            {
                log.Error("Error al desbloquer usuario.", q);
                SystemMessages.DisplaySystemMessage("Ocurrió un error al desbloquear el usuario.");
            }
        }
        else if (OperationHiddenField.Value == "RESET")
        {
            try
            {
                MembershipUser theUser = Membership.GetUser(userName);
                if (theUser == null)
                {
                    SystemMessages.DisplaySystemMessage("Error al obtener al usuario: " + userName + " de ASPNETDB.");
                    return;
                }

                string password = theUser.ResetPassword();
                if (!string.IsNullOrEmpty(password))
                {
                    string toMail = theUser.Email;

                    string link = HttpContext.Current.Request.Url.Scheme + "://" +
                                   HttpContext.Current.Request.Url.Authority +
                                   HttpContext.Current.Request.ApplicationPath + "/MainPage.aspx";

                    List<EmailFileParameter> theParams = new List<EmailFileParameter>();
                    theParams.Add(new EmailFileParameter("UserName", userName));
                    theParams.Add(new EmailFileParameter("Password", password));
                    theParams.Add(new EmailFileParameter("Link", link));

                    EmailUtilities.SendEmailFile(Resources.Files.ResetPassword,
                    "Contraseña restablecida", userName, toMail, theParams);

                    SystemMessages.DisplaySystemMessage("Se restableció la contraseña para el usuario: " + userName + " y fue enviada satisfactoriamente.");
                }
                else
                {
                    SystemMessages.DisplaySystemErrorMessage("No se pudo restablecer la contraseña del Usuario: " + userName);
                }
            }
            catch (Exception q)
            {
                log.Error("Error al restablecer la contraseña del usuario.", q);
                SystemMessages.DisplaySystemMessage("Ocurrió un error al restablecer la contraseña del usuario.");
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