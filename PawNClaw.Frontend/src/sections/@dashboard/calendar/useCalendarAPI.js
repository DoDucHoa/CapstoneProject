import axios from '../../../utils/axios';

const URL = '/api/bookings';

const checkSize = async (petInfo, cageCode, centerId) => {
  const response = await axios.post(`${URL}/check-size`, {
    petRequestForSearchCenters: petInfo,
    cageCode,
    centerId,
  });
  return response.data;
};

export { checkSize };
