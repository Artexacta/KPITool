using Artexacta.App.SavedSearch;
using Artexacta.App.SavedSearch.BLL;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using SearchComponent;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

[Themeable(true)]
public partial class UserControls_SearchUserControl_SearchControl : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    private string _title;
    private ConfigColumns _config;
    private string _advancedSearchForm;
    private string _sql = " 1 = 1";
    private bool _expressionOk = false;
    private int _expressionErrorInColumn = -1;
    private bool _displayHelp;
    private bool _displayContextualHelp;
    private string _imageErrorUrl = "";
    private string _imageHelpUrl = "";
    private bool _savedSearches = false;
    private string _tooltip = "";

    #region Properties
    /// <summary>
    /// The name of the user control to load in the advanced search panel
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue("")]
    public string AdvancedSearchForm
    {
        get { return _advancedSearchForm; }
        set { _advancedSearchForm = value; }
    }

    [Bindable(true), Category("Search"), DefaultValue("")]
    public string AdvancedSearchUrl
    {
        get { return AdvancedSearchUrlHiddenField.Value; }
        set { AdvancedSearchUrlHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the search control
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSearch
    {
        get { return CssSearchHiddenField.Value; }
        set { CssSearchHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the help panel of the search control
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSearchHelp
    {
        get { return CssSearchHelpHiddenField.Value; }
        set { CssSearchHelpHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the advanced search form
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSearchAdvanced
    {
        get { return CssSearchAdvancedHiddenField.Value; }
        set { CssSearchAdvancedHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the advanced search form
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSearchError
    {
        get { return CssSearchErrorHiddenField.Value; }
        set { CssSearchErrorHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the advanced search form
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSavedSearch
    {
        get { return CssSavedSearchesHiddenField.Value; }
        set { CssSavedSearchesHiddenField.Value = value; }
    }

    /// <summary>
    /// The name of the class family for the styles of the advanced search form
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string CssSearchTools
    {
        get { return CssSearchToolsHiddenField.Value; }
        set { CssSearchToolsHiddenField.Value = value; }
    }

    /// <summary>
    /// Wheether the expression complies with the grammar or not
    /// </summary>
    public bool ExpressionOk
    {
        get { return _expressionOk; }
    }

    /// <summary>
    /// Wheether the help is displayed or not
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public bool DisplayHelp
    {
        get { return _displayHelp; }
        set { _displayHelp = value; }
    }

    /// <summary>
    /// Wheether the help is displayed or not
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public bool DisplayContextualHelp
    {
        get { return _displayContextualHelp; }
        set { _displayContextualHelp = value; }
    }

    /// <summary>
    /// Gets or sets the Image that will be displayed when the query does not comply with grammar
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string ImageErrorUrl
    {
        get { return _imageErrorUrl; }
        set { _imageErrorUrl = value; }
    }

    /// <summary>
    /// Gets or sets the Image that will be displayed to load the help
    /// </summary>
    [Bindable(true), Themeable(true), Category("Appearance"), DefaultValue("")]
    public string ImageHelpUrl
    {
        get { return _imageHelpUrl; }
        set { _imageHelpUrl = value; }
    }

    /// <summary>
    /// by default the search contains the identity query
    /// </summary>
    public string Sql
    {
        get
        {
            BuildSql();
            return _sql;
        }
    }

    /// <summary>
    /// Whether the control displays the saved searches option
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue(false)]
    public bool SavedSearches
    {
        get { return _savedSearches; }
        set { _savedSearches = value; }
    }

    /// <summary>
    /// The ID to be used when saving the search query 
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue("")]
    public string SavedSearchesID
    {
        get { return SavedSearchesIDHidden.Value; }
        set { SavedSearchesIDHidden.Value = value; }
    }

    /// <summary>
    /// by default the search contains the identity query
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue("")]
    public string Title
    {
        get { return _title; }
        set { _title = value; }
    }

    /// <summary>
    /// by default the search contains the identity query
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue(true)]
    public bool CommandsList
    {
        get { return btnSearchTools.Visible; }
        set { btnSearchTools.Visible = value; }
    }

    /// <summary>
    /// The scenario configuration
    /// </summary>
    public ConfigColumns Config
    {
        get { return _config; }
        set { _config = value; }
    }

    /// <summary>
    /// The query this control will load first.
    /// </summary>
    [Bindable(true), Category("Search"), DefaultValue("")]
    public string Query
    {
        get { return txtSearch.Text; }
        set
        {
            txtSearch.Text = value;
            OnSearch();
        }
    }

    /// <summary>
    /// Gets or sets the Image that will be displayed when the query does not comply with grammar
    /// </summary>
    [Category("Appearance"), DefaultValue("")]
    public string Tooltip
    {
        get { return _tooltip; }
        set { _tooltip = value; }
    }
    #endregion

    public delegate void OnSearchDelegate();

    public event OnSearchDelegate OnSearch;

    protected void Page_Load(object sender, EventArgs e)
    {
        ShowTitle();
        ShowSavedSearches();
        ShowAdvancedSearchLink();
        ShowHelp();
        ShowContextualHelp();
        ShowCommandsList();

        LoadCssClass();
        LoadImages();
        UserIdHiddenField.Value = this.GetUserId.ToString();
    }

    private void ShowCommandsList()
    {
        StringBuilder content = new StringBuilder();

        content.Append("<ul id=\"searchTools\">\n");
        foreach (Column col in this._config.Cols)
        {
            if (!col.DisplayHelp)
                continue;
            content.Append("\t<li>\n");
            content.Append("<a href=\"javascript:fijarLlave('" + col.SearchKey + "');\"><b>@" + col.SearchKey + "</b>: ");
            string contextHelp = GetColumnContextHelp(col);
            if (!string.IsNullOrEmpty(col.Description))
            {
                contextHelp = col.Description + "<br />(" + contextHelp + ")";
            }
            else
            {
                contextHelp = "(" + contextHelp + ")";
            }
            content.Append(contextHelp);
            content.Append("</a></li>\n");
        }
        content.Append("</ul>\n");

        CommandsListLabel.Text = content.ToString();
    }

    private void ShowSavedSearches()
    {
        btnSavedSearches.Visible = SavedSearches;
    }

    private void LoadImages()
    {
        imgNotValidExpression.ImageUrl = _imageErrorUrl;
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        ShowError();
    }

    private void ShowError()
    {
        string query = txtSearch.Text.Trim();
        imgNotValidExpression.Visible =
            (!_expressionOk &&
             !string.IsNullOrEmpty(query));

        if (_expressionErrorInColumn < 0) return;

        log.Debug((_expressionOk ? "NOT s" : "S") + "howing the error panel");

        lblErrorText.Text =
            Resources.SearchControl.lblErrorText_Text.Replace("[NBCOL]",
                _expressionErrorInColumn.ToString());

        int fromIndex = _expressionErrorInColumn > 10 ? _expressionErrorInColumn - 10 : 0;
        int length = _expressionErrorInColumn - fromIndex;
        string first = query.Substring(fromIndex, length);
        lblErrorText.Text += "\n<p><span class=\"ErrorPanelOkText\">" +
            (fromIndex > 0 ? "..." : "") + first + "</span>";
        fromIndex = fromIndex + length;
        length = _expressionErrorInColumn + 10 > query.Length ? query.Length - fromIndex : 10;
        string second = query.Substring(fromIndex, length);
        lblErrorText.Text += "<span class=\"ErrorPanelWrongText\">" +
            second + (length == 10 ? "..." : "") + "</span></p>";
    }

    private void LoadCssClass()
    {
        CSearch.CssClass = CssSearch;
        CSearchHelpPanel.CssClass = CssSearchHelp;
        CSearch_Advanced_Panel.CssClass = CssSearchAdvanced;
        CSearchErrorPanel.CssClass = CssSearchError;
        CSearch_SavedSearches_Panel.CssClass = CssSavedSearch;
        CSearch_SearchTools_Panel.CssClass = CssSearchTools;
    }

    private void ShowContextualHelp()
    {
        chSearch.Visible = _displayContextualHelp;
        chSearch.IconUrlLink = _imageHelpUrl;
    }

    private void ShowHelp()
    {
        if (_displayHelp)
        {
            BuildHelpContent();
        }
    }

    private void BuildHelpContent()
    {
        string scriptHover = "$(\"#" + txtSearch.ClientID + "\").hover(" +
            "function() {" +
            "    var helpW = $(\"#" + CSearchHelpPanel.ClientID + "\").width();" +
            "    var helpH = $(\"#" + CSearchHelpPanel.ClientID + "\").height();" +

            "    var position = $(this).position();" +
            "    var thisHeight = $(this).height();" +
            "    $(\"#" + CSearchHelpPanel.ClientID + "\").css('top', position.top + thisHeight + 5);" +
            "    $(\"#" + CSearchHelpPanel.ClientID + "\").css('left', position.left);" +
            "    $(\"#" + CSearchHelpPanel.ClientID + "\").show();" +
            "}," +
            "function() {" +
            "    $(\"#" + CSearchHelpPanel.ClientID + "\").hide();" +
            "});";

        //ScriptManager.RegisterStartupScript(Page, this.GetType(), "Help_" + txtSearch.ClientID, scriptHover, true);

        StringBuilder content = new StringBuilder();

        content.Append("<table cellpadding='4' cellspacing='4' border='0'>\n");
        foreach (Column col in this._config.Cols)
        {
            if (!col.DisplayHelp)
                continue;
            content.Append("\t<tr>\n");
            content.Append("\t\t<td><b>@" + col.SearchKey + "</b></td>\n");
            string contextHelp = GetColumnContextHelp(col);
            if (!string.IsNullOrEmpty(col.Description))
            {
                contextHelp = col.Description + "<br />" + contextHelp;
            }
            content.Append("\t\t<td>" + contextHelp + "</td>\n");
            content.Append("\t</tr>\n");
        }
        content.Append("</table>\n");

        //lblHelpContent.Text = content.ToString();
    }

    public string GetColumnContextHelp(Column col)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(col.ContextHelp);
        sb.Replace("[Numeric]", Resources.SearchControl.columnContextHelp_Numeric);
        sb.Replace("[Fts]", Resources.SearchControl.columnContextHelp_Fts);
        sb.Replace("[String]", Resources.SearchControl.columnContextHelp_String);
        sb.Replace("[Boolean]", Resources.SearchControl.columnContextHelp_Boolean);
        sb.Replace("[Date]", Resources.SearchControl.columnContextHelp_Date);
        sb.Replace("[GLOBAL]", Resources.SearchControl.columnContextHelp_Global);
        sb.Replace("[NOT_GLOBAL]", Resources.SearchControl.columnContextHelp_NotGlobal);

        return sb.ToString();
    }

    private void ShowTitle()
    {
        if (string.IsNullOrEmpty(_title))
        {
            lblSearchTitle.Visible = false;
            return;
        }
        lblSearchTitle.Text = _title;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (_config == null)
        {
            log.Error("Called the search component without configuration");
            return;
        }

        log.Info("Searched for: " + txtSearch.Text);
        //BuildSql();
        OnSearch();
    }

    private void BuildSql()
    {
        Searcher srch = new Searcher(this._config);
        srch.Query = txtSearch.Text.Trim();

        int nbCol = -1;
        _expressionOk = srch.ExpressionOk(ref nbCol);
        _expressionErrorInColumn = nbCol;

        log.Debug("Expression: [" + srch.Query + "] is " + _expressionOk.ToString());
        _sql = srch.SqlQuery();
    }

    #region Advanced Search methods
    private void ShowAdvancedSearchLink()
    {
        if (string.IsNullOrEmpty(_advancedSearchForm) &&
            string.IsNullOrEmpty(AdvancedSearchUrl))
        {
            DontShowAdvancedSearch();
            return;
        }

        if (!string.IsNullOrEmpty(_advancedSearchForm) &&
            !string.IsNullOrEmpty(AdvancedSearchUrl))
        {
            log.Error("Only choose one of the forms for thee advanced search, Url or Form");
            DontShowAdvancedSearch();
            return;
        }

        if (!string.IsNullOrEmpty(_advancedSearchForm))
        {
            try
            {
                UserControl ctlAdvancedForm = (UserControl)LoadControl(_advancedSearchForm);
                plhldAdvancedSearchForm.Controls.Add(ctlAdvancedForm);
                log.Debug("Showing advanced search because '" + _advancedSearchForm + " is ok");
                btnAdvancedSearch.Visible = true;

                LinkjQueryFunctionalityToAdvancedSearchLink();
            }
            catch (Exception err)
            {
                log.Error("Could not load control given as argument: " + _advancedSearchForm, err);
                DontShowAdvancedSearch();
            }
        }

        if (!string.IsNullOrEmpty(AdvancedSearchUrl))
        {
            log.Debug("Showing advanced search because Url is not empty");
            btnAdvancedSearch.Visible = true;
            btnAdvancedSearch.Click += new EventHandler(btnAdvancedSearch_Click);
        }
    }

    void btnAdvancedSearch_Click(object sender, EventArgs e)
    {
        Response.Redirect(AdvancedSearchUrl);
    }

    private void LinkjQueryFunctionalityToAdvancedSearchLink()
    {
        StringBuilder theScript = new StringBuilder();
        theScript.Append("<script type=\"text/javascript\">\n");
        theScript.Append("    $(document).ready(function() {\n");
        theScript.Append("        // Handler to show the advanced search form if needed\n");
        theScript.Append("        $(\"#" + btnAdvancedSearch.ClientID + "\").click(function(e) {\n");
        theScript.Append("            e.preventDefault();\n");
        theScript.Append("\n");
        theScript.Append("            var maskWinH = $(document).height();\n");
        theScript.Append("            var maskWinW = $(window).width();\n");
        theScript.Append("            $(\"#CSearch_Advanced_Mask\").css({ 'width': maskWinW, 'height': maskWinH });\n");
        theScript.Append("            $(\"#CSearch_Advanced_Mask\").css('top', 0);\n");
        theScript.Append("            $(\"#CSearch_Advanced_Mask\").css('left', 0);\n");
        theScript.Append("            $(\"#CSearch_Advanced_Mask\").fadeIn(500);\n");
        theScript.Append("\n");
        theScript.Append("            var winH = $(window).height();\n");
        theScript.Append("            var winW = $(window).width();\n");
        theScript.Append("            $(\"#" + CSearch_Advanced_Panel.ClientID + "\").css('top', winH / 2 - $(\"#" + CSearch_Advanced_Panel.ClientID + "\").height() / 2);\n");
        theScript.Append("            $(\"#" + CSearch_Advanced_Panel.ClientID + "\").css('left', winW / 2 - $(\"#" + CSearch_Advanced_Panel.ClientID + "\").width() / 2);\n");
        theScript.Append("            $(\"#" + CSearch_Advanced_Panel.ClientID + "\").fadeIn(0);\n");
        theScript.Append("\n");
        theScript.Append("            return false;\n");
        theScript.Append("        });\n");
        theScript.Append("        $(\"#" + btnSearch_Advanced.ClientID + "\").click(function(e) {\n");
        theScript.Append("            $(\"#" + CSearch_Advanced_Panel.ClientID + ", #CSearch_Advanced_Mask\").fadeOut(500);\n");
        theScript.Append("\n");
        theScript.Append("        });\n");
        theScript.Append("        $(\"#" + CSearch_Advanced_Close.ClientID + "\").click(function(e) {\n");
        theScript.Append("            e.preventDefault();\n");
        theScript.Append("            $(\"#" + CSearch_Advanced_Panel.ClientID + ", #CSearch_Advanced_Mask\").fadeOut(500);\n");
        theScript.Append("        });\n");
        theScript.Append("    });\n");
        theScript.Append("</script>\n");

        AdvancedSearchJqueryFunctionality.Text = theScript.ToString();
    }

    private void DontShowAdvancedSearch()
    {
        log.Warn("Will NOT show nor use the Advanced Search");
        btnAdvancedSearch.Visible = false;
    }

    protected void btnSearch_Advanced_Click(object sender, EventArgs e)
    {
        log.Info("Advanced Search, recovering values from contained user control");
        List<AbstractSearchItem> searchItems = new List<AbstractSearchItem>();
        UserControl ucAdvancedSearch = (UserControl)(plhldAdvancedSearchForm.Controls[1]);
        if (ucAdvancedSearch == null)
        {
            log.Error("Advanced SEarch place holder doesnt have a user control");
            return;
        }
        FindAllSearchItems(ucAdvancedSearch, searchItems);

        StringBuilder query = new StringBuilder();
        bool first = true;

        foreach (AbstractSearchItem item in searchItems)
        {
            if (string.IsNullOrEmpty(item.GetValue()))
                continue;

            if (!first)
            {
                log.Debug("Operation between search columns: " + item.GetOperation());
                query.Append(" " + item.GetOperation());
            }
            query.Append(" " + item.GetValue());
            first = false;
        }

        this.Query = query.ToString();
        //txtSearch.Text = query.ToString();
        //btnSearch_Click(sender, e);
    }

    /// <summary>
    /// Fills the list with all the AbstractSearchItem controls in uc
    /// </summary>
    /// <param name="uc"></param>
    /// <param name="searchItems"></param>
    private void FindAllSearchItems(UserControl uc, List<AbstractSearchItem> searchItems)
    {
        foreach (Control ctl in uc.Controls)
        {
            try
            {
                AbstractSearchItem searchItem = (AbstractSearchItem)ctl;
                searchItems.Add(searchItem);
                continue;
            }
            catch
            {
                log.Debug("Control found is NOT an AbstractSearchItem");
            }

            if (ctl.HasControls())
                FindAllSearchItems(uc, searchItems);
        }
    }
    #endregion

    #region Saved searches methods

    protected void btnSavedSearches_Save_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }
        // Change the way the application gets the user here
        int userId = this.GetUserId;
        string name = txtSavedSearch.Text.Trim();

        if (string.IsNullOrEmpty(Query))
        {
            log.Debug("Cannot save a query without an expression");
            return;
        }
        if (string.IsNullOrEmpty(name))
        {
            log.Debug("Cannot save a query without a name");
            return;
        }

        SavedSearch obj = new SavedSearch(SavedSearchesIDHidden.Value, userId, name, Query, DateTime.Now);
        if (SavedSearchBLL.Insert(obj))
        {
            // Inform saved search was inserted
            log.Info("New saved search for user " + userId.ToString() +
                " searchId: " + SavedSearchesIDHidden.Value + " name: " + name);
        }
        else
        {
            // Inform saved search was NOT inserted
            log.Error("Error Saving new Savedsearch " + userId.ToString() +
                " searchId: " + SavedSearchesIDHidden.Value + " name: " + name);
        }

        SavedSearchesGrid.DataBind();
    }

    protected void SavedSearchItemLink_Clicked(object sender, EventArgs e)
    {
        string name = ((LinkButton)sender).CommandArgument;
        int userID = this.GetUserId;
        string searchId = SavedSearchesID;

        List<SavedSearch> aList = SavedSearchBLL.GetSavedSearch(searchId, userID, name);

        if (aList == null || aList.Count != 1)
        {
            log.Error("Error recovering saved search name:" +
                name + ", user:" + userID.ToString() + ", searchid:" + searchId);
            return;
        }

        SavedSearch theSavedSearch = aList[0];
        Query = theSavedSearch.SearchExpression;
    }

    protected void SavedSearchesGrid_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null)
        {
            log.Error("Failed to delete SavedSearch from database", e.Exception);
            e.ExceptionHandled = true;
            return;
        }
        SavedSearchesGrid.DataBind();
    }

    #endregion

    public int GetUserId
    {
        get
        {
            //Get the current user
            User theUser = UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);
            if (theUser == null || theUser.UserId <= 0)
            {
                log.Error("Cannot get user from database.");
                SystemMessages.DisplaySystemErrorMessage(Resources.UserLabels.GetUserErrorMessaje);
                return 0;
            }

            return theUser.UserId;
        }
    }
}