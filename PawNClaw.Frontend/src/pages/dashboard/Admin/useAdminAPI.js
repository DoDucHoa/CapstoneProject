import axios from '../../../utils/axios';

const URL = '/api/admins';

const getAdmin = async (idAdmin) => {
  const response = await axios.get(`${URL}/${idAdmin}`);
  return response.data;
};

const getAdmins = async (page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(URL, {
    params: {
      Name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus === 'all' ? '' : filterStatus,
    },
  });
  return response.data;
};

const createAdmin = async (userName, createdUser, phone, name, gender) => {
  const response = await axios.post(URL, {
    userName,
    createdUser,
    phone,
    name,
    gender,
  });
  return response.data;
};

const updateAdmin = async (idAdmin, name, phone, gender) => {
  const response = await axios.put(URL, {
    name,
    phone,
    gender,
  });
  return response.status;
};

const banAdmin = async (idAdmin) => {
  const response = await axios.delete(`${URL}/${idAdmin}`);
  return response.data;
};

const unbanAdmin = async (idAdmin) => {
  const response = await axios.put(`${URL}/restore/${idAdmin}`);
  return response.data;
};

export { getAdmin, getAdmins, createAdmin, banAdmin, unbanAdmin, updateAdmin };
