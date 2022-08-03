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
  const response = await axios.get(`${URL}/${idSponsor}`);
  return response.data;
};

const createSponsor = async (sponsorData) => {
  const response = await axios.post(URL, { ...sponsorData, brandId: sponsorData.brandInfo.id });
  return response.data;
};

const updateSponsor = async (idSponsor, name, description, ownerId) => {
  const response = await axios.put(`${URL}/${idSponsor}`, {
    name,
    description,
    ownerId,
  });
  return response.status;
};

const banSponsor = async (idSponsor) => {
  const response = await axios.put(`${URL}/deactivate/${idSponsor}`);
  return response.data;
};

const unbanSponsor = async (idSponsor) => {
  const response = await axios.put(`${URL}/restore/${idSponsor}`);
  return response.data;
};

export { getSponsor, getSponsors, createSponsor, banSponsor, unbanSponsor, updateSponsor };
