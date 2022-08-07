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
import { getSponsor } from './useSponsorAPI';
// sections
import SponsorNewEditForm from '../../../sections/@dashboard/sponsor/SponsorNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [sponsorData, setSponsorData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { id } = useParams();
  useEffect(() => {
    if (isEdit) {
      getSponsor(id).then((data) => {
        setSponsorData(data);
      });
    }
  }, [id, isEdit]);

  return (
    <Page title="Quảng cáo">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới quảng cáo' : 'Sửa thông tin quảng cáo'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách quảng cáo', href: PATH_DASHBOARD.sponsor.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <SponsorNewEditForm isEdit={isEdit} sponsorData={sponsorData} />
      </Container>
    </Page>
  );
}
