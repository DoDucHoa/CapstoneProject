import axios from '../../../utils/axios';
import { formatTime } from '../../../utils/formatTime';

const URL = '/api/petcenters';

const getCenters = async (page, rowsPerPage, filterStatus, searchName, filterBrandName) => {
  const response = await axios.get(`${URL}/for-admin/get-all`, {
    params: {
      name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      status: filterStatus,
      brandName: filterBrandName,
    },
  });
  return response.data;
};

const getCenter = async (idCenter) => {
  const response = await axios.get(`${URL}/for-admin/${idCenter}`);
  return response.data;
};

const createCenter = async (centerData) => {
  const response = await axios.post(URL, {
    ...centerData,
    checkin: formatTime(centerData.checkinUI),
    checkout: formatTime(centerData.checkoutUI),
    openTime: formatTime(centerData.openTimeUI),
    closeTime: formatTime(centerData.closeTimeUI),
    brandId: centerData.brandInfo.id,
  });
  return response.data;
};

const updateCenter = async (centerData) => {
  const response = await axios.put(`${URL}/for-admin`, {
    ...centerData,
    checkin: formatTime(centerData.checkinUI),
    checkout: formatTime(centerData.checkoutUI),
    openTime: formatTime(centerData.openTimeUI),
    closeTime: formatTime(centerData.closeTimeUI),
  });
  return response.status;
};

const updateCenterForOwner = async (centerData) => {
  const response = await axios.put(`${URL}/for-owner`, centerData);
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

const getCities = async () => {
  const response = await axios.get('/api/cities');
  return response.data;
};

const getDistricts = async (cityCode) => {
  const response = await axios.get(`/api/districts/${cityCode || 0}`);
  return response.data;
};

const getWards = async (districtCode) => {
  const response = await axios.get(`/api/wards/${districtCode || 0}`);
  return response.data;
};

export {
  getCenter,
  getCenters,
  createCenter,
  banCenter,
  unbanCenter,
  updateCenter,
  getCities,
  getDistricts,
  getWards,
  updateCenterForOwner,
};
