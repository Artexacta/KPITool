<%@ Page Title="<%$ Resources: Credits, PageTitle %>"
    Language="C#"
    MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Credits.aspx.cs" Inherits="About_Credits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="Label1" runat="server" Text="<%$ Resources: Credits, PageTitle %>"
                    CssClass="title"></asp:Label>
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-12">
                    <asp:Literal ID="PoweredByLiteral" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

