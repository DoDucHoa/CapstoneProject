import axios from '../../../utils/axios';

const URL = '/api/staffs';

const getStaff = async (idStaff) => {
  const response = await axios.get(`${URL}/${idStaff}`);
  return response.data;
};

const getStaffs = async (centerId, page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(`${URL}/center`, {
    params: {
      centerId,
      name: searchName,
      status: filterStatus === 'all' ? null : filterStatus,
      PageSize: rowsPerPage,
      PageNumber: page,
    },
  });
  return response.data;
};

const createStaff = async (staffData) => {
  const response = await axios.post(URL, staffData);
  return response;
};

const updateStaff = async (idStaff, name, phone, gender) => {
  const response = await axios.put(URL, {
    name,
    phone,
    gender,
  });
  return response.status;
};

const banStaff = async (idStaff) => {
  const response = await axios.put(`${URL}/update-status/${idStaff}`);
  return response.data;
};

export { getStaff, getStaffs, createStaff, banStaff, updateStaff };
