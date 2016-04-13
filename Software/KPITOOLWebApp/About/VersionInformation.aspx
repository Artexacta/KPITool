<%@ Page Title="<%$ Resources: VersionInformation, PageTitle %>"
    Language="C#"
    MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="VersionInformation.aspx.cs" Inherits="About_VersionInformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="Label1" runat="server"
                    Text="<%$ Resources: VersionInformation, ChangeHistoryTitle %>"
                    CssClass="title" />
             </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-12">
                    <asp:Literal ID="OnlyInEnglishLabel" runat="server"
                        Text="<%$ Resources: VersionInformation, OnlyInEnglish %>"></asp:Literal>
                    <div class="table-responsive">
                        <asp:Repeater ID="ChangesDataList" runat="server">
                            <HeaderTemplate>
                                <table class="table table-striped table-bordered table-hover" style="width: 100%">
                                    <thead>
                                        <tr class="head">
                                            <th>
                                                <asp:Literal ID="DateLabel" runat="server"
                                                    Text="<%$ Resources: VersionInformation, Date %>"></asp:Literal>
                                            </th>
                                            <th>
                                                <asp:Literal ID="Literal1" runat="server"
                                                    Text="<%$ Resources: VersionInformation, Version %>"></asp:Literal>
                                            </th>
                                            <th>
                                                <asp:Literal ID="Literal2" runat="server"
                                                    Text="<%$ Resources: VersionInformation, Description %>"></asp:Literal>
                                            </th>
                                        </tr>
                                    </thead>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="">
                                    <td>
                                        <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("Date") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="VersionLabel" runat="server" Text='<%# Bind("Version") %>'></asp:Label>
                                    </td>
                                    <td class="alignLeft">
                                        <asp:Literal ID="DescriptionLiteral" runat="server" Text='<%# Bind("Description") %>'></asp:Literal>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="">
                                    <td>
                                        <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("Date") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="VersionLabel" runat="server" Text='<%# Bind("Version") %>'></asp:Label>
                                    </td>
                                    <td class="alignLeft">
                                        <asp:Literal ID="DescriptionLiteral" runat="server" Text='<%# Bind("Description") %>'></asp:Literal>
                                    </td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

