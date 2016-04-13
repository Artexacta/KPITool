<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TestTooltip.aspx.cs" Inherits="TestTooltip" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="oneColumn">
        <div class="frame">
            <span class="inlineLabel" title="Este el el tooltip del Label">Nombre</span><br />
            <asp:TextBox ID="Test1TexBox_T" runat="server" CssClass="normalField" ToolTip="Este es el tooltip del campo de texto que se deberia mostrar"></asp:TextBox>
            <span class="label">Edad</span>
            <asp:TextBox ID="Test2TexBox" runat="server" CssClass="normalField" ToolTip="Este es el tooltip del campo de texto que se deberia mostrar"></asp:TextBox>
        </div>
    </div>
</asp:Content>

