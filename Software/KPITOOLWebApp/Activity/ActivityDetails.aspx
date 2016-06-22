﻿<%@ Page Title="<%$ Resources:DataDetails, PageTitleActivity %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="ActivityDetails.aspx.cs" Inherits="Activity_ActivityDetails" %>

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

    <!-- KPIs -->
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title"><asp:Literal ID="KpisActivityLabel" runat="server" Text="<%$ Resources:DataDetails, KpisActivityLabel %>" /></div>
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
                                            <asp:LinkButton ID="ViewButton" runat="server" CommandName="ViewData">
                                                <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:DataDetails, KPINameColumn %>" HeaderStyle-Width="350px">
                                        <ItemTemplate>
                                            <asp:Label ID="KPINameLabel" runat="server" Text='<%# Eval("Name") %>' /><br />
                                            (<asp:HyperLink ID="OrganizationNameLink" runat="server" Text='<%# Eval("OrganizationName") %>' />
                                            <asp:Label ID="SeparatorArea" runat="server" Text=" - " />
                                            <asp:Label ID="AreaNameLabel" runat="server" Text='<%# Eval("AreaName") %>' CssClass="text-primary" />
                                            <asp:Label ID="SeparatorProject" runat="server" Text=" - " />
                                            <asp:HyperLink ID="ProjectNameLink" runat="server" Text='<%# Eval("ProjectName") %>' />
                                            <asp:Label ID="SeparatorActivity" runat="server" Text=" - " />
                                            <asp:Label ID="ActivityNameLabel" runat="server" Text='<%# Eval("ActivityName") %>' CssClass="text-primary" />
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
                                        <asp:Literal ID="NoKpisActivityLabel" runat="server" Text="<%$ Resources:DataDetails, NoKpisActivityLabel %>" />
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
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Activity/ActivitiesList.aspx" Text="<%$ Resources:DataDetails, ReturnActivityLink %>" 
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="ActivityIdHiddenField" runat="server" />

    <asp:ObjectDataSource ID="KPIObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.KPI.BLL.KPIBLL" SelectMethod="GetKPIsByActivity"
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActivityIdHiddenField" PropertyName="Value" Name="activityId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

