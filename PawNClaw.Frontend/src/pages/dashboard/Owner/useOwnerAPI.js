import axios from '../../../utils/axios';

const URL = '/api/owners';

const getOwner = async (idOwner) => {
  const response = await axios.get(`${URL}/${idOwner}`);
  return response.data;
};

const getOwners = async (page, rowsPerPage, filterStatus, searchName) => {
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

const createOwner = async (userName, createdUser, phone, name, gender) => {
  const response = await axios.post(URL, {
    userName,
    createdUser,
    phone,
    name,
    gender,
  });
  return response.data;
};

const updateOwner = async (idOwner, name, phone, gender, modifyUser) => {
  const response = await axios.put(`${URL}/${idOwner}`, {
    name,
    phone,
    gender,
    modifyUser,
  });
  return response.status;
};

const banOwner = async (idOwner) => {
  const response = await axios.delete(`${URL}/${idOwner}`);
  return response.data;
};

const unbanOwner = async (idOwner) => {
  const response = await axios.put(`${URL}/restore/${idOwner}`);
  return response.data;
};

export { getOwner, getOwners, createOwner, banOwner, unbanOwner, updateOwner };
