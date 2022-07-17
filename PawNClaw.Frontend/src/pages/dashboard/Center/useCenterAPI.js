import axios from '../../../utils/axios';

const URL = '/api/petcenters';

const getCenters = async (page, rowsPerPage, filterStatus, searchName) => {
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

const getCenter = async (idCenter) => {
  const response = await axios.get(`${URL}/${idCenter}`);
  return response.data;
};

const createCenter = async (userName, createdUser, phone, name, gender) => {
  const response = await axios.post(URL, {
    userName,
    createdUser,
    phone,
    name,
    gender,
  });
  return response.data;
};

const updateCenter = async (idCenter, name, phone, gender) => {
  const response = await axios.put(URL, {
    name,
    phone,
    gender,
  });
  return response.status;
};

const banCenter = async (idCenter) => {
  const response = await axios.delete(`${URL}/${idCenter}`);
  return response.data;
};

const unbanCenter = async (idCenter) => {
  const response = await axios.put(`${URL}/restore/${idCenter}`);
  return response.data;
};

export { getCenter, getCenters, createCenter, banCenter, unbanCenter, updateCenter };
