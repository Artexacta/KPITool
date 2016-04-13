using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

[Themeable(true)]
public partial class UserControls_ContextualHelp : System.Web.UI.UserControl
{
    #region Enums
    public enum eTypeOfLink
    {
        Text,
        Image
    }
    public enum eMode
    {
        Ajax,
        Window
    }
    #endregion

    #region Properties
    [Bindable(true), Category("Appearance"), DefaultValue(eTypeOfLink.Text)]
    public eTypeOfLink TypeOfLink
    {
        get
        {
            if (ViewState["typeOfLink"] == null)
                ViewState["typeOfLink"] = eTypeOfLink.Text;
            return (eTypeOfLink)ViewState["typeOfLink"];
        }
        set { ViewState["typeOfLink"] = value; }
    }
    /// <summary>
    /// Set or Get the image used to display the Contextual Help
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("~/Images/Help.png")]
    public string IconUrlLink
    {
        get
        {
            if (ViewState["iconUrlLink"] == null)
                ViewState["iconUrlLink"] = "~/Images/Help.png";
            return ViewState["iconUrlLink"].ToString();
        }
        set { ViewState["iconUrlLink"] = value; }
    }
    /// <summary>
    /// Set or Get the text used to display the Contextual Help
    /// </summary>
    [Bindable(true), Category("Appearance"), DefaultValue("Help")]
    public string TextLink
    {
        get
        {
            if (ViewState["textLink"] == null)
                ViewState["textLink"] = "Help";
            return ViewState["textLink"].ToString();
        }
        set { ViewState["textLink"] = value; }
    }

    /// <summary>
    /// Set or Get the relative path to the Contextual Help files
    /// </summary>
    [Bindable(true), Category("Files"), DefaultValue("~/Help")]
    public string FilesRoute
    {
        get
        {
            if (ViewState["filesRoute"] == null)
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesRoute"]))
                    ViewState["filesRoute"] = "~/Help";
                else
                    ViewState["filesRoute"] = ConfigurationManager.AppSettings["HelpFilesRoute"];
            }
            return ViewState["filesRoute"].ToString();
        }
        set { ViewState["filesRoute"] = value; }
    }
    /// <summary>
    /// Set or Get the file name of the Contextual Help file
    /// </summary>
    [Bindable(true), Category("Files"), DefaultValue("General")]
    public string FileName
    {
        get
        {
            if (ViewState["fileName"] == null)
                ViewState["fileName"] = "General";
            return ViewState["fileName"].ToString();
        }
        set { ViewState["fileName"] = value; }
    }
    /// <summary>
    /// Set or Get the field name of the control used to retrieve the Contextual Help 
    /// </summary>
    [Bindable(true), Category("Files"), DefaultValue("")]
    public string Field
    {
        get
        {
            if (ViewState["field"] == null)
                ViewState["field"] = string.Empty;
            return ViewState["field"].ToString();
        }
        set { ViewState["field"] = value; }
    }
    /// <summary>
    /// Set or Get the file extension used to retrieve the Contextual Help files
    /// </summary>
    [Bindable(true), Category("Files"), DefaultValue("html")]
    public string FilesExtension
    {
        get
        {
            if (ViewState["filesExtension"] == null)
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesExtension"]))
                    ViewState["filesExtension"] = "html";
                else
                    ViewState["filesExtension"] = ConfigurationManager.AppSettings["HelpFilesExtension"];
            }
            return ViewState["filesExtension"].ToString();
        }
        set { ViewState["filesExtension"] = value; }
    }
    /// <summary>
    /// Set or Get the language culture used to retrieve the Contextual Help files
    /// If language is not set in the control or in the web.config. The control retrieves the language from the Current Culture
    /// </summary>
    [Bindable(true), Category("Settings"), DefaultValue("")]
    public string Language
    {
        get
        {
            if (ViewState["language"] == null)
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesLanguage"]))
                    ViewState["language"] = CultureInfo.CurrentCulture.ToString();
                else
                    ViewState["language"] = ConfigurationManager.AppSettings["HelpFilesLanguage"];
            }
            return ViewState["language"].ToString();
        }
        set { ViewState["language"] = value; }
    }
    /// <summary>
    /// Set or Get the languages soported by the application
    /// This field has to be defined in the appSettings of the web.config
    /// This field is used in the Administration Process of the Contextual Help
    /// </summary>
    [Bindable(true), Category("Settings"), DefaultValue("Actual language of the site")]
    public string HelpLanguages
    {
        get
        {
            if (ViewState["helpLanguages"] == null)
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpLanguages"]))
                    ViewState["helpLanguages"] = Language;
                else
                    ViewState["helpLanguages"] = ConfigurationManager.AppSettings["HelpLanguages"];
            }
            return ViewState["helpLanguages"].ToString();
        }
    }
    /// <summary>
    /// Set or Get the PopUp width
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue(400)]
    public int Width
    {
        get
        {
            if (ViewState["width"] == null)
                ViewState["width"] = "0";

            int width = Convert.ToInt32(ViewState["width"]);
            if (width <= 0)
                width = 400;
            return width;
        }
        set { ViewState["width"] = value; }
    }
    /// <summary>
    /// Set or Get the PopUp height
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue(300)]
    public int Height
    {
        get
        {
            if (ViewState["height"] == null)
                ViewState["height"] = "0";

            int height = Convert.ToInt32(ViewState["height"]);
            if (height <= 0)
                height = 300;
            return height;
        }
        set { ViewState["height"] = value; }
    }
    /// <summary>
    /// Set or Get the PopUp close text
    /// </summary>
    [Bindable(true), Category("Appearance"), DefaultValue("Close")]
    public string CloseText
    {
        get
        {
            if (ViewState["closeText"] == null)
                ViewState["closeText"] = Resources.ContextHelpManager.Close;
            return ViewState["closeText"].ToString();
        }
        set { ViewState["closeText"] = value; }
    }
    /// <summary>
    /// Set or Get the mode how the PopUp will appear
    /// </summary>
    [Bindable(true), Category("Appearance"), DefaultValue(eMode.Ajax)]
    public eMode Mode
    {
        get
        {
            if (ViewState["mode"] == null)
                ViewState["mode"] = eMode.Ajax;
            return (eMode)ViewState["mode"];
        }
        set { ViewState["mode"] = value; }
    }
    /// <summary>
    /// Set or Get the css Class used by the Ajax PopUp
    /// </summary>
    [Bindable(true), Themeable(true), Category("Ajax CSS"), DefaultValue("CHelpMainCss")]
    public string CssMainClass
    {
        get
        {
            if (ViewState["cssMainClass"] == null)
                ViewState["cssMainClass"] = "CHelpMainCss";
            return ViewState["cssMainClass"].ToString();
        }
        set { ViewState["cssMainClass"] = value; }
    }
    /// <summary>
    /// Set or Get the css Class used by the mask of the Ajax PopUp
    /// </summary>
    [Bindable(true), Themeable(true), Category("Ajax CSS"), DefaultValue("CHelpMaskCss")]
    public string CssMaskClass
    {
        get
        {
            if (ViewState["cssMaskClass"] == null)
                ViewState["cssMaskClass"] = "CHelpMaskCss";
            return ViewState["cssMaskClass"].ToString();
        }
        set { ViewState["cssMaskClass"] = value; }
    }
    /// <summary>
    /// Set or Get the default Message to show if the Context Help File does not exists in the Server.
    /// </summary>
    [Bindable(true), Category("Settings"), DefaultValue("The contextual help file selected does not exist.")]
    public string DefaultMessage
    {
        get
        {
            if (ViewState["defaultMessage"] == null)
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpDefaultMessage_" + Language]))
                    ViewState["defaultMessage"] = "The contextual help file selected does not exist.";
                else
                    ViewState["defaultMessage"] = ConfigurationManager.AppSettings["HelpDefaultMessage_" + Language];
            }
            return ViewState["defaultMessage"].ToString();
        }
        set { ViewState["defaultMessage"] = value; }
    }
    #endregion

    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (FileExists())
        {
            this.ltlLink.Text = RegisterPopUpLink();
            this.ltlHelpFile.Text = GetContextualHelpFile();
        }
        else
            this.ltlHelpFile.Text = DefaultMessage;
        BuildMainCss();
    }

    private void BuildMainCss()
    {
        StringBuilder styleMain = new StringBuilder("<style type='text/css'>\n");
        styleMain.Append(".CHelpMainCss_" + this.ID + "\n");
        styleMain.Append("{\n");
        styleMain.Append("  width:" + this.Width + "px;\n");
        styleMain.Append("  height:" + (this.Height + 15) + "px;\n");
        styleMain.Append("  position: fixed;\n");
        styleMain.Append("}\n");
        styleMain.Append("</style>\n");

        //MainCssStyleLabel.Text = styleMain.ToString();
    }
    #endregion

    #region Methods
    /// <summary>
    /// Get the link used to display the modal PopUp
    /// </summary>
    /// <returns>The link [image or text]</returns>
    private string RegisterPopUpLink()
    {
        string popUpLink = string.Empty;
        switch (Mode)
        {
            case eMode.Ajax:
                {
                    popUpLink = string.Format("<a class='miniHelp' style='float:right;' {0} id='modal_{1}'>", "data-toggle='modal' data-target='#" + this.ID + "'", this.ID);
                    break;
                }
            case eMode.Window:
                {
                    popUpLink = string.Format("<a class='miniHelp' {0} id='modal_{1}' href='#this'>", "onclick='RunWindowsPopUp()'", this.ID);
                    break;
                }
            default:
                {
                    popUpLink = string.Format("<a class='miniHelp' {0} id='modal_{1}'>", "href='#CHelpDialog_" + this.ID + "'" + this.ID);
                    break;
                }
        }
        return string.Format("{0}{1}</a>", popUpLink, GeneratePopUpLink());
    }
    /// <summary>
    /// Get the image used to display the modal PopUp
    /// </summary>
    /// <returns>The image</returns>
    private string GeneratePopUpLink()
    {
        switch (TypeOfLink)
        {
            case eTypeOfLink.Image:
                return "";//string.Format("<img border='0' src='{0}' alt='{1}' title='{1}' />", GetApplicationPath(IconUrlLink), TextLink);
            case eTypeOfLink.Text:
                return TextLink;
            default:
                return TextLink;
        }
    }
    /// <summary>
    /// Get the contextual help information
    /// Uses the GetAjaxPopUp or GetWindowPopUp methods
    /// </summary>
    /// <returns>The contextual help file information</returns>
    private string GetContextualHelpFile()
    {
        // Recupero el nombre completo del archivo de ayuda contextual.
        string theFile = this.GetApplicationPath(GetTheCompleteContextHelpFileNameAndRelativeRoute());
        // Define cuantos pixeles se le va a quitar de ancho y de alto al iFrame o windowsPopUp para que cuadre bien en el ModalPopUp (DIV).
        int sizeFactor = 10;

        // retorno el PopUp en el formato deseado
        switch (Mode)
        {
            case eMode.Ajax:
                return GetAjaxPopUp(theFile, sizeFactor);
            case eMode.Window:
                return GetWindowPopUp(theFile, sizeFactor);
            default:
                return GetAjaxPopUp(theFile, sizeFactor);
        }
    }
    /// <summary>
    /// Get the contextual help information in ajax format
    /// </summary>
    /// <param name="theFile">The contextual help file</param>
    /// <param name="sizeFactor">The size of the ajax box</param>
    /// <returns>The contextual help information in ajax format</returns>
    private string GetAjaxPopUp(string theFile, int sizeFactor)
    {
        // Formo el tag para el IFrame
        string iFrameTag = string.Format("<iframe allowtransparency='true' src='{0}' width='{1}' height='{2}' frameborder='0'></iframe>", theFile, Width - sizeFactor, Height - sizeFactor);

        // Formo el modalPopUp incorporandole como contenido el iFrame
        /*string ajaxScript = string.Format(@"
                <div id='CHelpDialog_{3}' class='{0} {0}_{3}'>
                    <div class='frame'>
                        <div class='columnHead'>
                            <span class='title'>{4}</span>
                            <a href='#CHelpDialog_{3}' id='closeBox_{3}' name='closeBox' class='commands'>{2}</a>
                        </div>
                        <div class='columnContent'>
                        {1}
                        <div class='clear'></div>
                        </div>
                    </div>       
                </div>         
        ", CssMainClass, iFrameTag, CloseText, this.ID, Resources.ContextHelpManager.AyudaLabel);*/
        string ajaxScript = string.Format(@"
                <div class='modal inmodal' id='{0}' tabindex='-1' role='dialog' aria-hidden='true'>
                    <div class='modal-dialog'>
                        <div class='modal-content '>
                            <div class='modal-header'>
                                <button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>
                                <h4 class='modal-title'>{1}</h4>
                            </div>
                            <div class='modal-body'>
                                <iframe src='{2}' height='{3}'></iframe>
                            </div>
                        </div> 
                    </div> 
                </div> 
        ", this.ID, Resources.ContextHelpManager.AyudaLabel, theFile, Height - sizeFactor);
        return ajaxScript;
    }
    /// <summary>
    /// Get the contextual help information in windows format
    /// </summary>
    /// <param name="theFile">The contextual help file</param>
    /// <param name="sizeFactor">The size of the ajax box</param>
    /// <returns>The contextual help information in windows format</returns>
    private string GetWindowPopUp(string theFile, int sizeFactor)
    {
        string windowScript = string.Format(@"
            <script language='javascript' type='text/javascript'>
                function RunWindowsPopUp()
                {{
                    var winH = $(window).height();
                    var winW = $(window).width();
                    winH = (winH / 2) - ({2} / 2);
                    winW = (winW / 2) - ({1} / 2);
                    newwindow = window.open(""{0}"", ""name"", ""width={1},height={2}, left="" + winW + "", top="" + winH + """");
                    if (window.focus) 
                        newwindow.focus(); 
                }}
            </script>", theFile, Width - sizeFactor, Height - sizeFactor);
        return windowScript;
    }


    /// <summary>
    /// Get the complete address for the Contextual help file
    /// </summary>
    /// <returns>The address to the file</returns>
    private string GetTheCompleteContextHelpFileNameAndRelativeRoute()
    {
        string temporalField = string.Empty;
        // Si se quiere recuperar un archivo de ayuda para un "Campo", procedo a darle el formato.
        if (!string.IsNullOrEmpty(Field))
            temporalField = "_" + Field;

        // Concateno todas las variables que necesito para acceder a mi archivo de ayuda contextual
        return string.Format("{0}/{1}{2}_{3}.{4}", FilesRoute, FileName, temporalField, Language, FilesExtension);
    }
    /// <summary>
    /// Checks if the route to the contextual help files exists in the server
    /// </summary>
    /// <returns>True if the route exists. False otherwise</returns>
    private bool FileExists()
    {
        if (!System.IO.Directory.Exists(Server.MapPath(FilesRoute)))
            return false;

        bool exists = System.IO.File.Exists(Server.MapPath(GetTheCompleteContextHelpFileNameAndRelativeRoute()));
        if (!exists)
        {
            Language = GetFirstLevelLenguageID();
            return System.IO.File.Exists(Server.MapPath(GetTheCompleteContextHelpFileNameAndRelativeRoute()));
        }
        return exists;
    }
    /// <summary>
    /// Gets the first level language identification
    /// </summary>
    /// <returns>The first level language ID</returns>
    private string GetFirstLevelLenguageID()
    {
        string[] lang = Language.Split('-');
        if (lang.Length <= 1)
            return Language;

        return lang[0];
    }
    /// <summary>
    /// Gets the application path
    /// </summary>
    /// <returns>The application path</returns>    
    private string GetApplicationPath(string file)
    {
        return Page.ResolveUrl(file);
    }
    #endregion

}