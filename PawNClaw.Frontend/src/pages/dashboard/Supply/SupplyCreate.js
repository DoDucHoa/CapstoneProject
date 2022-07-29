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
import { getSupply } from './useSupplyAPI';
// sections
import SupplyNewEditForm from '../../../sections/@dashboard/supply/SupplyNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [supplyData, setSupplyData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getSupply(id).then((data) => {
        setSupplyData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Đồ dùng">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới đồ dùng' : 'Sửa thông tin đồ dùng'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách đồ dùng', href: PATH_DASHBOARD.supply.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <SupplyNewEditForm isEdit={isEdit} supplyData={supplyData} />
      </Container>
    </Page>
  );
}
