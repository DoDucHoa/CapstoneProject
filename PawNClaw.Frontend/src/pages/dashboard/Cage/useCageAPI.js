import axios from '../../../utils/axios';

const URL = '/api/cages';

const getCages = async (centerId, page, rowsPerPage, cageCode, isOnline, cageTypeId) => {
  const response = await axios.get(URL, {
    params: {
      CenterId: centerId,
      Code: cageCode,
      PageSize: rowsPerPage,
      PageNumber: page,
      IsOnline: isOnline === 3 ? null : isOnline === 1,
      CageTypeId: cageTypeId === 0 ? null : cageTypeId,
    },
  });
  return response.data;
};

const getCage = async (cageCode, centerId) => {
  const response = await axios.get(`${URL}?Code=${cageCode}&CenterId=${centerId}`);
  return response.data.data[0];
};

const createCage = async (cageInfo) => {
  const response = await axios.post(URL, {
    code: cageInfo.code,
    name: cageInfo.name,
    color: cageInfo.color,
    isOnline: cageInfo.isOnline,
    createUser: cageInfo.createUser,
    modifyUser: cageInfo.modifyUser,
    cageTypeId: cageInfo.cageTypeInfo.id,
    centerId: cageInfo.centerId,
  });
  return response.data;
};

const updateCage = async (cageInfo) => {
  const response = await axios.put(URL, {
    code: cageInfo.code,
    name: cageInfo.name,
    color: cageInfo.color,
    isOnline: cageInfo.isOnline,
    modifyUser: cageInfo.modifyUser,
    cageTypeId: cageInfo.cageTypeInfo.id,
    centerId: cageInfo.centerId,
    status: cageInfo.status,
    modifyDate: new Date(),
  });
  return response.status;
};

const banCage = async (idCage) => {
  const response = await axios.delete(`${URL}/${idCage}`);
  return response.data;
};

const unbanCage = async (idCage) => {
  const response = await axios.put(`${URL}/restore/${idCage}`);
  return response.data;
};

const getCageTypes = async (centerId) => {
  const response = await axios.get(`/api/cagetypes?CenterId=${centerId}`);
  return response.data;
};

export { getCage, getCages, createCage, banCage, unbanCage, updateCage, getCageTypes };
