<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SearchControl.ascx.cs" Inherits="UserControls_SearchUserControl_SearchControl" %>

<!-- Do not remove div#mask, because you'll need it to fill the whole screen -->
<div id="CSearch_Advanced_Mask"></div>

<asp:HiddenField ID="SavedSearchesIDHidden" runat="server" Value="" />
<asp:HiddenField ID="AdvancedSearchUrlHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSearchHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSearchHelpHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSearchAdvancedHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSearchErrorHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSavedSearchesHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CssSearchToolsHiddenField" runat="server" Value="" />
<asp:HiddenField ID="UserIdHiddenField" runat="server" />
<!-- Please use a reference to Jquery in the page that uses this user control -->
<asp:Panel ID="CSearch" runat="server" DefaultButton="btnSearch">

    <asp:Label ID="lblSearchTitle" runat="server"
        CssClass="SearchTitle"
        Text="<%$ Resources: SearchControl,lblSearchTitle_Text %>">
    </asp:Label>

    <asp:Image ID="imgNotValidExpression" runat="server"
        CssClass="NotValidExpressionImage"
        AlternateText="<%$ Resources: SearchControl,lblNotValidExpression_Text %>" />

    <div class="SearchContainer">
        <asp:TextBox ID="txtSearch" runat="server"
            CssClass="SearchBox"
            Text="<%$ Resources: SearchControl,txtSearch_Text %>"
            AutoCompleteType="Disabled"
            autocomplete="off">
        </asp:TextBox>

        <asp:LinkButton ID="btnSavedSearches" runat="server"
            CssClass="SearchButton"
            AlternateText="<%$ Resources: SearchControl,btnSavedSearches_AlternateText %>"
            Text="<i class='fa fa-file'></i>" />

        <asp:HyperLink ID="btnSearchTools" runat="server"
            CssClass="SearchButton"
            Text="<i class='fa fa-wrench'></i>" />

        <asp:LinkButton ID="btnSearch" runat="server"
            CssClass="SearchButton"
            AlternateText="<%$ Resources: SearchControl,btnSearch_AlternateText %>"
            Text="<i class='fa fa-search'></i>"
            OnClick="btnSearch_Click" />
    </div>

    <asp:LinkButton ID="btnAdvancedSearch" runat="server"
        CssClass="AdvancedSearchLink"
        Text="<%$ Resources: SearchControl,lblAdvancedSearch_Text %>">
    </asp:LinkButton>

    <div class="HelpImage">
        <app:ContextualHelp ID="chSearch" runat="server"
            Mode="Ajax"
            FileName="SearchComponent"
            FilesExtension="htm"
            FilesRoute="~/HelpFiles"
            TypeOfLink="Image"
            JQueryIncludedInPage="true"
            Width="600" Height="400" />
    </div>

</asp:Panel>
<asp:Label ID="CSearchTooltip" runat="server" Visible="false"></asp:Label>

<asp:Panel ID="CSearchErrorPanel" runat="server">
    <h3>
        <asp:Literal ID="lblErrorTitle" runat="server"
            Text="<%$ Resources: SearchControl, lblErrorTitle_Text %>"></asp:Literal>
    </h3>
    <asp:Literal ID="lblErrorText" runat="server"></asp:Literal>
</asp:Panel>

<asp:Panel ID="CSearchHelpPanel" runat="server">
    <h3>
        <asp:Literal ID="lblHelpTitle" runat="server"
            Text="<%$ Resources: SearchControl, lblHelpTitle_Text %>"></asp:Literal>
    </h3>
    <hr />
    <p>
        <asp:Literal ID="lblHelpText" runat="server"
            Text="<%$ Resources: SearchControl, lblHelpText_Text %>"></asp:Literal>
    </p>
    <asp:Literal ID="lblHelpContent" runat="server"></asp:Literal>
</asp:Panel>

<asp:Panel ID="CSearch_SavedSearches_Panel" runat="server"
    DefaultButton="btnSavedSearches_Save">

    <div class="columnHead">
        <asp:Label ID="SavedSearchesTitle" runat="server"
            Text="<%$ Resources: SearchControl, SavedSearchesTitle %>" CssClass="title" />
        <asp:HyperLink ID="CloseLink" runat="server"
            CssClass="commands right"
            NavigateUrl="#"
            Text="<%$ Resources: SearchControl,CloseLink_Text %>">
        </asp:HyperLink>
    </div>
    <div class="columnContent">

        <asp:TextBox ID="txtSavedSearch" runat="server" />
        <asp:RequiredFieldValidator ID="reqTxtSavedSearch" runat="server"
            ControlToValidate="txtSavedSearch"
            Display="Dynamic"
            ValidationGroup="savedSearch"
            ErrorMessage="<%$Resources: SearchControl, reqTxtSavedSearch_ErrorMessage %>"
            Text="<%$Resources: SearchControl, reqTxtSavedSearch_ErrorMessage %>">
        </asp:RequiredFieldValidator>

        <asp:LinkButton ID="btnSavedSearches_Save" runat="server"
            CssClass="button"
            ValidationGroup="savedSearch"
            OnClick="btnSavedSearches_Save_Click">
            <asp:Label ID="btnSavedSearches_SaveLabel" runat="server"
                Text="<%$ Resources: SearchControl,btnSavedSearches_Save_Text %>" />
        </asp:LinkButton><asp:GridView ID="SavedSearchesGrid" runat="server"
            AutoGenerateColumns="False"
            CssClass="grid"
            GridLines="None"
            DataKeyNames="SearchId,UserId,Name"
            DataSourceID="savedSearchesDataSource"
            OnRowDeleted="SavedSearchesGrid_RowDeleted"
            EmptyDataText="<%$ Resources:SearchControl,SavedSearchesGrid_Empty %>">
            <HeaderStyle CssClass="head" />
            <Columns>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <asp:ImageButton ID="DeleteLinkButton" runat="server"
                            CausesValidation="False"
                            CommandName="Delete"
                            AlternateText="<%$Resources: SearchControl, DeleteLabel %>"
                            ImageUrl="~/images/neutral/delete-item.png"
                            Width="16"
                            Height="16"></asp:ImageButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources: SearchControl,SavedSearchesGrid_Header %>">
                    <ItemTemplate>
                        <asp:LinkButton ID="SavedSearchItemLink" runat="server"
                            CausesValidation="false"
                            OnClick="SavedSearchItemLink_Clicked"
                            Text='<%# Eval("Name") %>'
                            CommandArgument='<%# Eval("Name") %>'>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <asp:ObjectDataSource ID="savedSearchesDataSource" runat="server"
            OldValuesParameterFormatString="original_{0}"
            DataObjectTypeName="Artexacta.App.SavedSearch.SavedSearch"
            DeleteMethod="Delete"
            SelectMethod="GetSavedSearch"
            TypeName="Artexacta.App.SavedSearch.BLL.SavedSearchBLL">
            <SelectParameters>
                <asp:ControlParameter ControlID="SavedSearchesIDHidden" PropertyName="Value"
                    Name="searchId" Type="String" />
                <asp:ControlParameter
                    ControlID="UserIdHiddenField" DefaultValue="1" Name="userId"
                    PropertyName="Value" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <div class="clear"></div>
    </div>
</asp:Panel>

<asp:Panel ID="CSearch_SearchTools_Panel" runat="server"
    class="hidden">
    <div class="ibox ">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="SearchToolsTitleLabel" runat="server"
                    Text="<%$ Resources: SearchControl, SearchToolsTitle %>" CssClass="" /></h5>

        </div>
        <div class="ibox-content">
            <h5>
                <asp:Literal ID="SelectCommandLabel" runat="server"
                    Text="<%$ Resources: SearchControl, ViewOrSelectCommandLabel %>">
                </asp:Literal>
            </h5>
            <asp:Literal ID="CommandsListLabel" runat="server"></asp:Literal>
        </div>
    </div>
</asp:Panel>

<asp:Panel ID="CSearch_Advanced_Panel" runat="server"
    DefaultButton="btnSearch_Advanced">
    <div class="frame">
        <div class="columnHead">
            <asp:Label ID="lblAdvancedSearchTitle" runat="server"
                Text="<%$ Resources: SearchControl, lblAdvancedSearchTitle_Text %>" CssClass="title" />
            <asp:HyperLink ID="CSearch_Advanced_Close" runat="server"
                CssClass="commands right"
                NavigateUrl="#"
                Text="<%$ Resources: SearchControl,lblClose_Text %>">
            </asp:HyperLink>
        </div>
        <div class="columnContent">
            <div id="CSearch_Advanced_Close_Div">
            </div>
            <asp:PlaceHolder ID="plhldAdvancedSearchForm" runat="server">
                <!-- Here we call dynamically the usercontrol that has the form -->
            </asp:PlaceHolder>

            <div class="buttonsPanel">
                <asp:LinkButton ID="btnSearch_Advanced" runat="server" CssClass="button"
                    OnClick="btnSearch_Advanced_Click">
                    <asp:Label ID="lblSearch_Advanced" runat="server"
                        Text="<%$ Resources: SearchControl,btnSearch_Advanced_Text %>" />
                </asp:LinkButton>
            </div>
            <div class="clear"></div>
        </div>
    </div>
</asp:Panel>

<asp:Literal ID="AdvancedSearchJqueryFunctionality" runat="server"></asp:Literal>

<script type="text/javascript">
    $(document).ready(function () {
        $("#<%=CSearchErrorPanel.ClientID %>").hide();
        $("#<%=CSearchHelpPanel.ClientID %>").hide();
        $("#<%=CSearch_Advanced_Panel.ClientID %>").hide();
        $("#<%=CSearch_SavedSearches_Panel.ClientID %>").hide();
        $("#<%=CSearch_SearchTools_Panel.ClientID %>").hide();

        // Handler for Error panel on hover
        $("#<%=imgNotValidExpression.ClientID %>").hover(
            function () {
                var errorW = $("#<%=CSearchErrorPanel.ClientID %>").width();
                var errorH = $("#<%=CSearchErrorPanel.ClientID %>").height();

                var position = $(this).position();
                var thisHeight = $(this).height();
                $("#<%=CSearchErrorPanel.ClientID %>").css('top', position.top + thisHeight);
                $("#<%=CSearchErrorPanel.ClientID %>").css('left', position.left - errorW / 2);
                $("#<%=CSearchErrorPanel.ClientID %>").show();
            },
            function () {
                $("#<%=CSearchErrorPanel.ClientID %>").hide();
            });

        // Handler to show the saved searches if needed
        $("#<%=btnSavedSearches.ClientID %>").click(function (e) {
            e.preventDefault();

            var savedW = $("#<%=CSearch_SavedSearches_Panel.ClientID %>").width();
            var savedH = $("#<%=CSearch_SavedSearches_Panel.ClientID %>").height();

            var position = $(this).position();
            var thisHeight = $(this).height();
            $("#<%=CSearch_SavedSearches_Panel.ClientID %>").css('top', position.top + thisHeight);
            $("#<%=CSearch_SavedSearches_Panel.ClientID %>").css('left', position.left - savedW / 2);
            $("#<%=CSearch_SavedSearches_Panel.ClientID %>").show();
        });

        // Handler to close the saved searches if needed
        $("#<%=CloseLink.ClientID %>").click(function (e) {
            e.preventDefault();
            $("#<%=CSearch_SavedSearches_Panel.ClientID %>").hide();
            return false;
        });

        // Handler to show the commands list
        $("#<%=btnSearchTools.ClientID %>").attr("href", "#");
        $("#<%=btnSearchTools.ClientID %>").popover({
            html: true,
            placement: "bottom",
            trigger: "focus",
            content: function () {
                return $('#<%=CSearch_SearchTools_Panel.ClientID %>').html();
            }
        });

        // Handler for all the commands
        $(".popover ul li").on("click", function () {
            var position = $("#<%=txtSearch.ClientID %>").getCursorPosition();
            var complete = $("#<%=txtSearch.ClientID %>").val().substring(0, position);
            complete = complete + '@' + this.id + $("#<%=txtSearch.ClientID %>").val().substring(position);
            var lengthId = this.id.length + 1;
            $("#<%=txtSearch.ClientID %>").val(complete);

            if ($("#<%=txtSearch.ClientID %>")[0].createTextRange) { /* For IE */
                var range = $("#<%=txtSearch.ClientID %>")[0].createTextRange();
                range.move('character', position + lengthId);
                range.select();
            }
            else { /* For other browsers */
                $("#<%=txtSearch.ClientID %>")[0].setSelectionRange(position + lengthId, position + lengthId);
            }

            $("#<%=txtSearch.ClientID %>").focus();
            return false;
        });
    });
    function fijarLlave(llave) {
        $("#<%=txtSearch.ClientID %>").val('@' + llave);
        $("#<%=txtSearch.ClientID %>").focus();
    }
</script>
