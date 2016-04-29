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

public partial class Security_EditUser : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (UsernameHiddenField.Value != null && UsernameHiddenField.Value.Length > 0)
            {
                GetUserDetails(UsernameHiddenField.Value.ToString());
            }
            else
            {
                Response.Redirect("~/Security/UserList.aspx");
            }
        }
    }

    private void ProcessSessionParameteres()
    {
        if (Session["USERID"] != null)
        {
            string initUserName = "";
            initUserName = (string)Session["USERID"];
            if (!string.IsNullOrEmpty(initUserName))
            {
                UsernameHiddenField.Value = initUserName;
            }
        }
        else
        {
            UsernameHiddenField.Value = HttpContext.Current.User.Identity.Name;
            MyAccountHiddenField.Value = "true";
        }
        Session["USERID"] = null;
    }

    protected void GetUserDetails(string UserName)
    {
        if (String.IsNullOrEmpty(UserName))
        {
            log.Error("Se recibió un usuario vació o nulo.");
            SystemMessages.DisplaySystemMessage("Se recibió un usuario vació o nulo.");
        }

        UsernameLabel.Text = "[ " + UserName + " ]";
        UsernameLabel.Enabled = false;
        MembershipUser MemUser = null;

        try
        {
            MemUser = Membership.GetUser(UserName);
        }
        catch (Exception q)
        {
            log.Error("Error al intentar obtener detalles del usuario " + UserName, q);
            SystemMessages.DisplaySystemMessage("Error al intentar obtener detalles del usuario: " + UserName + ".");
        }

        if (MemUser == null)
        {
            log.Error("No se pudo encontrar al usuario " + UserName + " en la lista de cuentas ASP.NET.");

            Session["ErrorMessage"] = "No se encontró el usuario indicado.";
            Response.Redirect("~/FatalError.aspx");
        }

        try
        {
            EmailTextBox.Text = MemUser.Email.ToString();
            EmailHiddenField.Value = EmailTextBox.Text;

            User theUser = UserBLL.GetUserByUsername(UserName);
            if (theUser != null)
            {
                NameTextBox.Text = theUser.FullName;
                AddressTextBox.Text = theUser.Address;
                CellPhoneTextBox.Text = theUser.CellPhone;
                CiudadAreaTextBox.Text = theUser.PhoneArea.ToString();
                NumeroTextBox.Text = theUser.PhoneNumber;
                PaisAreaTextBox.Text = theUser.PhoneCode.ToString();
                UserIdHiddenField.Value = theUser.UserId.ToString();
            }
        }
        catch (Exception q)
        {
            log.Error("Cannot get user data", q);
            SystemMessages.DisplaySystemMessage("Error al obtener los datos del usuario.");
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        bool sucess = false;
        string userName = UsernameHiddenField.Value;

        if (!Page.IsValid)
            return;

        try
        {
            if (EmailTextBox.Text != EmailHiddenField.Value)
            {
                string user = Membership.GetUserNameByEmail(EmailTextBox.Text);

                if (!String.IsNullOrEmpty(user) && !user.Equals(userName))
                {
                    SystemMessages.DisplaySystemErrorMessage("El correo electrónico ya está registrado para otro usuario.");
                    return;
                }

                MembershipUser theUser = null;
                theUser = Membership.GetUser(userName);

                if (theUser != null)
                {
                    theUser.Email = EmailTextBox.Text;
                    Membership.UpdateUser(theUser);
                }
                else
                {
                    SystemMessages.DisplaySystemMessage("No se pudo obtener información [ASPDB] del usuario:" + userName + ".");
                    return;
                }
            }

            sucess = true;
        }
        catch (Exception q)
        {
            log.Error("Cannot update user email in database", q);
            SystemMessages.DisplaySystemMessage("No se pudo modificar el correo electrónico del Usuario.");
        }

        if (sucess)
        {
            try
            {
                if (!UserBLL.UpdateUserRecord(Convert.ToInt32(UserIdHiddenField.Value),
                        userName,
                        NameTextBox.Text,
                        CellPhoneTextBox.Text,
                        AddressTextBox.Text,
                        NumeroTextBox.Text,
                        Convert.ToInt32(CiudadAreaTextBox.Text),
                        Convert.ToInt32(PaisAreaTextBox.Text),
                        EmailTextBox.Text))
                {
                    SystemMessages.DisplaySystemMessage("No se pudo modificar el Usuario " + userName + ".");
                }
                else
                {
                    SystemMessages.DisplaySystemMessage("Se modificó los datos del usuario satisfactoriamente.");
                }
            }
            catch (Exception q)
            {
                log.Error("Cannot update user information to database", q);
                SystemMessages.DisplaySystemMessage("No se pudo modificar el Usuario.");
            }
        }
        else
        {
            SystemMessages.DisplaySystemMessage("No se pudo modificar el Usuario " + userName + ".");
        }

        if (MyAccountHiddenField.Value.Equals("false"))
            Response.Redirect("~/Security/UserList.aspx");
        else
            Response.Redirect("~/MainPage.aspx");
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        if (MyAccountHiddenField.Value.Equals("false"))
            Response.Redirect("~/Security/UserList.aspx");
        else
            Response.Redirect("~/MainPage.aspx");
    }

}