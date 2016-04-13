<%@ Page Title="Add Activity" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AddActivity.aspx.cs" Inherits="Activity_AddActivity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="container">


        <div class="tile">
            <div class="t-header">
                <div class="th-title">Create Activity</div>
            </div>

            <div class="t-body tb-padding">

                <div class="row">
                    <div class="col-sm-6">
                        <label>Activity Name <span class="label label-danger">Required</span></label>
                        <asp:TextBox ID="ActivityNameTextBox" runat="server" CssClass="form-control" placeholder="Enter the activity name"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ActivityNameTextBox"
                                Display="Dynamic"
                                ValidationGroup="AddActivity"
                                ErrorMessage="You must enter the Activity Name">
                            </asp:RequiredFieldValidator>
                        </div>


                        <label>
                            Organization
                        <span class="label label-danger">Required</span></label>
                        <asp:DropDownList ID="OrganizationComboBox" runat="server" CssClass="form-control m-b-10"
                            DataValueField="ObjectId"
                            DataTextField="Name"
                            OnDataBound="OrganizationComboBox_DataBound"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="OrganizationComboBox_SelectedIndexChanged">
                        </asp:DropDownList>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="OrganizationComboBox"
                                Display="Dynamic"
                                ValidationGroup="AddActivity"
                                ErrorMessage="You must select a Organization">
                            </asp:RequiredFieldValidator>
                        </div>

                        <label>Area</label>
                        <asp:DropDownList ID="AreaComboBox" runat="server" CssClass="form-control m-b-10"
                            DataValueField="ObjectId"
                            DataTextField="Name"
                            OnDataBound="AreaComboBox_DataBound"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="AreaComboBox_SelectedIndexChanged">
                        </asp:DropDownList>

                        <label>Project</label>
                        <asp:DropDownList ID="ProjectComboBox" runat="server" CssClass="form-control m-b-10"
                            DataValueField="ObjectId"
                            DataTextField="Name"
                            OnDataBound="ProjectComboBox_DataBound">
                        </asp:DropDownList>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save Activity"
                            ValidationGroup="AddActivity" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="Cancel" OnClick="CancelButton_Click"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="ActivityIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="ParentPageHiddenField" runat="server" Value="" />
</asp:Content>

