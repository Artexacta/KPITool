<%@ Page Title="<% $Resources: Trash, LabelTitle %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TrashList.aspx.cs" Inherits="Trash_TrashList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <asp:Panel ID="ProjectsPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">
                            <asp:Label ID="Label1" runat="server" Text="<% $Resources: Trash, LabelTitle %>"></asp:Label>
                        </div>
                    </div>
                    <div class="t-body tb-padding">
                        <%--<app:SearchControl ID="TrashSearchControl" runat="server"
                            Title="<% $Resources: Glossary, AdvancedSearchLabel %>"
                            DisplayHelp="true"
                            DisplayContextualHelp="true"
                            CssSearch="CSearch"
                            CssSearchHelp="CSearchHelpPanel"
                            CssSearchError="CSearchErrorPanel"
                            SavedSearches="true" 
                            SavedSearchesID="TrashSavedSearch"
                            ImageHelpUrl="Images/Neutral/Help.png"
                            ImageErrorUrl="~/images/exclamation.png" />--%>

                        <%--Organization--%>
                        <div class="panel panel-default">
                            <div class="panel-heading text-center">
                                <strong>
                                    <asp:Label ID="Label5" runat="server" Text="<% $Resources: Trash, LabelOrgDelete %>" Font-Size="Medium"></asp:Label></strong>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <asp:Repeater ID="ORGRepeater" runat="server" OnItemDataBound="ORGRepeater_ItemDataBound" DataSourceID="ORGObjectDataSource"
                                        OnItemCommand="ORGRepeater_ItemCommand">
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:Label ID="nameLabel" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true" Font-Size="Small"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:Label ID="DetailLabel" runat="server" Text=""></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:LinkButton ID="ResorteLinkButton" runat="server" Text="<% $Resources: Trash, labelRestoreOrg %>"
                                                        CommandName="Restore" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<% $Resources: Trash, labelDeletePermanentlyOrg %>"
                                                        CommandName="DeleteOrg" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                            <br />
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="EmptyMessageContainer" runat="server" CssClass="row" Visible='<%# ORGRepeater.Items.Count == 0 %>'>
                                                <div class="col-md-12">
                                                    <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Trash, MessageNoOrganizations %>"></asp:Label>
                                                </div>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <%--Projects--%>
                        <div class="panel panel-default">
                            <div class="panel-heading text-center">
                                <strong>
                                    <asp:Label ID="Label2" runat="server" Text="<% $Resources: Trash, LabelProjectDelete %>" Font-Size="Medium"></asp:Label></strong>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <asp:Repeater ID="ProjectRepeater" runat="server" DataSourceID="PROObjectDataSource" OnItemDataBound="ProjectRepeater_ItemDataBound"
                                        OnItemCommand="ProjectRepeater_ItemCommand">
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:Label ID="nameLabel" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true" Font-Size="Small"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:Label ID="DetailLabel" runat="server" Text=""></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:LinkButton ID="ResorteLinkButton" runat="server" Text="<% $Resources: Trash, labelRestoreProject %>"
                                                        CommandName="Restore" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<% $Resources: Trash, labelDeletePermanentlyProj %>"
                                                        CommandName="DeleteProject" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                            <br />
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="EmptyMessageContainer" runat="server" CssClass="row" Visible='<%# ProjectRepeater.Items.Count == 0 %>'>
                                                <div class="col-md-12">
                                                    <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Trash, MessageNoProjects %>"></asp:Label>
                                                </div>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <%--Persons--%>
                        <div class="panel panel-default">
                            <div class="panel-heading text-center">
                                <strong>
                                    <asp:Label ID="Label3" runat="server" Text="<% $Resources: Trash, LabelPersonDelete %>" Font-Size="Medium"></asp:Label></strong>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <asp:Repeater ID="PersonRepeater" runat="server" DataSourceID="PersonObjectDataSource" OnItemDataBound="PersonRepeater_ItemDataBound"
                                        OnItemCommand="PersonRepeater_ItemCommand">
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:Label ID="nameLabel" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true" Font-Size="Small"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:Label ID="DetailLabel" runat="server" Text=""></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:LinkButton ID="ResorteLinkButton" runat="server" Text="<% $Resources: Trash, labelRestorePerson %>"
                                                        CommandName="Restore" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<% $Resources: Trash, labelDeletePermanentlyPerson %>"
                                                        CommandName="DeletePerson" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                            <br />
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="EmptyMessageContainer" runat="server" CssClass="row" Visible='<%# PersonRepeater.Items.Count == 0 %>'>
                                                <div class="col-md-12">
                                                    <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Trash, MessageNoPeople %>"></asp:Label>
                                                </div>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <%--Activities--%>
                        <div class="panel panel-default">
                            <div class="panel-heading text-center">
                                <strong>
                                    <asp:Label ID="Label6" runat="server" Text="<% $Resources: Trash, LabelActivityDelete %>" Font-Size="Medium"></asp:Label></strong>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <asp:Repeater ID="ActivityRepeater" runat="server" DataSourceID="ActivityObjectDataSource" OnItemDataBound="ActivityRepeater_ItemDataBound"
                                        OnItemCommand="ActivityRepeater_ItemCommand">
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:Label ID="nameLabel" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true" Font-Size="Small"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:Label ID="DetailLabel" runat="server" Text=""></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:LinkButton ID="ResorteLinkButton" runat="server" Text="<% $Resources: Trash, labelRestoreActivity %>"
                                                        CommandName="Restore" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<% $Resources: Trash, labelDeletePermanentlyAct %>"
                                                        CommandName="DeleteActivity" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                            <br />
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="EmptyMessageContainer" runat="server" CssClass="row" Visible='<%# ActivityRepeater.Items.Count == 0 %>'>
                                                <div class="col-md-12">
                                                    <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Trash, MessageNoActivity %>"></asp:Label>
                                                </div>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <%--KPI--%>
                        <div class="panel panel-default">
                            <div class="panel-heading text-center">
                                <strong>
                                    <asp:Label ID="Label4" runat="server" Text="<% $Resources: Trash, LabelKpiDelete %>" Font-Size="Medium"></asp:Label></strong>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                    <asp:Repeater ID="KpiRepeater" runat="server" DataSourceID="KpiObjectDataSource" OnItemDataBound="KpiRepeater_ItemDataBound"
                                        OnItemCommand="KpiRepeater_ItemCommand">
                                        <ItemTemplate>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <asp:Label ID="nameLabel" runat="server" Text='<%# Eval("Name") %>' Font-Bold="true" Font-Size="Small"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:Label ID="DetailLabel" runat="server" Text=""></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-md-offset-1">
                                                    <asp:LinkButton ID="ResorteLinkButton" runat="server" Text="<% $Resources: Trash, labelRestoreKpi %>"
                                                        CommandName="Restore" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="DeleteLinkButton" runat="server" Text="<% $Resources: Trash, labelDeletePermanentlyKpi %>"
                                                        CommandName="DeleteKpi" CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                            <br />
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Panel ID="EmptyMessageContainer" runat="server" CssClass="row" Visible='<%# KpiRepeater.Items.Count == 0 %>'>
                                                <div class="col-md-12">
                                                    <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Trash, MessageNoKpi %>"></asp:Label>
                                                </div>
                                            </asp:Panel>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:HiddenField ID="OrganizationHF" runat="server" />
    <asp:HiddenField ID="ProjectHF" runat="server" />
    <asp:HiddenField ID="PersonHF" runat="server" />
    <asp:HiddenField ID="ActivityHF" runat="server" />
    <asp:HiddenField ID="KpiHF" runat="server" />
    <asp:ObjectDataSource ID="ORGObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetTrashByObjectType" TypeName="Artexacta.App.Trash.BLL.TrashBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationHF" Name="objectType" PropertyName="Value" Type="String" />
            <asp:Parameter Name="whereClause" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="PROObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetTrashByObjectType" TypeName="Artexacta.App.Trash.BLL.TrashBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="ProjectHF" Name="objectType" PropertyName="Value" Type="String" />
            <asp:Parameter Name="whereClause" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="PersonObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetTrashByObjectType" TypeName="Artexacta.App.Trash.BLL.TrashBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="PersonHF" Name="objectType" PropertyName="Value" Type="String" />
            <asp:Parameter Name="whereClause" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ActivityObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetTrashByObjectType" TypeName="Artexacta.App.Trash.BLL.TrashBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActivityHF" Name="objectType" PropertyName="Value" Type="String" />
            <asp:Parameter Name="whereClause" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="KpiObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetTrashByObjectType" TypeName="Artexacta.App.Trash.BLL.TrashBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="KpiHF" Name="objectType" PropertyName="Value" Type="String" />
            <asp:Parameter Name="whereClause" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

