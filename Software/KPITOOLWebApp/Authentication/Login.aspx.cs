using Artexacta.App.User.BLL;
using Artexacta.MSCRRHH.Utilities.Bitacora;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Authentication_Login : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    private static Artexacta.MSCRRHH.Utilities.Bitacora.Bitacora theBitacora = new Bitacora();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/MainPage.aspx", true);
        }
    }

    protected override void InitializeCulture()
    {
        base.InitializeCulture();
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        
    }

    protected void Login1_LoggingIn(object sender, LoginCancelEventArgs e)
    {
        // If the user that is authenticating is not approved, then we need to re-direct
        // him to the page where he/she can confirm the user
        MembershipUser theUser = Membership.GetUser(Login1.UserName);

        if (theUser == null)
            return;

        if (!theUser.IsApproved)
        {
            // The user needs to be approved, but if there is no confirmation code then 
            // there is no point asking the user to confirm the user.

            if (String.IsNullOrEmpty(Profile.GetProfile(theUser.UserName).AccountValidationCode))
            {
                log.Warn("User loged in correctly, but is not approved and does not have a validation code. " +
                    "Assuming user was disabled manually by administrator");
                e.Cancel = true;

                Response.Redirect("~/Authentication/AccountDisabled.aspx");
            }
        }
        if (theUser.IsLockedOut)
        {
            DateTime fiveMinutesBefore = DateTime.Now.Subtract(new TimeSpan(0, 5, 0));
            if (theUser.LastLockoutDate > fiveMinutesBefore)
            {
                log.Debug("User " + Login1.UserName + " is locked");
                Response.Redirect("~/Authentication/UserIsLocked.aspx");
            }
            else
            {
                log.Debug("User " + Login1.UserName + " is unlocking");
                theUser.UnlockUser();
                Response.Redirect("~/Authentication/UserIsUnlocked.aspx");
            }
        }
    }

    protected void Login1_LoggedIn(object sender, EventArgs e)
    {
        // Now that the user has been authenticated, see if we need to 
        // redirect the user to some page.
        int userId = 0;

        try
        {
            userId = UserBLL.GetUserIdByUsername(Login1.UserName);
        }
        catch (Exception q)
        {
            log.Error("Cannot determine the User Id", q);
            Session["ErrorMessage"] = Resources.LoginGlossary.UserIdErrorMessage;
            FormsAuthentication.SignOut();
            Response.Redirect("~/FatalError.aspx");
        }

        if (userId <= 0)
        {
            log.Error("Cannot determine the User Id");
            Session["ErrorMessage"] = Resources.LoginGlossary.UserIdErrorMessage;
            FormsAuthentication.SignOut();
            Response.Redirect("~/FatalError.aspx");
        }


        string loggedOutUser = (string)Session["LoggedOutUser"];
        Session["LoggedOutUser"] = null;

        if (!string.IsNullOrEmpty(loggedOutUser))
        {
            if (Login1.UserName != loggedOutUser)
            {
                Response.Redirect("~/MainPage.aspx");
                return;
            }
        }

        string page = (string)Session["RequestPage"];
        Session["RequestPage"] = null;
        if (!String.IsNullOrEmpty(page))
        {
            Response.Redirect(page);
        }
        else
        {
            theBitacora.RecordTrace(Bitacora.TraceType.UserLogin, Login1.UserName, "Seguridad", userId.ToString(), "Inicio de sesión de usuario " + Login1.UserName);
            Response.Redirect("~/MainPage.aspx");
        }
    }

    protected void Login1_LoginError(object sender, EventArgs e)
    {
        // Simply log the failed attempt.
        log.Warn("Failed login attempt for user " + Login1.UserName);
    }

    protected void RecoverLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Authentication/ResetearContrasena.aspx");
    }

}