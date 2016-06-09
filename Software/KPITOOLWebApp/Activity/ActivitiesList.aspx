<%@ Page Title="Activities" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ActivitiesList.aspx.cs" Inherits="Activity_ActivitiesList" %>

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
        <div class="col-md-6">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="t-header">
                    <div class="th-title">Activities</div>
                </div>
                <div class="t-body tb-padding">
                    <app:SearchControl ID="ActivitySearchControl" runat="server"
                        Title="Búsqueda"
                        DisplayHelp="true"
                        DisplayContextualHelp="true"
                        CssSearch="CSearch"
                        CssSearchHelp="CSearchHelpPanel"
                        CssSearchError="CSearchErrorPanel"
                        SavedSearches="true" SavedSearchesID="ActivitySavedSearch"
                        ImageHelpUrl="Images/Neutral/Help.png"
                        ImageErrorUrl="~/images/exclamation.png" />
                </div>
                <div class="t-body tb-padding" id="ActivityList">
                    <asp:Repeater ID="ActivityRepeater" runat="server" OnItemDataBound="ActivityRepeater_ItemDataBound"
                        OnItemCommand="ActivityRepeater_ItemCommand" DataSourceID="ActivityObjectDataSource">
                        <ItemTemplate>
                            <div class="row">
                                <div class="col-md-1">
                                    <asp:LinkButton ID="ViewActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn detailsBtn"
                                        CommandName="ViewActivity">
                                        <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="EditActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn editBtn"
                                        CommandName="EditActivity">
                                        <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1 disabled">
                                    <asp:LinkButton ID="ShareActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn shareBtn">
                                        <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="DeleteActivity" CommandArgument='<%# Eval("ActivityId") %>' runat="server" CssClass="viewBtn deleteBtn"
                                        CommandName="DeleteActivity"
                                        OnClientClick="return confirm('Are you sure you want to delete selected Activity?')">   
                                        <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-8">
                                    <p style="font-size: 14px; padding-top: 2px;">
                                        <%# Eval("Name") %>
                                        (
                                            <asp:LinkButton ID="OwnerLinkButton" runat="server" Text='<%# GetOwnerInfo(Eval("ActivityId")) %>'
                                                CommandName="ViewOwner"
                                                CommandArgument='<%# Eval("ActivityId") %>'></asp:LinkButton>
                                        )
                                    </p>
                                </div>
                            </div>
                            <div class="row m-b-20">
                                <asp:Panel runat="server" ID="emptyMessage" class="col-md-11 col-md-offset-1 m-t-5" Visible="false">
                                    This activity does not have any objects. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above
                                </asp:Panel>
                                <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                    <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" OwnerType="ACTIVITY" />
                                </asp:Panel>
                                <asp:Panel runat="server" ID="detailsContainer" class="col-md-111 m-t-5" Visible="false">
                                    This activity has 
                                    <asp:LinkButton ID="KpisButton" runat="server" Visible="false"></asp:LinkButton>
                                </asp:Panel>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# ActivityRepeater.Items.Count == 0 %>'>
                                <div class="col-md-12 text-center">
                                    -- There are no Activities registered. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above --
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
                                element="#OrganizationList .editBtn:first" />
                            <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                content="<%$ Resources: ActivitiesList, TourStep3 %>"
                                element="#OrganizationList .detailsBtn:first" />
                            <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                content="<%$ Resources: ActivitiesList, TourStep4 %>"
                                element="#OrganizationList .shareBtn:first" />
                            <app:TourItem title="<%$ Resources: ActivitiesList, TourStepTitle %>"
                                content="<%$ Resources: ActivitiesList, TourStep5 %>"
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
    <asp:ObjectDataSource ID="ActivityObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActivitiesBySearch" TypeName="Artexacta.App.Activities.BLL.ActivityBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActivitySearchControl" PropertyName="Sql" Name="whereClause" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
</asp:Content>

