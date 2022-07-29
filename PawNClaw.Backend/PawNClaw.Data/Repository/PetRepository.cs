using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PetRepository : Repository<Pet>, IPetRepository
    {
        private readonly ApplicationDbContext _db;
        private PhotoRepository _photoRepository;
        IPetBookingDetailRepository _petBookingDetailRepository;

        public PetRepository(ApplicationDbContext db, PhotoRepository photoRepository, IPetBookingDetailRepository petBookingDetailRepository) : base(db)
        {
            _db = db;
            _photoRepository = photoRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
        }

        public async Task<bool> AddNewPet(CreatePetRequestParameter createPetRequestParameter)
        {
            int petId = 0;
            Pet pet = new Pet()
            {
                Birth = createPetRequestParameter.Birth,
                BreedName = createPetRequestParameter.BreedName,
                CustomerId = createPetRequestParameter.CustomerId,
                Height = createPetRequestParameter.Height,
                Length = createPetRequestParameter.Length,
                Name = createPetRequestParameter.Name,
                PetTypeCode = createPetRequestParameter.PetTypeCode,
                Weight = createPetRequestParameter.Weight,
                Status = createPetRequestParameter.Status
            };

            //create pet
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                
                try
                {
                    _db.Add(pet);
                    await _db.SaveChangesAsync();
                    petId = pet.Id;
                    if (!string.IsNullOrWhiteSpace(createPetRequestParameter.photoUrl))
                    {
                        CreatePhotoParameter createPhotoParameter = new CreatePhotoParameter()
                        {
                            IdActor = petId,
                            IsThumbnail = true,
                            PhotoTypeId = 7,
                            Url = createPetRequestParameter.photoUrl
                        };

                        _photoRepository.CreatePhotos(createPhotoParameter);
                        await _photoRepository.SaveDbChangeAsync();

                    }
                    
                    transaction.Commit();
                    return true;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }

        public bool DeletePet(int petId)
        {
            if(_petBookingDetailRepository.GetFirstOrDefault(x => x.PetId == petId && (x.BookingDetail.Booking.StatusId == 2 || x.BookingDetail.Booking.StatusId == 1)) == null){
                Pet pet = _dbSet.Find(petId);
                pet.Status = false;
                try
                {
                    _dbSet.Update(pet);
                    return (_db.SaveChanges() >= 0);
                }
                catch
                {
                    return false;
                }
            }
            else
            {
                throw new Exception();
            }
        }

        public IEnumerable<Pet> GetPetByCustomer(int CusId)
        {
            IQueryable<Pet> query = _dbSet;

            query = query.Where(x => x.CustomerId == CusId && x.Status == true).Include(x => x.PetHealthHistories);

            return query.ToList();
        }

        public bool UpdatePetForStaff(int id, decimal Weight, decimal Lenght, decimal Height)
        {
            Pet query = _dbSet.Find(id);

            query.Weight = (decimal)Weight;
            query.Length = (decimal)Lenght;
            query.Height = (decimal)Height;

            try
            {
                _dbSet.Update(query);
                return (_db.SaveChanges() >= 0);
            }
            catch
            {
                return false;
            }
        }
    }
}
