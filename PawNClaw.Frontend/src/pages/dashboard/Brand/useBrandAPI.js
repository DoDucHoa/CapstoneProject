import axios from '../../../utils/axios';

const URL = '/api/brands';

const getBrands = async (page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(URL, {
    params: {
      Name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

const getBrand = async (idBrand) => {
  const response = await axios.get(`${URL}/${idBrand}`);
  return response.data;
};

const createBrand = async (name, description, ownerId, createUser, modifyUser) => {
  const response = await axios.post(URL, {
    name,
    description,
    ownerId,
    createUser,
    modifyUser,
  });
  return response.data;
};

const updateBrand = async (idBrand, name, description, ownerId) => {
  const response = await axios.put(`${URL}/${idBrand}`, {
    name,
    description,
    ownerId,
  });
  return response.status;
};

const banBrand = async (idBrand) => {
  const response = await axios.delete(`${URL}/${idBrand}`);
  return response.data;
};

const unbanBrand = async (idBrand) => {
  const response = await axios.put(`${URL}/restore/${idBrand}`);
  return response.data;
};

export { getBrand, getBrands, createBrand, banBrand, unbanBrand, updateBrand };
