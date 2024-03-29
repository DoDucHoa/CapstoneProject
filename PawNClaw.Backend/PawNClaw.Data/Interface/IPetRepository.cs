﻿using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IPetRepository : IRepository<Pet>
    {
        public IEnumerable<Pet> GetPetByCustomer(int CusId);
        public bool UpdatePetForStaff(int id, decimal Weight, decimal Lenght, decimal Height);
        public Task<bool> AddNewPet(CreatePetRequestParameter createPetRequestParameter);
        public bool DeletePet(int petId);
        public Pet GetPetById(int id);
    }
}
