<%@ Page Title="Project Details" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ProjectDetails.aspx.cs" Inherits="Project_ProjectDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <app:AddButton ID="TheAddButton" runat="server" />
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal ID="ProjectNameLiteral" runat="server"></asp:Literal>
            </h1>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-header">
                <div class="th-title">Activities for Project</div>
            </div>

            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <asp:GridView ID="ActivitiesGridView" runat="server" AutoGenerateColumns="false"
                            CssClass="table table-striped m-b-15 i-table tbl-summary"
                            GridLines="None"
                            OnRowDataBound="ActivitiesGridView_RowDataBound"
                            DataKeyNames="ObjectId" OnSelectedIndexChanged="ActivitiesGridView_SelectedIndexChanged">
                            <EmptyDataTemplate>
                                <p class="text-center">
                                    There are no Activities registered for this Project
                                </p>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField HeaderText="View">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="ViewActivityButton" runat="server" CommandName="Select" OnClick="ViewActivityButton_Click">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Activity Name" DataField="Name" />
                                <asp:TemplateField HeaderText="KPIs">
                                    <ItemTemplate>
                                        <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumerOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumerOfKpis")) == 0 %>'></asp:Label>
                                        <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumerOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumerOfKpis")) > 0 %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="KPI Progress" HeaderStyle-Width="120px">
                                    <ItemTemplate>
                                        <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-header">
                <div class="th-title">KPIs for Project</div>
            </div>

            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <asp:GridView ID="KpisGridView" runat="server" AutoGenerateColumns="false"
                            CssClass="table table-striped m-b-15 i-table tbl-summary"
                            GridLines="None"
                            DataKeyNames="ObjectId" OnSelectedIndexChanged="KpisGridView_SelectedIndexChanged">
                            <EmptyDataTemplate>
                                <p class="text-center">
                                    There are no KPIs registered for this Project
                                </p>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField HeaderText="View">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="ViewKpiButton" runat="server" CommandName="Select" OnClick="ViewKpiButton_Click">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Project Name" DataField="Name" />
                                <asp:TemplateField HeaderText="Progress">
                                    <ItemTemplate>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" aria-valuenow='<%# Eval("Progress") %>' aria-valuemin="0" aria-valuemax="100"
                                                style='<%# "width:" + Eval("Progress") + "%" %>'>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Literal ID="ProgressLiteral" runat="server" Text='<%# Eval("Progress") %>'></asp:Literal>%
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="KPI Progress" HeaderStyle-Width="120px">
                                    <ItemTemplate>
                                        <app:KpiImage ID="ImageOfKpi" runat="server" KpiId='<%# Eval("ObjectId") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Project/ProjectList.aspx"
                            CssClass="btn btn-primary">
                            Back to Project List
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <asp:HiddenField ID="ProjectIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="OperationHiddenField" runat="server" />
</asp:Content>

