<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LanguageSelector.ascx.cs" Inherits="UserControls_LanguageSelector" %>
<div>
    <asp:Repeater ID="languagesRepeater" DataSourceID="odsLanguages" runat="server" OnItemDataBound="languagesRepeater_ItemDataBound">
        <ItemTemplate>
            <asp:Label ID="LanguageLinkButton" runat="server" Text='<%# Eval("LanguageId") %>'
                ToolTip='<%# Eval("LanguageName") %>'>
            </asp:Label>
        </ItemTemplate>
    </asp:Repeater>
</div>
<asp:ObjectDataSource ID="odsLanguages" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="GetLanguageList" TypeName="Artexacta.App.Language.BLL.LanguageBLL">
</asp:ObjectDataSource>
<asp:HiddenField ID="ActualLanguageHiddenField" runat="server" />
<script type="text/javascript">
    function LanguageSelector_ChangeLanguage(lang) {
        var cookieName = '<%= Artexacta.App.Utilities.LanguageUtilities.cookieName%>';

        //Removing the actual cookie
        $.removeCookie(cookieName);
        //Creating the new cookie
        $.cookie(cookieName, lang, { expires: 360, path: '/' });

        //Reloading the page
        location.reload();
    }
</script>
