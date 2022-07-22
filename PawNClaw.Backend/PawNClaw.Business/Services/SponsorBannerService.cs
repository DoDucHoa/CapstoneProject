using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class SponsorBannerService
    {
        ISponsorBannerRepository _sponsorBannerRepository;

        public SponsorBannerService(ISponsorBannerRepository sponsorBannerRepository)
        {
            _sponsorBannerRepository = sponsorBannerRepository;
        }

        public IEnumerable<SponsorBanner> GetSponsorBanners()
        {
            DateTime today = DateTime.Today;
            return _sponsorBannerRepository.GetSponsorBannersWithPhoto();
        }
    }
}
