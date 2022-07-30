import axios from '../../../utils/axios';

const URL = '/api/supplies';

const getSupplies = async (centerId, page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(`${URL}/center`, {
    params: {
      CenterId: centerId,
      Name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

const getSupply = async (idSupply) => {
  const response = await axios.get(`${URL}/${idSupply}`);
  return response.data;
};

const createSupply = async (name, description, ownerId, createUser, modifyUser) => {
  const response = await axios.post(URL, {
    name,
    description,
    ownerId,
    createUser,
    modifyUser,
  });
  return response.data;
};

const updateSupply = async (idSupply, name, description, ownerId) => {
  const response = await axios.put(`${URL}/${idSupply}`, {
    name,
    description,
    ownerId,
  });
  return response.status;
};

const banSupply = async (idSupply) => {
  const response = await axios.delete(`${URL}/${idSupply}`);
  return response.data;
};

const unbanSupply = async (idSupply) => {
  const response = await axios.put(`${URL}/restore/${idSupply}`);
  return response.data;
};

export { getSupply, getSupplies, createSupply, banSupply, unbanSupply, updateSupply };
