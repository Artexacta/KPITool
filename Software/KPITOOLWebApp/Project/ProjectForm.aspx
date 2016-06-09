<%@ Page Title="Project" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ProjectForm.aspx.cs" Inherits="Project_ProjectForm" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">

    <div class="container">


        <div class="tile">
            <div class="t-header">
                <div class="th-title">
                    <asp:Literal ID="TitleLiteral" runat="server"></asp:Literal>
                </div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">

                        <label>Project name <span class="label label-danger">Required</span></label>
                        <asp:TextBox ID="ProjectNameTextBox" runat="server" CssClass="form-control" placeholder="Enter the project name"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ProjectNameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddData"
                                ErrorMessage="You must enter the Project Name">
                            </asp:RequiredFieldValidator>
                        </div>

                        <uc1:AddDataControl ID="OrganizationControl" runat="server" />

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">

                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save Project"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="Cancel" OnClick="CancelButton_Click"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="ProjectIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
</asp:Content>

