<%@ Page Title="Asignar Roles" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="AssignRoles.aspx.cs" Inherits="Security_AssignRoles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>Asignar Roles</h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-4">
                            <asp:Label ID="RoleLabel" runat="server" AssociatedControlID="RoleDropDownList" Text="Rol: "></asp:Label>
                            <asp:DropDownList ID="RoleDropDownList" runat="server" CssClass="form-control m-b-10" AutoPostBack="true" 
                                OnSelectedIndexChanged="RoleDropDownList_SelectedIndexChanged" />

                            <asp:LinkButton ID="DeleteRolImageButton" runat="server" Text="<i class='fa fa-user-times'></i>" CssClass="text-danger"
                                OnClick="DeleteRolImageButton_Click" ToolTip="Eliminar Rol"
                                OnClientClick="return confirm('¿Esta seguro de eliminar el rol?')" />
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="row" style="margin: 15px 0;">
                        <div class="col-md-5 col-sm-5 col-xs-5 text-center">
                            <asp:Label ID="UsersInLabel" runat="server" CssClass="font-bold" Text="Usuarios en el Rol"></asp:Label>
                            <asp:ListBox ID="InRoleListBox" runat="server" Height="250px" SelectionMode="Multiple" CssClass="form-control full-width"
                                AutoPostBack="True" OnSelectedIndexChanged="InRoleListBox_SelectedIndexChanged"></asp:ListBox>
                        </div>
                        <div class="col-md-2 col-sm-2 col-xs-2" style="margin-top: 18px; ">
                            <div style="text-align: center; ">
                                <p>
                                    <asp:LinkButton ID="AddInImageButton" runat="server" Text="<i class='fa fa-arrow-left'></i>"
                                        OnClick="AddInImageButton_Click" ToolTip="Mover Usuario a Rol" />
                                </p>
                                <p>
                                    <asp:LinkButton ID="AddOutImageButton" runat="server" Text="<i class='fa fa-arrow-right'></i>"
                                        OnClick="AddOutImageButton_Click" ToolTip="Mover cuenta fuera del Rol" />
                                </p>
                            </div>
                        </div>
                        <div class="col-md-5 col-sm-5 col-xs-5 text-center">
                            <asp:Label ID="UsersNotInLabel" runat="server" CssClass="font-bold" Text="Usuarios no en el Rol"></asp:Label>
                            <asp:ListBox ID="OutRoleListBox" runat="server" Height="250px" SelectionMode="Multiple" CssClass="form-control full-width"
                                AutoPostBack="True" OnSelectedIndexChanged="OutRoleListBox_SelectedIndexChanged"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <asp:Panel ID="EmployeeRolePanel" runat="server" Visible="False" CssClass="frame">
                                <p>
                                    <h6>
                                        <asp:Label ID="TitleLabel" runat="server" Text="Información del Usuario Seleccionado"
                                            Font-Size="Small" Font-Bold="true"></asp:Label></h6>
                                </p>
                                <p>
                                    <asp:Label ID="User1Label" runat="server" Text="Nombre de Usuario:"></asp:Label>
                                    <asp:Label ID="UserLabel" runat="server"></asp:Label>
                                </p>
                                <p>
                                    <asp:Label ID="UserEmail1Label" runat="server" Text="Correo Electrónico:"></asp:Label>
                                    <asp:Label ID="UserEmailLabel" runat="server"></asp:Label>
                                </p>
                                <p>
                                    <asp:Label ID="RolesLabel" runat="server" Text="Roles para el Usuario"></asp:Label><br />
                                </p>
                                <div style="margin: 15px 0;">
                                    <asp:CheckBoxList ID="UserRoleCheckBoxList" runat="server" BackColor="Transparent">
                                    </asp:CheckBoxList>
                                </div>
                                <div class="text-center" style="margin: 15px 0;">
                                    <asp:LinkButton ID="SaveRolesButton" runat="server" OnClick="SaveRolesButton_Click"
                                        CssClass="btn btn-primary">
												<i class="fa fa-floppy-o"></i> Grabar los Roles del Usuario	
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="ResetRolesButton" runat="server" OnClick="ResetRolesButton_Click"
                                        CssClass="btn btn-info">
												<i class="fa fa-refresh"></i> Resetar los Roles del usuario
                                    </asp:LinkButton>
                                </div>
                            </asp:Panel>
                        </div>
                        <div class="col-md-12">
                            <div class="text-center" style="margin-top: 15px;">
                                <asp:LinkButton ID="AddNewRoleLinkButton" runat="server" OnClick="AddNewRoleLinkButton_Click"
                                    CssClass="btn btn-primary" Visible="false">
					                <i class="fa fa-plus"></i> Adicionar Nuevo Rol	
                                </asp:LinkButton>
                                <asp:LinkButton ID="AddNewUserLinkButton" runat="server" OnClick="AddNewUserLinkButton_Click"
                                    CssClass="btn btn-primary">
					                <i class="fa fa-plus"></i> Adicionar Nuevo Usuario	
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $('.RadComboBox input[text]').addClass("form-control");

                        $('input:checkbox').each(function () {
                            var attr = $(this).attr('checked');
                            if (typeof attr == typeof undefined || attr != 'checked') {
                                $(this).removeClass("icheckbox_square-green");
                                $(this).removeClass("iradio_square-green");
                            } else {
                                $(this).addClass("icheckbox_square-green");
                                $(this).addClass("iradio_square-green");
                            }
                        });

                        $('.icheckbox_square-green').css("margin-right", "10px");
                    });
                </script>
            </div>
        </div>
    </div>
</asp:Content>

