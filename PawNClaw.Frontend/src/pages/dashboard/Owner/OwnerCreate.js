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
  const [ownerData, setOwnerData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getOwner(id).then((data) => {
        setOwnerData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Chủ trung tâm">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới chủ trung tâm' : 'Sửa thông tin chủ trung tâm'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách chủ trung tâm', href: PATH_DASHBOARD.owner.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <UserNewEditForm isEdit={isEdit} ownerData={ownerData} />
      </Container>
    </Page>
  );
}
