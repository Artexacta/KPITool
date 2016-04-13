using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Seguimiento
{
    /// <summary>
    /// Summary description for Publicidad
    /// </summary>
    public class Publicidad
    {
        public string publicidad { get; set; }
        public int impacto { get; set; }
        public int notoriedad { get; set; }
        public int engagement { get; set; }
        public int persuasion { get; set; }
        public int efectividad { get; set; }
        public string empresa { get; set; }
        public int semana { get; set; }
        public bool destacado { get; set; }

        public Publicidad()
        {
        }

        public Publicidad(string _publicidad, int _impacto, int _notoriedad, int _engagement, int _persuasion, int _efectividad, string _empresa, int _semana, bool _destacado)
        {
            this.publicidad = _publicidad;
            this.impacto = _impacto;
            this.notoriedad = _notoriedad;
            this.engagement = _engagement;
            this.persuasion = _persuasion;
            this.efectividad = _efectividad;
            this.empresa = _empresa;
            this.semana = _semana;
            this.destacado = _destacado;
        }
    }
}