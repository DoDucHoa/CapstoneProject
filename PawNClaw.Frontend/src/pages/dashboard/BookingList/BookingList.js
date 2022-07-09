import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

// @mui
import { Button, Card, Container, Typography } from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';

// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Iconify from '../../../components/Iconify';

// ----------------------------------------------------------------------

export default function BookingList() {
  const { themeStretch } = useSettings();

  return (
    <Page title="Đơn booking">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Đơn booking"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Đơn booking' }]}
        />

        <Card sx={{ p: 3 }}>
          <Typography>Ngày từ</Typography>
          
        </Card>
      </Container>
    </Page>
  );
}
