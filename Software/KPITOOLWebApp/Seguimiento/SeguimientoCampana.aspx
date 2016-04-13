<%@ Page Title="Seguimiento de Campañas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SeguimientoCampana.aspx.cs" Inherits="Seguimiento_SeguimientoCampana" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                Seguimiento de Campañas
                <asp:DropDownList ID="CampanaComboBox" runat="server" CssClass="form-control pull-right" Width="200" OnSelectedIndexChanged="CampanaComboBox_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
            </div>
        </div>

        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-12" style="overflow: hidden">
                    <span style="font-size: 14px; font-weight: bold; float: left; margin-right: 20px; padding-top: 6px;">Estadísticas de la semana</span>
                    <asp:DropDownList ID="SemanaComboBox" runat="server" CssClass="form-control pull-left" Width="100" OnSelectedIndexChanged="SemanaComboBox_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <p class="m-t-15"><b>KPIs de Campaña</b></p>
                    <asp:Repeater ID="KPIRepeater" runat="server">
                        <ItemTemplate>
                            <div class="row m-t-5 m-b-5">
                                <div class="col-md-6">
                                    <p class="p-t-10"><%#Eval("descripcion") %></p>
                                </div>
                                <div class="col-md-3">
                                    <%#Convert.ToInt32(Eval("anterior")) > Convert.ToInt32(Eval("actual")) ?
                                        "<i class=\"zmdi zmdi-long-arrow-down c-red pull-left\" style=\"font-size: 20px; padding-top: 10px;\"></i>":"<i class=\"zmdi zmdi-long-arrow-up c-lightgreen pull-left\" style=\"font-size: 20px; padding-top: 10px;\"></i>"%>
                                    <div class="btn btn-default btn-icon pull-left" style="padding-top: 7px; font-size: 18px;"><%#Eval("anterior") %></div>
                                </div>
                                <div class="col-md-3">
                                    <%#Convert.ToInt32(Eval("anterior")) < Convert.ToInt32(Eval("actual")) ?
                                        "<div class=\"btn bg-lightgreen btn-icon\" style=\"padding-top: 7px; font-size: 18px;\">"+ Eval("actual") +"</div>":"<div class=\"btn bg-red btn-icon\" style=\"padding-top: 7px; font-size: 18px;\">"+ Eval("actual") +"</div>"%>
                                </div>
                            </div>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <div class="row m-t-5 m-b-5" style="background: #FCFCFC;">
                                <div class="col-md-6">
                                    <p class="p-t-10"><%#Eval("descripcion") %></p>
                                </div>
                                <div class="col-md-3">
                                    <%#Convert.ToInt32(Eval("anterior")) > Convert.ToInt32(Eval("actual")) ?
                                        "<i class=\"zmdi zmdi-long-arrow-down c-red pull-left\" style=\"font-size: 20px; padding-top: 10px;\"></i>":"<i class=\"zmdi zmdi-long-arrow-up c-lightgreen pull-left\" style=\"font-size: 20px; padding-top: 10px;\"></i>"%>
                                    <div class="btn btn-default btn-icon pull-left" style="padding-top: 7px; font-size: 18px;"><%#Eval("anterior") %></div>
                                </div>
                                <div class="col-md-3">
                                    <%#Convert.ToInt32(Eval("anterior")) < Convert.ToInt32(Eval("actual")) ?
                                        "<div class=\"btn bg-lightgreen btn-icon\" style=\"padding-top: 7px; font-size: 18px;\">"+ Eval("actual") +"</div>":"<div class=\"btn bg-red btn-icon\" style=\"padding-top: 7px; font-size: 18px;\">"+ Eval("actual") +"</div>"%>
                                </div>
                            </div>
                        </AlternatingItemTemplate>
                    </asp:Repeater>
                    <div class="bg-bluegray count-box m-t-15">
                        <div class="row">
                            <div class="col-sm-6 col-xs-6">
                                <div class="cb-item">
                                    <h3>5400 USD</h3>
                                    <small>Inversión</small>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xs-6">
                                <div class="cb-item">
                                    <h3>38</h3>
                                    <small>GRP</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="embed-responsive embed-responsive-16by9">
                        <asp:Literal ID="videoFrame" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="row">
        <div class="col-md-3 col-sm-6">
            <div class="o-item bg-teal">
                <div class="oi-title">
                    <span data-value="452"></span>
                    <span>Opinión sobre la Publicidad</span>
                </div>
                <div class="overview-chart-bar text-center">
                    <!-- 6,9,5,6,3,7,5,4,6,5,6,4,2,5,8,3,9,1,3,5,6,7,6,8,2,5,2,7,5 -->
                </div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="bg-lightgreen text-center p-20">
                <div class="pie-chart-tiny po-item" data-percent="57">
                    <span class="poi-percent">57</span>
                </div>
                <div class="text-center c-white f-12">Recuerda esta publicidad</div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="bg-amber text-center p-20">
                <div class="pie-chart-tiny po-item" data-percent="66">
                    <span class="poi-percent">66</span>
                </div>
                <div class="text-center c-white f-12">Lo vió en televisión</div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="bg-orange text-center p-20">
                <div class="pie-chart-tiny po-item" data-percent="34">
                    <span class="poi-percent">34</span>
                </div>
                <div class="text-center c-white f-12">Lo vió en Internet</div>
            </div>
        </div>
    </div>
    <div class="tile icons-demo">
        <div class="t-body tb-padding">
            <div class="row m-t-20">
                <div class="col-md-12" id="filtros">
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkDataUsersNonDataUsers" value="DataUsersNonDataUsers" />
                        <i class="input-helper"></i>
                        Data Users / Non Data Users
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkCiudad" value="Ciudad" checked="checked" />
                        <i class="input-helper"></i>
                        Ciudad
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkSexo" value="Sexo" checked="checked" />
                        <i class="input-helper"></i>
                        Sexo
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkNse" value="NSE" />
                        <i class="input-helper"></i>
                        NSE
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkEdad" value="Edad" checked="checked" />
                        <i class="input-helper"></i>
                        Edad
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkClientesTigo" value="ClientesTigo" />
                        <i class="input-helper"></i>
                        Clientes / No Clientes TIGO
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkUsuariosTvPaga" value="UsuariosTvPaga" />
                        <i class="input-helper"></i>
                        Usuarios TV Paga
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkInternet" value="Internet" />
                        <i class="input-helper"></i>
                        Internet
                    </label>
                    <label class="checkbox checkbox-inline cr-alt">
                        <input type="checkbox" id="ChkPerfil" value="Perfil" checked="checked" />
                        <i class="input-helper"></i>
                        Perfil
                    </label>


                </div>



            </div>

        </div>

        <div class="table-responsive m-15">
            <table class="table table-striped datos-campana">
                <thead>
                    <tr>
                        <th rowspan="2"></th>
                        <th rowspan="2">Efectividad</th>
                        <th colspan="2" class="Sexo">Sexo</th>
                        <th colspan="2" class="Edad">Edad</th>
                        <th colspan="2" class="Perfil">Perfil</th>
                        <th colspan="2" class="Ciudad">Ciudad</th>
                        <th rowspan="2">Total</th>
                    </tr>
                    <tr>
                        <th class="Sexo">Hombre</th>
                        <th class="Sexo">Mujer</th>
                        <th class="Edad">15 a 18 años</th>
                        <th class="Edad">19 a 25 años</th>
                        <th class="Perfil">Ramiro</th>
                        <th class="Perfil">Sebastián</th>
                        <th class="Ciudad">La Paz</th>
                        <th class="Ciudad">Santa Cruz</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td rowspan="3" class="bold text-uppercase c-black">
                            <div class="rotate-minus-90 text-center">Impacto</div>
                        </td>
                        <td class="descripcion">Ha visto la publicidad</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">49%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">34%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">45%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">36%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">44%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">36%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">33%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">49%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">32%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Sabe de qué marca es</td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">53%</div>
                        </td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">71%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">67%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">58%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">67%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">50%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">70%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">45%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">62%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold text-center">Brand Linkage</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">26%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">24%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">30%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">21%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">29%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">18%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">23%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">22%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-lightgreen btn-icon center-circle">20%</div>
                        </td>
                    </tr>

                    <tr>
                        <td rowspan="4" class="bold text-uppercase c-black">
                            <div class="rotate-minus-90 text-center">Notoriedad</div>
                        </td>
                        <td class="descripcion">Llamó su atención</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">33%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">30%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">39%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">24%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">32%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">29%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">43%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">19%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">31%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Podría repetirlo</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">44%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">39%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">55%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">29%</div>
                        </td>
                        <td class="cbold Perfil">
                            <div class="btn bg-red btn-icon center-circle">42%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">40%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">43%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">19%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">31%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Comentaría con amigos</td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">37%</div>
                        </td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">38%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">53%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">24%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">41%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">33%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">47%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">28%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">38%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold text-center">Promedio Notoriedad</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">38%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">36%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">49%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">25%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">38%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">34%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">48%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">26%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-lightgreen btn-icon center-circle">37%</div>
                        </td>
                    </tr>

                    <tr>
                        <td rowspan="7" class="bold text-uppercase c-black">
                            <div class="rotate-minus-90 text-center">Engagement</div>
                        </td>
                        <td class="descripcion">Era creible</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">52%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">71%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">44%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">59%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">55%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">51%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">57%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Información nueva</td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">30%</div>
                        </td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">62%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">59%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">38%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">49%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">50%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">57%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">40%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">48%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Información diferente</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">67%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">52%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">67%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">51%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">58%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">62%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">67%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">51%</div>
                        </td>
                        <td class="bold">
                            <div class="btn bg-red btn-icon center-circle">59%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Tiene mucha importancia</td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">33%</div>
                        </td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">52%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">59%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">31%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">49%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">38%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">45%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">43%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">44%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Lo entretuvo</td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">58%</div>
                        </td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">62%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">69%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">53%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">60%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">65%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">57%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">61%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Identificación con la marca</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">37%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">34%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">51%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">22%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">46%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">21%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">37%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">34%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">36%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold text-center">Promedio Engagement</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">48%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">52%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">63%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">40%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">54%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">48%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">56%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">46%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-lightgreen btn-icon center-circle">51%</div>
                        </td>
                    </tr>

                    <tr>
                        <td rowspan="5" class="bold text-uppercase c-black">
                            <div class="rotate-minus-90 text-center">Persiuación</div>
                        </td>
                        <td class="descripcion">Representa a la marca</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">74%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">56%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">69%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">58%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">71%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">55%</div>
                        </td>
                        <td class="bold Ciudad">
                            <div class="btn bg-red btn-icon center-circle">76%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">51%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">63%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Aumenta su atractivo</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">59%</div>
                        </td>
                        <td class="cbold Edad">
                            <div class="btn bg-red btn-icon center-circle">71%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">51%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">60%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">67%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">55%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">61%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Motivó su compra</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">51%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">49%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">63%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">38%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">51%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">48%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">57%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">43%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">50%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="descripcion">Aumentó su conocimiento</td>
                        <td class="bold Sexo">
                            <div class="btn bg-red btn-icon center-circle">58%</div>
                        </td>
                        <td class="Sexo">
                            <div class="btn bg-cyan btn-icon center-circle">56%</div>
                        </td>
                        <td class="bold Edad">
                            <div class="btn bg-red btn-icon center-circle">78%</div>
                        </td>
                        <td class="Edad">
                            <div class="btn bg-cyan btn-icon center-circle">38%</div>
                        </td>
                        <td class="bold Perfil">
                            <div class="btn bg-red btn-icon center-circle">58%</div>
                        </td>
                        <td class="Perfil">
                            <div class="btn bg-cyan btn-icon center-circle">57%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">69%</div>
                        </td>
                        <td class="Ciudad">
                            <div class="btn bg-cyan btn-icon center-circle">45%</div>
                        </td>
                        <td>
                            <div class="btn bg-gray btn-icon center-circle">57%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold text-center">Promedio Persuación</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">62%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">55%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">70%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">46%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">61%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">55%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">67%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">49%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-lightgreen btn-icon center-circle">58%</div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="11"></td>
                    </tr>


                    <tr>
                        <td rowspan="2" style="border-top: 0px;"></td>
                        <td class="bold text-center">Promedio Total</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">49%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-lightgreen btn-icon center-circle">48%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">61%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-lightgreen btn-icon center-circle">37%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">51%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-lightgreen btn-icon center-circle">46%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">57%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-lightgreen btn-icon center-circle">40%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-lightgreen btn-icon center-circle">48%</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="bold text-center">Indice de Efectividad (Impacto x Persuación)</td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-green btn-icon center-circle">16%</div>
                        </td>
                        <td class="bold text-center Sexo">
                            <div class="btn bg-green btn-icon center-circle">13%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-green btn-icon center-circle">21%</div>
                        </td>
                        <td class="bold text-center Edad">
                            <div class="btn bg-green btn-icon center-circle">10%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-green btn-icon center-circle">18%</div>
                        </td>
                        <td class="bold text-center Perfil">
                            <div class="btn bg-green btn-icon center-circle">10%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-green btn-icon center-circle">16%</div>
                        </td>
                        <td class="bold text-center Ciudad">
                            <div class="btn bg-green btn-icon center-circle">11%</div>
                        </td>
                        <td class="bold text-center">
                            <div class="btn bg-green btn-icon center-circle">11%</div>
                        </td>
                    </tr>
                </tbody>

            </table>


            <script type="text/javascript">
                $(document).ready(function () {
                    $("#filtros input[type='checkbox']").click(function () {
                        var column = $(this).val();
                        if ($(this).is(":checked"))
                            $("." + column).show();
                        else
                            $("." + column).hide();
                    });

                    /*Chart Line*/
                    function sparklineBar(id, height, barWidth, barColor, barSpacing) {
                        $('.' + id).sparkline('html', {
                            type: 'bar',
                            height: height,
                            barWidth: barWidth,
                            barColor: barColor,
                            barSpacing: barSpacing
                        })
                    }

                    if ($('.overview-chart-bar')[0]) {
                        sparklineBar('overview-chart-bar', 111, 5, 'rgba(255,255,255,0.9)', 2);
                    }

                    function easyPieChart(id, barColor, trackColor, scaleColor, lineWidth, size) {
                        $('.' + id).easyPieChart({
                            easing: 'easeOutBounce',
                            barColor: barColor,
                            trackColor: trackColor,
                            scaleColor: scaleColor,
                            lineCap: 'square',
                            lineWidth: lineWidth,
                            size: size,
                            animate: 3000,
                            onStep: function (from, to, percent) {
                                $(this.el).find('.percent').text(Math.round(percent));
                            }
                        });
                    }

                    easyPieChart('pie-chart-tiny', '#fff', 'rgba(0,0,0,0.08)', 'rgba(0,0,0,0)', 3, 100);

                });
            </script>
        </div>
    </div>
</asp:Content>

