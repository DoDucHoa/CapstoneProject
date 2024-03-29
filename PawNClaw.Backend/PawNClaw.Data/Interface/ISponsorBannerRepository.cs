﻿using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface ISponsorBannerRepository : IRepository<SponsorBanner>
    {
        public IEnumerable<SponsorBanner> GetSponsorBannersWithPhoto();
        public IEnumerable<SponsorBanner> GetSponsorBanners();
    }
}
