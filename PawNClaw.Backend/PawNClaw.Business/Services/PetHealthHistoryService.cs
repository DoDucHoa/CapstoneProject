using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PetHealthHistoryService
    {
        IPetHealthHistoryRepository _petHealthHistoryRepository;
        IPetRepository _petRepository;

        private readonly ApplicationDbContext _db;

        public PetHealthHistoryService(IPetHealthHistoryRepository petHealthHistoryRepository, IPetRepository petRepository, 
            ApplicationDbContext db)
        {
            _petHealthHistoryRepository = petHealthHistoryRepository;
            _petRepository = petRepository;
            _db = db;
        }

        //Create Pet Health History
        public async Task<bool> CreatePetHealthHistory(CreateUpdatePetHealthHistoryParameter createUpdatePetHealthHistoryParameter)
        {
            PetHealthHistory petHealthHistory = new PetHealthHistory()
            {
                CheckedDate = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.CheckedDate,
                Description = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Description,
                CenterName = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.CenterName,
                PetId = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.PetId,
                Length = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Length,
                Height = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Height,
                Weight = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Weight,
                BookingId = createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.BookingId
            };


            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    var petHealth = _petHealthHistoryRepository.GetFirstOrDefault(x => x.BookingId == createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.BookingId);
                    if (petHealth != null)
                    {
                        _petHealthHistoryRepository.Remove(petHealth);
                        await _petHealthHistoryRepository.SaveDbChangeAsync();
                    }

                    _petHealthHistoryRepository.Add(petHealthHistory);
                    await _petHealthHistoryRepository.SaveDbChangeAsync();

                    if (createUpdatePetHealthHistoryParameter.IsUpdatePet)
                    {
                        _petRepository.UpdatePetForStaff(createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.PetId,
                            createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Weight,
                            createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Length,
                            createUpdatePetHealthHistoryParameter.createPetHealthHistoryParameter.Height);
                        await _petRepository.SaveDbChangeAsync();
                    }
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }

                transaction.Commit();
            }
            return true;
        }
    }
}
