using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
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

        public bool ShiftCage(List<String> cageCodes, int centerId)
        {
            try
            {
                _cageRepository.UpdateCageStatus(cageCodes, centerId);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw e;
            }
        }

        //Get Cages
        public PagedList<Cage> getCages(CageRequestParameter cageRequestParameter, PagingParameter pagingParameter)
        {
            try
            {
                var values = _cageRepository.GetCages(cageRequestParameter.CenterId);

                if(!string.IsNullOrWhiteSpace(cageRequestParameter.Code))
                {
                    values = values.Where(x => cageRequestParameter.Code.Equals(x.Code.Trim()));
                }

                if(cageRequestParameter.CageTypeId != null)
                {
                    values = values.Where(x => x.CageTypeId == cageRequestParameter.CageTypeId);
                }

                if(cageRequestParameter.IsOnline != null)
                {
                    values = cageRequestParameter.IsOnline switch
                    {
                        true => values.Where(x => x.IsOnline == true),
                        false => values.Where(x => x.IsOnline == false),
                        _ => values
                    };
                }

                if (cageRequestParameter.Status != null)
                {
                    values = cageRequestParameter.Status switch
                    {
                        true => values.Where(x => x.Status == true),
                        false => values.Where(x => x.Status == false),
                        _ => values
                    };
                }

                if (!string.IsNullOrWhiteSpace(cageRequestParameter.sort))
                {
                    switch (cageRequestParameter.sort)
                    {
                        case "code":
                            if (cageRequestParameter.dir == "asc")
                                values = values.OrderBy(d => d.Code);
                            else if (cageRequestParameter.dir == "desc")
                                values = values.OrderByDescending(d => d.Code);
                            break;
                    }
                }

                return PagedList<Cage>.ToPagedList(values.AsQueryable(),pagingParameter.PageNumber,pagingParameter.PageSize);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw e;
            }
        }
    }
}
