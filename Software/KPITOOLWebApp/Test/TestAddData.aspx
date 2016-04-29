<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TestAddData.aspx.cs" Inherits="_Default" %>

<%@ Register Src="~/UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="control" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">
                    <asp:Literal ID="TitleLiteral" runat="server"></asp:Literal>
                </div>
            </div>

            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-6 m-b-20">
                        <asp:RadioButtonList ID="DataTypeRadioButtonList" runat="server" RepeatDirection="Horizontal" 
                            OnSelectedIndexChanged="DataTypeRadioButtonList_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Text="Project" Value="PRJ" />
                            <asp:ListItem Text="Activity" Value="ACT" />
                            <asp:ListItem Text="People" Value="PPL" />
                            <asp:ListItem Text="KPI" Value="KPI" />
                        </asp:RadioButtonList>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-sm-6">
                        <label><asp:Literal ID="NameLabel" runat="server" Text="Project name " /><span class="label label-danger">Required</span></label>
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" placeholder="Enter the project name"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="NameTextBox"
                                Display="Dynamic" ValidationGroup="AddData" ErrorMessage="You must enter the Name">
                            </asp:RequiredFieldValidator>
                        </div>

                        <control:AddDataControl ID="AddDataControl" runat="server" />
                    </div> 
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <hr />
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" Text="Save"
                            ValidationGroup="AddData" OnClick="SaveButton_Click">
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CssClass="btn btn-danger" Text="Cancel"></asp:LinkButton>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

