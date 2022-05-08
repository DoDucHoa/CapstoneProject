using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PetCenterRepository : Repository<PetCenter>, IPetCenterRepository
    {
        private readonly ApplicationDbContext _db;

        public PetCenterRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<PetCenter> SearchPetCenter(string City, string District)
        {
            IQueryable<PetCenter> query = _dbSet;

            query = query.Include("Location").Where(x => x.Location.CityId.ToString().Trim().Equals(City) 
                                            && x.Location.DistrictId.ToString().Trim().Equals(District));

            return query.ToList();
        }

        //public IEnumerable<PetCenter> CheckBookingPetCenter(int Id)
        //{
        //    IQueryable<PetCenter> query = _dbSet;

        //    var petCenter = query.Include("Bookings").FirstOrDefault(x => x.Id == Id);

        //    ICollection<Booking> bookings = petCenter.Bookings;



        //    return query.ToList();
        //}
    }
}
