﻿using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PetService
    {
        IPetRepository _petRepository;

        public PetService(IPetRepository petRepository)
        {
            _petRepository = petRepository;
        }

        public PagedList<Pet> GetsPetByCusId(int CusId, PagingParameter paging)
        {
            var values = _petRepository.GetPetByCustomer(CusId);
            return PagedList<Pet>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public bool UpdatePetForStaff(int id, decimal Weight, decimal Lenght, decimal Height)
        {
            return _petRepository.UpdatePetForStaff(id, Weight, Lenght, Height);
        }

        public async Task<bool> CreatePet(CreatePetRequestParameter createPetRequestParameter)
        {
            try
            {
                return await _petRepository.AddNewPet(createPetRequestParameter);
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool UpdatePetForCustomer(UpdatePetRequestForCusParameter updatePetRequestForCusParameter)
        {
            try
            {
                Pet pet = _petRepository.Get(updatePetRequestForCusParameter.Id);

                pet.Weight = updatePetRequestForCusParameter.Weight;
                pet.Length = updatePetRequestForCusParameter.Length;
                pet.Height = updatePetRequestForCusParameter.Height;
                pet.Name = updatePetRequestForCusParameter.Name;
                pet.Birth = updatePetRequestForCusParameter.Birth;
                pet.BreedName = updatePetRequestForCusParameter.BreedName;

                _petRepository.Update(pet);
                _petRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool DeletePet(int id)
        {
            try
            {
                _petRepository.DeletePet(id);
                return true;
            }
            catch
            {
                throw new Exception("Pet is booking already");
            }
        }

        public Pet GetPetById(int id)
        {
            return _petRepository.GetPetById(id);
        }
    }
}
