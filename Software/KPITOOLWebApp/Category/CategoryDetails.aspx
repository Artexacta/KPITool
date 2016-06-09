<%@ Page Title="Category Details" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="CategoryDetails.aspx.cs" Inherits="Category_CategoryDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5><asp:Label ID="TitleLabel" runat="server" /></h5>
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
                        <asp:LinkButton ID="NewButton" runat="server" Text="<i class='fa fa-plus'></i> Nuevo Item" CssClass="btn btn-primary "
                            OnClick="NewButton_Click"></asp:LinkButton>
                        <asp:LinkButton ID="ReturnButton" runat="server" Text="Volver al listado" CssClass="btn btn-info" OnClick="ReturnButton_Click">
                        </asp:LinkButton>
                    </p>
                </div>
                <div class="col-md-7">
                    <div class="table-responsive">
                        <asp:GridView ID="CategoryItemGridView" runat="server" DataSourceID="CategoryItemObjectDataSource" AutoGenerateColumns="False" 
                            CssClass="table table-striped table-bordered table-hover" GridLines="None" Width="100%" OnRowCommand="CategoryItemGridView_RowCommand">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <Columns>
                                <asp:TemplateField HeaderText="Editar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditImageButton" runat="server" CommandName="EditData" CssClass="text-success img-buttons" 
                                            Text="<i class='fa fa-pencil'></i>" CommandArgument='<%#Eval("ItemID")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Eliminar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="DeleteImageButton" runat="server" CommandName="DeleteData" CssClass="text-danger img-buttons" 
                                            Text="<i class='fa fa-trash-o'></i>" CommandArgument='<%#Eval("ItemID")%>' 
                                            OnClientClick="return confirm('¿Está seguro de eliminar el item?')" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ItemID" HeaderText="ID" SortExpression="ID"></asp:BoundField>
                                <asp:BoundField DataField="ItemName" HeaderText="Name" SortExpression="Name"></asp:BoundField>
                            </Columns>
                            <EmptyDataTemplate>
                                No se tienen items registrados
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
                <asp:Panel ID="pnlEditData" runat="server" CssClass="col-md-5" DefaultButton="SaveButton" Visible="false">
                    <div class="form-group">
                        <asp:Label ID="IDLabel" runat="server" Text="ID:" />
                        <asp:TextBox ID="IDTextBox" runat="server" CssClass="form-control" MaxLength="20" />
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="CategoryItemIdRequiredFieldValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="IDTextBox" ValidationGroup="RegisterCategory" ErrorMessage="Enter an ID." />
                            <asp:RegularExpressionValidator ID="CategoryItemRegularExpressionValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="IDTextBox" ValidationGroup="RegisterCategoryItem" ErrorMessage="Invalid characters." 
                                ValidationExpression="<%$ Resources:Validations, CodeFormat %>" />
                            <asp:CustomValidator ID="ExistsIDCustomValidator" runat="server" ControlToValidate="IDTextBox" 
                                ValidationGroup="RegisterCategoryItem" ErrorMessage="El ID se encuentra registrado." 
                                OnServerValidate="ExistsIDCustomValidator_ServerValidate" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="NameLabel" runat="server" Text="Nombre:" />
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" MaxLength="250" />
                        <div class="has-error m-b-10">
                            <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="NameTextBox" ValidationGroup="RegisterCategoryItem" ErrorMessage="Enter a name." />
                        </div>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" ValidationGroup="RegisterCategoryItem" 
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
    <asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" />

    <asp:ObjectDataSource ID="CategoryItemObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.Categories.CategoryItemBLL" SelectMethod="GetCategoriesItemByCategoryId"
        OnSelected="CategoryItemObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="CategoryIdHiddenField" PropertyName="Value" Name="categoryId" Type="String"></asp:ControlParameter>
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

