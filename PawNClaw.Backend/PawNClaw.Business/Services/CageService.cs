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

        public bool CreateCage(CreateCageParameter createCageParameter)
        {
            try
            {
                Cage cage = new Cage()
                {
                    CenterId = createCageParameter.CenterId,
                    CageTypeId = createCageParameter.CageTypeId,
                    Code = createCageParameter.Code,
                    Color = createCageParameter.Color,
                    Name = createCageParameter.Name,
                    CreateUser = createCageParameter.CreateUser,
                    ModifyUser = createCageParameter.ModifyUser,
                    IsOnline = createCageParameter.IsOnline
                };
                _cageRepository.Add(cage);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
        
        //update cage detail
        public bool UpdateCage(UpdateCageParameter updateCageParameter)
        {
            try
            {
                var cage = _cageRepository.GetCage(updateCageParameter.Code, updateCageParameter.CenterId);
                cage.IsOnline = updateCageParameter.IsOnline;
                cage.ModifyDate = updateCageParameter.ModifyDate;
                cage.ModifyUser = updateCageParameter.ModifyUser;
                cage.Status = updateCageParameter.Status;
                cage.Color = updateCageParameter.Color;
                cage.Name = updateCageParameter.Name;
                cage.CageTypeId = updateCageParameter.CageTypeId;

                _cageRepository.Update(cage);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        //shift cage between onl/off
        public bool ShiftCage(string cageCode, int centerId)
        {
            try
            {
                _cageRepository.UpdateCageStatus(cageCode, centerId);
                _cageRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
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
                    values = values.Where(x => cageRequestParameter.Code.ToLower().Contains(x.Code.Trim()));
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

                if(cageRequestParameter.CanShift != null)
                {
                    values = cageRequestParameter.CanShift switch
                    {
                        true => values.Where(x => x.CanShift == true),
                        false => values.Where(x => x.CanShift == false),
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

                if (cageRequestParameter.from != null && cageRequestParameter.to != null)
                {
                    values = values.Where(x => !x.BookingDetails.Any(detail =>
                                (((DateTime.Compare((DateTime)cageRequestParameter.from, (DateTime)detail.Booking.StartBooking) <= 0
                                && DateTime.Compare((DateTime)cageRequestParameter.to, (DateTime)detail.Booking.EndBooking) >= 0)
                                ||
                                (DateTime.Compare((DateTime)cageRequestParameter.from, (DateTime)detail.Booking.StartBooking) >= 0
                                && DateTime.Compare((DateTime)cageRequestParameter.from, (DateTime)detail.Booking.EndBooking) < 0)
                                ||
                                (DateTime.Compare((DateTime)cageRequestParameter.to, (DateTime)detail.Booking.StartBooking) > 0
                                && DateTime.Compare((DateTime)cageRequestParameter.to, (DateTime)detail.Booking.EndBooking) <= 0))
                                && (detail.Booking.StatusId == 1 || detail.Booking.StatusId == 2))));
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
            catch
            {
                throw new Exception();
            }
        }
    }
}
