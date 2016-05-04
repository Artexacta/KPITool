<%@ Page Title="Organization" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="OrganizationDetails.aspx.cs" Inherits="Organization_OrganizationDetails" %>

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
                <asp:Literal ID="OrganizationNameLiteral" runat="server"></asp:Literal>
            </h1>
        </div>
    </div>

    <!-- Areas -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Areas for Organization</div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <asp:GridView ID="AreasGridView" runat="server" AutoGenerateColumns="False" Width="100%" GridLines="None" 
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="AreasObjectDataSource" DataKeyNames="AreaID" 
                                OnRowDataBound="AreasGridView_RowDataBound" OnRowCommand="AreasGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="View" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Area Name" DataField="Name" ItemStyle-Width="350px" />
                                    <asp:TemplateField HeaderText="KPIs" ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPI Progress" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        There are no Areas registered for this Organization
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Projects -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Project for Organization</div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="ProjectsGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="ProjectObjectDataSource" DataKeyNames="ProjectID" 
                                OnRowDataBound="ProjectsGridView_RowDataBound" OnRowCommand="ProjectsGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="View" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Project Name" DataField="Name" ItemStyle-Width="350px" />
                                    <asp:TemplateField HeaderText="KPIs" ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPI Progress" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        There are no Projects registered for this Organzation
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Activities -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Activities for Organization</div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="ActivitiesGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped m-b-15 i-table tbl-summary" DataSourceID="ActivityObjectDataSource" DataKeyNames="ActivityId" 
                                OnRowDataBound="ActivitiesGridView_RowDataBound" OnRowCommand="ActivitiesGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="View" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Activity Name" DataField="Name" ItemStyle-Width="350px" />
                                    <asp:TemplateField HeaderText="KPIs" ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPI Progress" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        There are no Activities registered for this Organzation
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KPIs -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">KPIs for Organization</div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="KpisGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped m-b-15 i-table tbl-summary" DataSourceID="KPIObjectDataSource" DataKeyNames="KpiID" 
                                OnRowCommand="KpisGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="View" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="KPI Name" DataField="Name" ItemStyle-Width="350px" />
                                    <asp:TemplateField HeaderText="Progress" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <%--<div class="progress">
                                                <div class="progress-bar" role="progressbar" aria-valuenow='<%# Eval("Progress") %>' aria-valuemin="0" aria-valuemax="100"
                                                    style='<%# "width:" + Eval("Progress") + "%" %>'>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <asp:Literal ID="ProgressLiteral" runat="server" Text='<%# Eval("Progress") %>'></asp:Literal>%
                                            </div>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPI Progress" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <%--<app:KpiImage ID="ImageOfKpi" runat="server" KpiId='<%# Eval("KpiID") %>' />--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        There are no KPIs registered for this Organzation
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/MainPage.aspx" Text="Back to Organization list"
                    CssClass="btn btn-primary">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="OrganizationIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="OperationHiddenField" runat="server" />

    <asp:ObjectDataSource ID="AreasObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Area.BLL.AreaBLL" SelectMethod="GetAreasByOrganization" OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" Name="organizationId" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ProjectObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Project.BLL.ProjectBLL" SelectMethod="GetProjectByOrganization" OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" PropertyName="Value" Name="organizationId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ActivityObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Activities.BLL.ActivityBLL" SelectMethod="GetActivitiesByOrganization" 
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" PropertyName="Value" Name="organizationId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="KPIObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.KPI.BLL.KPIBLL" SelectMethod="GetKPIsByOrganization" 
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" PropertyName="Value" Name="organizationId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

