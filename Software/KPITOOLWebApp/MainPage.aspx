﻿<%@ Page Title="FRTWB" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="MainPage.aspx.cs" Inherits="MainPage" %>

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
                        <asp:Panel ID="SearchPanel" runat="server" CssClass="input-group" >
                            <%--<asp:TextBox ID="SearchTextBox" runat="server" CssClass="form-control" placeholder="Search..."></asp:TextBox>                            
                            <span class="input-group-addon last">
                                <asp:LinkButton ID="SearchButton" runat="server" Style="color: #000" OnClick="SearchButton_Click">
                                    <i class="zmdi zmdi-search"></i>
                                </asp:LinkButton>
                                <asp:ImageButton ID="SearchImageButton" runat="server" OnClick="SearchButton_Click"
                                    ImageUrl="~/Images/Neutral/pixel.gif" Style="display: none" /></span>--%>
                             <%--<app:SearchControl ID="OrganizationSearchControl" runat="server" />--%>
                        </asp:Panel>
                    </div>
                </div>

                <%--<div class="dropdown">
                    <a id="btn-behavior" href="javascript:openModal();" style="font-size: 45px; text-decoration: none; color: #000000"><i id="addIcon" runat="server" class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i></a>
                    <ul class="dropdown-menu pull-left">
                        <li role="presentation">
                            <a role="menuitem" tabindex="-1"  href="#" onclick="return newOrganization()">Add Organization CTRL+T</a>
                        </li>
                        <li role="presentation">
                            <asp:HyperLink runat="server" role="menuitem" TabIndex="-1" NavigateUrl="~/Project/ProjectForm.aspx">Add Project CTRL+T</asp:HyperLink>
                        </li>
                        <li role="presentation">
                            <asp:HyperLink ID="HyperLink2" runat="server" role="menuitem" TabIndex="-1" NavigateUrl="~/Activity/AddActivity.aspx">Add Activity CTRL+A</asp:HyperLink>
                        </li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="Kpi/KpiForm.aspx">Add KPI CTRL+K</a></li>
                    </ul>
                </div>--%>
            </div>
        </div>
        <div class="col-md-6">
        </div>
    </div>
    <asp:Panel ID="OrganizationsPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">Organizations</div>
                    </div>
                    <div class="t-body tb-padding" id="OrganizationList">
                        <asp:Repeater ID="OrganizationsRepeater" runat="server" OnItemDataBound="OrganizationsRepeater_ItemDataBound"
                            OnItemCommand="OrganizationsRepeater_ItemCommand">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="ViewOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server" 
                                            CssClass="viewBtn detailsBtn" CommandName="ViewOrganization">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="EditOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server" 
                                            CssClass="viewBtn editBtn" CommandName="EditOrganization">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1 disabled">
                                        <asp:LinkButton ID="ShareOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server" 
                                            CssClass="viewBtn shareBtn">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:LinkButton ID="DeleteOrganization" CommandArgument='<%# Eval("OrganizationId") %>' runat="server" 
                                            OnClientClick="return confirm('Are you sure you want to delete selected Organization?')"
                                            CssClass="viewBtn deleteBtn" CommandName="DeleteOrganization">
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="col-md-8">
                                        <p style="font-size: 14px; padding-top: 2px;"><%# Eval("Name") %></p>
                                    </div>
                                </div>
                                <div class="row m-b-15">
                                    <asp:Panel runat="server" ID="emptyMessage" class="col-md-11 col-md-offset-1 m-t-5" Visible="false">
                                        This organization does not have any objects. Create one by clicking on the 
                                        <i class="zmdi zmdi-plus-circle-o" id=""></i> icon above
                                    </asp:Panel>
                                    <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                        <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                    </asp:Panel>
                                    <asp:Panel runat="server" ID="detailsContainer" CssClass="col-md-11 m-t-5" Visible="false">
                                        This organization has 
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

                                        <asp:LinkButton ID="KpisButton" runat="server" Visible="false"
                                            CommandName="ViewKPIs" CommandArgument='<%# Eval("OrganizationId") %>'>
                                        </asp:LinkButton>
                                    </asp:Panel>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# OrganizationsRepeater.Items.Count == 0 %>'>
                                    <h3 class="col-md-12 text-center">No organizations have been defined for you.
                                        At least one organization is needed and you won't be able to create evaluations, projects, actions or KPI's
                                        until at least one organization is available.
                                        You can create an organization by clicking 
                                        <i class="zmdi zmdi-plus-circle-o"></i>
                                        icon above.
                                    </h3>
                                </asp:Panel>
                            </FooterTemplate>
                        </asp:Repeater>
                        <br />
                        <div style="overflow: hidden">
                            <a id="showTourBtn" runat="server" href="#" class="btn btn-default pull-right" clientidmode="Static" style="display: none">
                                Show tips for this page</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:HiddenField ID="ResetTourHiddenField" runat="server" Value="false" />
    <asp:HiddenField ID="ShowTourHiddenField" runat="server" Value="false" />
    <asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
    <asp:PlaceHolder ID="ScriptBlock" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
                if ($("#<%= ResetTourHiddenField.ClientID %>").val() == "true") {
                    var storageKeys = Object.keys(localStorage);
                    for (var i in storageKeys) {
                        var key = storageKeys[i];
                        if (key.indexOf("MainPageTour") >= 0)
                            localStorage.removeItem(key);
                    }
                    $("#<%= ResetTourHiddenField.ClientID %>").val("false");
                }
                showTour();

                $("#showTourBtn").click(function () {
                    var storageKeys = Object.keys(localStorage);
                    for (var i in storageKeys) {
                        var key = storageKeys[i];
                        if (key.indexOf("MainPageTour") >= 0)
                            localStorage.removeItem(key);
                    }
                    $("#<%= ForceShowTour.ClientID %>").val("true");
                    $("#<%= ShowTourHiddenField.ClientID %>").val("true");
                    showTour();
                    return false;
                });
            });

            function showTour() {
                if ($("#<%= ShowTourHiddenField.ClientID %>").val() == "true") {
                    var tour = new Tour({
                        name: "MainPageTour",
                        steps: [
                            {
                                element: "#<%= TheAddButton.ClientID %>",
                                title: "You are in the Organization List page.",
                                content: "At any time you can create new system objects by clicking on this icon. You can create new organizations, evaluations, projects, actions or KPIs from anywhere"
                            }, {
                                element: "#OrganizationList .editBtn:first",
                                title: "You are in the Organization List page.",
                                content: "Organizations, projects and actions have properties that you can set. You can edit the name as well as the properties by clickin on this icon.   You can also add areas to organizations using this icon."
                            }, {
                                element: "#OrganizationList .detailsBtn:first",
                                title: "You are in the Organization List page.",
                                content: "You can view the object page using this icon.  In the object page you can see everything about the object."
                            }, {
                                element: "#OrganizationList .shareBtn:first",
                                title: "You are in the Organization List page.",
                                content: "You can share this organization with other people by clicking on this button"
                            }, {
                                element: "#<%= SearchPanel.ClientID %>",
                                title: "You are in the Organization List page.",
                                content: "You can search using this textbox. You can simply search be entering any text.",
                                placement: "bottom"
                            }
                        ],
                        backdrop: true
                    });

                    // Initialize the tour
                    if ($("#<%= ForceShowTour.ClientID %>").val() == "true") {
                        $("#<%= ForceShowTour.ClientID %>").val("false");
                        tour.init(true);
                    } else
                        tour.init();

                    // Start the tour
                    tour.start();
                    $("#showTourBtn").show();
                    $("#<%= ShowTourHiddenField.ClientID %>").val("false");
                }
            }
        </script>
    </asp:PlaceHolder>
   
</asp:Content>

