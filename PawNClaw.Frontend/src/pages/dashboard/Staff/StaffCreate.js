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
import { getStaff } from './useStaffAPI';
// sections
import StaffNewEditForm from '../../../sections/@dashboard/staff/StaffNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [staffData, setStaffData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getStaff(id).then((data) => {
        setStaffData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Nhân viên">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới nhân viên' : 'Sửa thông tin nhân viên'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách nhân viên', href: PATH_DASHBOARD.staff.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <StaffNewEditForm isEdit={isEdit} staffData={staffData} />
      </Container>
    </Page>
  );
}
