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
import { getVoucher } from './useVoucherAPI';
// sections
import UserNewEditForm from '../../../sections/@dashboard/voucher/VoucherNewEditForm';

// ----------------------------------------------------------------------

export default function UserCreate() {
  const [voucherData, setVoucherData] = useState({});

  const { themeStretch } = useSettings();
  const { pathname } = useLocation();

  const isEdit = pathname.includes('edit');

  const { code } = useParams();
  useEffect(() => {
    if (isEdit) {
      getVoucher(code).then((data) => {
        setVoucherData(data);
      });
    }
  }, [code, isEdit]);

  return (
    <Page title="Voucher">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading={!isEdit ? 'Thêm mới voucher' : 'Sửa thông tin voucher'}
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            { name: 'Danh sách voucher', href: PATH_DASHBOARD.voucher.list },
            { name: !isEdit ? 'Thêm mới' : 'Sửa' },
          ]}
        />
        <UserNewEditForm isEdit={isEdit} voucherData={voucherData} />
      </Container>
    </Page>
  );
}
