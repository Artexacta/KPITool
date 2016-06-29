<%@ Page Title="<%$ Resources:DataDetails, PageTitleOrganization %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
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
                <asp:Literal ID="TitleLabel" runat="server"></asp:Literal>
            </h1>
        </div>
    </div>

    <!-- Areas -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title"><asp:Literal ID="AreasOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, AreasOrganizationLabel %>" /></div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <asp:GridView ID="AreasGridView" runat="server" AutoGenerateColumns="False" Width="100%" GridLines="None" 
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="AreasObjectDataSource" DataKeyNames="AreaID">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, AreaNameColumn %>" HeaderStyle-Width="420px">
                                        <ItemTemplate>
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("Name") %>' /> 
                                            (<asp:Label ID="OrganizationNameLabel" runat="server" Text='<%# Eval("OrganizationName") %>' CssClass="text-primary" />)
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPIs" HeaderStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KpiProgressColumn %>" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" OwnerType="AREA" OwnerId='<%# Eval("AreaID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoAreasOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, NoAreasOrganizationLabel %>" />
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
                <div class="th-title"><asp:Literal ID="ProjectsOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, ProjectsOrganizationLabel %>" /></div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="ProjectsGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="ProjectObjectDataSource" DataKeyNames="ProjectId" 
                                OnRowDataBound="ProjectsGridView_RowDataBound">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ViewColumn %>" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ProjectNameColumn %>" HeaderStyle-Width="350px">
                                        <ItemTemplate>
                                            <asp:Label ID="ProjectNameLabel" runat="server" Text='<%# Eval("Name") %>' /> 
                                            (<asp:Label ID="OrganizationNameLabel" runat="server" Text='<%# Eval("OrganizationName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorArea" runat="server" Text=" - " />
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("AreaName") %>' CssClass="text-primary" />)
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPIs" HeaderStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KpiProgressColumn %>" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" OwnerType="PROJECT" OwnerId='<%# Eval("ProjectID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoProjectsOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, NoProjectsOrganizationLabel %>" />
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
                <div class="th-title"><asp:Literal ID="ActivitiesOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, ActivitiesOrganizationLabel %>" /></div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="ActivitiesGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="ActivityObjectDataSource" DataKeyNames="ActivityId" 
                                OnRowDataBound="ActivitiesGridView_RowDataBound">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ViewColumn %>" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ActivityNameColumn %>" HeaderStyle-Width="350px">
                                        <ItemTemplate>
                                            <asp:Label ID="ActivityNameLabel" runat="server" Text='<%# Eval("Name") %>' /> 
                                            (<asp:Label ID="OrganizationNameLabel" runat="server" Text='<%# Eval("OrganizationName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorArea" runat="server" Text=" - " />
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("AreaName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorProject" runat="server" Text=" - " />
                                            <asp:HyperLink ID="ProjectNameLink" runat="server" Text='<%# Eval("ProjectName") %>'  />)
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPIs" HeaderStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KpiProgressColumn %>" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server" OwnerType="ACTIVITY" OwnerId='<%# Eval("ActivityID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoActivitiesOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, NoActivitiesOrganizationLabel %>" />
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- People -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title"><asp:Literal ID="PeopleOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, PeopleOrganizationLabel %>" /></div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="PeopleGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="PeopleObjectDataSource" DataKeyNames="PersonID" 
                                OnRowDataBound="PeopleGridView_RowDataBound">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ViewColumn %>" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, PersonNameColumn %>" HeaderStyle-Width="350px">
                                        <ItemTemplate>
                                            <asp:Label ID="ProjectNameLabel" runat="server" Text='<%# Eval("Name") %>' /> 
                                            (<asp:Label ID="OrganizationNameLabel" runat="server" Text='<%# Eval("OrganizationName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorArea" runat="server" Text=" - " />
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("AreaName") %>' CssClass="text-primary" />)
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="KPIs" HeaderStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:Label ID="KpiLabel" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) == 0 %>'></asp:Label>
                                            <asp:LinkButton ID="KpiButton" runat="server" Text='<%# Eval("NumberOfKpisForDisplay") %>' Visible='<%# Convert.ToInt32(Eval("NumberOfKpis")) > 0 %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KpiProgressColumn %>" HeaderStyle-Width="140px">
                                        <ItemTemplate>
                                            <app:KpiImage ID="ImageOfKpi" runat="server"  OwnerType="PERSON" OwnerId='<%# Eval("PersonId") %>'  />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoPeopleOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, NoPeopleOrganizationLabel %>" />
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
                <div class="th-title"><asp:Literal ID="KpisOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, KpisOrganizationLabel %>" /></div>
            </div>
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <asp:GridView ID="KpisGridView" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="None"
                                CssClass="table table-striped table-bordered table-hover" DataSourceID="KPIObjectDataSource" DataKeyNames="KpiID" 
                                OnRowDataBound="KpisGridView_RowDataBound" OnRowCommand="KpisGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ViewColumn %>" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData" CommandArgument='<%# Eval("KpiID") %>'>
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KPINameColumn %>" HeaderStyle-Width="350px">
                                        <ItemTemplate>
                                            <asp:Label ID="KPINameLabel" runat="server" Text='<%# Eval("Name") %>' /><br />
                                            (<asp:Label ID="OrganizationNameLabel" runat="server" Text='<%# Eval("OrganizationName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorArea" runat="server" Text=" - " />
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("AreaName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorProject" runat="server" Text=" - " />
                                            <asp:HyperLink ID="ProjectNameLink" runat="server" Text='<%# Eval("ProjectName") %>'  />
                                            <asp:Label ID="SeparatorActivity" runat="server" Text=" - " />
                                            <asp:HyperLink ID="ActivityNameLink" runat="server" Text='<%# Eval("ActivityName") %>'  />
                                            <asp:Label ID="SeparatorPerson" runat="server" Text=" - " />
                                            <asp:HyperLink ID="PersonNameLink" runat="server" Text='<%# Eval("PersonName") %>'  />)
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, ProgressColumn %>" HeaderStyle-Width="100px">
                                        <ItemTemplate>
                                            <div class="progress">
                                                <div class='<%# Eval("ProgressClass") %>' role="progressbar" aria-valuenow='<%# Eval("ProgressText") %>' aria-valuemin="0" aria-valuemax="100"
                                                    style='<%# "width:" + Eval("ProgressText") + "%" %>'>60%
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <asp:Literal ID="ProgressLiteral" runat="server" Text='<%# Eval("ProgressText") %>'></asp:Literal>%
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, TrendColumn %>" HeaderStyle-Width="100px">
                                        <ItemTemplate>
                                            <asp:Label ID="EqualLabel" runat="server" CssClass="glyphicon glyphicon-minus text-primary" style="font-size: 12pt; " 
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) == 0 %>' />
                                            <asp:Label ID="ArrowUpLabel" runat="server" CssClass="glyphicon glyphicon-arrow-up text-success" style="font-size: 12pt; " 
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) > 0 %>' />
                                            <asp:Label ID="ArrowDownLabel" runat="server" CssClass="glyphicon glyphicon-arrow-down text-danger" style="font-size: 12pt; " 
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) < 0 %>' />
                                            <asp:Literal ID="TrendLiteral" runat="server" Text='<%# Eval("TrendText") %>'></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoKpisOrganizationLabel" runat="server" Text="<%$ Resources:DataDetails, NoKpisOrganizationLabel %>" />
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
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/MainPage.aspx" Text="<%$ Resources:DataDetails, ReturnOrganizationLink %>" 
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="OrganizationIdHiddenField" runat="server" />

    <asp:ObjectDataSource ID="AreasObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Area.BLL.AreaBLL" SelectMethod="GetAreasByOrganization" OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" Name="organizationId" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ProjectObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Project.BLL.ProjectBLL" SelectMethod="GetProjectsByOrganization" OnSelected="ObjectDataSource_Selected">
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

    <asp:ObjectDataSource ID="PeopleObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.People.BLL.PeopleBLL" SelectMethod="GetPeopleByOrganization" OnSelected="ObjectDataSource_Selected">
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

