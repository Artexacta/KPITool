using Artexacta.App.Configuration;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Authentication_RecoverPassword : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void PasswordRecovery1_SendingMail(object sender, MailMessageEventArgs e)
    {
        e.Message.From = new System.Net.Mail.MailAddress(
            Configuration.GetReturnEmailAddress(), Configuration.GetReturnEmailName());
        e.Message.Subject = Resources.Glossary.PasswordRecoverySubject;
        e.Message.IsBodyHtml = true;
    }

    protected void PasswordRecovery1_SendMailError(object sender, SendMailErrorEventArgs e)
    {
        log.Error("Unable to send new password to user " + PasswordRecovery1.UserName);
        e.Handled = true;

        Session["ErrorMessage"] = "No se pudo enviar la nueva contraseña al usuario. Error " + e.Exception.Message;
        Response.Redirect("~/FatalError.aspx");
    }

    protected void PasswordRecovery1_VerifyingUser(object sender, LoginCancelEventArgs e)
    {
        MembershipUser theUser = Membership.GetUser(PasswordRecovery1.UserName);

        try
        {
            if (theUser.IsLockedOut)
            {
                DateTime fiveMinutesBefore = DateTime.Now.Subtract(new TimeSpan(0, 5, 0));
                if (theUser.LastLockoutDate > fiveMinutesBefore)
                {
                    log.Debug("User " + PasswordRecovery1.UserName + " is locked");
                    Response.Redirect("~/Authentication/UserIsLocked.aspx");
                }
                else
                {
                    log.Debug("User " + PasswordRecovery1.UserName + " is unlocking");
                    theUser.UnlockUser();
                    Response.Redirect("~/Authentication/UserIsUnlocked.aspx");
                }
                return;
            }
        }
        catch (Exception q)
        {
            log.Debug("User do not exists" + q.Message);
        }
    }

}