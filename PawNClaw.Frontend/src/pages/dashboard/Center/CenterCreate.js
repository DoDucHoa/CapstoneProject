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
import { getCenter } from './useCenterAPI';
// sections
import CenterNewEditForm from '../../../sections/@dashboard/center/CenterNewEditForm';

// ----------------------------------------------------------------------

export default function CenterCreate() {
  const [adminData, setAdminData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getCenter(id).then((data) => {
        setAdminData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Trung tâm">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới trung tâm' : 'Sửa thông tin trung tâm'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách trung tâm', href: PATH_DASHBOARD.center.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <CenterNewEditForm isEdit={isEdit} adminData={adminData} />
      </Container>
    </Page>
  );
}
