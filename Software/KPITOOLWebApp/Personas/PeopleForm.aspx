<%@ Page Title="<% $Resources: People, LabelPeople %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PeopleForm.aspx.cs" Inherits="Personas_PeopleForm" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">
                    <asp:Literal ID="TitleLiteral" runat="server" Text="<% $Resources: People, TitleCreatePerson %>"></asp:Literal>
                </div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">
                        <label>
                            <asp:Label ID="Label1" runat="server" Text="<% $Resources: People, LabelDocIdentification %>"></asp:Label>
                            <span class="label label-danger">
                                <asp:Label ID="ReqLabel" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label></span></label>
                        <asp:TextBox ID="CodeTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: People, LabelEnterCode %>" MaxLength="50"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="CodeRequiredFieldValidator" runat="server" ControlToValidate="CodeTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: People, MessageCodeRequired %>">
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="CodeFormatRegularExpressionValidator" runat="server" ControlToValidate="CodeTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: People, MessageCodeFormat %>"
                                ValidationExpression="<% $Resources: Validations, CodeFormat %>"></asp:RegularExpressionValidator>
                        </div>

                        <label>
                            <asp:Label ID="NameLabel" runat="server" Text="<% $Resources: People, LabelName %>"></asp:Label>
                            <span class="label label-danger">
                                <asp:Label ID="Req1Label" runat="server" Text="<% $Resources: Glossary, RequiredLabel %>"></asp:Label>
                            </span>
                        </label>
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: People, LabelEnterName %>" MaxLength="200"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" ControlToValidate="NameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: People, MessageNameRequired %>">
                            </asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="NameFormatRegularExpressionValidator" runat="server" ControlToValidate="NameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="<% $Resources: People, MessageNameFormat %>"
                                ValidationExpression="<% $Resources: Validations, NameFormat %>"></asp:RegularExpressionValidator>
                        </div>

                        <uc1:AddDataControl ID="DataControl" runat="server" />

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">

                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="<% $Resources: Glossary, GenericSaveLabel %>"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="<% $Resources: People, LabelBackPeople %>"
                            OnClick="CancelButton_Click"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="PersonIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
</asp:Content>

