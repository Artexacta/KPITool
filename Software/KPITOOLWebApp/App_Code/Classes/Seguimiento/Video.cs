using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Seguimiento
{
    /// <summary>
    /// Summary description for Video
    /// </summary>
    public class Video
    {
        public int idCampana { get; set; }
        public string urlVideo { get; set; }
        public string nombreCombo { get; set; }

        public Video()
        {
        }

        public Video(int _idCampana, string _urlVideo)
        {
            this.idCampana = _idCampana;
            this.urlVideo = _urlVideo;
            this.nombreCombo = "Campaña " + this.idCampana;
        }
    }
}