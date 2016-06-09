<%@ Page Title="Categories" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="CategoriesList.aspx.cs" Inherits="Category_CategoriesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>Lista de Categorías</h5>
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
                        <asp:LinkButton ID="NewButton" runat="server" Text="<i class='fa fa-plus'></i> Nueva Categoría" CssClass="btn btn-primary "
                            OnClick="NewButton_Click"></asp:LinkButton>
                    </p>
                </div>
                <div class="col-md-7">
                    <div class="table-responsive">
                        <asp:GridView ID="CategoryGridView" runat="server" DataSourceID="CategoryObjectDataSource" AutoGenerateColumns="False" 
                            CssClass="table table-striped table-bordered table-hover" GridLines="None" Width="100%" 
                            OnRowCommand="CategoryGridView_RowCommand">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <Columns>
                                <asp:TemplateField HeaderText="Editar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditImageButton" runat="server" CommandName="Edit" CssClass="text-success img-buttons" 
                                            Text="<i class='fa fa-pencil'></i>" CommandArgument='<%#Eval("ID")%>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="SaveLinkButton" runat="server"  CommandName="Update" 
                                            CssClass="text-success img-buttons" Text="<i class='fa fa-pencil'></i>"></asp:LinkButton>
                                        <asp:LinkButton ID="CancelLinkButton" runat="server"  CommandName="Cancel" 
                                            CssClass="text-success img-buttons" Text="<i class='fa fa-trash-o'></i>"></asp:LinkButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Eliminar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="DeleteImageButton" runat="server" CommandName="Delete" CssClass="text-danger img-buttons" 
                                            Text="<i class='fa fa-trash-o'></i>" CommandArgument='<%#Eval("ID")%>' 
                                            OnClientClick="return confirm('¿Está seguro de eliminar la categoría?')" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Items" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="ItemImageButton" runat="server" CommandName="ViewItems" CssClass="text-warning img-buttons"
                                            Text="<i class='fa fa-navicon'></i>" CommandArgument='<%#Eval("ID")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" Width="50px"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="ID"></asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name"></asp:BoundField>
                            </Columns>
                            <EmptyDataTemplate>
                                No se tienen categorías registradas
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
                <asp:Panel ID="pnlEditData" runat="server" CssClass="col-md-5" DefaultButton="SaveButton" Visible="false">
                    <div class="form-group">
                        <asp:Label ID="IDLabel" runat="server" Text="ID:" />
                        <asp:TextBox ID="IDTextBox" runat="server" CssClass="form-control" MaxLength="20" />
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="CategoryIdRequiredFieldValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="IDTextBox" ValidationGroup="RegisterCategory" ErrorMessage="Enter an ID." />
                            <asp:CustomValidator ID="ExistsIDCustomValidator" runat="server" ControlToValidate="IDTextBox" 
                                ValidationGroup="RegisterCategory" ErrorMessage="El ID se encuentra registrado." 
                                OnServerValidate="ExistsIDCustomValidator_ServerValidate" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="NameLabel" runat="server" Text="Nombre:" />
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" MaxLength="250" />
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="NameTextBox" ValidationGroup="RegisterCategory" ErrorMessage="Enter a name." />
                        </div>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" ValidationGroup="RegisterCategory" 
                            OnClick="SaveButton_Click">
                            <i class="fa fa-plus"></i> Guardar
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" Text="Cancelar"
                            CssClass="btn btn-danger" OnClick="CancelButton_Click">
                            <i class="fa fa-times"></i> Cancelar	
                        </asp:LinkButton>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="CategoryIdHiddenField" runat="server" />

    <asp:ObjectDataSource ID="CategoryObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.Categories.BLL.CategoryBLL" SelectMethod="GetCategories" 
        OnSelected="CategoryObjectDataSource_Selected">
    </asp:ObjectDataSource>
</asp:Content>

