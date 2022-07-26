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

        public bool Create(SponsorBanner sponsorBanner)
        {
            _sponsorBannerRepository.Add(sponsorBanner);
            _sponsorBannerRepository.SaveDbChange();
            return true;
        }

        public bool Update(SponsorBanner sponsorBanner)
        {
            _sponsorBannerRepository.Update(sponsorBanner);
            _sponsorBannerRepository.SaveDbChange();
            return true;
        }

        public bool Deactivate(int id)
        {
            var sponsor = _sponsorBannerRepository.Get(id);
            sponsor.Status = false;
            _sponsorBannerRepository.Update(sponsor);
            _sponsorBannerRepository.SaveDbChange();
            return true;
        }
    }
}
