<%@ Page Title="Manage System" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ResetSystem.aspx.cs" Inherits="ResetSystem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="tile">
                    <div class="t-header">
                        <div class="th-title">Manage System</div>
                    </div>
                    <%--This option will reset entire system deleting all created objects.--%>
                    <div class="t-body tb-padding">
                        <div class="row">
                            <div class="col-md-12">
                                <asp:LinkButton ID="ResetButton" runat="server" OnClick="ResetButton_Click" CssClass="btn btn-primary"
                                    OnClientClick="return confirm('Are you sure you want reset the system?')">
                                    Reset System
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

