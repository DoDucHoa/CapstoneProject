import axios from '../../../../utils/axios';

const URL = '/api/revenuereportowners';
const getUrl = (path) => `${URL}/${path}`;

const getBookingCountStatus = async (centerId, from, to) => {
  const response = await axios.get(getUrl('booking-count-status'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

const getBookingCount = async (centerId, from, to) => {
  const response = await axios.get(getUrl('booking-count'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

const getTotalCage = async (centerId, from, to) => {
  const response = await axios.get(getUrl('total-cage'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

const getTotalService = async (centerId, from, to) => {
  const response = await axios.get(getUrl('total-service'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

const getTotalSupply = async (centerId, from, to) => {
  const response = await axios.get(getUrl('total-supply'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

const getCageFreeList = async (centerId, from, to) => {
  const response = await axios.get(getUrl('cage-free-list'), {
    params: {
      centerId,
      from,
      to,
    },
  });
  return response.data;
};

export { getBookingCountStatus, getTotalCage, getCageFreeList, getBookingCount, getTotalService, getTotalSupply };
