<%@ Page Title="Error Fatal" Language="C#" MasterPageFile="~/SimpleMasterPage.master" AutoEventWireup="true" 
    CodeFile="FatalError.aspx.cs" Inherits="FatalError" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
    <div class="oneColumn">
        <div class="columnHead">
            <asp:Label ID="FatalErrorLabelTitle" runat="server" CssClass="title" 
                Text="<% $ Resources : FatalError, FatalErrorLabelTitle %>" />
        </div>
        
        <div class="columnContent">
        
            <asp:Literal ID="FatalErrorLabel" runat="server" 
                Text="<% $ Resources : FatalError, FatalErrorLabelText %>"> 
            </asp:Literal>
            <p>
            
            <asp:HyperLink ID="StartHyperLink" runat="server" 
                NavigateUrl="~/MainPage.aspx"
                Text="<% $ Resources : FatalError, StartHyperLinkText %>" ></asp:HyperLink>
            </p>
            <div class="clear"></div>
        </div>
    </div>
</asp:Content>

