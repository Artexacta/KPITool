<%@ Page Title="Error Fatal" Language="C#" MasterPageFile="~/SimpleMasterPage.master" AutoEventWireup="true" 
    CodeFile="FatalError.aspx.cs" Inherits="FatalError" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <h3 class="font-bold">
            <asp:Label ID="FatalErrorLabelTitle" runat="server" CssClass="title" 
                Text="<% $ Resources : FatalError, FatalErrorLabelTitle %>" />
        </h3>
        <div class="error-desc">
            <p>
                <asp:Literal ID="FatalErrorLabel" runat="server" 
                    Text="<% $ Resources : FatalError, FatalErrorLabelText %>"> 
                </asp:Literal>
            </p>
            <p>
                <asp:HyperLink ID="StartHyperLink" runat="server" 
                    NavigateUrl="~/Organization/ListOrganizations.aspx" Text="<% $ Resources : FatalError, StartHyperLinkText %>" ></asp:HyperLink>
            </p>
        </div>
    </div>
</asp:Content>

