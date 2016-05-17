using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_BasicContextualHelp : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public enum ModeOption
    {
        Dialog,
        Tooltip,
        Popover
    }

    public ModeOption Mode
    {
        set { ModeHiddenLabel.Text = value.ToString(); }
        get
        {
            ModeOption mode = ModeOption.Popover;
            try
            {
                mode = (ModeOption)Enum.Parse(typeof(ModeOption), ModeHiddenLabel.Text);
            }
            catch (Exception ex)
            {
                log.Error("Error converting ModeHiddenLabel.Text to ModeOption enum value", ex);
            }
            return mode;
        }
    }

    public string HelpText
    {
        set
        {
            HelpLink.Attributes["data-content"] = value;
            ContentLiteral.Text = value;
        }
        get { return ContentLiteral.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ModeOption currentMode = Mode;
        if (currentMode == ModeOption.Popover)
        {
            HelpLink.Attributes["data-toggle"] = "popover";
            HelpLink.Attributes["data-trigger"] = "focus";
            return;
        }

        if (currentMode == ModeOption.Tooltip)
        {
            HelpLink.Attributes["data-toggle"] = "tooltip";
            HelpLink.Attributes["title"] = ContentLiteral.Text;
            HelpLink.Attributes["data-placement"] = "rigth";
            return;
        }

        HelpLink.Attributes["data-toggle"] = "modal";
        HelpLink.Attributes["data-target"] = "#" + modal.ClientID;
        modal.Visible = true;
    }
}