<%@ Page Title="<% $ Resources : LoginGlossary, NotAuthorizedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" AutoEventWireup="true"
    CodeFile="NotAuthorized.aspx.cs" Inherits="Authentication_NotAuthorized" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <h1><i class="fa fa-user-secret"></i></h1>
        <h3 class="font-bold">
            <asp:Label ID="NotAuthorizedTitleLabel" runat="server" CssClass="title" Text="<% $ Resources : LoginGlossary, NotAuthorizedTitle %>" /></h3>

        <div class="error-desc">
            <p>
                <asp:Literal ID="NotAuthorizedLabel" runat="server" Text="<% $ Resources : LoginGlossary, NotAuthorizedMessage %>"> 
                </asp:Literal>
            </p>
            <p>
                <asp:HyperLink ID="StartHyperLink" runat="server" NavigateUrl="~/MainPage.aspx" CssClass="btn btn-primary m-t"
                    Text="<% $ Resources : FatalError, StartHyperLinkText %>">
                </asp:HyperLink>
            </p>
        </div>
    </div>
</asp:Content>

