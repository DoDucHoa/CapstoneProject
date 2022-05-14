import axios from '../../../utils/axios';

const getAdmins = async (page, rowsPerPage, filterStatus) => {
  const response = await axios.get('/api/admins', {
    params: {
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

export { getAdmins };
