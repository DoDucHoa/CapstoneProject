﻿using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PhotoRepository : Repository<Photo>, IPhotoRepository
    {
        private readonly ApplicationDbContext _db;

        public PhotoRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public void CreatePhotos(CreatePhotoParameter createPhotoParameter)
        {
            Photo photo = new Photo();
            photo.PhotoTypeId = createPhotoParameter.PhotoTypeId;
            photo.IdActor = createPhotoParameter.IdActor;
            photo.Line = _dbSet.Where(x => x.PhotoTypeId == createPhotoParameter.PhotoTypeId
                                    && x.IdActor == createPhotoParameter.IdActor).Count() + 1;
            photo.Url = createPhotoParameter.Url;
            photo.IsThumbnail = createPhotoParameter.IsThumbnail;
            photo.Status = true;

            _dbSet.Add(photo);

        }
    }
}
