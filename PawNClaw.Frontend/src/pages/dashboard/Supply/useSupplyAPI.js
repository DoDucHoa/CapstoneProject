import axios from '../../../utils/axios';

const URL = '/api/supplies';

const getSupplies = async (centerId, page, rowsPerPage, filterStatus, searchName) => {
  const response = await axios.get(`${URL}/center`, {
    params: {
      CenterId: centerId,
      Name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      TypeCode: filterStatus,
      Status: true,
    },
  });
  return response.data;
};

const getSupply = async (idSupply) => {
  const response = await axios.get(`${URL}/${idSupply}`);
  return response.data;
};

const createSupply = async (supplyData) => {
  const response = await axios.post(URL, supplyData);
  return response.data;
};

const updateSupply = async (supplyData, modifyUser) => {
  const response = await axios.put(URL, {
    id: supplyData.id,
    sellPrice: supplyData.sellPrice,
    discountPrice: supplyData.discountPrice,
    quantity: supplyData.quantity,
    modifyDate: new Date(),
    modifyUser,
    status: true,
  });
  return response.status;
};

const deleteSupply = async (idSupply) => {
  const response = await axios.put(`${URL}/delete/${idSupply}`);
  return response.data;
};

export { getSupply, getSupplies, createSupply, deleteSupply, updateSupply };
