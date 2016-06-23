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
            <div class="col-md-6">
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">KPIs</div>
                    </div>
                    <div class="t-body tb-padding">
                        <app:SearchControl ID="KPISearchControl" runat="server"
                            Title="Búsqueda"
                            DisplayHelp="true"
                            DisplayContextualHelp="true"
                            CssSearch="CSearch"
                            CssSearchHelp="CSearchHelpPanel"
                            CssSearchError="CSearchErrorPanel"
                            SavedSearches="true" SavedSearchesID="KPISavedSearch"
                            ImageHelpUrl="Images/Neutral/Help.png"
                            ImageErrorUrl="~/images/exclamation.png" />
                    </div>
                    <div class="t-body tb-padding">
                        <div class="table-responsive">
                            <br />
                            <asp:GridView ID="KpisGridView" runat="server" DataSourceID="KPIListObjectDataSource" AutoGenerateColumns="false"
                                OnRowCommand="KpisGridView_RowCommand" CssClass="table table-striped table-bordered table-hover">
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ViewKpi" CommandArgument='<%# Eval("KpiID") %>' runat="server" CssClass="viewBtn"
                                                CommandName="ViewKpi"><i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="EditKpi" CommandArgument='<%# Eval("KpiID") %>' runat="server" CssClass="viewBtn"
                                                CommandName="EditKpi">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ShareKpi" CommandArgument='<%# Eval("KpiID") %>' runat="server" CssClass="viewBtn"
                                                CommandName="ShareKpi">
                                            <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteKpi" CommandArgument='<%# Eval("KpiID") %>' CommandName="DeleteKpi" runat="server"
                                                CssClass="viewBtn" OnClientClick="return confirm('Are you sure you want to delete the selected KPI?')">
                                            <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ListValuesKpi" CssClass="viewBtn" CommandArgument='<%# Eval("KpiID") %>' CommandName="ListValuesKpi"
                                                runat="server"><i class="zmdi zmdi-format-list-bulleted zmdi-hc-fw"></i></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<% $Resources: Kpi, LabelName %>">
                                        <ItemTemplate>
                                            <p style="font-size: 14px; padding-top: 2px;">
                                                <%# Eval("Name") %>
                                                <br />
                                                <asp:LinkButton ID="OrganizationLinkButton" runat="server" Text='<%# GetOrganizationInfo(Eval("OrganizationID")) %>'
                                                    CommandName="ViewOrganization"
                                                    CommandArgument='<%# Eval("OrganizationID") %>'>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="AreaLinkButton" runat="server" Text='<%# GetAreaInfo(Eval("AreaID")) %>'
                                                    CommandName="ViewArea"
                                                    CommandArgument='<%# Eval("AreaID") %>'>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="ProjectLinkButton" runat="server" Text='<%# GetProjectInfo(Eval("ProjectID")) %>'
                                                    CommandName="ViewProject"
                                                    CommandArgument='<%# Eval("ProjectID") %>'>
                                                </asp:LinkButton>
                                            </p>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Progress" HeaderStyle-Width="150px">
                                        <ItemTemplate>
                                            <div class="progress">
                                                <div class='<%# Eval("ProgressClass") %>' role="progressbar" aria-valuenow='<%# Eval("Progress") %>' aria-valuemin="0" aria-valuemax="100"
                                                    style='<%# "width:" + Eval("Progress") + "%" %>'>
                                                    60%
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <asp:Literal ID="ProgressLiteral" runat="server" Text='<%# Eval("Progress") %>'></asp:Literal>%
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Trend" HeaderStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:Label ID="EqualLabel" runat="server" CssClass="glyphicon glyphicon-minus text-primary" Style="font-size: 12pt;"
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) == 0 %>' />
                                            <asp:Label ID="ArrowUpLabel" runat="server" CssClass="glyphicon glyphicon-arrow-up text-success" Style="font-size: 12pt;"
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) > 0 %>' />
                                            <asp:Label ID="ArrowDownLabel" runat="server" CssClass="glyphicon glyphicon-arrow-down text-danger" Style="font-size: 12pt;"
                                                Visible='<%# Convert.ToDecimal(Eval("Trend")) < 0 %>' />
                                            <asp:Literal ID="TrendLiteral" runat="server" Text='<%# Eval("TrendText") %>'></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:ObjectDataSource ID="KPIListObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetKPIsBySearch" TypeName="Artexacta.App.KPI.BLL.KPIBLL" OnSelected="KPIListObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="KPISearchControl" PropertyName="Sql" Name="whereClause" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

