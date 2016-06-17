using Artexacta.App.Utilities;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
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

    public enum SourceTypeOption
    {
        Resource,
        HelpFile
    }

    public SourceTypeOption SourceType
    {
        set
        {
            SourceTypeHiddenField.Value = value.ToString();
        }
        get
        {
            SourceTypeOption option = SourceTypeOption.Resource;
            try
            {
                option = (SourceTypeOption)Enum.Parse(typeof(SourceTypeOption), SourceTypeHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error trying to convert SourceTypeHiddenField.Value to enum value", ex);
            }
            return option;
        }
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

    public string HelpSourceFile
    {
        set
        {
            HelpFileHiddenField.Value = value;
        }
        get { return HelpFileHiddenField.Value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (SourceType == SourceTypeOption.HelpFile)
        {
            setContentFromFile();
        }

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


    private void setContentFromFile()
    {
        string helpText = "";
        System.IO.StreamReader streamReader = null;
        try
        {
            string directory = ConfigurationManager.AppSettings["HelpFilesRoute"];
            string extension = ConfigurationManager.AppSettings["HelpFilesExtension"];
            if (!string.IsNullOrEmpty(directory) && !directory.EndsWith("/"))
                directory += "/";
            if (!string.IsNullOrEmpty(extension) && !extension.StartsWith("."))
                extension = "." + extension;

            string language = LanguageUtilities.GetLanguageFromContext();
            string helpSourceFile = HelpSourceFile;

            string file = Server.MapPath(directory + helpSourceFile + "_" + language + extension);
            if (System.IO.File.Exists(file))
            {
                streamReader = new System.IO.StreamReader(file);
                helpText = streamReader.ReadToEnd();
            }
            else
            {
                helpText = "";
            }

            HelpFileIdLiteral.Text += " <small><span class='label label-default'>" + helpSourceFile + "</span></small>";
            HelpLink.Attributes["title"] = HelpLink.Attributes["title"] + " [" + helpSourceFile + "]";
        }
        catch (Exception x)
        {
            log.Error("Error loading content from help file", x);
        }
        finally
        {
            if (streamReader != null)
                streamReader.Close();
        }
        ContentLiteral.Text = helpText;
    }
}