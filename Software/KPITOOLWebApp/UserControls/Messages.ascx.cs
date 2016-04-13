using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_Messages : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadMainMenuScript();
            LoadImages();
        }
    }
    private void LoadImages()
    {
        //MessagesImage.ImageUrl = "~/Images/Neutral/notifications.png";
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        bool? showMessages = (bool?)Session["SHOW_MESSAGE"];
        if (showMessages != null && (bool)showMessages)
        {
            ShowMessageHiddenField.Value = true.ToString();
            Session["SHOW_MESSAGE"] = false;
        }

        UpdateContent();
    }
    private void LoadMainMenuScript()
    {
        StringBuilder scriptText = new StringBuilder("<script src=\"");
        //scriptText.Append(ResolveClientUrl("~/Scripts/jquery.jgrowl.js"));
        scriptText.Append(ResolveClientUrl("~/Scripts/toastr.min.js"));
        scriptText.Append("\" type=\"text/javascript\"></script>\n");

        ltScript.Text = scriptText.ToString();
    }
    private void UpdateContent()
    {
        string title = Resources.Glossary.SystemMessagesTitle;
        int messageCount = 0;

        try
        {
            // Clear the older messages that won't show again.
            SystemMessages.ExpireOlderSystemMessages();

            // Get a list of user messages we should display
            SystemMessageList myList = new SystemMessageList();
            List<SystemMessage> theList = SystemMessages.GetPendingSystemMessages();
            //SystemMessagesTextBox.Text = "";
            bool firstMessage = true;

            // Construct the HTML representation of the list of errors.
            StringBuilder message = new StringBuilder();
            JavaScriptSerializer js = new JavaScriptSerializer();
            //foreach (SystemMessage element in theList)
            //{element.
            //    if (!firstMessage)
            //    {
            //        message.Append("!");
            //    }
            //    message.Append(Server.UrlEncode(element.ShortMessage).Replace("+", "%20"));
            //    firstMessage = false;
            //}

            //MessagesLiteral.Text = message.ToString();
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "showMessage", message.ToString(), true);
            MessageHiddenField.Value = js.Serialize(theList);// message.ToString();

            messageCount = theList.Count;
        }
        catch (Exception q)
        {
            log.Error("Failed to update system messages", q);
        }

        if (messageCount > 0)
        {
            MessagesNumberLiteral.Text = messageCount.ToString();
            /*       title = title + " [" + ResourceReplacement.ReplaceResourceWithParameters("Messages",
                 "SystemMessagesCountMessage", "Number", messageCount.ToString()) + "]";
                  TitleLabel.Text = title;
                  MSG_WebPanel.Visible = true;
             */
        }
        else
        {
            MessagesNumberLiteral.Text = "";
        }
    }
}