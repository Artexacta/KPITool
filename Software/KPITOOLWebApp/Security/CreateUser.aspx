<%@ Page Title="<%$ Resources:UserData, PageTitleCreate %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CreateUser.aspx.cs" Inherits="Security_CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .formWizard {
            background: none !important;
        }
        .formWizard table {
            background: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="TitleLabel" runat="server" Text="<%$ Resources:UserData, PageTitleCreate %>" CssClass="title"></asp:Label>
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-6">
                    <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" DisplayCancelButton="True" CssClass="formWizard" Width="100%" OnCreatedUser="CreateUserWizard1_CreatedUser" 
                        OnCreatingUser="CreateUserWizard1_CreatingUser" OnCreateUserError="CreateUserWizard1_CreateUserError" OnSendingMail="CreateUserWizard1_SendingMail" 
                        OnSendMailError="CreateUserWizard1_SendMailError" OnCancelButtonClick="CreateUserWizard1_CancelUser" CancelDestinationPageUrl="~/Security/UserList.aspx">
                        <MailDefinition BodyFileName="<%$ Resources: Files, CreateUserEmail %>">
                        </MailDefinition>
                        <WizardSteps>
                            <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                                <ContentTemplate>
                                    <div class="form-group">
                                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="<%$ Resources:UserData, UserNameLabel %>"></asp:Label>
                                        <asp:TextBox ID="UserName" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, UserNameRequired %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:RegularExpressionValidator ID="UserNameRegularExpressionValidator" runat="server" 
                                                Display="Dynamic" ControlToValidate="UserName" ErrorMessage="<%$ Resources:UserData, UserNameRegularExpressionValidator %>" 
                                                ValidationExpression="<%$ Resources:Validations, UserNameFormat %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:CustomValidator ID="ExistsUserNameCustomValidator" runat="server" ErrorMessage="<%$ Resources:UserData, ExistsUserNameCustomValidator %>" 
                                                Display="Dynamic" ValidationGroup="CreateUserWizard1" OnServerValidate="ExistsUserNameCustomValidator_ServerValidate" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="<%$ Resources:UserData, PasswordLabel %>"></asp:Label>
                                        <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, PasswordRequired %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:RegularExpressionValidator ID="PasswordRegularExpressionValidator" runat="server" ControlToValidate="Password" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, PasswordRegularExpressionValidator %>" 
                                                ValidationExpression="<%$ Resources: Validations, PasswordFormat %>" ValidationGroup="CreateUserWizard1" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" Text="<%$ Resources:UserData, ConfirmPasswordLabel %>"></asp:Label>
                                        <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, ConfirmPasswordRequired %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:CompareValidator ID="PasswordCompareValidator" runat="server" ControlToValidate="ConfirmPassword" ControlToCompare="Password" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, PasswordCompareValidator %>" ValidationGroup="CreateUserWizard1" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="FullNameLabel" runat="server" AssociatedControlID="FullNameTextBox" Text="<%$ Resources:UserData, FullNameLabel %>"></asp:Label>
                                        <asp:TextBox ID="FullNameTextBox" runat="server" CssClass="form-control" MaxLength="500"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RequiredFieldValidator ID="FullNameRequired" runat="server" ControlToValidate="FullNameTextBox" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FullNameRequired %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:RegularExpressionValidator ID="FormatNombreRegularExpressionValidator" runat="server" ControlToValidate="FullNameTextBox" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FormatNombreRegularExpressionValidator %>" 
                                                ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>" ValidationGroup="CreateUserWizard1" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" Text="<%$ Resources:UserData, EmailLabel %>"></asp:Label>
                                        <asp:TextBox ID="Email" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, EmailRequired %>" ValidationGroup="CreateUserWizard1" />
                                            <asp:RegularExpressionValidator ID="FormatEmailRegularExpressionValidator" runat="server" ControlToValidate="Email" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FormatEmailRegularExpressionValidator %>" ValidationGroup="CreateUserWizard1" 
                                                ValidationExpression="<%$ Resources: Validations, EmailFormat %>" />
                                            <asp:CustomValidator ID="ExistsEmailCustomValidator" runat="server" ErrorMessage="<%$ Resources:UserData, ExistsEmailCustomValidator %>" 
                                                Display="Dynamic" ValidationGroup="CreateUserWizard1" OnServerValidate="ExistsEmailCustomValidator_ServerValidate" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="AddressLabel" runat="server" Text="<%$ Resources:UserData, AddressLabel %>" AssociatedControlID="AddressTextBox"></asp:Label>
                                        <asp:TextBox ID="AddressTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RegularExpressionValidator ID="DireccionFormatRegularExpressionValidator" runat="server" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, DireccionFormatRegularExpressionValidator %>" ControlToValidate="AddressTextBox" 
                                                ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>" ValidationGroup="CreateUserWizard1" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="CellPhoneLabel" runat="server" Text="<%$ Resources:UserData, CellPhoneLabel %>" AssociatedControlID="CellPhoneTextBox"></asp:Label>
                                        <asp:TextBox ID="CellPhoneTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                        <div class="has-error m-b-10">
                                            <asp:RegularExpressionValidator ID="PhoneFormatRegularExpressionValidator" runat="server" ControlToValidate="CellPhoneTextBox" 
                                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, PhoneFormatRegularExpressionValidator %>" ValidationGroup="CreateUserWizard1" 
                                                ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="PhoneLabel" runat="server" AssociatedControlID="NumeroTextBox" Text="<%$ Resources:UserData, PhoneLabel %>"></asp:Label>
                                        <div class="row">
                                            <div class="col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="PaisAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="<%$ Resources:UserData, PaisAreaTextBox %>"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="PaisFormatRegularExpressionValidator" runat="server" ControlToValidate="PaisAreaTextBox" 
                                                    ErrorMessage="<%$ Resources:UserData, PaisFormatRegularExpressionValidator %>" ValidationGroup="CreateUserWizard1" 
                                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                                            </div>
                                            <div class="col-md-3 col-sm-3 col-xs-3">
                                                <asp:TextBox ID="CiudadAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="<%$ Resources:UserData, CiudadAreaTextBox %>"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="AreaFormatRegularExpressionValidator" runat="server" ControlToValidate="CiudadAreaTextBox" 
                                                    ErrorMessage="<%$ Resources:UserData, AreaFormatRegularExpressionValidator %>" ValidationGroup="CreateUserWizard1" 
                                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <asp:TextBox ID="NumeroTextBox" runat="server" CssClass="form-control min-letter" MaxLength="12" placeholder="<%$ Resources:UserData, NumeroTextBox %>"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="NumeroFormatRegularExpressionValidator" runat="server" ControlToValidate="NumeroTextBox" 
                                                    ErrorMessage="<%$ Resources:UserData, NumeroFormatRegularExpressionValidator %>" ValidationGroup="CreateUserWizard1" 
                                                    ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" Display="Dynamic" />
                                            </div>
                                        </div>
                                    </div>
                                </ContentTemplate>
                                <CustomNavigationTemplate>
                                    <div class="text-center" style="margin-top: 15px;">
                                        <asp:LinkButton ID="StepNextButton" runat="server" CommandName="MoveNext" CssClass="btn btn-primary"
                                            ValidationGroup="CreateUserWizard1" Text="<%$ Resources:UserData, StepNextButton %>">
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                                            CssClass="btn btn-danger" ValidationGroup="CreateUserWizard1" Text="<%$ Resources:UserData, CancelButton %>">
                                        </asp:LinkButton>
                                    </div>
                                </CustomNavigationTemplate>
                            </asp:CreateUserWizardStep>
                            <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                                <ContentTemplate>
                                    <asp:Label ID="CreatedUserLabel" runat="server" Text="<%$ Resources:UserData, CreatedUserLabel %>"></asp:Label><br />
                                    <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Security/UserList.aspx" Text="<%$ Resources:UserData, PageTitleList %>" CssClass="linkButton" />
                                </ContentTemplate>
                            </asp:CompleteWizardStep>
                        </WizardSteps>
                        <CancelButtonStyle CssClass="btn btn-danger"></CancelButtonStyle>
                    </asp:CreateUserWizard>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="FullNameHiddenField" runat="server" />

</asp:Content>

