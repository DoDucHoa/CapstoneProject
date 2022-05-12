import axios from '../../../utils/axios';

const getAdmins = async () => {
  const response = await axios.get('/api/admins', {
    params: {
      includeProperties: 'IdNavigation',
    },
  });
  return response.data;
};

export { getAdmins };
