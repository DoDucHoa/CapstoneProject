import axios from '../../../utils/axios';

const URL = '/api/vouchers';

const getVoucher = async (codeVoucher) => {
  const response = await axios.get(`${URL}/${codeVoucher}`);
  return response.data;
};

const getVouchers = async (page, rowsPerPage, centerId) => {
  const response = await axios.get(`${URL}/for-staff/center`, {
    params: {
      centerId,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: true,
    },
  });
  return response.data;
};

const createVoucher = async (voucherData) => {
  const response = await axios.post(URL, voucherData);
  return response.data;
};

const updateVoucher = async (voucherData) => {
  const response = await axios.put(URL, voucherData);
  return response.status;
};

const banVoucher = async (code) => {
  const response = await axios.put(`${URL}/update-status?code=${code}`);
  return response.data;
};

const getVoucherType = async () => {
  const response = await axios.get('/api/vouchertypes');
  return response.data;
};

export { getVoucher, getVouchers, createVoucher, banVoucher, updateVoucher, getVoucherType };
