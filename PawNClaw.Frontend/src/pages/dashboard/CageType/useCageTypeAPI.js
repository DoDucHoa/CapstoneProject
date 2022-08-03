import axios from '../../../utils/axios';

const URL = '/api/cagetypes';

const getCageTypes = async (centerId, page, rowsPerPage, searchName) => {
  const response = await axios.get(URL, {
    params: {
      CenterId: centerId,
      TypeName: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: true,
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

const updateCageType = async (cageTypeData) => {
  const response = await axios.put(URL, {
    updateCageTypeParameter: cageTypeData.createCageTypeParameter,
    updatePriceParameters: cageTypeData.createPriceParameters,
    updateFoodSchedules: cageTypeData.foodSchedules,
  });
  return response.status;
};

const deleteCageType = async (idCageType) => {
  const response = await axios.put(`${URL}/delete/${idCageType}`);
  return response.data;
};

const getPriceTypes = async () => {
  const response = await axios.get('/api/pricetypes');
  return response.data;
};

export { getCageType, getCageTypes, createCageType, deleteCageType, updateCageType, getPriceTypes };
