<%@ Page Title="KPI Tool" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="MainPage.aspx.cs" Inherits="MainPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="App_Themes/Default/09_search.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="page-header">
                <div class="row">
                    <div class="col-md-1">
                        <app:AddButton ID="TheAddButton" runat="server" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-8 col-md-offset-3">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="OrganizationsPanel" runat="server" CssClass="container">
        <div class="row">
            <div class="col-md-12">
                
            </div>
        </div>
    </asp:Panel>
</asp:Content>

