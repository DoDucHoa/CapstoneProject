import axios from '../../../utils/axios';

const URL = '/api/bookings';

const getBookingList = async (centerId, page, rowsPerPage, bookingStatus) => {
  const response = await axios.get(`${URL}/list`, {
    params: {
      CenterId: centerId,
      PageSize: rowsPerPage,
      PageNumber: page,
      dir: 'desc',
      StatusId: bookingStatus === 0 ? null : bookingStatus,
    },
  });
  return response.data;
};

const getBooking = async (idBookingList) => {
  const response = await axios.get(`${URL}/${idBookingList}`);
  return response.data;
};

const updateBookingList = async (supplyData, modifyUser) => {
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

export { getBookingList, updateBookingList, getBooking };
