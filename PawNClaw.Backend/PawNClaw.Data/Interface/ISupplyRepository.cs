﻿using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface ISupplyRepository : IRepository<Supply>
    {
        IEnumerable<Supply> GetSuppliesWithType(int centerId);

        public Supply GetSupplyById(int id);
    }
}
