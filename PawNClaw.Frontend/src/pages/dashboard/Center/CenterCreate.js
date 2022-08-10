import { useState, useEffect } from 'react';
import { useParams, useLocation } from 'react-router-dom';
// @mui
import { Container } from '@mui/material';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useSettings from '../../../hooks/useSettings';
import useAuth from '../../../hooks/useAuth';
// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { getCenter } from './useCenterAPI';
// sections
import CenterNewEditForm from '../../../sections/@dashboard/center/CenterNewEditForm';

// ----------------------------------------------------------------------

export default function CenterCreate() {
  const [centerData, setCenterData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  const { centerId } = useAuth();

  let idCenter = null;
  if (id === '0') {
    idCenter = centerId;
  } else {
    idCenter = id;
  }

  useEffect(() => {
    if (isEdit) {
      getCenter(idCenter).then((data) => {
        setCenterData(data);
      });
    }
  }, [id, isEdit, idCenter]);

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
        <CenterNewEditForm isEdit={isEdit} centerData={centerData} />
      </Container>
    </Page>
  );
}
