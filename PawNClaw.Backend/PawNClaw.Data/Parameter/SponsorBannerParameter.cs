using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class SponsorBannerParameter
    {
    }

    public class CreateSponsorBanner
    {
        public string Title { get; set; }
        public string Content { get; set; }
        public decimal? Duration { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int BrandId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
    }

    public class UpdateSponsorBanner
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public decimal? Duration { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int BrandId { get; set; }
    }
}
