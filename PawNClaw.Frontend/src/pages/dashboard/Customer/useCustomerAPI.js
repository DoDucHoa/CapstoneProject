import axios from '../../../utils/axios';

const URL = '/api/accounts/customer';

const getCustomers = async (page, rowsPerPage, filterStatus, email) => {
  const response = await axios.get(URL, {
    params: {
      UserName: email,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

const changeCustomerStatus = async (id) => {
  await axios.put(`/api/Customers/update-status?id=${id}`);
};

export { getCustomers, changeCustomerStatus };
