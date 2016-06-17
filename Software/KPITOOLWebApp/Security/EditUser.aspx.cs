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

    protected void GetUserDetails(string userName)
    {
        UsernameLabel.Text = "[ " + userName + " ]";
        UsernameLabel.Enabled = false;
        MembershipUser memUser = null;
        try
        {
            memUser = Membership.GetUser(userName);
        }
        catch (Exception q)
        {
            log.Error("Error en Membership.GetUser para userName: " + userName, q);
            SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.UserData.MessageErrorGetMembership, userName));
            Response.Redirect("~/Security/UserList.aspx");
        }

        if (memUser == null)
        {
            SystemMessages.DisplaySystemErrorMessage(string.Format(Resources.UserData.MessageErrorNoMembership, userName));
            Response.Redirect("~/Security/UserList.aspx");
        }

        try
        {
            EmailTextBox.Text = memUser.Email.ToString();
            EmailHiddenField.Value = EmailTextBox.Text;

            User theUser = UserBLL.GetUserByUsername(userName);
            if (theUser != null)
            {
                FullNameTextBox.Text = theUser.FullName;
                AddressTextBox.Text = theUser.Address;
                CellPhoneTextBox.Text = theUser.CellPhone;
                PaisAreaTextBox.Text = theUser.PhoneCode > 0 ? theUser.PhoneCode.ToString() : "";
                CiudadAreaTextBox.Text = theUser.PhoneArea > 0 ? theUser.PhoneArea.ToString() : "";
                NumeroTextBox.Text = theUser.PhoneNumber;
                UserIdHiddenField.Value = theUser.UserId.ToString();
            }
        }
        catch (Exception q)
        {
            log.Error("Error en GetUserByUsername para userName: " + userName, q);
            SystemMessages.DisplaySystemMessage(Resources.UserData.MessageErrorGetUser);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        bool sucess = false;
        string userName = UsernameHiddenField.Value;
        try
        {
            if (EmailTextBox.Text != EmailHiddenField.Value)
            {
                string user = Membership.GetUserNameByEmail(EmailTextBox.Text);
                if (!String.IsNullOrEmpty(user) && !user.Equals(userName))
                {
                    SystemMessages.DisplaySystemErrorMessage(Resources.UserData.ExistsEmailCustomValidator);
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
                    SystemMessages.DisplaySystemMessage(string.Format(Resources.UserData.MessageErrorGetMembership, userName));
                    return;
                }
            }

            sucess = true;
        }
        catch (Exception q)
        {
            log.Error("Error en UpdateUser para userId: " + UserIdHiddenField.Value, q);
            SystemMessages.DisplaySystemMessage(Resources.UserData.MessageErrorChangeEmail);
        }

        if (sucess)
        {
            if (!UserBLL.UpdateUserRecord(Convert.ToInt32(UserIdHiddenField.Value), 
                userName, 
                FullNameTextBox.Text,
                CellPhoneTextBox.Text,
                AddressTextBox.Text,
                NumeroTextBox.Text,
                !string.IsNullOrEmpty(CiudadAreaTextBox.Text) ? Convert.ToInt32(CiudadAreaTextBox.Text) : 0,
                !string.IsNullOrEmpty(PaisAreaTextBox.Text) ? Convert.ToInt32(PaisAreaTextBox.Text) : 0,
                EmailTextBox.Text))
            {
                SystemMessages.DisplaySystemErrorMessage(Resources.UserData.MessageErrorUpdateUser);
            }
            else
            {
                SystemMessages.DisplaySystemMessage(Resources.UserData.MessageUserUpdated);
            }
        }
        else
        {
            SystemMessages.DisplaySystemErrorMessage(Resources.UserData.MessageErrorUpdateUser);
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