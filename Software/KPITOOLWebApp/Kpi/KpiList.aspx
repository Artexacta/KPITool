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
                    <div class="col-md-8 col-md-offset-3">
                        <asp:Panel ID="Panel1" runat="server" CssClass="input-group" DefaultButton="SearchImageButton">
                            <asp:TextBox ID="SearchTextBox" runat="server" CssClass="form-control" placeholder="Search..."></asp:TextBox>
                            <div class="input-group-addon last" style="cursor: pointer">

                                <a class="dropdown-toggle" id="advanced-search" style="color: #000; display: block">
                                    <i class="zmdi zmdi-chevron-down" id="advanced-search-icon"></i>
                                </a>
                                <div id="advanced-search-panel" class="dropdown-menu col-md-12" style="padding: 10px">
                                    <div style="font-size: 12px;" class="m-b-5">Owner</div>
                                    <telerik:RadComboBox ID="ObjectsComboBox" runat="server"
                                        Width="100%"
                                        Filter="Contains"
                                        DataValueField="UniqueId"
                                        DataTextField="Name"
                                        OnClientSelectedIndexChanged="onObjectSelected"
                                        BorderColor="Transparent"
                                        EmptyMessage="-- Select an Object --">
                                        <HeaderTemplate>
                                            <ul>
                                                <li class="radcol">Name</li>
                                                <li class="radcol">Type</li>
                                            </ul>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <ul>
                                                <li class="radcol">
                                                    <%# DataBinder.Eval(Container.DataItem, "Name") %>
                                                </li>
                                                <li class="radcol">
                                                    <%# DataBinder.Eval(Container.DataItem, "Type") %>
                                                </li>
                                            </ul>
                                        </ItemTemplate>
                                    </telerik:RadComboBox>
                                    <div class="text-right">
                                        <a href="#" id="clearSelection" style="display: none; font-size: 9px">Clear selection</a>
                                    </div>
                                </div>
                            </div>
                            <span class="input-group-addon last">
                                <asp:LinkButton ID="SearchButton" runat="server" Style="color: #000" OnClick="SearchButton_Click">
                                    <i class="zmdi zmdi-search"></i>
                                </asp:LinkButton>
                                <asp:ImageButton ID="SearchImageButton" runat="server" OnClick="SearchButton_Click"
                                    ImageUrl="~/Images/Neutral/pixel.gif" Style="display: none" />
                            </span>
                        </asp:Panel>
                        <asp:Label ID="OwnerObjectLabel" runat="server" Style="font-size: 10px"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
        </div>
    </div>

    <asp:Panel ID="KpisPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">KPIs</div>
                    </div>
                    <div class="t-body tb-padding">
                        <asp:Repeater ID="KpisRepeater" runat="server"
                            OnItemCommand="KpisRepeater_ItemCommand">
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
                                        <asp:LinkButton ID="ListValuesKpi" data-id='<%# Eval("ObjectId") %>'  CssClass="viewBtn" CommandArgument='<%# Eval("ObjectId") %>' OnClick="ListValuesKpi_Click" CommandName="ListValuesKpi" runat="server"><i class="zmdi zmdi-format-list-bulleted zmdi-hc-fw"></i></asp:LinkButton>
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

                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#clearSelection").click(function () {
                $find("<%= ObjectsComboBox.ClientID %>").clearSelection();
                $("#clearSelection").hide();
                return false;
            });
            $(".rcbArrowCellRight a").html("V");

            $("#advanced-search").click(function () {
                if ($("#advanced-search-panel").is(":visible")) {
                    $("#advanced-search-panel").slideUp(500, function () { $("#advanced-search-icon").removeClass("zmdi-chevron-up").addClass("zmdi-chevron-down"); });
                } else {
                    $("#advanced-search-panel").slideDown(500, function () { $("#advanced-search-icon").removeClass("zmdi-chevron-down").addClass("zmdi-chevron-up"); });
                }

            });

        });
        $telerik.$(document).ready(function () {
            if ($find("<%= ObjectsComboBox.ClientID %>").get_value() != "")
                $("#clearSelection").show();
        });

        function onObjectSelected(sender, args) {
            $("#clearSelection").show();
        }

    </script>

</asp:Content>

