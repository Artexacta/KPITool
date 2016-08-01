using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Tour
{

    /// <summary>
    /// Summary description for TourBLL
    /// </summary>
    public class TourBLL
    {
        public TourBLL()
        {
            
        }

        public static void SetUserTourStatus(int userId, string tourId)
        {
            if (userId <= 0)
                throw new ArgumentException("UserId cannot be equals or less than zero");

            if (string.IsNullOrEmpty(tourId))
                throw new ArgumentException("TourId cannot be null or empty");

            TourDSTableAdapters.QueriesTableAdapter adapter = new TourDSTableAdapters.QueriesTableAdapter();
            adapter.SetUserTourStatus(userId, tourId);
        }

        public static bool CheckIfUserViewTour(int userId, string tourId)
        {
            if (userId <= 0)
                throw new ArgumentException("UserId cannot be equals or less than zero");

            if (string.IsNullOrEmpty(tourId))
                throw new ArgumentException("TourId cannot be null or empty");

            bool? status = false;
            TourDSTableAdapters.QueriesTableAdapter adapter = new TourDSTableAdapters.QueriesTableAdapter();
            adapter.CheckUserTourStatus(userId, tourId, ref status);

            return status.Value;
        }
    }
}