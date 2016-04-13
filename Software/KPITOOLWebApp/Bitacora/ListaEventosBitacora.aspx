<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ListaEventosBitacora.aspx.cs" Inherits="Bitacora_ListaEventosBitacora" %>

<%@ Register Src="~/UserControls/SearchUserControl/SearchControl.ascx" TagPrefix="asistexa" TagName="SearchControl" %>

<%@ Register Src="~/UserControls/PagerControl.ascx" TagName="PagerControl" TagPrefix="asistexa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>Lista de Eventos de la Bitácora</h5>
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
                            <div style="margin: 10px 0;">
                                <asistexa:SearchControl ID="SearchBitacora" runat="server"
                                    Title="Búsqueda"
                                    DisplayHelp="true"
                                    DisplayContextualHelp="true"
                                    CssSearch="CSearch"
                                    CssSearchHelp="CSearchHelpPanel"
                                    CssSearchError="CSearchErrorPanel"
                                    SavedSearches="true" SavedSearchesID="Bitacora"
                                    ImageHelpUrl="Images/Neutral/Help.png"
                                    ImageErrorUrl="~/images/exclamation.png" />
                            </div>
                            <div>
                                Enlaces rápidos:
                                <asp:DropDownList ID="enlaceRapidoBusqueda" runat="server"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="enlaceRapidoBusqueda_SelectedIndexChanged">
                                    <asp:ListItem Text="Todos" Value="" Selected="True"> </asp:ListItem>
                                    <asp:ListItem Text="Eventos de Login al sistema" Value="@evento UserLogin"></asp:ListItem>
                                    <asp:ListItem Text="Creación de casos desgravamen" Value="@fecha TD()"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <telerik:RadGrid ID="BitacoraGridView" runat="server"
                        AutoGenerateColumns="false"
                        DataSourceID="BitacoraDataSource"
                        AllowPaging="false"
                        OnItemDataBound="BitacoraGridView_ItemDataBound"
                        AllowMultiRowSelection="False" Skin="aetemplate" EnableEmbeddedSkins="false" CssClass="table-responsive">
                        <MasterTableView DataKeyNames="Id" ExpandCollapseColumn-Display="false"
                            CommandItemDisplay="None"
                            AllowSorting="false"
                            OverrideDataSourceControlSorting="true">
                            <NoRecordsTemplate>
                                <div style="text-align: center;">No hay eventos en la bitácora, ver si el web.config está bien configurado</div>
                            </NoRecordsTemplate>


                            <Columns>

                                <telerik:GridBoundColumn UniqueName="Id" DataField="Id"
                                    HeaderText="Id" />
                                <telerik:GridBoundColumn UniqueName="Fecha" DataField="Fecha"
                                    HeaderText="Fecha/Hora" />
                                <telerik:GridBoundColumn UniqueName="TipoEvento" DataField="TipoEvento"
                                    HeaderText="Tipo de Evento" />
                                <telerik:GridBoundColumn UniqueName="Empleado" DataField="Empleado"
                                    HeaderText="Usuario" />
                                <telerik:GridBoundColumn UniqueName="TipoObjeto" DataField="TipoObjeto"
                                    HeaderText="Módulo" />
                                <telerik:GridBoundColumn UniqueName="IdObjeto" DataField="IdObjeto"
                                    HeaderText="Id Obj." />
                                <telerik:GridBoundColumn UniqueName="Mensaje" DataField="Mensaje"
                                    HeaderText="Mensaje" />
                            </Columns>

                        </MasterTableView>

                    </telerik:RadGrid>
                    <asp:ObjectDataSource ID="BitacoraDataSource" runat="server"
                        TypeName="Artexacta.MSCRRHH.Bitacora.BLL.EventoBitacoraBLL"
                        SelectMethod="getEventoBitacoraList"
                        OnSelected="BitacoraDataSource_Selected">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="SearchBitacora" PropertyName="Sql" Name="search" Type="String" />
                            <asp:ControlParameter ControlID="Pager" PropertyName="CurrentRow" Name="firstRow" Type="Int32" />
                            <asp:ControlParameter ControlID="Pager" PropertyName="PageSize" Name="pageSize" Type="Int32" />
                            <asp:ControlParameter ControlID="Pager" Name="totalRows" PropertyName="TotalRows" Type="Int32" Direction="Output" />
                        </SelectParameters>
                    </asp:ObjectDataSource>

                    <asistexa:PagerControl ID="Pager" runat="server"
                        PageSize="20"
                        CurrentRow="0"
                        InvisibilityMethod="PropertyControl"
                        OnPageChanged="Pager_PageChanged" />
                </div>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $(".rgMasterTable").addClass("table table-striped table-bordered table-hover");
                        $(".rgExpXLS").val('E');
                    });
                </script>
            </div>
        </div>
    </div>
</asp:Content>

