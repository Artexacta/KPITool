<%@ Page Title="KPI Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiDashboard.aspx.cs" Inherits="Kpis_KpiDashboard" %>

<%@ Register Src="~/UserControls/Dashboard/KpiDashboard.ascx" TagName="KpiDashboard" TagPrefix="app" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../Scripts/kpiUtils.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <div class="dropdown">
                    <app:AddButton ID="TheAddButton" runat="server" />
                </div>
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal runat="server" Text="<%$ Resources: KpiDashboard, KpiDashboardTitle %>"></asp:Literal>
            </h1>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-md-12">
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation">
                                <a href="#main-dashboard" aria-controls="main-dashboard" role="tab" data-toggle="tab">
                                    <asp:Literal runat="server" Text="<%$ Resources: KpiDashboard, MainDashboardTitle %>"></asp:Literal>
                                </a>
                            </li>
                            <asp:Repeater ID="UserDashboardRepeater" runat="server">
                                <ItemTemplate>
                                    <li role="presentation">
                                        <asp:HyperLink ID="TabLink" runat="server" NavigateUrl='<%# "#t-" + Eval("DashboardId").ToString() %>'
                                            Text='<%# Eval("Name") %>'
                                            aria-controls='<%# "t-" + Eval("DashboardId").ToString() %>' role="tab" data-toggle="tab">
                                        </asp:HyperLink>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                            <li role="presentation">
                                <a runat="server" href="#" data-toggle="modal" data-target="#myModal" title="<%$ Resources: KpiDashboard, AddDashboard %>">
                                    <i class="fa fa-plus-square"></i>
                                </a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane fade in active" id="main-dashboard">
                                <app:KpiDashboard ID="MainKpiDashboardControl" runat="server" DashboardId="0" />
                            </div>
                            <asp:Repeater ID="UserDashboard2Repeater" runat="server"
                                OnItemCommand="UserDashboard2Repeater_ItemCommand"
                                OnItemDataBound="UserDashboard2Repeater_ItemDataBound">
                                <ItemTemplate>
                                    <asp:Literal ID="HeaderLiteral" runat="server">
                                    </asp:Literal>
                                    <div class="pull-right">
                                        <asp:LinkButton ID="RenameButton" runat="server" CommandArgument='<%# Eval("DashboardId") %>'
                                            CommandName="RenameDashboard" Text="Rename this Dashboard">
                                        </asp:LinkButton>&nbsp;&nbsp;
                                        <asp:LinkButton ID="Delete" runat="server" CommandArgument='<%# Eval("DashboardId") %>'
                                            OnClientClick="return confirm('Are you sure you want delete this Dashboard and its KPIs?')"
                                            CommandName="DeleteDashboard" Text="Delete this Dashboard">
                                        </asp:LinkButton>
                                        
                                    </div>
                                    <app:KpiDashboard ID="UserDashboardControl" runat="server" DashboardId='<%# Eval("DashboardId") %>'
                                        OnKpiDeleted="UserDashboardControl_KpiDeleted" />
                                    <asp:Literal ID="FooterLiteral" runat="server" Text="</div>"></asp:Literal>
                                    
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:ObjectDataSource ID="UserDashboardDataSource" runat="server"
                                TypeName="Artexacta.App.Dashboard.BLL.UserDashboardBLL"
                                SelectMethod="GetUserDashboards"
                                OnSelected="UserDashboardDataSource_Selected">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="UserIdHiddenField" Type="Int32" Name="userId" PropertyName="Value" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </div>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">
                        <asp:Literal ID="ModalTitle" runat="server"></asp:Literal>
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>
                            <asp:Literal runat="server" Text="<%$ Resources: KpiDashboard, DashboardNameLabel %>"></asp:Literal>
                        </label>
                        <asp:TextBox ID="DashboardNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator runat="server" Display="Dynamic"
                        ErrorMessage="<%$ Resources: KpiDashboard, DashboardNameRequiredMessage %>"
                        ControlToValidate="DashboardNameTextBox"
                        ValidationGroup="Dashboard">
                    </asp:RequiredFieldValidator>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <asp:Literal runat="server" Text="<%$ Resources: KpiDashboard, CancelLabel %>"></asp:Literal>
                    </button>
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" OnClick="SaveButton_Click"
                        ValidationGroup="Dashboard">
                        <asp:Literal runat="server" Text="<%$ Resources: KpiDashboard, SaveLabel %>"></asp:Literal>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="SelectedDashboardHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="OpenPopup" runat="server" Value="false" />
    <asp:HiddenField ID="UserIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="CurrentTabIndex" runat="server" Value="0" />
    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#<%= OpenPopup.ClientID %>").val() == "true") {
                $('#myModal').modal();
                $("#<%= OpenPopup.ClientID %>").val("false");
            }

            var index = parseInt($("#<%= CurrentTabIndex.ClientID %>").val()) + 1;
            $('.nav-tabs li:nth-child(' + index + ') a').tab('show');

            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                $(window).resize();
                var index = $(e.target).closest('li').index();
                $("#<%= CurrentTabIndex.ClientID %>").val(index);
            })
        });
    </script>
</asp:Content>

