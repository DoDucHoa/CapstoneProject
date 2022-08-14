import axios from '../../../utils/axios';

async function fetchOwnerPolicy() {
  try {
    const { data } = await axios.get('/api/policies');
    return data.policy;
  } catch (error) {
    console.error(error);
    return {};
  }
}

async function updateOwnerPolicy(newPolicy) {
  try {
    await axios.post('/api/policies', {
      newPolicy,
    });
  } catch (error) {
    throw new Error(error);
  }
}

async function fetchCustomerPolicy() {
  try {
    const { data } = await axios.get('/api/policies/for-customer');
    return data.policy;
  } catch (error) {
    console.error(error);
    return {};
  }
}

async function updateCustomerPolicy(newPolicy) {
  try {
    await axios.post('/api/policies/for-customer', {
      newPolicy,
    });
  } catch (error) {
    throw new Error(error);
  }
}

export { fetchCustomerPolicy, updateCustomerPolicy, fetchOwnerPolicy, updateOwnerPolicy };
