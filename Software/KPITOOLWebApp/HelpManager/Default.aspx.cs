using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Globalization;
using log4net;
using Artexacta.App.ContextHelp;

public partial class ContextHelpManager_Default : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");
    #region Eventos
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        // Por cada idioma definido en el web.config, cargo una nueva columna al Grid
        foreach (string language in GetListOfSupportedLanguages())
        {
            ButtonField button = new ButtonField();
            button.CommandName = "language_" + language;
            button.ButtonType = ButtonType.Link;
            button.HeaderText = language;
            button.HeaderStyle.CssClass = "text-center";
            grdData.Columns.Add(button);
        }
    }

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // if the user is not authenticated then the Master Page will redirect 
        // him to the appropriata page.  Just return without doing anything 
        // and let the master page deal with this issue.
        if (!User.Identity.IsAuthenticated)
            return;

        try
        {
            if (!IsPostBack)
            {
                LoadSupportedLanguagesList();
                LoadContextHelpSystemConfiguration();
                LoadHelpFiles();
                SetLanguages();
                //fckData.BasePath = Request.ApplicationPath + ConfigurationManager.AppSettings["FCKEditorBasePath"];
                this.Session["FCKeditor:UserFilesPath"] = Request.ApplicationPath + ConfigurationManager.AppSettings["HelpFilesDirectory"];
                SetMessage(false);
            }
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    protected void btnNuevo_Click(object sender, EventArgs e)
    {
        this.ViewState["state"] = "new";
        SetLabelsConfiguration();
        // Limpio los campos
        txtNombre.Text = string.Empty;
        EditorHtml.Text = string.Empty;
        rbtLanguages.Items[0].Selected = true;
        // Configuro paneles y mensajes
        SetMessage(false);
        SetSearchPanel(false);
    }
    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        try
        {
            LoadHelpFiles();
            SetMessage(false);
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    protected void btnGuardar_Click(object sender, EventArgs e)
    {
        try
        {
            string fileName = null;
            if (ViewState["state"].ToString() == "new")
                fileName = txtNombre.Text + "_" + rbtLanguages.SelectedValue + "." + lblHelpFilesExtension.Text;
            else
                fileName = lblUFileName.Text;// +"_" + lblULanguage.Text + "." + lblHelpFilesExtension.Text;

            System.IO.StreamWriter streamWriter = new System.IO.StreamWriter(Server.MapPath(lblHelpFilesRoute.Text + "/" + fileName), false);
            streamWriter.Write(CodeHtmlTextBox.Text);
            streamWriter.Close();

            LoadHelpFiles();
            EditorHtml.Text = "";
            CodeHtmlTextBox.Text = "";
            SetMessage(GetGlobalResourceObject("ContextHelpManager", "save").ToString());
            SetSearchPanel(true);
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnSave").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnSave").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            string fileName = lblUFileName.Text + "_" + lblULanguage.Text + "." + lblHelpFilesExtension.Text;
            fileName = Server.MapPath(lblHelpFilesRoute.Text + "/" + fileName);
            if (System.IO.File.Exists(fileName))
            {
                System.IO.File.Delete(fileName);

                LoadHelpFiles();
                this.SetMessage(string.Format(GetGlobalResourceObject("ContextHelpManager", "delete").ToString(), lblUFileName.Text + "_" + lblULanguage.Text));
                SetSearchPanel(true);
            }
            else
                this.SetMessage(GetGlobalResourceObject("ContextHelpManager", "deleteError").ToString());
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnDelete").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnDelete").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    protected void btnCancelar_Click(object sender, EventArgs e)
    {
        try
        {
            LoadHelpFiles();
            SetMessage(false);
            SetSearchPanel(true);
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    protected void grdData_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdData.PageIndex = e.NewPageIndex;
        try
        {
            LoadHelpFiles();
            SetMessage(false);
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }

    protected void grdData_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        log.Info("Deleted all help files");
    }

    protected void grdData_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        LinkButton button = null;
        Label label = null;
        string fileName = string.Empty;
        if (e.Row.RowIndex < 0)
        {
            return;
        }
        label = e.Row.Cells[1].Controls[1] as Label;
        // Establesco pos en 3 dado que es la columna donde comienza la definición de idiomas
        int pos = 2;
        while (pos < grdData.Columns.Count)
        {
            e.Row.Cells[pos].HorizontalAlign = HorizontalAlign.Center;
            fileName = label.Text + "_" + grdData.Columns[pos].HeaderText + "." + lblHelpFilesExtension.Text;

            button = e.Row.Cells[pos].Controls[0] as LinkButton;
            if (button != null)
            {
                bool exists = ExistsFile(fileName);
                button.Text = exists ? "<i class='fa fa-check' aria-hidden='true'></i>" : "<i class='fa fa-exclamation-circle' aria-hidden='true'></i>";
                button.ForeColor = exists ? System.Drawing.ColorTranslator.FromHtml("#4CAF50") : System.Drawing.ColorTranslator.FromHtml("#FFC107");
                button.ToolTip = exists ? GetGlobalResourceObject("ContextHelpManager", "yesImage").ToString() : GetGlobalResourceObject("ContextHelpManager", "noImage").ToString();
            }
            pos++;
        }
    }
    protected void grdData_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            // Si el botón que se presionó en el Grid fue de una columna de Idioma
            if (e.CommandName.StartsWith("language_"))
            {
                // Parto el texto del comando para quedarme solo con el código de idioma
                string[] text = e.CommandName.Split('_');

                Label label = (Label)grdData.Rows[Convert.ToInt32(e.CommandArgument)].Cells[1].FindControl("lblNombre");
                string fileName = label.Text + "_" + text[1] + "." + lblHelpFilesExtension.Text;
                // Cargo los datos en los Labels y FckEditor
                LoadControlsData(fileName, text[1]);
                SetMessage(false);
                SetSearchPanel(false);
                // Establezco la configuracion de los labels y textBox                
                this.ViewState["state"] = "newUpdate";
                SetLabelsConfiguration();
            }
            // Si el botón que se presionó en el Grid fue el eliminar
            if (e.CommandName == "Delete")
            {
                string[] languages = GetListOfSupportedLanguages();
                foreach (string language in languages)
                {
                    string file = e.CommandArgument + "_" + language + "." + lblHelpFilesExtension.Text;
                    file = Server.MapPath(lblHelpFilesRoute.Text + "/" + file);
                    if (System.IO.File.Exists(file))
                        System.IO.File.Delete(file);
                }
                LoadHelpFiles();
                this.SetMessage(string.Format(GetGlobalResourceObject("ContextHelpManager", "deleteAll").ToString(), e.CommandArgument));
            }
        }
        catch (Exception x)
        {
            log.Error(GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString(), x);
            Session["ErrorMessage"] = GetGlobalResourceObject("ContextHelpManager", "errorOnLoad").ToString();
            Response.Redirect("~/MessageUser.aspx");
        }
    }
    #endregion
    #region Methods
    #region Métodos Load. 
    // Son métodos que cargan en los controles ASP.Net información de un origen de datos
    private void LoadHelpFiles()
    {
        try
        {
            grdData.DataSource = GetFiles();
            grdData.DataBind();
        }
        catch (Exception x)
        {
            throw x;
        }
    }
    private void LoadSupportedLanguagesList()
    {
        string[] list = GetListOfSupportedLanguages();
        rbtLanguages.DataSource = list;
        rbtLanguages.DataBind();
        rbtLanguages.Items[0].Selected = true;
    }
    private void LoadContextHelpSystemConfiguration()
    {
        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesRoute"]))
            lblHelpFilesRoute.Text = ConfigurationManager.AppSettings["HelpFilesRoute"];
        else
            lblHelpFilesRoute.Text = GetDefaultHelpFilesRoute();

        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpLanguages"]))
            lblHelpFilesLanguages.Text = ConfigurationManager.AppSettings["HelpLanguages"];
        else
            lblHelpFilesLanguages.Text = CultureInfo.CurrentCulture.ToString();

        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesExtension"]))
            lblHelpFilesExtension.Text = ConfigurationManager.AppSettings["HelpFilesExtension"];
        else
            lblHelpFilesExtension.Text = "htm";
    }
    public void LoadControlsData(string fileName, string language)
    {
        lblUFileName.Text = fileName;
        lblULanguage.Text = language;
        lblUType.Text = GetFileType(fileName).ToString();
        EditorHtml.Text = GetFileContent(fileName);
        //fckData.Content = GetFileContent(fileName + "_" + language + "." + lblHelpFilesExtension.Text);
    }
    #endregion
    #region Métodos Getters.
    // Son métodos encargados de recuperar información
    private string[] GetListOfSupportedLanguages()
    {
        string language = CultureInfo.CurrentCulture.ToString();

        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpLanguages"]))
            language = ConfigurationManager.AppSettings["HelpLanguages"];

        string[] separator = { " - " };
        return language.Split(separator, StringSplitOptions.RemoveEmptyEntries);
    }
    private string GetDefaultHelpFilesRoute()
    {
        return "~/HelpFiles";
    }
    private List<File> GetFiles()
    {
        List<File> helpFiles = new List<File>();
        string fileRoute = Server.MapPath(GetDefaultHelpFilesRoute());

        if (!System.IO.Directory.Exists(fileRoute))
            return helpFiles;

        string[] files = System.IO.Directory.GetFiles(fileRoute);
        foreach (string file in files)
        {
            string tempFile = System.IO.Path.GetFileName(file);
            File helpFile = new File();
            helpFile.FileName = SubstractFileInfo(tempFile, File.eType.File);
            helpFile.FieldName = SubstractFileInfo(tempFile, File.eType.Field);
            helpFile.Type = GetFileType(tempFile);
            helpFile.Asociatedlanguages.Add(SubstractFileLanguage(helpFile, tempFile));
            helpFile.ListOflanguages = GetListOfSupportedLanguages();

            // Evalúo las condiciones de búsqueda
            if (MatchConditions(helpFile))
            {
                bool insertItem = true;
                foreach (File item in helpFiles)
                {
                    if (item.FileName == helpFile.FileName && item.FieldName == helpFile.FieldName)
                    {
                        item.Asociatedlanguages.Add(SubstractFileLanguage(helpFile, tempFile));
                        insertItem = false;
                        break;
                    }
                }
                if (insertItem)
                    helpFiles.Add(helpFile);
            }
        }
        // Evalúo si hay que buscar los archivos que les falta idiomas y los recupero
        return GetFilesWithLanguagesConfiguration(helpFiles);
    }
    private File.eType GetFileType(string file)
    {
        string[] files = file.Split('_');
        if (files.Length > 1 && files.Length < 3)
            return File.eType.File;
        if (files.Length == 3)
            return File.eType.Field;
        return File.eType.Undefined;
    }
    public string GetFileType(object item)
    {
        File.eType type = (File.eType)DataBinder.Eval(item, "Type");
        switch (type)
        {
            case File.eType.File:
                return GetGlobalResourceObject("ContextHelpManager", "file").ToString();
            case File.eType.Field:
                return GetGlobalResourceObject("ContextHelpManager", "field").ToString();
            case File.eType.Undefined:
                return GetGlobalResourceObject("ContextHelpManager", "undefined").ToString();
            default:
                return string.Empty;
        }
    }
    public string GetFileContent(string file)
    {
        System.IO.StreamReader streamReader = null;
        try
        {
            if (System.IO.File.Exists(Server.MapPath(lblHelpFilesRoute.Text + "/" + file)))
            {
                streamReader = new System.IO.StreamReader(Server.MapPath(lblHelpFilesRoute.Text + "/" + file));
                this.ViewState["state"] = "update";
                return streamReader.ReadToEnd();
            }
            else
            {
                this.ViewState["state"] = "new";
                return string.Empty;
            }
        }
        catch (Exception x)
        {
            throw x;
        }
        finally
        {
            if (streamReader != null)
                streamReader.Close();
        }

    }
    public string GetFileName(object item)
    {
        File.eType itemType = (File.eType)DataBinder.Eval(item, "Type");
        switch (itemType)
        {
            case File.eType.File:
                return DataBinder.Eval(item, "FileName").ToString();
            case File.eType.Field:
                return DataBinder.Eval(item, "FileName").ToString() + "_" + DataBinder.Eval(item, "FieldName").ToString();
            default:
                return DataBinder.Eval(item, "FileName").ToString();
        }
    }
    #endregion

    #region Métodos Setters.
    // Son métodos que cargan en los controles ASP.Net información constante
    private void SetLabelsConfiguration()
    {
        if (this.ViewState["state"].ToString() == "new")
        {
            lblUFileName.Visible = false;
            lblULanguage.Visible = false;
            txtNombre.Visible = true;
            rbtLanguages.Visible = true;
            lblUType.Text = string.Empty;
            txtNombre.Focus();
        }
        else
        {
            lblUFileName.Visible = true;
            lblULanguage.Visible = true;
            txtNombre.Visible = false;
            rbtLanguages.Visible = false;
            txtFileName.Focus();
        }
    }
    private void SetSearchPanel(bool state)
    {
        pnlSearch.Visible = state;
        pnlDML.Visible = !state;
        //btnNuevo.Visible = state;
    }
    private void SetMessage(string text)
    {
        pnlInfo.Visible = true;
        lblInfo.Text = text;
    }
    private void SetMessage(bool state)
    {
        pnlInfo.Visible = state;
        lblInfo.Text = string.Empty;
    }
    private void SetLanguages()
    {
        FieldPerPageLiteral.Text = GetGlobalResourceObject("ContextHelpManager", "chkCampos_pagina").ToString();
        GeneralFieldLiteral.Text = GetGlobalResourceObject("ContextHelpManager", "chkCampos_generales").ToString();

        PagesLiteral.Text = GetGlobalResourceObject("ContextHelpManager", "rbtTypesOfFiles_pagina").ToString();
        FieldsLiteral.Text = GetGlobalResourceObject("ContextHelpManager", "rbtTypesOfFiles_campos").ToString();
    }
    #endregion
    private bool ExistsFile(string file)
    {
        string fileRoute = Server.MapPath(lblHelpFilesRoute.Text);
        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["HelpFilesRoute"]))
            fileRoute = Server.MapPath(ConfigurationManager.AppSettings["HelpFilesRoute"]);

        fileRoute += file;
        bool exists = System.IO.File.Exists(fileRoute);
        if (!exists)
            log.Warn("The Contextual Help File " + fileRoute + " does not exists.");

        return exists;
    }
    private bool MatchConditions(File file)
    {
        if (!file.FileName.ToLower().Contains(txtFileName.Text.ToLower()) && !file.FieldName.ToLower().Contains(txtFileName.Text.ToLower()))
            return false;

        if (!ChkPages.Checked)
            if (file.Type == File.eType.File)
                return false;

        if (!ChkFields.Checked)
            if (file.Type == File.eType.Field)
                return false;

        if (!ChkFieldPerPage.Checked && file.Type == File.eType.Field)
            if (file.FileName.ToLower() != "general")
                return false;

        if (!ChkGeneralField.Checked && file.Type == File.eType.Field)
            if (file.FileName.ToLower() == "general")
                return false;

        return true;
    }
    private List<File> GetFilesWithLanguagesConfiguration(List<File> files)
    {
        if (!chkWithOutLanguages.Checked)
            return files;

        List<File> list = new List<File>();
        int numberOfLangs = GetListOfSupportedLanguages().Length;
        foreach (File file in files)
        {
            if (file.Asociatedlanguages.Count != numberOfLangs)
                list.Add(file);
        }
        return list;
    }
    private string SubstractFileLanguage(File file, string fileName)
    {
        string[] parts = fileName.Split('_');

        switch (file.Type)
        {
            case File.eType.File:
                {
                    string[] lang = parts[1].Split('.');
                    if (lang.Length > 1)
                        return lang[0];
                    return string.Empty;
                }
            case File.eType.Field:
                {
                    string[] lang = parts[2].Split('.');
                    if (lang.Length > 1)
                        return lang[0];
                    return string.Empty;
                }
            case File.eType.Undefined:
                return string.Empty;
            default:
                return string.Empty;
        }
    }
    private string SubstractFileInfo(string file, File.eType type)
    {
        string[] parts = file.Split('_');

        switch (type)
        {
            case File.eType.File:
                {
                    if (parts.Length > 1)
                        return parts[0];
                    return string.Empty;
                }
            case File.eType.Field:
                {
                    if (parts.Length > 2)
                        return parts[1];
                    return string.Empty;
                }
            default:
                return string.Empty;
        }
    }
    #endregion
}