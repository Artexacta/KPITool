<%@ Page Title="Projects" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ProjectList.aspx.cs" Inherits="Project_ProjectList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="page-header">
                <div class="row">
                    <div class="col-md-1">
                        <app:AddButton ID="TheAddButton" runat="server" />
                    </div>
                    <div class="col-md-8 col-md-offset-3">
                        <asp:Label ID="OwnerObjectLabel" runat="server" Style="font-size: 10px"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:Panel ID="ProjectsPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">Projects</div>
                    </div>
                    <div class="t-body tb-padding">
                        <app:SearchControl ID="ProjectSearchControl" runat="server"
                            Title="Búsqueda"
                            DisplayHelp="true"
                            DisplayContextualHelp="true"
                            CssSearch="CSearch"
                            CssSearchHelp="CSearchHelpPanel"
                            CssSearchError="CSearchErrorPanel"
                            SavedSearches="true" SavedSearchesID="ProjectSavedSearch"
                            ImageHelpUrl="Images/Neutral/Help.png"
                            ImageErrorUrl="~/images/exclamation.png" />
                    </div>
                    <div class="t-body tb-padding" id="ProjectList">
                        <asp:Repeater ID="ProjectsRepeater" runat="server" OnItemDataBound="ProjectsRepeater_ItemDataBound"
                            DataSourceID="ProjectsObjectDataSource" OnItemCommand="ProjectsRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="ViewProject" CommandArgument='<%# Eval("ProjectID") %>' runat="server"
                                            CssClass="viewBtn detailsBtn" CommandName="ViewProject">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="EditProject" CommandArgument='<%# Eval("ProjectID") %>' runat="server"
                                            CssClass="viewBtn editBtn" CommandName="EditProject">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1 disabled">
                                        <asp:LinkButton ID="ShareProject" CommandArgument='<%# Eval("ProjectID") %>' runat="server"
                                            CssClass="viewBtn shareBtn">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="DeleteProject" data-id='<%# Eval("ProjectID") %>' CommandArgument='<%# Eval("ProjectID") %>'
                                            CommandName="DeleteProject" runat="server" CssClass="viewBtn deleteBtn"
                                            OnClientClick="return confirm('Are you sure you want to delete selected Project?')">
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-8">
                                        <p style="font-size: 14px; padding-top: 2px;">
                                            <%# Eval("Name") %>
                                            (
                                            <asp:LinkButton ID="OwnerLinkButton" runat="server" Text='<%# Eval("Owner") %>'
                                                CommandName="ViewOwner"
                                                CommandArgument='<%# Eval("ProjectID") %>'></asp:LinkButton>
                                            )
                                        </p>
                                    </div>
                                </div>
                                <div class="row m-b-20">
                                    <asp:Panel runat="server" ID="emptyMessage" class="col-md-11 col-md-offset-1 m-t-5" Visible="false">
                                        This project does not have any objects. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above
                                    </asp:Panel>
                                    <%-- <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                        <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                    </asp:Panel>
                                   <asp:Panel runat="server" id="detailsContainer" class="col-md-11 m-t-5" visible="false">
                                        This project has 
                                        <asp:LinkButton ID="ActivitiesButton" runat="server" Visible="false"
                                            CommandName="ViewActivities" CommandArgument='<%# Eval("ProjectID") %>'>
                                        </asp:LinkButton>
                                        <asp:Literal ID="AndLiteral" runat="server" Visible="false" Text="and"></asp:Literal>

                                        <asp:LinkButton ID="KpisButton" runat="server" Visible="false"
                                            CommandName="ViewKPIs" CommandArgument='<%# Eval("ProjectID") %>'>
                                        </asp:LinkButton>
                                    </asp:Panel>--%>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# ProjectsRepeater.Items.Count == 0 %>'>
                                    <div class="col-md-12 text-center">
                                        -- There are no Projects registered. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above --
                                    </div>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>

                        <br />
                        <%--<div style="overflow: hidden">
                            <a id="showTourBtn" runat="server" href="#" class="btn btn-default pull-right" clientidmode="Static" style="display: none">Show tips for this page</a>
                        </div>--%>
                        <app:TourSettings runat="server" ID="Settings">
                            <Items>
                                <app:TourItem title="<%$ Resources: ProjectList, TourStepTitle %>"
                                    content="<%$ Resources: ProjectList, TourStep1 %>"
                                    element="#TheAddButton" />
                                <app:TourItem title="<%$ Resources: ProjectList, TourStepTitle %>"
                                    content="<%$ Resources: ProjectList, TourStep2 %>"
                                    element="#OrganizationList .editBtn:first" />
                                <app:TourItem title="<%$ Resources: ProjectList, TourStepTitle %>"
                                    content="<%$ Resources: ProjectList, TourStep3 %>"
                                    element="#OrganizationList .detailsBtn:first" />
                                <app:TourItem title="<%$ Resources: ProjectList, TourStepTitle %>"
                                    content="<%$ Resources: ProjectList, TourStep4 %>"
                                    element="#OrganizationList .shareBtn:first" />
                                <app:TourItem title="<%$ Resources: ProjectList, TourStepTitle %>"
                                    content="<%$ Resources: ProjectList, TourStep5 %>"
                                    element="#SearchPanel" />
                            </Items>
                        </app:TourSettings>
                        <div style="overflow: hidden">
                            <app:TourControl ID="Tour" runat="server" TourSettingsId="Settings" CssClass="btn btn-default pull-right"></app:TourControl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
    <asp:ObjectDataSource ID="ProjectsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetProjectBySearch" TypeName="Artexacta.App.Project.BLL.ProjectBLL" OnSelected="ProjectsObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="ProjectSearchControl" PropertyName="Sql" Name="whereClause" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

