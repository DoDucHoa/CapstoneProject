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
import { getCage } from './useCageAPI';
// sections
import CageNewEditForm from '../../../sections/@dashboard/cage/CageNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [cageData, setCageData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();
  const { centerId } = useAuth();

  const isEdit = pathname.includes('edit');

  const { code } = useParams();
  useEffect(() => {
    if (isEdit) {
      getCage(code, centerId).then((data) => {
        setCageData(data);
      });
    }
  }, [centerId, code, isEdit]);

  return (
    <Page title="Chuồng thú">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới chuồng thú' : 'Sửa thông tin chuồng thú'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách chuồng thú', href: PATH_DASHBOARD.cage.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <CageNewEditForm isEdit={isEdit} cageData={cageData} />
      </Container>
    </Page>
  );
}
