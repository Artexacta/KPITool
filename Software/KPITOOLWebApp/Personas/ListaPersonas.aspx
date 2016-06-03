<%@ Page Title="Lista de Personas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ListaPersonas.aspx.cs" Inherits="Personas_ListaPersonas" %>

<%@ Register Src="../UserControls/SearchUserControl/SearchControl.ascx" TagName="SearchControl" TagPrefix="uc1" %>

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
    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="t-header">
                    <div class="th-title">People</div>
                </div>
                <div class="t-body tb-padding">
                    <app:SearchControl ID="PeopleSearchControl" runat="server"
                        Title="Búsqueda"
                        DisplayHelp="true"
                        DisplayContextualHelp="true"
                        CssSearch="CSearch"
                        CssSearchHelp="CSearchHelpPanel"
                        CssSearchError="CSearchErrorPanel"
                        SavedSearches="true" SavedSearchesID="PeopleSavedSearch"
                        ImageHelpUrl="Images/Neutral/Help.png"
                        ImageErrorUrl="~/images/exclamation.png" />
                </div>
                <div class="t-body tb-padding" id="ActivityList">
                    <asp:Repeater ID="PeopleRepeater" runat="server" DataSourceID="PersonaObjectDataSource" OnItemCommand="PeopleRepeater_ItemCommand"
                        OnItemDataBound="PeopleRepeater_ItemDataBound" >
                        <ItemTemplate>
                            <div class="row">
                                <div class="col-md-1">
                                    <asp:LinkButton ID="ViewPerson" CommandArgument='<%# Eval("PersonID") %>' runat="server" CssClass="viewBtn detailsBtn"
                                        CommandName="ViewPerson">
                                        <i class="zmdi zmdi-eye zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="EditPerson" CommandArgument='<%# Eval("PersonID") %>' runat="server" CssClass="viewBtn editBtn"
                                        CommandName="EditPerson">
                                        <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1 disabled">
                                    <asp:LinkButton ID="SharePerson" CommandArgument='<%# Eval("PersonID") %>' runat="server" CssClass="viewBtn shareBtn">
                                        <i class="zmdi zmdi-share zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-1">
                                    <asp:LinkButton ID="DeletePerson" CommandArgument='<%# Eval("PersonID") %>' runat="server" CssClass="viewBtn deleteBtn"
                                        CommandName="DeletePerson"
                                        OnClientClick="return confirm('Are you sure you want to delete selected person?')">   
                                        <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-8">
                                    <p style="font-size: 14px; padding-top: 2px;">
                                        <%# Eval("Name") %>
                                        (
                                            <asp:LinkButton ID="OwnerLinkButton" runat="server" Text='<%# GetOwnerInfo(Eval("PersonID")) %>'
                                                CommandName="ViewOwner"
                                                CommandArgument='<%# Eval("PersonID") %>'></asp:LinkButton>
                                        )
                                    </p>
                                </div>
                            </div>
                            <%--<div class="row m-b-20">
                                <asp:Panel runat="server" ID="emptyMessage" class="col-md-11 col-md-offset-1 m-t-5" Visible="false">
                                    This person does not have any objects. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above
                                </asp:Panel>
                                <asp:Panel ID="KpiImageContainer" runat="server" CssClass="col-md-1 m-t-5" Visible="false">
                                    <app:KpiImage ID="ImageOfKpi" runat="server" Visible="false" OwnerType="ACTIVITY" />
                                </asp:Panel>
                                <asp:Panel runat="server" ID="detailsContainer" class="col-md-111 m-t-5" Visible="false">
                                    This person has 
                                    <asp:LinkButton ID="KpisButton" runat="server" Visible="false"></asp:LinkButton>
                                </asp:Panel>
                            </div>--%>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# PeopleRepeater.Items.Count == 0 %>'>
                                <div class="col-md-12 text-center">
                                    -- There are no person registered. Create one by clicking on the <i class="zmdi zmdi-plus-circle-o"></i>icon above --
                                </div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>

                </div>
            </div>
        </div>
    </div>

    <asp:ObjectDataSource ID="PersonaObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.People.BLL.PeopleBLL" SelectMethod="GetPeopleBySearch" OnSelected="PersonaObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="PeopleSearchControl" Name="whereClause" PropertyName="Sql"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

