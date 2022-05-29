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
import { getOwner } from './useOwnerAPI';
// sections
import UserNewEditForm from '../../../sections/@dashboard/owner/OwnerNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [adminData, setAdminData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getOwner(id).then((data) => {
        setAdminData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Người điều hành">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới người điều hành' : 'Sửa thông tin người điều hành'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách người điều hành', href: PATH_DASHBOARD.admin.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <UserNewEditForm isEdit={isEdit} adminData={adminData} />
      </Container>
    </Page>
  );
}
