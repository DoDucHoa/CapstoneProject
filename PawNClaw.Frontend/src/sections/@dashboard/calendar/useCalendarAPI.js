import axios from '../../../utils/axios';

const URL = '/api/bookings';

const checkSize = async (petInfo, cageCode, centerId, bookingId) => {
  const response = await axios.post(`${URL}/check-size`, {
    petRequestForSearchCenters: petInfo,
    cageCode,
    centerId,
    bookingId,
  });
  return response.data;
};

const updateInvoiceUrl = async (bookingId, invoiceUrl) => {
  const response = await axios.put(`${URL}/invoice-url/${bookingId}`, { invoiceUrl });
  return response.data;
};

export { checkSize, updateInvoiceUrl };
