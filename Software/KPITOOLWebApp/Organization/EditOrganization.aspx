<%@ Page Title="<% $Resources: Organization, TitleOrganizations %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="EditOrganization.aspx.cs" Inherits="Organization_EditOrganization" %>

<%@ Register Src="../UserControls/FRTWB/AddDataControl.ascx" TagName="AddDataControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-6">
            <div class="page-header">
            </div>
        </div>
        <div class="col-md-6">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="t-header">
                    <div class="th-title">
                        <asp:Literal ID="OrganizationNameLit" runat="server"></asp:Literal>
                    </div>
                </div>
                <div class="t-body tb-padding">
                    <div class="row">
                        <div class="col-md-4">
                            <p>
                                <asp:Label ID="OrganizationNameLabel" runat="server" Text="<% $Resources: Organization, TitleOrganizationName %>"></asp:Label>
                            </p>
                            <div class="form-group">
                                <asp:TextBox ID="OrganizationNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:Label ID="NameLabel" runat="server" Text="" Visible="false" CssClass="form-control"></asp:Label>
                                <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" ControlToValidate="OrganizationNameTextBox"
                                    ErrorMessage="<% $Resources: Organization, MessageNameRequired %>" Display="Dynamic" ValidationGroup="EditOrganizationValidator" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <p>
                                <asp:Label ID="AreasLabel" runat="server" Text="<% $Resources: Organization, LabelAreas %>" Font-Bold="true"></asp:Label>
                            </p>
                            <div class="form-group">
                                <a href="javascript:openModal();">
                                    <asp:Label ID="AddAreaLabel" runat="server" Text="<% $Resources: Organization, LabelAddAreas %>"></asp:Label></a>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <asp:GridView ID="AreasGridView" runat="server" DataSourceID="AreasObjectDataSource" DataKeyNames="AreaId"
                                GridLines="None" ShowHeader="False" AutoGenerateColumns="False" OnRowCommand="AreasGridView_RowCommand"
                                OnRowDataBound="AreasGridView_RowDataBound">
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="EditAreaLB" runat="server" CssClass="viewBtn editBtn" CommandName="Edit">
                                                <i class="zmdi zmdi-edit zmdi-hc-fw"></i></asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="SaveLinkButton" runat="server" CommandName="Actualizar" CommandArgument='<%# Eval("AreaId") %>'
                                                CssClass="viewBtn editBtn" Text="<i class='fa fa-save'></i>" ToolTip="<% $Resources: Glossary, GenericSaveLabel %>"
                                                ValidationGroup="EditArea"></asp:LinkButton>
                                            &nbsp;
                                            <asp:LinkButton ID="CancelLinkButton" runat="server" CommandName="Cancel"
                                                CssClass="viewBtn editBtn" Text="<i class='fa fa-close'></i>" ToolTip="<% $Resources: Glossary, GenericCancelLabel %>"></asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteArea" runat="server" CssClass="viewBtn" CommandArgument='<%# Eval("AreaId") %>'
                                                CommandName="Eliminar">
                                                <i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i></asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="200px">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="form-control"></asp:TextBox>
                                            <div>
                                                <asp:RequiredFieldValidator ID="NameAreaRequiredFieldValidator" runat="server"
                                                    ErrorMessage="<% $Resources: Organization, MessageAreaRequired %>" Display="Dynamic"
                                                    ControlToValidate="NameTextBox" ValidationGroup="EditArea"></asp:RequiredFieldValidator>
                                            </div>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:ObjectDataSource ID="AreasObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="GetAreasByOrganization" TypeName="Artexacta.App.Area.BLL.AreaBLL"
                                OnSelected="AreasObjectDataSource_Selected">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="OrganizationIdHiddenField" Name="organizationId" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </div>
                    </div>
                    <div class="row" style="padding-top: 20px">
                        <div class="col-md-12">
                            <asp:LinkButton ID="SaveOrganizationButton" runat="server" CssClass="btn btn-primary"
                                OnClick="SaveOrganizationButton_Click" ValidationGroup="EditOrganizationValidator" Text="<% $Resources: Glossary, GenericSaveLabel %>">
                            </asp:LinkButton>
                            <asp:HyperLink runat="server" NavigateUrl="~/MainPage.aspx" CssClass="btn btn-danger">
                                <asp:Label ID="BackListLabel" runat="server" Text="<% $Resources: Organization, LabelBackListOrganization %>"></asp:Label>
                            </asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="addModal" class="myCustomBg">
        <div class="myCustomModal">
            <div class="modal-header">
                <h4 class="modal-title">
                    <asp:Label ID="Label1" runat="server" Text="<% $Resources: Organization, LabelAddArea %>"></asp:Label></h4>
            </div>
            <div class="modal-body">
                <div class="middle-box">
                    <div class="form-group">
                        <asp:Label ID="AreaNameLb" runat="server" AssociatedControlID="AreaName" Text="<% $Resources: Organization, LabelAreaName %>"></asp:Label>
                        <asp:TextBox ID="AreaName" runat="server" CssClass="form-control" MaxLength="100" Text="" />
                        <asp:RequiredFieldValidator ID="AreaNAmeValidator" runat="server" ControlToValidate="AreaName"
                            ErrorMessage="<% $Resources: Organization, MessageNameRequired %>" Display="Dynamic" ValidationGroup="AreaValidator" />
                    </div>
                </div>
            </div>
            <div class="modal-footer btn-colors">
                <asp:LinkButton ID="AddArea" runat="server" CssClass="btn btn-primary" OnClick="AddArea_Click">
                    <asp:Label ID="CreateAreaLabel" runat="server" Text="<% $Resources: Organization, LabelCreateArea %>"></asp:Label>
                </asp:LinkButton>
                <a class="btn btn-danger" href="javascript:cerrarModal();">
                    <asp:Label ID="CancelLabel" runat="server" Text="<% $Resources: Glossary, CancelLabel %>"></asp:Label></a>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="OrganizationIdHiddenField" runat="server" Value="0" />
    <script type="text/javascript">
        function cerrarModal() {
            $(".myCustomBg").css("display", "none");
            $("#<% =AreaName.ClientID %>").val("");
        }
        function openModal() {
            $("#addModal").css("display", "block");
            $("#<% =AreaName.ClientID %>").val("");
        }
    </script>
</asp:Content>

