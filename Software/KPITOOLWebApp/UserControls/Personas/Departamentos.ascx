<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Departamentos.ascx.cs" Inherits="UserControls_Personas_Departamentos" %>

<asp:Panel ID="DepartamentosPanel" runat="server" CssClass="ibox float-e-margins">
    <div class="ibox-title">
        <h5>
            <asp:Label ID="SubTitleLabel" runat="server" Text="Departamentos de trabajo" CssClass="title" /></h5>
        <div class="ibox-tools">
            <a class="collapse-link">
                <i class="fa fa-chevron-up"></i>
            </a>
        </div>
    </div>
    <div class="ibox-content">
        <div class="row">
            <div class="col-md-12">
                <a id="openPopupDepartamento" class="btn btn-primary" href="javascript:openAddModal();">Asignar Departamento</a>
                <telerik:RadGrid ID="DepartamentoRadGrid" runat="server" CellSpacing="0" DataSourceID="PersonaDepartamentosObjectDataSource"
                    GridLines="None" AllowPaging="true" AutoGenerateColumns="false" PageSize="10" AllowSorting="true" OnItemCommand="DepartamentoRadGrid_ItemCommand" Skin="aetemplate" EnableEmbeddedSkins="false" CssClass="table-responsive">
                    <MasterTableView DataSourceID="PersonaDepartamentosObjectDataSource" AutoGenerateColumns="False" DataKeyNames="PersonaId,DepartamentoId,Cargo"
                        OverrideDataSourceControlSorting="true">
                        <Columns>
                            <telerik:GridButtonColumn UniqueName="EditCommandColumn" HeaderText="Editar" CommandName="Edit" ButtonType="LinkButton"
                                ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ButtonCssClass="text-success img-buttons"
                                Text="<i class='fa fa-pencil'></i>"  />
                            <telerik:GridButtonColumn UniqueName="DeleteCommandColumn" HeaderText="Eliminar" CommandName="Delete" ButtonType="LinkButton"
                                ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ButtonCssClass="text-danger img-buttons"
                                Text="<i class='fa fa-trash-o'></i>" ConfirmText="¿Está seguro que desea eliminar la información del cargo?" />
                            <telerik:GridBoundColumn DataField="PersonaId" HeaderText="PersonaId" SortExpression="PersonaId" UniqueName="PersonaId"
                                DataType="System.Int32" FilterControlAltText="Filter PersonaId column" Visible="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="DepartamentoId" HeaderText="DepartamentoId" SortExpression="DepartamentoId"
                                UniqueName="DepartamentoId" DataType="System.Int32" FilterControlAltText="Filter DepartamentoId column" Visible="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="DepartamentoForDisplay" ReadOnly="True" HeaderText="Departamento" SortExpression="DepartamentoForDisplay"
                                UniqueName="DepartamentoForDisplay" FilterControlAltText="Filter DepartamentoForDisplay column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn DataField="Cargo" HeaderText="Cargo" SortExpression="Cargo" UniqueName="Cargo" FilterControlAltText="Filter Cargo column"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                </telerik:RadGrid>
                <div id="addModal" class="myCustomBg">
                    <div class="myCustomModal">
                        <div class="modal-header">
                            <h4 class="modal-title">Asignar Departamento</h4>
                        </div>
                        <div class="modal-body">
                            <div class="middle-box">
                                <div class="form-group">
                                    <asp:Label ID="DepartamentoLabel" runat="server" Text="Departamento" AssociatedControlID="DepartamentoComboBox" />
                                    <telerik:RadComboBox ID="DepartamentoComboBox" runat="server" DataSourceID="DepartamentoObjectDataSource"
                                        DataTextField="Nombre" DataValueField="DepartamentoId" EmptyMessage=" - seleccione un departamento - "
                                        Filter="Contains" EnableLoadOnDemand="true" ZIndex="8101"  Skin="aetemplate" EnableEmbeddedSkins="false"/>
                                    <div class="validators">
                                        <asp:RequiredFieldValidator ID="DepartamentoRequiredFieldValidator" runat="server" ControlToValidate="DepartamentoComboBox"
                                            Display="Dynamic" ErrorMessage="El departamento es requerido." ValidationGroup="RegistrarDepartamento" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="CargoLabel" runat="server" Text="Cargo" AssociatedControlID="CargoTextBox" />
                                    <asp:TextBox ID="CargoTextBox" runat="server" CssClass="form-control" MaxLength="250" />
                                    <div class="validators">
                                        <asp:RequiredFieldValidator ID="CargoRequiredFieldValidator" runat="server" ControlToValidate="CargoTextBox"
                                            ValidationGroup="RegistrarDepartamento" ErrorMessage="El Cargo es requerido." Display="Dynamic" />
                                        <asp:RegularExpressionValidator ID="CargoRegularExpressionValidator" runat="server"
                                            ControlToValidate="CargoTextBox" ValidationGroup="RegistrarDepartamento" ErrorMessage="Caracteres inválidos en el Cargo."
                                            ValidationExpression="<%$ Resources:Validations, NameFormat %>" Display="Dynamic" />
                                        <asp:RegularExpressionValidator ID="CargoLengRegularExpressionValidator" runat="server"
                                            ControlToValidate="CargoTextBox" ValidationGroup="RegistrarDepartamento" ErrorMessage="El Cargo no puede exceder 250 caracteres."
                                            ValidationExpression="<%$ Resources:Validations, GenericLength250 %>" Display="Dynamic" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:LinkButton ID="closeModal" runat="server" type="button" class="btn btn-danger" OnClientClick="javascript:cerrarModal();">Cancelar</asp:LinkButton>
                            <asp:LinkButton ID="RegistrarLinkButton" runat="server" CssClass="btn btn-primary" ValidationGroup="RegistrarDepartamento"
                                OnClick="RegistrarLinkButton_Click">
                                <asp:Label ID="RegistrarLinkButtonLabel" runat="server" Text="Guardar" />
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".rgMasterTable").addClass("table table-striped table-bordered table-hover");
            $(".rgExpXLS").val('E');
        });
        function cerrarModal() {
            $(".myCustomBg").css("display", "none");
            }
            function openAddModal() {
                $("#addModal").css("display", "block");
            }
    </script>

    <asp:HiddenField ID="PersonaIdHiddenField" runat="server" />
    <asp:HiddenField ID="DepartamentoIdHiddenField" runat="server" />
    <asp:HiddenField ID="ShowDepartamentoModalHiddenField" runat="server" Value="false" />

    <asp:ObjectDataSource ID="PersonaDepartamentosObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.PersonaDepartamento.BLL.PersonaDepartamentoBLL" SelectMethod="GetPersonaDepartamentoByPersonaId"
        OnSelected="PersonaDepartamentosObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="PersonaIdHiddenField" PropertyName="Value" Name="personaId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="DepartamentoObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.Departamento.BLL.DepartamentoBLL" SelectMethod="GetAllRecords" OnSelected="DepartamentoObjectDataSource_Selected"></asp:ObjectDataSource>

</asp:Panel>
