<%@ Page Title="Share Organization" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="ShareOrganization.aspx.cs" Inherits="Organization_ShareOrganization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <app:AddButton ID="TheAddButton" runat="server" />
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal ID="TitleLabel" runat="server" Text="Share Organization" />
            </h1>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h3>
                    <asp:Literal ID="SubtitleLabel" runat="server" Text="You area sharing an Organization: " />
                    <asp:Literal ID="OrganizationNameLiteral" runat="server" />
                </h3>
            </div>
        </div>
    </div>

    <!-- MANAGE -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Who can manage this organization:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div style="border: 1px solid #e8e8e8; padding: 6px 12px; margin-bottom: 20px; ">
                            <label><asp:Literal ID="UserNameText" runat="server" Text="Charles Blanco (chblanco@gmail.com)" /></label>
                            <asp:LinkButton ID="RemoveActivityButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
                                ToolTip="Delete" />
                            <br />
                            <label><asp:Literal ID="Label1" runat="server" Text="Charles Blanco (chblanco@gmail.com)" /></label>
                            <asp:LinkButton ID="LinkButton1" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
                                ToolTip="Delete" />
                            <br />
                            <label><asp:Literal ID="Label2" runat="server" Text="Charles Blanco (chblanco@gmail.com)" /></label>
                            <asp:LinkButton ID="LinkButton2" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
                                ToolTip="Delete" />
                            <br />
                        </div>
                        <asp:LinkButton ID="ManageButton" runat="server" CssClass="btn btn-primary" Text="Invite more people" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CREATE AREA -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Who can create Areas for this organization:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <asp:CheckBox ID="CreateAreaAllCheckBox" runat="server" Text="Everyone" />
                        </div>

                        <asp:LinkButton ID="CreateAreaButton" runat="server" CssClass="btn btn-primary" Text="Invite more people" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CREATE KPI -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Who can create KPIs for this organization:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <asp:CheckBox ID="CreateKPIAllCheckBox" runat="server" Text="Everyone" />
                        </div>

                        <asp:LinkButton ID="CreateKPIButton" runat="server" CssClass="btn btn-primary" Text="Invite more people" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CREATE PROJECT -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Who can create Projects for this organization:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <asp:CheckBox ID="CreateProjectAllCheckBox" runat="server" Text="Everyone" />
                        </div>

                        <asp:LinkButton ID="CreateProjectButton" runat="server" CssClass="btn btn-primary" Text="Invite more people" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CREATE ACTIVITY -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Who can create Activities for this organization:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <asp:CheckBox ID="CreateActivityAllCheckBox" runat="server" Text="Everyone" />
                        </div>

                        <asp:LinkButton ID="CreateActivityButton" runat="server" CssClass="btn btn-primary" Text="Invite more people" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/MainPage.aspx" Text="Back to Organization list"
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="OrganizationIdHiddenField" runat="server" />

</asp:Content>

