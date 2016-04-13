<%@ Page Title="Configuracion" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="UserConfiguration.aspx.cs" Inherits="User_UserConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="lblOneColTitle" runat="server" Text="Configuracion" CssClass="title" />
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:Label ID="SavedSearchesLabel" runat="server" Text="Número de búsquedas guardadas" AssociatedControlID="SavedSearchesRadNumericTextBox_T"></asp:Label>
                                <telerik:RadNumericTextBox ID="SavedSearchesRadNumericTextBox_T" runat="server"
                                    Type="Number" DataType="Integer" MaxValue="20" MinValue="1"
                                    ButtonsPosition="Right" ShowSpinButtons="true"
                                    Width="100px" NumberFormat-DecimalDigits="0"
                                    ToolTip="Es el numero de busquedas que el sistema guardará">
                                </telerik:RadNumericTextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="DisplayToolTipsLabel" runat="server" Text="Número de veces a mostrar tooltips" AssociatedControlID="DisplayToolTipsRadNumericTextBox_T"></asp:Label>
                                <telerik:RadNumericTextBox ID="DisplayToolTipsRadNumericTextBox_T" runat="server"
                                    Type="Number" DataType="Integer" MaxValue="10" MinValue="1"
                                    ButtonsPosition="Right" ShowSpinButtons="true"
                                    Width="100px" NumberFormat-DecimalDigits="0"
                                    ToolTip="Es el numero de veces que se mostrará ciertos tooltips">
                                </telerik:RadNumericTextBox>
                            </div>
                            <p>
                                <asp:LinkButton ID="ResetToolTipsButton" runat="server" OnClick="ResetToolTipsButton_Click"
                                    OnClientClick="return confirm('Esta seguro que desea reestablecer el uso de los tooltips?')" CssClass="btn btn-info min-letter">
                                        <i class="fa fa-refresh"></i> Reestablecer uso de tooltips
                                </asp:LinkButton>
                            </p>
                            <div class="text-center" style="margin: 15px 0;">
                                <div class="buttonsPanel">
                                    <asp:LinkButton ID="SaveButton" runat="server" CausesValidation="True"
                                        ValidationGroup="Config" CssClass="btn btn-primary" OnClick="SaveButton_Click">
                                        <asp:Label ID="SaveButtonnLabel" runat="server" />
                                        <i class="fa fa-floppy-o"></i>Guardar Configuración
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="SaveCancelButton" runat="server" CausesValidation="False"
                                        CssClass="btn btn-danger" OnClick="CancelButton_Click">
                                        <asp:Label ID="CancelButtonLabel" runat="server" />
                                        <i class="fa fa-times"></i>Cancelar
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

