﻿using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class OwnerRepository : Repository<Owner>, IOwnerRepository
    {
        private readonly ApplicationDbContext _db;

        public OwnerRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }
    }
}
