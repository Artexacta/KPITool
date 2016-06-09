<%@ Page Title="Edit Organization" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="EditOrganization.aspx.cs" Inherits="Organization_EditOrganization" %>

<%@ Register src="../UserControls/FRTWB/AddDataControl.ascx" tagname="AddDataControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-6">
            <div class="page-header">
                <div class="dropdown">
                    <a href="#" style="font-size: 45px; text-decoration: none; color: #000000" class="dropdown-toggle" aria-expanded="false" data-toggle="dropdown"><i class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i></a>
                    <ul class="dropdown-menu pull-left">
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:openAddOrgModal();">Add Organization CTRL+N</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Add Project CTRL+T</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Add Activity CTRL+A</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Add KPI CTRL+K</a></li>
                    </ul>
                </div>
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
                        <div class="col-md-3">
                            <p>Organization Name</p>
                            
                        </div>
                        <div class="col-md-9">
                            <div class="form-group">
                                <asp:TextBox ID="OrganizationNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" ControlToValidate="OrganizationNameTextBox"
                                    ErrorMessage="<% $Resources: Organization, MessageNameRequired %>" Display="Dynamic" ValidationGroup="EditOrganizationValidator" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <p>Areas:</p>
                        </div>
                        <div class="col-md-9">
                            <div class="form-group">
                                <a href="javascript:openModal();">Add new area for this Organization</a>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-9">
                            <asp:Repeater ID="AreasRepeater" runat="server" DataSourceID="AreasObjectDataSource" >
                                <ItemTemplate>
                                    <div class="row">
                                        <div class="col-md-1">
                                            <asp:LinkButton ID="EditAreaLB" data-id='<%# Eval("AreaId") %>' runat="server" CssClass="viewBtn editBtn" 
                                                OnClick="EditAreaLB_Click"><i class="zmdi zmdi-edit zmdi-hc-fw"></i></asp:LinkButton>
                                        </div>
                                        <div class="col-md-1">
                                            <asp:LinkButton ID="DeleteArea" data-id='<%# Eval("AreaId") %>' runat="server" CssClass="viewBtn" 
                                                OnClientClick="return confirm('Are you sure you want to delete selected Area?')"
                                                OnClick="DeleteArea_Click"><i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i></asp:LinkButton>
                                        </div>
                                        <div class="col-md-10">
                                            <p style="padding-top: 2px;"><%# Eval("Name") %></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:ObjectDataSource ID="AreasObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                                SelectMethod="GetAreasByOrganization" TypeName="Artexacta.App.Area.BLL.AreaBLL" OnSelected="AreasObjectDataSource_Selected">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="OrganizationIdHiddenField" Name="organizationId" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:LinkButton ID="SaveOrganizationButton" runat="server" CssClass="btn btn-primary"
                                OnClick="SaveOrganizationButton_Click" ValidationGroup="EditOrganizationValidator">
                                Save
                            </asp:LinkButton>
                            <asp:HyperLink runat="server" NavigateUrl="~/MainPage.aspx" CssClass="btn btn-danger" >Back to Organization List</asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="addModal" class="myCustomBg">
        <div class="myCustomModal">
            <div class="modal-header">
                <h4 class="modal-title">Add Area</h4>
            </div>
            <div class="modal-body">
                <div class="middle-box">
                    <div class="form-group">
                        <asp:Label ID="AreaNameLb" runat="server" AssociatedControlID="AreaName" Text="Area Name:"></asp:Label>
                        <asp:TextBox ID="AreaName" runat="server" CssClass="form-control" MaxLength="100" Text="" />
                        <asp:RequiredFieldValidator ID="AreaNAmeValidator" runat="server" ControlToValidate="AreaName"
                            ErrorMessage="The name is required" Display="Dynamic" ValidationGroup="AreaValidator" />
                    </div>
                </div>
            </div>
            <div class="modal-footer btn-colors">
                <asp:LinkButton ID="AddArea" runat="server" CssClass="btn btn-primary" OnClick="AddArea_Click">Create Area</asp:LinkButton>
                <a class="btn btn-danger" href="javascript:cerrarModal();">Cancel</a>
            </div>
        </div>
    </div>
    <div id="addOrganization" class="myCustomBg">
        <div class="myCustomModal">
            <div class="modal-header">
                <h4 class="modal-title">Add Organization</h4>
            </div>
            <div class="modal-body">
                <div class="middle-box">
                    <div class="form-group">
                        <asp:Label ID="OrganizationNameLb" runat="server" AssociatedControlID="OrganizationName" Text="Organization Name:"></asp:Label>
                        <asp:TextBox ID="OrganizationName" runat="server" CssClass="form-control" MaxLength="100" Text="" />
                        <asp:RequiredFieldValidator ID="OrganizationNameValidator" runat="server" ControlToValidate="OrganizationName"
                            ErrorMessage="The name is required" Display="Dynamic" ValidationGroup="OrganizationValidator" />
                    </div>
                </div>
            </div>
            <div class="modal-footer btn-colors">
                <asp:LinkButton ID="AddOrganization" runat="server" CssClass="btn btn-primary" OnClick="AddOrganization_Click">Create Organization</asp:LinkButton>
                <a class="btn btn-danger" href="javascript:cerrarModal();">Cancel</a>
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
        function openAddOrgModal() {
            $("#addOrganization").css("display", "block");
            $("#<% =OrganizationName.ClientID %>").val("");
        }
    </script>
</asp:Content>

