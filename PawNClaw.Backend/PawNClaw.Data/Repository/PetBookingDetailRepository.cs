using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PetBookingDetailRepository : Repository<PetBookingDetail>, IPetBookingDetailRepository
    {

        public PetBookingDetailRepository(ApplicationDbContext db) : base(db)
        {
        }

        public IEnumerable<PetBookingDetail> GetPetBookingDetailsByBookingId(int BookingId)
        {
            IQueryable<PetBookingDetail> query = _dbSet
                .Include(x => x.Pet)
                .ThenInclude(pet => pet.PetHealthHistories)
                .Select(x => new PetBookingDetail
                {
                    BookingId = x.BookingId,
                    Line = x.Line,
                    Pet = new Pet
                    {
                        Id = x.Pet.Id,
                        Weight = x.Pet.Weight,
                        Length = x.Pet.Length,
                        Height = x.Pet.Height,
                        Name = x.Pet.Name,
                        Birth = x.Pet.Birth,
                        CustomerId = x.Pet.CustomerId,
                        PetTypeCode = x.Pet.PetTypeCode,
                        BreedName = x.Pet.BreedName,
                        PetHealthHistories = (ICollection<PetHealthHistory>)x.Pet.PetHealthHistories
                        .Where(health => health.Id == x.Pet.PetHealthHistories.Max(x => x.Id))
                    }
                })
                .Where(x => x.BookingId == BookingId);

            return query.ToList();
        }
    }
}
