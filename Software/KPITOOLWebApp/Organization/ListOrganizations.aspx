<%@ Page Title="KPI Tool" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="ListOrganizations.aspx.cs" Inherits="ListOrganizations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="App_Themes/Default/09_search.css" rel="stylesheet" />
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
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="OrganizationsPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">
                            <asp:Literal ID="Literal1" runat="server" Text="<% $Resources: Organization, TitleOrganizations %>"></asp:Literal>
                        </div>
                    </div>
                    <div class="t-body tb-padding">
                        <div class="col-sm-6">
                            <div class="m-b-10">
                                <label class="checkbox checkbox-inline cr-alt">
                                    <asp:CheckBox runat="server" ID="ShowPeopleCheckbox" AutoPostBack="true" OnCheckedChanged="ShowPeopleCheckbox_CheckedChanged" />
                                    <i class="input-helper"></i>
                                    <asp:Label ID="ShowPeopleLabel" runat="server" Text="<% $Resources: Organization, TitleShowPeople %>"></asp:Label>
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <app:SearchControl ID="OrgSearchControl" runat="server"
                                Title="<% $Resources: Glossary, AdvancedSearchLabel %>"
                                DisplayHelp="true"
                                DisplayContextualHelp="true"
                                AdvancedSearchForm="~/UserControls/AdvancedSearch/OrganizationAdvancedSearch.ascx"
                                CssSearch="CSearch"
                                CssSearchHelp="CSearchHelpPanel"
                                CssSearchError="CSearchErrorPanel"
                                CssSearchAdvanced="CSearch_Advanced_Panel"
                                SavedSearches="true"
                                SavedSearchesID="OrgSavedSearch"
                                ImageHelpUrl="Images/Neutral/Help.png"
                                ImageErrorUrl="~/images/exclamation.png" />
                        </div>
                    </div>
                    <div class="t-body tb-padding" id="OrganizationList">
                        <asp:Repeater ID="OrganizationsRepeater" runat="server" OnItemDataBound="OrganizationsRepeater_ItemDataBound"
                            OnItemCommand="OrganizationsRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-1 col-sm-1 col-xs-3">
                                        <asp:LinkButton ID="ViewOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server"
                                            CssClass="viewBtn detailsBtn" CommandName="ViewOrganization">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1 col-sm-1 col-xs-3">
                                        <asp:LinkButton ID="EditOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server"
                                            CssClass="viewBtn editBtn" CommandName="EditOrganization">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <asp:Panel class="col-md-1 col-sm-1 col-xs-3" ID="pnlShare" runat="server">
                                        <asp:LinkButton ID="ShareOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server"
                                            CssClass="viewBtn shareBtn" CommandName="ShareOrganization">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </asp:Panel>

                                    <asp:Panel class="col-md-1 col-sm-1 col-xs-3" ID="pnlDelete" runat="server">
                                        <asp:HiddenField ID="IsOwnerHiddenField" runat="server" Value='<%# Eval("IsOwner") %>' />
                                        <asp:LinkButton ID="DeleteOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server"
                                            OnClientClick="return confirm('Are you sure you want to delete selected Organization?')"
                                            CssClass="viewBtn deleteBtn" CommandName="DeleteOrganization">
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </asp:Panel>
                                    <div class="col-md-8 col-sm-8 col-xs-12">
                                        <p style="font-size: 14px; padding-top: 2px;"><%# Eval("Name") %></p>
                                    </div>
                                </div>
                                <div class="row m-b-20">
                                    <div class="col-md-3"></div>
                                    <asp:Panel runat="server" ID="emptyMessage" class="col-md-9 m-t-5" Visible="false">
                                        <asp:Label ID="Label1" runat="server" Text="<% $Resources: Organization, MessageNoObjects %>"></asp:Label>
                                        <i class="zmdi zmdi-plus-circle-o" id=""></i>
                                        <asp:Label ID="Label2" runat="server" Text="<% $resources: Organization, MessageNoObtects2 %>"></asp:Label>
                                    </asp:Panel>
                                    <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                        <app:KpiImage ID="ImageOfKpi" runat="server" OwnerType="ORGANIZATION" OwnerId='<%# Eval("OrganizationId") %>' />
                                    </asp:Panel>
                                    <asp:Panel runat="server" ID="detailsContainer" CssClass="col-md-6 m-t-5" Visible="false">
                                        <asp:Label ID="Label3" runat="server" Text="<% $Resources: Organization, LabelOrganizationHas %>"></asp:Label>
                                        <asp:Label ID="AreasLabel" runat="server" Visible="false"></asp:Label>
                                        <asp:Literal ID="AndLiteral1" runat="server" Visible="false"></asp:Literal>

                                        <asp:LinkButton ID="ProjectsButton" runat="server" Visible="false"
                                            CommandName="ViewProjects" CommandArgument='<%# Eval("OrganizationId") %>'>
                                        </asp:LinkButton>
                                        <asp:Literal ID="AndLiteral2" runat="server" Visible="false"></asp:Literal>

                                        <asp:LinkButton ID="ActivitiesButton" runat="server" Visible="false"
                                            CommandName="ViewActivities" CommandArgument='<%# Eval("OrganizationId") %>'>
                                        </asp:LinkButton>
                                        <asp:Literal ID="AndLiteral3" runat="server" Visible="false"></asp:Literal>

                                        <asp:LinkButton ID="PersonLinkButton" runat="server" Visible="false"
                                            CommandName="ViewPersons" CommandArgument='<%# Eval("OrganizationId") %>'>
                                        </asp:LinkButton>
                                        <asp:Literal ID="AndLiteral4" runat="server" Visible="false"></asp:Literal>

                                        <asp:LinkButton ID="KpisButton" runat="server" Visible="false"
                                            CommandName="ViewKPIs" CommandArgument='<%# Eval("OrganizationId") %>'>
                                        </asp:LinkButton>
                                    </asp:Panel>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# OrganizationsRepeater.Items.Count == 0 %>'>
                                    <h3 class="col-md-12 text-center">
                                        <asp:Literal ID="NoOrganizationLiteral" runat="server" Text="<% $Resources: Organization, MessageNoOrganizations %>"></asp:Literal>
                                        <asp:Literal ID="NoObjectLiteral" runat="server" Text="<% $Resources: Organization, MessageCanCreate %>"></asp:Literal><i class="zmdi zmdi-plus-circle-o"></i>
                                        <asp:Literal ID="NoObject1Literal" runat="server" Text="<% $Resources: Organization, MessageNoObtects2 %>"></asp:Literal>
                                    </h3>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>
                        <br />
                        <app:TourSettings runat="server" ID="Settings">
                            <Items>
                                <app:TourItem title="<%$ Resources: MainPage, TourStepTitle %>"
                                    content="ORG-WIZ-1"
                                    SourceType="HelpFile"
                                    element="#TheAddButton" />
                                <app:TourItem title="<%$ Resources: MainPage, TourStepTitle %>"
                                    content="ORG-WIZ-2"
                                    SourceType="HelpFile"
                                    element="#OrganizationList .editBtn:first" />
                                <app:TourItem title="<%$ Resources: MainPage, TourStepTitle %>"
                                    content="ORG-WIZ-3"
                                    SourceType="HelpFile"
                                    element="#OrganizationList .detailsBtn:first" />
                                <app:TourItem title="<%$ Resources: MainPage, TourStepTitle %>"
                                    content="ORG-WIZ-4"
                                    SourceType="HelpFile"
                                    element="#OrganizationList .shareBtn:first" />
                            </Items>
                        </app:TourSettings>
                        <div class="col-md-12" style="overflow: hidden">
                            <app:TourControl ID="Tour" runat="server" TourSettingsId="Settings" CssClass="btn btn-default pull-right" TourId="Organizations" ></app:TourControl>
                        </div>
                        <br />
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
</asp:Content>

