using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Quantity
/// </summary>
/// 
namespace Artexacta.App.Utilities.Quantity
{
    public class Quantity
    {
        public int Areas { get; set; }
        public int Projects { get; set; }
        public int People { get; set; }
        public int Activities { get; set; }
        public int Kpis { get; set; }

        public Quantity()
        {
        }

        public Quantity(int areas, int projects, int people, int activities, int kpis)
        {
            Areas = areas;
            Projects = projects;
            People = people;
            Activities = activities;
            Kpis = kpis;
        }
    }
}