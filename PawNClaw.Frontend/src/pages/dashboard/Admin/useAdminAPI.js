import axios from '../../../utils/axios';

const adminURL = '/api/admins';

const getAdmin = async (idAdmin) => {
  const response = await axios.get(`${adminURL}/${idAdmin}`);
  return response.data;
};

const getAdmins = async (page, rowsPerPage, filterStatus) => {
  const response = await axios.get(adminURL, {
    params: {
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

const createAdmin = async (userName, createdUser, phone, name, gender) => {
  const response = await axios.post(adminURL, {
    userName,
    createdUser,
    phone,
    name,
    gender,
  });
  return response.data;
};

const updateAdmin = async (idAdmin, name, phone, gender) => {
  const response = await axios.put(adminURL, {
    name,
    phone,
    gender,
  });
  return response.status;
};

const banAdmin = async (idAdmin) => {
  const response = await axios.delete(`${adminURL}/${idAdmin}`);
  return response.data;
};

const unbanAdmin = async (idAdmin) => {
  const response = await axios.put(`${adminURL}/${idAdmin}`);
  return response.data;
};

export { getAdmin, getAdmins, createAdmin, banAdmin, unbanAdmin, updateAdmin };
