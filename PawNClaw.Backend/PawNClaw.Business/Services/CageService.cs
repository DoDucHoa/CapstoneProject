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
    public class CageService
    {
        ICageRepository _cageRepository;

        public CageService(ICageRepository cageRepository)
        {
            _cageRepository = cageRepository;
        }

        public bool CreateCage(Cage cage)
        {
            try
            {
                _cageRepository.Add(cage);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool UpdateCage(UpdateCageParameter updateCageParameter)
        {
            try
            {
                var cage = _cageRepository.GetCage(updateCageParameter.Code, updateCageParameter.CenterId);
                cage.IsOnline = updateCageParameter.IsOnline;
                cage.ModifyDate = updateCageParameter.ModifyDate;
                cage.ModifyUser = updateCageParameter.ModifyUser;
                cage.Status = updateCageParameter.Status;

                _cageRepository.Update(cage);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
