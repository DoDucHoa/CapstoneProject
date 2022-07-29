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
import { getCageType } from './useCageTypeAPI';
// sections
import CageTypeNewEditForm from '../../../sections/@dashboard/cageType/new-edit-form';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [cageTypeData, setCageTypeData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getCageType(id).then((data) => {
        setCageTypeData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Loại chuồng">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới loại chuồng' : 'Sửa thông tin loại chuồng'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách loại chuồng', href: PATH_DASHBOARD.cageType.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <CageTypeNewEditForm isEdit={isEdit} cageTypeData={cageTypeData} />
      </Container>
    </Page>
  );
}
