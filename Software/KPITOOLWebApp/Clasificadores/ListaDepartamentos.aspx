<%@ Page Title="Listado de Departamentos" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ListaDepartamentos.aspx.cs" Inherits="Clasificadores_ListaDepartamentos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel" runat="server" Text="Lista de Departamentos" CssClass="title" /></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-12">
                    <p>
                        <a class="btn btn-primary" href="javascript:openAddModal();"><i class='fa fa-plus'></i> Nuevo departamento</a>
                    </p>
                </div>
                <div class="col-md-12">
                    <div class="table-responsive">
                        <asp:GridView ID="DepartamentoGridView" runat="server" AutoGenerateColumns="False" DataSourceID="DepartamentoObjectDataSource"
                            DataKeyNames="DepartamentoID" OnSelectedIndexChanged="DepartamentoGridView_SelectedIndexChanged"
                            CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <RowStyle CssClass="" />
                            <Columns>
                                <asp:TemplateField HeaderText="Editar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditImageButton" runat="server" CommandName="Select" CssClass="text-success img-buttons" Text="<i class='fa fa-pencil'></i>"
                                            OnClick="EditImageButton_Click" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Eliminar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="DeleteImageButton" runat="server" CommandName="Select" CssClass="text-danger img-buttons" Text="<i class='fa fa-trash-o'></i>"
                                            OnClick="DeleteImageButton_Click"
                                            OnClientClick="return confirm('¿Está seguro de eliminar el usuario?')" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" Width="50px"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Nombre" HeaderText="Nombre" ReadOnly="True"
                                    SortExpression="Nombre" ItemStyle-Width="150px">
                                    <ItemStyle HorizontalAlign="Center" Width="150px"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:BoundField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyLiteral" runat="server" Text="No se encuentran usuarios registrados"></asp:Label>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
        </div>
        <div id="editModal" class="myCustomBg">
            <div class="myCustomModal">
                <div class="modal-header">
                    <h4 class="modal-title">Editar Departamento</h4>
                </div>
                <div class="modal-body">
                    <div class="middle-box">
                        <div class="form-group">
                            <asp:Label ID="labelAddDpt" runat="server" AssociatedControlID="EditTextbox" Text="Nombre del Departamento"></asp:Label>
                            <asp:TextBox ID="EditTextbox" runat="server" CssClass="form-control" MaxLength="100" Text="Hola" />
                            <asp:RequiredFieldValidator ID="EditModalValidator" runat="server" ControlToValidate="EditTextbox"
                                ErrorMessage="El nombre es requerido." Display="Dynamic" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="closeModal" runat="server" type="button" class="btn btn-danger" OnClientClick="javascript:cerrarModal();">Cancelar</asp:LinkButton>
                    <asp:LinkButton runat="server" ID="saveDepartment" CssClass="btn btn-primary" OnClick="saveEdit_Click">Guardar</asp:LinkButton>
                </div>
            </div>
        </div>
        <div id="addModal" class="myCustomBg">
            <div class="myCustomModal">
                <div class="modal-header">
                    <h4 class="modal-title">Nuevo Departamento</h4>
                </div>
                <div class="modal-body">
                    <div class="middle-box">
                        <div class="form-group">
                            <asp:Label ID="label1" runat="server" AssociatedControlID="NombreTextbox" Text="Nombre del Departamento"></asp:Label>
                            <asp:TextBox ID="NombreTextbox" runat="server" CssClass="form-control" MaxLength="100" Text="Nombre" />
                            <asp:RequiredFieldValidator ID="AddModalValidation" runat="server" ControlToValidate="NombreTextbox"
                                ErrorMessage="El nombre es requerido." Display="Dynamic" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="LinkButton1" runat="server" type="button" class="btn btn-danger" OnClientClick="javascript:cerrarModal();">Cancelar</asp:LinkButton>
                    <asp:LinkButton runat="server" ID="LinkButton2" CssClass="btn btn-primary" OnClick="saveDepartment_Click">Guardar</asp:LinkButton>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $(".rgMasterTable").addClass("table table-striped table-bordered table-hover");
            });
            function cerrarModal() {
                $(".myCustomBg").css("display", "none");
                $("#<% =NombreTextbox.ClientID %>").val("Hola");
            }
            function openEditModal() {
                $("#editModal").css("display", "block");
            }
            function openAddModal() {
                $("#addModal").css("display", "block");
                $("#<% =NombreTextbox.ClientID %>").val("");
            }
        </script>
    </div>
    <asp:HiddenField ID="OperationHiddenField" runat="server" />
    <asp:HiddenField ID="SelectedDpto" runat="server" />
    <asp:ObjectDataSource ID="DepartamentoObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.Departamento.BLL.DepartamentoBLL" SelectMethod="GetAllRecords" OnSelected="DepartamentoObjectDataSource_Selected"></asp:ObjectDataSource>

</asp:Content>

