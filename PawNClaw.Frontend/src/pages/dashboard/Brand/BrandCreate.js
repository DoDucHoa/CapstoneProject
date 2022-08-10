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
import { getBrand } from './useBrandAPI';
// sections
import BrandNewEditForm from '../../../sections/@dashboard/brand/BrandNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [brandData, setBrandData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  const { centerInfo } = useAuth();

  let idCenter = null;
  if (id === '0') {
    idCenter = centerInfo?.id;
  } else {
    idCenter = id;
  }

  useEffect(() => {
    if (isEdit) {
      getBrand(idCenter).then((data) => {
        setBrandData(data);
      });
    }
  }, [id, isEdit, idCenter]);

  return (
    <Page title="Thương hiệu">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới thương hiệu' : 'Sửa thông tin thương hiệu'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách thương hiệu', href: PATH_DASHBOARD.brand.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <BrandNewEditForm isEdit={isEdit} brandData={brandData} />
      </Container>
    </Page>
  );
}
