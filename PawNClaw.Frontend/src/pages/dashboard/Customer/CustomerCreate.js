import { useState, useEffect } from 'react';
import { useParams, useLocation } from 'react-router-dom';
// @mui
import { Container } from '@mui/material';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useSettings from '../../../hooks/useSettings';
// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { getCustomer } from './useCustomerAPI';
// sections
import UserNewEditForm from '../../../sections/@dashboard/customer/CustomerNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [adminData, setAdminData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getCustomer(id).then((data) => {
        setAdminData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Khách hàng">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới khách hàng' : 'Sửa thông tin khách hàng'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách khách hàng', href: PATH_DASHBOARD.customer.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <UserNewEditForm isEdit={isEdit} adminData={adminData} />
      </Container>
    </Page>
  );
}
