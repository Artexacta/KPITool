<%@ Page Title="Activity" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DetailActivity.aspx.cs" Inherits="Activity_DetailActivity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
                <asp:Literal ID="ActivityNameLiteral" runat="server"></asp:Literal>
            </h1>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-header">
                <div class="th-title">Kpis for Activity</div>
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
                                    There are no Kpis registered for this Activity
                                </p>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField HeaderText="View">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="ViewButton" runat="server" CommandName="Select" OnClick="ViewButton_Click">
                                            <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="KPI Name" DataField="Name" />
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
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Activity/ActivitiesList.aspx"
                            CssClass="btn btn-primary">
                            Back to Activity List
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="ActivityIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
    <asp:HiddenField ID="OperationHiddenField" runat="server" />
</asp:Content>

