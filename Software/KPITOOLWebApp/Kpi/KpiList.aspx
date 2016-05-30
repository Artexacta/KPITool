<%@ Page Title="KPIs" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiList.aspx.cs" Inherits="Kpi_KpiList" %>

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
                </div>
            </div>
        </div>
        <div class="col-md-6">
        </div>
    </div>

    <asp:Panel ID="KpisPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-6">
            </div>
            <div class="col-md-6">
                <app:SearchControl ID="KPISearchControl" runat="server"
                    Title="Buscar:"
                    DisplayHelp="true"
                    DisplayContextualHelp="true"
                    CssSearch="CSearch"
                    CssSearchHelp="CSearchHelpPanel"
                    CssSearchError="CSearchErrorPanel"
                    SavedSearches="true" SavedSearchesID="KPIList"
                    ImageHelpUrl="Images/Neutral/Help.png"
                    ImageErrorUrl="~/images/exclamation.png" />
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">KPIs</div>
                    </div>
                    <div class="t-body tb-padding">
                        <asp:Repeater ID="KpisRepeater" runat="server" DataSourceID="KPIObjectDataSource" OnItemCommand="KpisRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="row m-b-10">
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="ViewKpi" data-id='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn"
                                            OnClick="ViewKpi_Click">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="EditKpi" data-id='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn"
                                            OnClick="EditKpi_Click">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1 disabled">
                                        <asp:LinkButton ID="ShareKpi" data-id='<%# Eval("ObjectId") %>' runat="server" CssClass="viewBtn"
                                            OnClick="ShareKpi_Click">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="DeleteKpi" data-id='<%# Eval("ObjectId") %>' CommandArgument='<%# Eval("ObjectId") %>'
                                            CommandName="DeleteKpi" runat="server" CssClass="viewBtn"
                                            OnClientClick="return confirm('Are you sure you want to delete the selected KPI?')">
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="ListValuesKpi" data-id='<%# Eval("ObjectId") %>' CssClass="viewBtn" CommandArgument='<%# Eval("ObjectId") %>' OnClick="ListValuesKpi_Click" CommandName="ListValuesKpi" runat="server"><i class="zmdi zmdi-format-list-bulleted zmdi-hc-fw"></i></asp:LinkButton>
                                    </div>
                                    <div class="col-md-7">
                                        <p style="font-size: 14px; padding-top: 2px;">
                                            <%# Eval("Name") %>
                                            (
                                            <asp:LinkButton ID="OwnerLinkButton" runat="server" Text='<%# GetOwnerInfo(Eval("Owner")) %>'
                                                CommandName="ViewOwner"
                                                CommandArgument='<%# Eval("ObjectId") %>'></asp:LinkButton>
                                            )
                                        </p>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# KpisRepeater.Items.Count == 0 %>'>
                                    <div class="col-md-12 text-center">
                                        -- There are no Kpis registered. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above --
                                    </div>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>

                        <br />
                        <%-- <app:TourSettings runat="server" ID="Settings">
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
                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
        <asp:ObjectDataSource ID="KPIObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetKPIBySearch" TypeName="Artexacta.App.KPI.BLL.KPIBLL">
            <SelectParameters>
                <asp:ControlParameter ControlID="KPISearchControl" Name="whereSql" PropertyName="Sql" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </asp:Panel>

</asp:Content>

