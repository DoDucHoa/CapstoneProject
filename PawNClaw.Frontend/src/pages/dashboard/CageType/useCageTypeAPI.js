import axios from '../../../utils/axios';

const URL = '/api/cagetypes';

const getCageTypes = async (centerId, page, rowsPerPage, searchName) => {
  const response = await axios.get(URL, {
    params: {
      CenterId: centerId,
      TypeName: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
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

const deleteCageType = async (idCageType) => {
  const response = await axios.put(`${URL}/delete/${idCageType}`);
  return response.data;
};

const getPriceTypes = async () => {
  const response = await axios.get('/api/pricetypes');
  return response.data;
};

const uploadPhotoToBackend = async (idCageType, photoUrl) => {
  const response = await axios.post('/api/photos/cagetype', {
    photoTypeId: 5,
    idActor: idCageType,
    url: photoUrl,
    isThumbnail: false,
  });
  return response.data;
};

export {
  getCageType,
  getCageTypes,
  createCageType,
  deleteCageType,
  updateCageType,
  getPriceTypes,
  uploadPhotoToBackend,
};
