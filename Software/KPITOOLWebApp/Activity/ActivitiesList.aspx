﻿<%@ Page Title="<% $Resources: Activity, TitleActivities %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ActivitiesList.aspx.cs" Inherits="Activity_ActivitiesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="page-header">
                <div class="row">
                    <div class="col-md-1">
                        <app:AddButton ID="TheAddButton" runat="server" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-8 col-md-offset-3">
                        <asp:Label ID="OwnerObjectLabel" runat="server" Style="font-size: 10px"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">
                            <asp:Label ID="TitleActivyLabel" runat="server" Text="<% $Resources: Activity, TitleActivities %>"></asp:Label>
                        </div>
                    </div>
                    <div class="t-body tb-padding" id="SearchPanel">
                        <app:SearchControl ID="ActivitySearchControl" runat="server"
                            Title="<% $Resources: Glossary, AdvancedSearchLabel %>"
                            DisplayHelp="true"
                            DisplayContextualHelp="true"
                            CssSearch="CSearch"
                            CssSearchHelp="CSearchHelpPanel"
                            CssSearchError="CSearchErrorPanel"
                            CssSearchAdvanced="CSearch_Advanced_Panel"
                            SavedSearches="true" SavedSearchesID="ActivitySavedSearch"
                            ImageHelpUrl="Images/Neutral/Help.png"
                            ImageErrorUrl="~/images/exclamation.png"
                            AdvancedSearchForm="~/UserControls/AdvancedSearch/ActivityAdvancedSearch.ascx" />
                    </div>
                    <div class="t-body tb-padding" id="ActivityList">
                        <asp:Repeater ID="ActivityRepeater" runat="server" OnItemDataBound="ActivityRepeater_ItemDataBound"
                            OnItemCommand="ActivityRepeater_ItemCommand" DataSourceID="ActivityObjectDataSource">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-1 col-sm-1 col-xs-3">
                                        <asp:LinkButton ID="ViewActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn detailsBtn"
                                            CommandName="ViewActivity">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1 col-sm-1 col-xs-3">
                                        <asp:LinkButton ID="EditActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn editBtn"
                                            CommandName="EditActivity">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <asp:Panel class="col-md-1 col-sm-1 col-xs-3" ID="pnlShare" runat="server">
                                        <asp:LinkButton ID="ShareActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn shareBtn"
                                            CommandName="ShareActivity">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </asp:Panel>
                                    <asp:Panel class="col-md-1 col-sm-1 col-xs-3" ID="pnlDelete" runat="server">
                                        <asp:HiddenField ID="IsOwnerHiddenField" runat="server" Value='<%# Eval("IsOwner") %>' />
                                        <asp:LinkButton ID="DeleteActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn deleteBtn"
                                            CommandName="DeleteActivity"
                                            OnClientClick="return confirm('Are you sure you want to delete selected Activity?')">   
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </asp:Panel>
                                    <div class="col-md-8 col-sm-8 col-xs-12">
                                        <p style="font-size: 14px; padding-top: 2px;">
                                            <%# Eval("Name") %>
                                            (
                                            <asp:LinkButton ID="OrganizationLinkButton" runat="server" Text='<%# Eval("OrganizationName") %>'
                                                CommandName="ViewOrganization"
                                                CommandArgument='<%# Eval("OrganizationId") %>'></asp:LinkButton>
                                            <asp:Label ID="GuionAreaLabel" runat="server" Text=" - " Visible="false"></asp:Label>
                                            <asp:LinkButton ID="AreaLinkButton" runat="server" Text='<%# Eval("AreaName") %>'
                                                CommandName="ViewArea"
                                                CommandArgument='<%# Eval("OrganizationId") %>'></asp:LinkButton>
                                            <asp:Label ID="GuionProjectLabel" runat="server" Text=" - " Visible="false"></asp:Label>
                                            <asp:LinkButton ID="ProjectLinkButton" runat="server" Text='<%# Eval("ProjectName") %>'
                                                CommandName="ViewProject"
                                                CommandArgument='<%# Eval("ProjectID") %>'></asp:LinkButton>
                                            )
                                        </p>
                                    </div>
                                </div>
                                <div class="row m-b-20">
                                    <div class="col-md-3"></div>
                                    <asp:Panel runat="server" ID="emptyMessage" class="col-md-6 m-t-5 col-md-offset-1" Visible="false">
                                        <asp:Label ID="NoObjectLabel" runat="server" Text="<% $Resources: Activity, MessageActivityNoObject %>"></asp:Label>
                                        <i class="zmdi zmdi-plus-circle-o"></i>
                                        <asp:Label ID="IconLabel" runat="server" Text="<% $Resources: Activity, MessageActivityIconAbove %>"></asp:Label>
                                    </asp:Panel>
                                    <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                        <app:KpiImage ID="ImageOfKpi" runat="server" OwnerType="ACTIVITY" OwnerId='<%# Eval("ActivityId") %>' />
                                    </asp:Panel>
                                    <asp:Panel runat="server" ID="detailsContainer" class="col-md-6 m-t-5" Visible="false">
                                        <asp:Label ID="HasLabel" runat="server" Text="<% $Resources: Activity, MessageActivityHas %>"></asp:Label>
                                        <asp:LinkButton ID="KpisButton" runat="server" CommandName="ViewKPIs" CommandArgument='<%# Eval("ActivityId") %>'></asp:LinkButton>
                                    </asp:Panel>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# ActivityRepeater.Items.Count == 0 %>'>
                                    <div class="col-md-12 text-center">
                                        <asp:Label ID="NoActivitiesLabel" runat="server" Text="<% $Resources: Activity, MessageNoActivity %>"></asp:Label>
                                        <i class="zmdi zmdi-plus-circle-o"></i>
                                        <asp:Label ID="Icon2Label" runat="server" Text="<% $Resources: Activity, MessageActivityIconAbove1 %>"></asp:Label>
                                    </div>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>
                        <br />
                        <app:TourSettings runat="server" ID="Settings">
                            <Items>
                                <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                    content="<%$ Resources: ActivitiesList, TourStep1 %>"
                                    element="#TheAddButton" />
                                <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                    content="<%$ Resources: ActivitiesList, TourStep2 %>"
                                    element="#ActivityList .editBtn:first" />
                                <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                    content="<%$ Resources: ActivitiesList, TourStep3 %>"
                                    element="#ActivityList .detailsBtn:first" />
                                <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                    content="<%$ Resources: ActivitiesList, TourStep4 %>"
                                    element="#ActivityList .shareBtn:first" />
                                <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                    content="<%$ Resources: ActivitiesList, TourStep5 %>"
                                    element="#SearchPanel"
                                    placement="bottom" />
                            </Items>
                        </app:TourSettings>
                        <div style="overflow: hidden">
                            <app:TourControl ID="Tour" runat="server" TourSettingsId="Settings" CssClass="btn btn-default pull-right"
                                TourId="ActivityList"></app:TourControl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
    <asp:ObjectDataSource ID="ActivityObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetActivitiesBySearch" TypeName="Artexacta.App.Activities.BLL.ActivityBLL" OnSelected="ActivityObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActivitySearchControl" PropertyName="Sql" Name="whereClause" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    
</asp:Content>

