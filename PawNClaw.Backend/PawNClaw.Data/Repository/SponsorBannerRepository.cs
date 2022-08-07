using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class SponsorBannerRepository : Repository<SponsorBanner>, ISponsorBannerRepository
    {
        IPhotoRepository _photoRepository;

        public SponsorBannerRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public IEnumerable<SponsorBanner> GetSponsorBannersWithPhoto()
        {
            DateTime today = DateTime.Today;
            IQueryable<SponsorBanner> query = _dbSet
                .Where(x => x.Status == true && ((DateTime)x.StartDate).Date <= today && ((DateTime)x.EndDate).Date >= today)
                .Select(x => new SponsorBanner
                {
                    Id = x.Id,
                    Title = x.Title,
                    Content = x.Content,
                    StartDate = x.StartDate,
                    EndDate = x.EndDate,
                    Duration = x.Duration,
                    BrandId = x.BrandId,
                    Brand = x.Brand,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Banner)
                });

            return query.ToList();
        }

        public IEnumerable<SponsorBanner> GetSponsorBanners()
        {
            IQueryable<SponsorBanner> query = _dbSet
                .Where(x => x.Status == true)
                .Select(x => new SponsorBanner
                {
                    Id = x.Id,
                    Title = x.Title,
                    Content = x.Content,
                    StartDate = x.StartDate,
                    EndDate = x.EndDate,
                    Duration = x.Duration,
                    BrandId = x.BrandId,
                    Brand = x.Brand,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Banner),
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status
                });

            return query.ToList();
        }
    }
}
