using Artexacta.App.Configuration;
using Artexacta.App.Utilities.Email;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Authentication_ResetearContrasena : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        string emailAddress = EmailTextBox.Text;

        string userName = Membership.GetUserNameByEmail(emailAddress);
        if (String.IsNullOrEmpty(userName))
        {
            // This should not have happened.
            //log.Error("Failed to find the specified email address in our system: " + emailAddress);
            ErrorLabel.Text = Resources.LoginGlossary.MensajeUsuarioNoEncontrado;
            ErrorLabel.ForeColor = System.Drawing.Color.Red;
            return;
        }

        string newPass = "";
        try
        {
            MembershipUser user = Membership.GetUser(userName, false);
            if (user == null)
            {
                ErrorLabel.Text = Resources.LoginGlossary.MensajeUsuarioNoEncontrado;
                ErrorLabel.ForeColor = System.Drawing.Color.Red;
                return;
            }

            user.IsApproved = true;
            newPass = user.ResetPassword();

            if (string.IsNullOrEmpty(newPass))
            {
                log.Error("No se genero la nueva contraseña.");
                ErrorLabel.Text = Resources.LoginGlossary.MensajeErrorContraseñaVacia;
                ErrorLabel.ForeColor = System.Drawing.Color.Red;
                return;
            }

            Membership.UpdateUser(user);
        }
        catch
        {
            ErrorLabel.Text = "No se pudo cambiar la constraseña del usuario. Comuníquese con el Administrador del Sistema.";
            ErrorLabel.ForeColor = System.Drawing.Color.Red;
            return;
        }

        StringBuilder mailText = new StringBuilder();
        try
        {
            // Ok.  Get the template for the email
            string emailFile = HttpContext.Current.Server.MapPath(Resources.Files.NewPasswordFileLocation);
            using (System.IO.StreamReader sr = System.IO.File.OpenText(emailFile))
            {
                string s = "";
                while ((s = sr.ReadLine()) != null)
                {
                    mailText.Append(s);
                }
            }
        }
        catch
        {
            ErrorLabel.Text = Resources.LoginGlossary.MensajeNoEnvioMail;
            ErrorLabel.ForeColor = System.Drawing.Color.Red;
            return;
        }

        mailText.Replace("{UserName}", userName);
        mailText.Replace("{Password}", newPass);

        try
        {
            EmailUtilities.SendEmail(emailAddress, Configuration.GetConfirmationPasswordSubject(), mailText.ToString());
        }
        catch (Exception q)
        {
            //log.Error("Failed to send email with validation code for user " + userName, q);
            ErrorLabel.Text = Resources.LoginGlossary.MensajeNoEnvioMail + ": " + q.Message; ;
            ErrorLabel.ForeColor = System.Drawing.Color.Red;
            return;
        }

        ErrorLabel.Text = Resources.LoginGlossary.MensajeEnvioMail;
        ErrorLabel.ForeColor = System.Drawing.Color.Black;

        Response.Redirect("~/Authentication/ConfirmarReseteo.aspx");
    }

    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = false;

        string userName = Membership.GetUserNameByEmail(EmailTextBox.Text);

        if (!String.IsNullOrEmpty(userName))
        {
            // Verify that the user is not valid
            MembershipUser muser = Membership.GetUser(userName);
            if (muser != null)
            {
                args.IsValid = true;
            }
        }
    }

}