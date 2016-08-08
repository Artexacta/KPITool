<%@ Page Title="<%$ Resources:UserData, PageTitlePassword %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ChangePassword.aspx.cs" Inherits="Security_ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .validation{
            color: red;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="ChangePassword" runat="server" Text="<%$ Resources:UserData, PageTitlePassword %>" CssClass="title"></asp:Label>
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-6">
                    <asp:ChangePassword ID="ChangePassword1" runat="server" ContinueDestinationPageUrl="~/Organization/ListOrganizations.aspx" Width="100%"  
                        OnCancelButtonClick="ChangePassword1_CancelButtonClick" ChangePasswordFailureText="<%$ Resources:UserData, PasswordRegularExpressionValidator %>">
                        <ChangePasswordTemplate>
                            <div class="form-group">
                                <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword" Text="<%$ Resources:UserData, PasswordLabel %>"></asp:Label>
                                <asp:TextBox ID="CurrentPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RequiredFieldValidator ID="CurrentRequiredFieldValidator" runat="server" Display="Dynamic" ControlToValidate="CurrentPassword" 
                                        ErrorMessage="<%$ Resources:UserData, PasswordRequired %>" ValidationGroup="ChangePassword" />
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword" Text="<%$ Resources:UserData, NewPasswordLabel %>"></asp:Label>
                                <asp:TextBox ID="NewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RequiredFieldValidator ID="NewPasswordRequiredFieldValidator" runat="server" Display="Dynamic" ControlToValidate="NewPassword" 
                                        ErrorMessage="<%$ Resources:UserData, NewPasswordRequiredFieldValidator %>" ValidationGroup="ChangePassword" />
                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="CurrentPassword" Display="Dynamic" 
                                        ControlToValidate="NewPassword" ErrorMessage="La nueva contraseña no debe ser igual a la contraseña actual." Operator="NotEqual" />
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="ConfirmNewPasswordLabel" runat="server" Text="<%$ Resources:UserData, ConfirmPasswordLabel %>"></asp:Label>
                                <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" Display="Dynamic"
                                        ErrorMessage="<%$ Resources:UserData, ConfirmPasswordRequired %>" ValidationGroup="ChangePassword" />
                                    <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" Display="Dynamic"
                                        ControlToValidate="ConfirmNewPassword" ErrorMessage="<%$ Resources:UserData, PasswordCompareValidator %>" />
                                </div>
                            </div>
                            <div class="validation">
                                <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                            </div>
                            <div class="text-center" style="margin-top: 15px;">
                                <asp:LinkButton ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" ValidationGroup="ChangePassword"  
                                    CssClass="btn btn-primary" Text="<%$ Resources:UserData, ChangePasswordButton %>">
                                </asp:LinkButton>
                                <asp:LinkButton ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel"
                                    CssClass="btn btn-danger" Text="<%$ Resources:UserData, CancelButton %>">
                                </asp:LinkButton>
                            </div>
                        </ChangePasswordTemplate>
                        <SuccessTemplate>
                            <asp:Label ID="PasswordChangedLabel" runat="server" Text="<%$ Resources:UserData, PasswordChangedLabel %>"></asp:Label>
                            <br />
                            <asp:LinkButton ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue" 
                                CssClass="button" Text="<%$ Resources:UserData, ContinuePushButton %>">
                            </asp:LinkButton>
                        </SuccessTemplate>
                    </asp:ChangePassword>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

