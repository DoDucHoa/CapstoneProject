import axios from '../../../utils/axios';

const URL = '/api/cagetypes';

const getCageTypes = async (centerId, page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(URL, {
    params: {
      CenterId: centerId,
      TypeName: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: filterStatus,
    },
  });
  return response.data;
};

const getCageType = async (idCageType) => {
  const response = await axios.get(`${URL}/${idCageType}`);
  return response.data;
};

const createCageType = async (cageTypeData) => {
  const response = await axios.post(URL, cageTypeData);
  return response.data;
};

const updateCageType = async (idCageType, name, description, ownerId) => {
  const response = await axios.put(`${URL}/${idCageType}`, {
    name,
    description,
    ownerId,
  });
  return response.status;
};

const banCageType = async (idCageType) => {
  const response = await axios.delete(`${URL}/${idCageType}`);
  return response.data;
};

const unbanCageType = async (idCageType) => {
  const response = await axios.put(`${URL}/restore/${idCageType}`);
  return response.data;
};

const getPriceTypes = async () => {
  const response = await axios.get('/api/pricetypes');
  return response.data;
};

export { getCageType, getCageTypes, createCageType, banCageType, unbanCageType, updateCageType, getPriceTypes };