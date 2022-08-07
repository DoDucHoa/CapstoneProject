import axios from '../../../utils/axios';

const URL = '/api/petcenters';

const getCenters = async (page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(`${URL}/for-admin/get-all`, {
    params: {
      name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      status: filterStatus,
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
    brandId: centerData.brandInfo.id,
  });
  return response.data;
};

const updateCenter = async (centerData) => {
  const response = await axios.put(`${URL}/for-admin`, centerData);
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

export { getCenter, getCenters, createCenter, banCenter, unbanCenter, updateCenter, getCities, getDistricts, getWards };
