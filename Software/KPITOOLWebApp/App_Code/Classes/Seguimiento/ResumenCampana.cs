using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Seguimiento
{
    /// <summary>
    /// Summary description for ResumenCampana
    /// </summary>
    public class ResumenCampana
    {
        public int CampanaId { get; set; }
        public List<Publicidad> DatosPublicidad { get; set; }

        public string Semana 
        { 
            get 
            { 
                return "Semana " + this.CampanaId.ToString(); 
            } 
        }

        public ResumenCampana(int campanaId)
        {
            CampanaId = campanaId;
            DatosPublicidad = new List<Publicidad>();
        }
    }
}