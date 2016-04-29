using log4net;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;

namespace Artexacta.App.Utilities.Email
{
    /// <summary>
    /// Summary description for EmailUtilities
    /// </summary>
    public class EmailUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public EmailUtilities()
        {
        }

        public static void SmtpClient_OnCompleted(object sender, AsyncCompletedEventArgs e)
        {
            MailMessage mail = (MailMessage)e.UserState;
            string subject = mail.Subject;

            if (e.Cancelled)
            {
                string cancelled = string.Format("[{0}] Send canceled.", subject);
                log.Warn("The email ssend was cancelled: " + cancelled);
            }
            if (e.Error != null)
            {
                string error = String.Format("[{0}] {1}", subject, e.Error.ToString());
                log.Error("Error sending email " + error);
            }
            else
            {
                log.Debug("Message sent: " + subject);
            }
            // mail Sent true;
        }

        /// <summary>
        /// Send an email message.
        /// </summary>
        /// <param name="to">The recipients address</param>
        /// <param name="from">Who is the message from</param>
        /// <param name="subject">The message subject</param>
        /// <param name="message">The email text (in HTML format)</param>
        static public void SendEmail(string to, string from, string subject, string message)
        {
            //Obtener el mail para enviar la copia oculta
            string emailBCC = "";

            try
            {
                emailBCC = ConfigurationManager.AppSettings.Get("emailCopyClient");
            }
            catch (Exception q)
            {
                log.Error("Error al obtener el email de copia oculta.", q);
            }

            System.Net.Mail.MailMessage emailMessage = new System.Net.Mail.MailMessage();
            emailMessage.From = new System.Net.Mail.MailAddress(from, Artexacta.App.Configuration.Configuration.GetReturnEmailName());
            emailMessage.IsBodyHtml = true;
            emailMessage.Subject = subject;
            emailMessage.To.Add(to);

            if (!string.IsNullOrEmpty(emailBCC))
                emailMessage.Bcc.Add(emailBCC);

            string logoMessage = "";
            try
            {
                //Path to save the image
                //string appPath = HttpContext.Current.Request.PhysicalApplicationPath;
                string appPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
                string file = appPath + "Images\\logo.png";
                LinkedResource logo = new LinkedResource(file);
                logo.ContentId = "companylogo";
                int imageHeight = 62;
                int imageWidth = 72;

                logoMessage = logoMessage + "<table>";
                logoMessage = logoMessage + "<tr>";
                logoMessage = logoMessage + "<td><img src=\"cid:companylogo" + "\"";
                logoMessage = logoMessage + " width=\"" + imageWidth.ToString();
                logoMessage = logoMessage + "\"";
                logoMessage = logoMessage + " height=\"" + imageHeight.ToString();
                logoMessage = logoMessage + "\"></td>";
                logoMessage = logoMessage + "</tr>";
                logoMessage = logoMessage + "</table>";
                logoMessage = logoMessage + "<br />";

                AlternateView av1 = AlternateView.CreateAlternateViewFromString(logoMessage + message, null, MediaTypeNames.Text.Html);
                av1.LinkedResources.Add(logo);

                emailMessage.AlternateViews.Add(av1);
                emailMessage.IsBodyHtml = true;
            }
            catch (Exception q)
            {
                emailMessage.Body = message;
                log.Warn("Failed to add logo to email", q);
            }

            try
            {
                //Deal with accents in subject
                emailMessage.Subject = HttpUtility.HtmlDecode(emailMessage.Subject);

                //Normalizing body in UTF8 encode
                emailMessage.BodyEncoding = System.Text.Encoding.UTF8;
                emailMessage.Body = emailMessage.Body.Normalize();

                //Sending Email
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.SendCompleted += new SendCompletedEventHandler(SmtpClient_OnCompleted);
                smtp.Send(emailMessage);
            }
            catch (Exception q)
            {
                log.Error("No se pudo enviar el email", q);
            }
        }

        /// <summary>
        /// Send an email message.
        /// </summary>
        /// <param name="to">The recipients address</param>
        /// <param name="subject">The message subject</param>
        /// <param name="message">The email text (in HTML format)</param>
        static public void SendEmail(string to, string subject, string message)
        {
            string from = ConfigurationManager.AppSettings.Get("SenderEmailAddress");
            SendEmail(to, from, subject, message);
        }

        /// <summary>
        /// Send email to the system administrator
        /// </summary>
        /// <param name="message"></param>
        /// <param name="subject"></param>
        public static void SendEmailToAdministrator(string message, string subject)
        {
            string admMail = "";

            try
            {
                admMail = System.Configuration.ConfigurationManager.AppSettings.Get("AdminEmailAddress");
                SendEmail(admMail, admMail, subject, message);
            }
            catch (Exception q)
            {
                log.Error("Cannot send email to administrator", q);
            }
        }

        /// <summary>
        /// Send an email message from a file template
        /// </summary>
        /// <param name="filePath">The application relative path for the email template</param>
        /// <param name="subject">The subject for the email message</param>
        /// <param name="toName">The name of the person we will send the message to</param>
        /// <param name="toEmail">The email address of the person we will send the message to</param>
        /// <param name="parameters">The substitution parameters for the email template</param>
        public static void SendEmailFile(string filePath, string subject, string toName, string toEmail,
            List<EmailFileParameter> parameters)
        {
            if (string.IsNullOrEmpty(filePath))
            {
                log.Error("Empty file path in call to SendEmailPath");
                return;
            }
            if (string.IsNullOrEmpty(subject))
            {
                log.Error("Empty subject in call to SendEmailPath");
                return;
            }
            if (string.IsNullOrEmpty(toName))
            {
                log.Error("Empty To Name in call to SendEmailPath for filePath: " + filePath + " and subject: " + subject);
                return;
            }
            if (string.IsNullOrEmpty(toEmail))
            {
                log.Error("Empty To Email in call to SendEmailPath");
                return;
            }
            if (parameters == null)
            {
                log.Error("Null parameters in call to SendEmailPath");
                return;
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Attempting to send an email message. Paramters are as follows:");
                log.Debug("Paramter File: " + filePath);
                log.Debug("To Name: " + toName);
                log.Debug("To Email: " + toEmail);
                log.Debug("Subject: " + subject);
                log.Debug("Number of substitution parameters: " + parameters.Count.ToString());
                foreach (EmailFileParameter theParam in parameters)
                {
                    log.Debug("Parameter " + theParam.ParameterName + " = " + theParam.ParameterSubstitutionInHTML);
                }
            }

            string textToSend = "";
            string baseDirectory = "";
            // Read the file to send
            try
            {
                baseDirectory = AppDomain.CurrentDomain.BaseDirectory.ToString();
                if (!string.IsNullOrEmpty(baseDirectory))
                {
                    baseDirectory = baseDirectory + filePath;
                }
                using (TextReader streamReader = new StreamReader(baseDirectory))
                {
                    textToSend = streamReader.ReadToEnd();
                }

                if (log.IsDebugEnabled)
                {
                    log.Debug("Read file " + baseDirectory);
                }
            }
            catch (Exception q)
            {
                log.Error("Failed to read file to mail form path " + baseDirectory, q);
            }

            textToSend = textToSend.Trim();
            if (textToSend.Length <= 0)
            {
                log.Warn("Empty text file to send or file does not exist: " + filePath);
                return;
            }

            // Now for every substitution parameter, perform the substitution
            foreach (EmailFileParameter theParameter in parameters)
            {
                textToSend = textToSend.Replace("{" + theParameter.ParameterName + "}", theParameter.ParameterSubstitutionInHTML);
                if (log.IsDebugEnabled)
                {
                    log.Debug("Replaced parameter " + theParameter.ParameterName + " in text to send by email");
                }
            }

            log.Debug("Finished replacing paramters ");

            // Now try to send the email
            try
            {
                SendEmail(toEmail, subject, textToSend);
                log.Debug("Done sending emails.  No aparent problems");
            }
            catch (Exception q)
            {
                log.Warn("Failed to send email message", q);
            }
        }

        /// <summary>
        /// Send an email message from a file template with attached files
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="subject"></param>
        /// <param name="toName"></param>
        /// <param name="toEmail"></param>
        /// <param name="parameters"></param>
        /// <param name="theAttachedList"></param>
        public static void SendEmailAttachedFiles(string filePath, string subject, string toName, string toEmail,
            List<EmailFileParameter> parameters, List<System.Net.Mail.Attachment> theAttachedList)
        {
            if (string.IsNullOrEmpty(filePath))
            {
                log.Error("Empty file path in call to SendEmailPath");
                return;
            }
            if (string.IsNullOrEmpty(subject))
            {
                log.Error("Empty subject in call to SendEmailPath");
                return;
            }
            if (string.IsNullOrEmpty(toName))
            {
                log.Error("Empty To Name in call to SendEmailPath for filePath: " + filePath + " and subject: " + subject);
                return;
            }
            if (string.IsNullOrEmpty(toEmail))
            {
                log.Error("Empty To Email in call to SendEmailPath");
                return;
            }
            if (parameters == null)
            {
                log.Error("Null parameters in call to SendEmailPath");
                return;
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Attempting to send an email message. Paramters are as follows:");
                log.Debug("Paramter File: " + filePath);
                log.Debug("To Name: " + toName);
                log.Debug("To Email: " + toEmail);
                log.Debug("Subject: " + subject);
                log.Debug("Number of substitution parameters: " + parameters.Count.ToString());
                foreach (EmailFileParameter theParam in parameters)
                {
                    log.Debug("Parameter " + theParam.ParameterName + " = " + theParam.ParameterSubstitutionInHTML);
                }
            }

            string textToSend = "";
            string baseDirectory = "";
            // Read the file to send
            try
            {
                baseDirectory = AppDomain.CurrentDomain.BaseDirectory.ToString();
                if (!string.IsNullOrEmpty(baseDirectory))
                {
                    baseDirectory = baseDirectory + filePath;
                }
                using (TextReader streamReader = new StreamReader(baseDirectory))
                {
                    textToSend = streamReader.ReadToEnd();
                }

                if (log.IsDebugEnabled)
                {
                    log.Debug("Read file " + baseDirectory);
                }
            }
            catch (Exception q)
            {
                log.Error("Failed to read file to mail form path " + baseDirectory, q);
            }

            textToSend = textToSend.Trim();
            if (textToSend.Length <= 0)
            {
                log.Warn("Empty text file to send or file does not exist: " + filePath);
                return;
            }

            // Now for every substitution parameter, perform the substitution
            foreach (EmailFileParameter theParameter in parameters)
            {
                textToSend = textToSend.Replace("{" + theParameter.ParameterName + "}", theParameter.ParameterSubstitutionInHTML);
                if (log.IsDebugEnabled)
                {
                    log.Debug("Replaced parameter " + theParameter.ParameterName + " in text to send by email");
                }
            }

            log.Debug("Finished replacing paramters ");

            // Now try to send the email
            try
            {
                string from = ConfigurationManager.AppSettings.Get("AdminEmailAddress");
                //Obtener el mail para enviar la copia oculta
                string emailBCC = "";
                try
                {
                    emailBCC = ConfigurationManager.AppSettings.Get("emailCopyClient");
                }
                catch (Exception q)
                {
                    log.Error("Error al obtener el email de copia oculta.", q);
                }

                System.Net.Mail.MailMessage emailMessage = new System.Net.Mail.MailMessage();
                emailMessage.From = new System.Net.Mail.MailAddress(from, Artexacta.App.Configuration.Configuration.GetReturnEmailName());
                emailMessage.IsBodyHtml = true;
                emailMessage.Subject = subject;
                emailMessage.To.Add(toEmail);

                if (!string.IsNullOrEmpty(emailBCC))
                    emailMessage.Bcc.Add(emailBCC);

                string logoMessage = "";
                try
                {
                    //Path to save the image
                    //string appPath = HttpContext.Current.Request.PhysicalApplicationPath;
                    string appPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
                    string file = appPath + "Images\\logo.png";
                    LinkedResource logo = new LinkedResource(file);
                    logo.ContentId = "companylogo";
                    int imageHeight = 62;
                    int imageWidth = 72;

                    logoMessage = logoMessage + "<table>";
                    logoMessage = logoMessage + "<tr>";
                    logoMessage = logoMessage + "<td><img src=\"cid:companylogo" + "\"";
                    logoMessage = logoMessage + " width=\"" + imageWidth.ToString();
                    logoMessage = logoMessage + "\"";
                    logoMessage = logoMessage + " height=\"" + imageHeight.ToString();
                    logoMessage = logoMessage + "\"></td>";
                    logoMessage = logoMessage + "</tr>";
                    logoMessage = logoMessage + "</table>";
                    logoMessage = logoMessage + "<br />";

                    AlternateView av1 = AlternateView.CreateAlternateViewFromString(logoMessage + textToSend, null, MediaTypeNames.Text.Html);
                    av1.LinkedResources.Add(logo);

                    emailMessage.AlternateViews.Add(av1);
                    emailMessage.IsBodyHtml = true;
                }
                catch (Exception q)
                {
                    emailMessage.Body = textToSend;
                    log.Warn("Failed to add logo to email", q);
                }

                try
                {
                    //Deal with accents in subject
                    emailMessage.Subject = HttpUtility.HtmlDecode(emailMessage.Subject);

                    //Normalizing body in UTF8 encode
                    emailMessage.BodyEncoding = System.Text.Encoding.UTF8;
                    emailMessage.Body = emailMessage.Body.Normalize();

                    //attached files
                    foreach (System.Net.Mail.Attachment att in theAttachedList)
                    {
                        emailMessage.Attachments.Add(att);
                    }

                    //Sending Email
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                    smtp.SendCompleted += new SendCompletedEventHandler(SmtpClient_OnCompleted);
                    smtp.Send(emailMessage);
                }
                catch (Exception q)
                {
                    log.Error("No se pudo enviar el email", q);
                }

                log.Debug("Done sending emails.  No aparent problems");
            }
            catch (Exception q)
            {
                log.Warn("Failed to send email message", q);
            }
        }

    }
}