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
import { getService } from './useServiceAPI';
// sections
import ServiceNewEditForm from '../../../sections/@dashboard/service/new-edit-form';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [serviceData, setServiceData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getService(id).then((data) => {
        setServiceData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Dịch vụ">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới dịch vụ' : 'Sửa thông tin dịch vụ'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách dịch vụ', href: PATH_DASHBOARD.service.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <ServiceNewEditForm isEdit={isEdit} serviceData={serviceData} />
      </Container>
    </Page>
  );
}
