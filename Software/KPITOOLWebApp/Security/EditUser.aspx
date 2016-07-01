<%@ Page Title="<%$ Resources:UserData, PageTitleEdit %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="EditUser.aspx.cs" Inherits="Security_EditUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="EditLabel" runat="server" Text="<%$ Resources:UserData, PageTitleEdit %>" CssClass="title"></asp:Label>
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label ID="UsernameTitLabel" runat="server" Text="<%$ Resources:UserData, UserNameLabel %>"></asp:Label>
                        <asp:TextBox ID="UsernameLabel" runat="server" Font-Bold="True" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="FullNameLabel" runat="server" Text="<%$ Resources:UserData, FullNameLabel %>"></asp:Label>
                        <asp:TextBox ID="FullNameTextBox" runat="server" CssClass="form-control" MaxLength="500"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="FullNameRequired" runat="server" ControlToValidate="FullNameTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FullNameRequired %>" ValidationGroup="EditUser" />
                            <asp:RegularExpressionValidator ID="FormatNombreRegularExpressionValidator" runat="server" ControlToValidate="FullNameTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FormatNombreRegularExpressionValidator %>" 
                                ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>" ValidationGroup="EditUser" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="EmailLabel" runat="server" Text="<%$ Resources:UserData, EmailLabel %>"></asp:Label>
                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="EmailTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, EmailRequired %>" ValidationGroup="EditUser" />
                            <asp:RegularExpressionValidator ID="FormatEmailRegularExpressionValidator" runat="server" ControlToValidate="EmailTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FormatEmailRegularExpressionValidator %>" ValidationGroup="EditUser" 
                                ValidationExpression="<%$ Resources: Validations, EmailFormat %>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="AddressLabel" runat="server" Text="<%$ Resources:UserData, AddressLabel %>"></asp:Label>
                        <asp:TextBox ID="AddressTextBox" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RegularExpressionValidator ID="DireccionFormatRegularExpressionValidator" runat="server" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, DireccionFormatRegularExpressionValidator %>" ControlToValidate="AddressTextBox" 
                                ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>" ValidationGroup="EditUser" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="CellLabel" runat="server" Text="<%$ Resources:UserData, CellPhoneLabel %>"></asp:Label>
                        <asp:TextBox ID="CellPhoneTextBox" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RegularExpressionValidator ID="PhoneFormatRegularExpressionValidator" runat="server" ControlToValidate="CellPhoneTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, PhoneFormatRegularExpressionValidator %>" ValidationGroup="EditUser" 
                                ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="PhoneLabel" runat="server" Text="<%$ Resources:UserData, PhoneLabel %>"></asp:Label>
                        <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-3">
                                <asp:TextBox ID="PaisAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="<%$ Resources:UserData, PaisAreaTextBox %>"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="PaisFormatRegularExpressionValidator" runat="server" ControlToValidate="PaisAreaTextBox" 
                                    ErrorMessage="<%$ Resources:UserData, PaisFormatRegularExpressionValidator %>" ValidationGroup="EditUser" 
                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-3">
                                <asp:TextBox ID="CiudadAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="<%$ Resources:UserData, CiudadAreaTextBox %>"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="AreaFormatRegularExpressionValidator" runat="server" ControlToValidate="CiudadAreaTextBox" 
                                    ErrorMessage="<%$ Resources:UserData, AreaFormatRegularExpressionValidator %>" ValidationGroup="EditUser" 
                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-6">
                                <asp:TextBox ID="NumeroTextBox" runat="server" CssClass="form-control min-letter" MaxLength="12" placeholder="<%$ Resources:UserData, NumeroTextBox %>"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="NumeroFormatRegularExpressionValidator" runat="server" ControlToValidate="NumeroTextBox" 
                                    ErrorMessage="<%$ Resources:UserData, NumeroFormatRegularExpressionValidator %>" ValidationGroup="EditUser" 
                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                            </div>
                        </div>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SaveButton" runat="server" ValidationGroup="EditUser" CssClass="btn btn-primary" 
                            Text="<%$ Resources:UserData, SaveButton %>" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CssClass="btn btn-danger" 
                            Text="<%$ Resources:UserData, CancelButton %>" OnClick="CancelButton_Click">
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="UsernameHiddenField" runat="server" />
    <asp:HiddenField ID="UserIdHiddenField" runat="server" />
    <asp:HiddenField ID="EmailHiddenField" runat="server" />
    <asp:HiddenField ID="MyAccountHiddenField" runat="server" Value="false" />

</asp:Content>

