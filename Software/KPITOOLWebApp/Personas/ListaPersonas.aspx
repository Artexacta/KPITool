<%@ Page Title="Lista de Personas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ListaPersonas.aspx.cs" Inherits="Personas_ListaPersonas" %>

<%@ Register Src="../UserControls/SearchUserControl/SearchControl.ascx" TagName="SearchControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel" runat="server" Text="Lista de Personas" CssClass="title" /></h5>
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
                        <div class="col-md-6">
                            <p>
                                <asp:LinkButton ID="NewButton" runat="server" CssClass="btn btn-primary min-letter"
                                    OnClick="NewButton_Click"><i class="fa fa-user-plus"></i> Registrar nueva persona
                                </asp:LinkButton>
                            </p>
                            <uc1:SearchControl ID="PersonaSearchControl" runat="server" Title="Buscar: " DisplayHelp="true"
                                DisplayContextualHelp="true" CssSearch="CSearch" CssSearchError="CSearchErrorPanel"
                                CssSearchHelp="CSearchHelpPanel" ImageErrorUrl="~/Images/neutral/exclamation.png"
                                ImageHelpUrl="~/Images/neutral/Help.png" />
                        </div>
                    </div>
                    <telerik:RadGrid ID="PersonaRadGrid" runat="server" CellSpacing="0" DataSourceID="PersonaObjectDataSource"
                        GridLines="None" AllowPaging="true" AutoGenerateColumns="false" PageSize="10" AllowSorting="true"
                        OnItemCommand="PersonaRadGrid_ItemCommand" Skin="aetemplate" EnableEmbeddedSkins="false" CssClass="table-responsive">
                        <MasterTableView DataSourceID="PersonaObjectDataSource" AutoGenerateColumns="False" DataKeyNames="PersonaId"
                            CommandItemDisplay="Top" OverrideDataSourceControlSorting="true">
                            <CommandItemSettings ShowAddNewRecordButton="false" ShowExportToExcelButton="true"
                                ShowRefreshButton="false" ExportToExcelText="Exportar a Excel"></CommandItemSettings>
                            <NoRecordsTemplate>
                                <asp:Label ID="NoRecordsLabel" runat="server" Text="No existen personas"></asp:Label>
                            </NoRecordsTemplate>
                            <PagerStyle Mode="NextPrevAndNumeric"></PagerStyle>
                            <Columns>
                                <telerik:GridButtonColumn UniqueName="EditCommandColumn" HeaderText="Editar" CommandName="Edit"
                                    ButtonType="ImageButton" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                    HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ImageUrl="~/Images/neutral/viewdetails.gif" />
                                <telerik:GridButtonColumn UniqueName="DeleteCommandColumn" HeaderText="Eliminar" CommandName="Delete"
                                    ButtonType="ImageButton" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                    HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ImageUrl="~/Images/neutral/delete.gif"
                                    ConfirmText="¿Está seguro que desea eliminar la información de la Persona?" />
                                <telerik:GridBoundColumn DataField="PersonaId" HeaderText="PersonaId" SortExpression="PersonaId" UniqueName="PersonaId"
                                    DataType="System.Int32" FilterControlAltText="Filter PersonaId column" Visible="false">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Nombre" HeaderText="Nombre" SortExpression="Nombre" UniqueName="Nombre"
                                    FilterControlAltText="Filter Nombre column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Email" HeaderText="Correo electrónico" SortExpression="Email" UniqueName="Email"
                                    FilterControlAltText="Filter Email column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="FechaNacimiento" HeaderText="Fecha de Nacimiento" SortExpression="FechaNacimiento"
                                    UniqueName="FechaNacimiento" DataType="System.DateTime" FilterControlAltText="Filter FechaNacimiento column"
                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd-MMM-yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="PaisForDisplay" HeaderText="País" SortExpression="PaisId" UniqueName="PaisId"
                                    FilterControlAltText="Filter PaisId column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="EstadoCivil" HeaderText="Estado Civil" SortExpression="EstadoCivil" UniqueName="EstadoCivil"
                                    FilterControlAltText="Filter EstadoCivil column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Genero" HeaderText="Género" SortExpression="Genero" UniqueName="Genero"
                                    FilterControlAltText="Filter Genero column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn DataField="Salario" HeaderText="Salario" SortExpression="Salario" UniqueName="Salario" DataType="System.Decimal"
                                    FilterControlAltText="Filter Salario column" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </telerik:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                        <ExportSettings ExportOnlyData="true" IgnorePaging="true" HideStructureColumns="false" FileName="ListaPersonas">
                            <Excel Format="Html" />
                        </ExportSettings>
                    </telerik:RadGrid>

                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $(".rgMasterTable").addClass("table table-striped table-bordered table-hover");
                $(".rgExpXLS").val('E');
            });
        </script>
    </div>
    <asp:ObjectDataSource ID="PersonaObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.Persona.BLL.PersonaBLL" SelectMethod="GetRecordForSearch" OnSelected="PersonaObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="PersonaSearchControl" Name="whereClause" PropertyName="Sql"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

