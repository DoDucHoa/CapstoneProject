import axios from '../../../utils/axios';

const URL = '/api/sponsorbanners';

const getSponsors = async (page, rowsPerPage) => {
  const response = await axios.get(`${URL}/all`, {
    params: {
      PageSize: rowsPerPage,
      PageNumber: page,
    },
  });
  return response.data;
};

const getSponsor = async (idSponsor) => {
  const response = await axios.get(`${URL}/all`, {
    params: {
      id: idSponsor,
    },
  });
  return response.data.data[0];
};

const createSponsor = async (sponsorData) => {
  const response = await axios.post(URL, { ...sponsorData, brandId: sponsorData.brandInfo.id });
  return response.data;
};

const updateSponsor = async (sponsorData) => {
  const response = await axios.put(URL, sponsorData);
  return response.status;
};

const banSponsor = async (idSponsor) => {
  const response = await axios.put(`${URL}/deactivate/${idSponsor}`);
  return response.data;
};

const extendSponsor = async (sponsorData) => {
  const response = await axios.post(URL, sponsorData);
  await axios.post('api/photos/banner', {
    idActor: response.data,
    url: sponsorData?.photos?.length > 0 ? sponsorData?.photos[0].url : '',
    isThumbnail: false,
  });
};

export { getSponsor, getSponsors, createSponsor, banSponsor, updateSponsor, extendSponsor };
