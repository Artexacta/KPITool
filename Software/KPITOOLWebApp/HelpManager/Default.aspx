<%@ Page Title="<% $ Resources:ContextHelpManager, lblTituloPanel %>" Language="C#" MasterPageFile="~/MasterPage.master"
    ValidateRequest="false" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="ContextHelpManager_Default" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
    <link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="body" ContentPlaceHolderID="cp" runat="Server">

    <div class="row">
        <div class="col-md-12">
            <div class="tile">
                <div class="t-header">
                    <div class="th-title">Help Manager</div>
                </div>
                <div class="t-body tb-padding">
                    <div class="row">
                        <asp:Panel runat="server" ID="pnlInfo" CssClass="col-md-12">
                            <asp:Literal runat="server" ID="lblInfo"></asp:Literal>
                        </asp:Panel>
                        <asp:LinkButton ID="btnNuevo" runat="server" OnClick="btnNuevo_Click">Add</asp:LinkButton>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblHelpFilesRouteLabel"
                                    Text="<% $ Resources:ContextHelpManager, lblHelpFilesRouteLabel %>">
                                </asp:Literal>
                            </label>
                            <br />
                            <asp:Literal ID="lblHelpFilesRoute" runat="server"></asp:Literal>

                        </div>
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblHelpFilesExtensionLabel"
                                    Text="<% $ Resources:ContextHelpManager, lblHelpFilesRouteLabel %>">
                                </asp:Literal>
                            </label>
                            <br />
                            <asp:Literal ID="lblHelpFilesExtension" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblHelpFilesLanguagesLabel"
                                    Text="<% $ Resources:ContextHelpManager, lblHelpFilesLanguagesLabel %>">
                                </asp:Literal>
                            </label>
                            <br />
                            <asp:Literal ID="lblHelpFilesLanguages" runat="server"></asp:Literal>
                        </div>
                        <div class="col-md-3">
                            <div class="checkbox cr-alt m-b-20">
                                <label>
                                    <asp:CheckBox ID="chkWithOutLanguages" runat="server" />
                                    <i class="input-helper"></i>
                                    <asp:Literal runat="server" ID="lblSearchWithOutLangs" Text="<% $ Resources:ContextHelpManager, lblSearchWithOutLangs %>"></asp:Literal>
                                </label>
                            </div>
                        </div>

                    </div>
                    <asp:Panel runat="server" ID="pnlSearch" CssClass="row m-t-20">
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblSearchType" Text="<% $ Resources:ContextHelpManager, lblSearchType %>"></asp:Literal>
                            </label>
                            <br />
                            <div class="checkbox cr-alt m-b-20">
                                <label>
                                    <asp:CheckBox ID="ChkPages" runat="server" Checked="true" />
                                    <i class="input-helper"></i>
                                    <asp:Literal ID="PagesLiteral" runat="server" Text="Pages"></asp:Literal>
                                </label>
                            </div>
                            <div class="checkbox cr-alt m-b-20">
                                <label>
                                    <asp:CheckBox ID="ChkFields" runat="server" Checked="true" />
                                    <i class="input-helper"></i>
                                    <asp:Literal ID="FieldsLiteral" runat="server" Text="Fields"></asp:Literal>
                                </label>
                            </div>
                            <%--<asp:CheckBoxList ID="rbtTypesOfFiles" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                <asp:ListItem Text="Páginas" Value="Páginas" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Campos" Value="Campos" Selected="True"></asp:ListItem>
                            </asp:CheckBoxList>--%>
                        </div>

                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblSearchFields" Text="<% $ Resources:ContextHelpManager, lblSearchFields %>"></asp:Literal>
                            </label>
                            <div class="checkbox cr-alt m-b-20">
                                <label>
                                    <asp:CheckBox ID="ChkFieldPerPage" runat="server" Checked="true" />
                                    <i class="input-helper"></i>
                                    <asp:Literal ID="FieldPerPageLiteral" runat="server" Text="Pages"></asp:Literal>
                                </label>
                            </div>
                            <div class="checkbox cr-alt m-b-20">
                                <label>
                                    <asp:CheckBox ID="ChkGeneralField" runat="server" Checked="true" />
                                    <i class="input-helper"></i>
                                    <asp:Literal ID="GeneralFieldLiteral" runat="server" Text="Fields"></asp:Literal>
                                </label>
                            </div>
                            <%--<asp:CheckBoxList ID="chkCampos" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                <asp:ListItem Text="Campos por página" Value="pagina" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Campos generales" Value="generales" Selected="True"></asp:ListItem>
                            </asp:CheckBoxList>--%>
                        </div>
                        <div class="col-md-6">
                            <label>
                                <asp:Literal runat="server" ID="lblSearchFileName" Text="<% $ Resources:ContextHelpManager, lblSearchFileName %>"></asp:Literal>
                            </label>
                            <br />
                            <asp:TextBox ID="txtFileName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                            <asp:LinkButton ID="btnBuscar" runat="server" OnClick="btnBuscar_Click" CssClass="btn btn-primary m-t-10">
                                <asp:Label ID="Label1" runat="server" Text="<% $ Resources:ContextHelpManager, btnBuscar %>"></asp:Label>
                            </asp:LinkButton>
                        </div>
                    <div class="row m-t-20">
                        <div class="col-md-12">
                                <asp:GridView ID="grdData" runat="server" BorderWidth="0"
                                    AutoGenerateColumns="false" AllowPaging="true" PageSize="20" Width="100%"
                                    OnPageIndexChanging="grdData_PageIndexChanging"
                                    OnRowCommand="grdData_RowCommand" OnRowDataBound="grdData_RowDataBound"
                                    OnRowDeleting="grdData_RowDeleting" CssClass="table table-striped m-t-20" GridLines="None">
                                    <Columns>
                                        <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:Literal runat="server" ID="lblGridTypeOfFile" Text="<% $ Resources:ContextHelpManager, lblGridTypeOfFile %>"></asp:Literal>
                                            </HeaderTemplate>
                                            <HeaderStyle CssClass="text-center" />
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lblTipoArchivo" Text='<%# GetFileType(Container.DataItem) %>'></asp:Label>
                                            </ItemTemplate>
                                            <%--<AlternatingItemTemplate>
                                                        <asp:Label runat="server" ID="lblTipoArchivo" Text='<%# GetFileType(Container.DataItem) %>'></asp:Label>
                                                    </AlternatingItemTemplate>--%>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:Literal runat="server" ID="lblGridFileName" Text="<% $ Resources:ContextHelpManager, lblGridFileName %>"></asp:Literal>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lblNombre" Text='<%# GetFileName(Container.DataItem) %>'></asp:Label>
                                            </ItemTemplate>
                                            <%--<AlternatingItemTemplate>
                                                        <asp:Label runat="server" ID="lblNombre" Text='<%# GetFileName(Container.DataItem) %>'></asp:Label>
                                                    </AlternatingItemTemplate>--%>
                                        </asp:TemplateField>
                                        <%--<asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:Literal runat="server" ID="lblGridx" Text="<% $ Resources:ContextHelpManager, lblGridDelete %>"></asp:Literal>
                                            </HeaderTemplate>
                                            <HeaderStyle CssClass="text-center" />
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ID="btnEliminar" OnClientClick="javascript:confirm('esta seguro?');"
                                                    ForeColor="#f44336"
                                                    CommandName="Delete" CommandArgument='<%# GetFileName(Container.DataItem) %>' ToolTip="Eliminar la página"> 
                                                            <i class="fa fa-trash-o" aria-hidden="true"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                            <AlternatingItemTemplate>
                                                        <asp:LinkButton runat="server" ID="btnEliminar" OnClientClick="javascript:confirm('esta seguro?');" 
                                                            ForeColor="#f44336"
                                                            CommandName="Delete" CommandArgument='<%# GetFileName(Container.DataItem) %>' ToolTip="Eliminar la página">
                                                            <i class="fa fa-trash-o" aria-hidden="true"></i>
                                                        </asp:LinkButton>
                                                    </AlternatingItemTemplate>
                                        </asp:TemplateField>--%>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <asp:Literal runat="server" ID="lblGridNoData" Text="<% $ Resources:ContextHelpManager, lblGridNoData %>"></asp:Literal>
                                    </EmptyDataTemplate>
                                    <PagerStyle Height="20px" HorizontalAlign="Left" CssClass="gridRowsNumberSelector" />
                                    <FooterStyle CssClass="foot" />
                                </asp:GridView>
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="pnlDML" Visible="false" CssClass="row m-t-10">
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblInfoFileType" Text="<% $ Resources:ContextHelpManager, lblInfoFileType %>"></asp:Literal>
                            </label><br />
                            <asp:Literal runat="server" ID="lblUType"></asp:Literal>
                        </div>
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblInfoFileName" Text="<% $ Resources:ContextHelpManager, lblInfoFileName %>"></asp:Literal>
                            </label><br />
                            <asp:Literal runat="server" ID="lblUFileName"></asp:Literal>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="txtNombreRFV" runat="server"
                                ControlToValidate="txtNombre" ErrorMessage="Nombre es obligatorio"
                                Text="Nombre es obligatorio">
                            </asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label>
                                <asp:Literal runat="server" ID="lblInfoFileLang" Text="<% $ Resources:ContextHelpManager, lblInfoFileLang %>"></asp:Literal>
                            </label><br />
                            <asp:Literal runat="server" ID="lblULanguage"></asp:Literal>
                            <asp:RadioButtonList ID="rbtLanguages" runat="server"
                                RepeatLayout="Table" RepeatDirection="Vertical"
                                CssClass="radioButtonLanguagesHelp">
                            </asp:RadioButtonList>
                        </div>
                        
                        <div class="col-md-12 m-t-10">
                            <label>
                                <asp:Literal runat="server" ID="lblInfoFileContent" Text="<% $ Resources:ContextHelpManager, lblInfoFileContent %>"></asp:Literal>
                            </label>
                            <div id="summernote">
                                <asp:Literal ID="EditorHtml" runat="server"></asp:Literal>
                            </div>

                            <asp:LinkButton runat="server" ID="btnGuardar"
                                OnClick="btnGuardar_Click" CssClass="btn btn-primary">
                                <asp:Label ID="btnGuardarLabel" runat="server" Text="<% $ Resources:ContextHelpManager, btnGuardar %>"></asp:Label>
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" ID="btnCancelar" Text="<% $ Resources:ContextHelpManager, btnCancelar %>"
                                OnClick="btnCancelar_Click" CausesValidation="false" CssClass="btn" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <asp:TextBox ID="CodeHtmlTextBox" runat="server" TextMode="MultiLine" CssClass="hide"></asp:TextBox>

    <script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.1/summernote.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#summernote').summernote({
                toolbar: [
                  // [groupName, [list of button]]
                  ['style', ['bold', 'italic', 'underline', 'clear']],
                  ['font', ['strikethrough', 'superscript', 'subscript']],
                  ['fontsize', ['fontsize']],
                  ['color', ['color']],
                  ['para', ['ul', 'ol', 'paragraph']],
                  ['height', ['height']]
                ],
                height: 300,
                focus: true
            });
            $("#<%= btnGuardar.ClientID %>").click(function () {
                var markupStr = $('#summernote').summernote('code');
                $("#<%= CodeHtmlTextBox.ClientID %>").val(markupStr);
            });
        });
    </script>
</asp:Content>

