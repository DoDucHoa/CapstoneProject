import axios from '../../../utils/axios';

const URL = '/api/Services';

const getServices = async (centerId, page, rowsPerPage, searchName) => {
  const response = await axios.get(`${URL}/center`, {
    params: {
      CenterId: centerId,
      Name: searchName,
      PageSize: rowsPerPage,
      PageNumber: page,
      Status: true,
    },
  });
  return response.data;
};

const getService = async (idService) => {
  const response = await axios.get(`${URL}/${idService}`);
  return response.data;
};

const createService = async (serviceData) => {
  const lastPriceInList = serviceData.servicePrice.at(-1);
  const extraPrice = {
    ...lastPriceInList,
    price: serviceData.lastPrice,
    minWeight: lastPriceInList.maxWeight,
    maxWeight: 999999999,
  };

  const sendData = {
    service: serviceData.service,
    servicePrice: [...serviceData.servicePrice, extraPrice],
  };

  const response = await axios.post(URL, sendData);
  return response.data;
};

const updateService = async (serviceData) => {
  const response = await axios.put(URL, {
    service: serviceData.service,
    updateServicePrices: serviceData.servicePrice,
  });
  return response.status;
};

const deleteService = async (idService) => {
  const response = await axios.put(`${URL}/delete/${idService}`);
  return response.data;
};

const getPriceTypes = async () => {
  const response = await axios.get('/api/pricetypes');
  return response.data;
};

export { getService, getServices, createService, deleteService, updateService, getPriceTypes };
