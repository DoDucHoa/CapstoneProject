using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
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

        public IEnumerable<SponsorBanner> GetBanners(int? Month, int? Year)
        {
            var values = _sponsorBannerRepository.GetSponsorBanners();

            if (Month != null && Year != null)
            {
                values = values.Where(x => ((DateTime)x.EndDate).Month == Month && ((DateTime)x.EndDate).Year == Year);
            }

            values = values.OrderByDescending(x => x.EndDate);

            return values;
        }

        public async Task<int> Create(CreateSponsorBanner sponsorBannerP)
        {
            var firstDayOfMonth = new DateTime(sponsorBannerP.Year, sponsorBannerP.Month, 1);
            var lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            SponsorBanner sponsorBanner = new SponsorBanner()
            {
                Title = sponsorBannerP.Title,
                Content = sponsorBannerP.Content,
                StartDate = firstDayOfMonth,
                EndDate = lastDayOfMonth,
                Duration = sponsorBannerP.Duration,
                CreateDate = sponsorBannerP.CreateDate,
                ModifyDate = sponsorBannerP.ModifyDate,
                CreateUser = sponsorBannerP.CreateUser,
                ModifyUser = sponsorBannerP.ModifyUser,
                Status = true,
                BrandId = sponsorBannerP.BrandId
            };

            var check = _sponsorBannerRepository.GetAll(x => x.Status == true 
                                                        && ((DateTime)x.StartDate).Date == firstDayOfMonth
                                                        && ((DateTime)x.EndDate).Date == lastDayOfMonth);
            var constraint = await ConstService.Get(Const.ProjectFirebaseId, "Const", "Config");

            var limitObj = constraint["numOfSponsor"];
            var limit = Convert.ToInt32(limitObj);

            if (check.Count() >= limit)
            {
                throw new Exception("Max limit sponsor for this month");
            }

            _sponsorBannerRepository.Add(sponsorBanner);
            _sponsorBannerRepository.SaveDbChange();
            return sponsorBanner.Id;
        }

        public bool Update(UpdateSponsorBanner sponsorBannerP)
        {
            SponsorBanner sponsorBanner = _sponsorBannerRepository.Get(sponsorBannerP.Id);
            sponsorBanner.Title = sponsorBannerP.Title;
            sponsorBanner.Content = sponsorBannerP.Content;
            sponsorBanner.Duration = sponsorBannerP.Duration;
            sponsorBanner.ModifyDate = sponsorBannerP.ModifyDate;
            sponsorBanner.ModifyUser = sponsorBannerP.ModifyUser;
            sponsorBanner.Status = sponsorBannerP.Status;
            sponsorBanner.BrandId = sponsorBannerP.BrandId;

            _sponsorBannerRepository.Update(sponsorBanner);
            _sponsorBannerRepository.SaveDbChange();
            return true;
        }

        public async Task<bool> UpdateExpired(UpdateExpiredSponsorBanner sponsorBannerP)
        {
            var firstDayOfMonth = new DateTime(sponsorBannerP.Year, sponsorBannerP.Month, 1);
            var lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            SponsorBanner sponsorBanner = _sponsorBannerRepository.Get(sponsorBannerP.Id);
            sponsorBanner.EndDate = lastDayOfMonth;
            sponsorBanner.ModifyDate = sponsorBannerP.ModifyDate;
            sponsorBanner.ModifyUser = sponsorBannerP.ModifyUser;

            var check = _sponsorBannerRepository.GetAll(x => x.Status == true 
                                                        && ((DateTime)x.StartDate).Date <= sponsorBanner.StartDate
                                                        && ((DateTime)x.EndDate).Date >= lastDayOfMonth);
            var constraint = await ConstService.Get(Const.ProjectFirebaseId, "Const", "Config");

            var limitObj = constraint["numOfSponsor"];
            var limit = Convert.ToInt32(limitObj);

            if (check.Count() >= limit)
            {
                throw new Exception("Max limit sponsor for this month");
            }

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
