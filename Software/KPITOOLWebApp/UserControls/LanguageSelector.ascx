<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LanguageSelector.ascx.cs" Inherits="UserControls_LanguageSelector" %>
<div style="position:relative">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" >
        <i class="zmdi zmdi-globe"></i>
        <asp:Label ID="Label1" runat="server" CssClass="hidden-xs" Text="<%$ Resources: InitMasterPage, SelectLanguageLabel %>"></asp:Label>
        <asp:Literal ID="SelectedLanguage" runat="server"></asp:Literal>
    </a>
    <asp:Repeater ID="LanguagesRepeater" runat="server"
        DataSourceID="odsLanguages"
        OnItemCommand="LanguagesRepeater_ItemCommand">
        <HeaderTemplate><ul class="dropdown-menu"></HeaderTemplate>
        <ItemTemplate>
            <li>
                <asp:LinkButton ID="Button" runat="server" CommandArgument='<%# Eval("LanguageId") %>' CommandName="SelectLanguage">
                    <asp:Literal ID="LanguageLiteral" runat="server"                    
                        Text='<%# Eval("LanguageName") %>'>
                    </asp:Literal>
                </asp:LinkButton>
            </li>        
        </ItemTemplate>    
        <FooterTemplate>
            </ul>
        </FooterTemplate>
    </asp:Repeater>
</div>

<%--<asp:DropDownList ID="ddlLanguages" runat="server"
    AutoPostBack="True"
    DataSourceID="odsLanguages"
    DataTextField="LanguageName"
    DataValueField="LanguageId"
    OnSelectedIndexChanged="ddlLanguages_SelectedIndexChanged"
    OnDataBound="ddlLanguages_DataBound">
</asp:DropDownList>--%>
<asp:ObjectDataSource ID="odsLanguages" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="GetLanguageList" TypeName="Artexacta.App.Language.BLL.LanguageBLL"
    OnSelected="odsLanguages_Selected">
</asp:ObjectDataSource>
<asp:HiddenField ID="ActualLanguageHiddenField" runat="server" />
