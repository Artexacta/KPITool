<%@ Page Title="<% $Resources: Activity, TitleActivity %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AddActivity.aspx.cs" Inherits="Activity_AddActivity" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="container">


        <div class="tile">
            <div class="t-header">
                <div class="th-title"><asp:Literal ID="TitleLiteral" runat="server" Text="<% $Resources: Activity, TitleCreateActivity %>"></asp:Literal></div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">
                        <label>
                            <asp:Label ID="NameLabel" runat="server" Text="<% $Resources: Activity, LabelName %>"></asp:Label>
                            <span class="label label-danger"><asp:Label ID="RequiredLabel" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:TextBox ID="ActivityNameTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Activity, LabelEnterName %>"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" 
                                ControlToValidate="ActivityNameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: Activity, MessageNameRequired %>">
                            </asp:RequiredFieldValidator>
                        </div>

                        <uc1:AddDataControl ID="AddDataControl" runat="server" />

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="<% $Resources: Glossary, GenericSaveLabel %>"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="<% $Resources: Activity, ButtonBackList %>" OnClick="CancelButton_Click"></asp:LinkButton>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="ActivityIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
</asp:Content>

