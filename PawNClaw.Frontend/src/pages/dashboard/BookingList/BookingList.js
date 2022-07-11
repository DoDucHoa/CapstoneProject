import { useState } from 'react';

// @mui
import { Button, Card, Container, Grid, MenuItem, TextField } from '@mui/material';
import DatePicker from '@mui/lab/DatePicker';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';

// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';

// config
import { BOOKING_STATUS } from '../../../config';

// ----------------------------------------------------------------------

export default function BookingList() {
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');
  const [bookingStatus, setBookingStatus] = useState(3);

  const { themeStretch } = useSettings();

  return (
    <Page title="Đơn booking">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Đơn booking"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Đơn booking' }]}
        />

        <Card sx={{ p: 3 }}>
          <Grid container spacing={3}>
            <Grid item md={3}>
              <DatePicker
                label="Từ ngày"
                value={fromDate}
                onChange={(newValue) => {
                  setFromDate(newValue);
                }}
                renderInput={(params) => <TextField {...params} fullWidth />}
              />
            </Grid>
            <Grid item md={3}>
              <DatePicker
                label="Đến ngày"
                value={toDate}
                onChange={(newValue) => {
                  setToDate(newValue);
                }}
                renderInput={(params) => <TextField {...params} fullWidth />}
              />
            </Grid>
            {BOOKING_STATUS.length > 0 && (
              <Grid item xs={8} md={3}>
                <TextField
                  label="Trạng thái booking"
                  value={bookingStatus}
                  onChange={(event) => setBookingStatus(event.target.value)}
                  select
                  fullWidth
                  SelectProps={{ native: false }}
                  InputLabelProps={{ shrink: true }}
                >
                  {BOOKING_STATUS.map((option) => (
                    <MenuItem
                      key={option.id}
                      value={option.id}
                      sx={{
                        mx: 1,
                        my: 0.5,
                        borderRadius: 0.75,
                        typography: 'body2',
                        textTransform: 'capitalize',
                      }}
                    >
                      {option.name}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
            )}
            <Grid item md={3} sx={{ alignSelf: 'center' }}>
              <Button variant="contained" size="large" fullWidth>
                Tìm kiếm
              </Button>
            </Grid>
          </Grid>
        </Card>
      </Container>
    </Page>
  );
}
