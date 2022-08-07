import { useEffect, useState } from 'react';
import { vi } from 'date-fns/locale';
// @mui
import { DatePicker, LocalizationProvider } from '@mui/lab';
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import { Grid, Container, TextField } from '@mui/material';
// hooks
import useSettings from '../../hooks/useSettings';
import useAuth from '../../hooks/useAuth';
// components
import Page from '../../components/Page';
// sections
import {
  // BookingDetails,
  // BookingTotalIncomes,
  BookingRoomAvailable,
  // BookingNewestBooking,
  BookingWidgetSummary,
  BookingCheckInWidgets,
  // BookingCustomerReviews,
  // BookingReservationStats,
  BookingStatuses,
} from '../../sections/@dashboard/general/booking';
// assets
import { BookingIllustration, CheckInIllustration, CheckOutIllustration } from '../../assets';
// API
import { getBookingCount } from '../../sections/@dashboard/general/booking/useOwnerDashboardAPI';

// ----------------------------------------------------------------------

export default function GeneralBooking() {
  // STATE
  const [dateFrom, setDateFrom] = useState(new Date());
  const [dateTo, setDateTo] = useState(new Date());

  const [totalBooking, setTotalBooking] = useState(0);

  // HOOKS
  const { centerId } = useAuth();
  const { themeStretch } = useSettings();

  useEffect(() => {
    getBookingCount(centerId, dateFrom, dateTo).then((data) => {
      setTotalBooking(data.totalBooking);
    });
  });

  return (
    <Page title="Biểu đồ">
      <Container maxWidth={themeStretch ? false : 'xl'}>
        <Grid container spacing={3}>
          <Grid item xs={3}>
            {AdapterDateFns && (
              <LocalizationProvider dateAdapter={AdapterDateFns} locale={vi}>
                <DatePicker
                  label="Ngày từ"
                  value={dateFrom}
                  onChange={(newValue) => {
                    setDateFrom(newValue);
                  }}
                  renderInput={(params) => <TextField {...params} />}
                />
              </LocalizationProvider>
            )}
          </Grid>
          <Grid item xs={3}>
            {AdapterDateFns && (
              <LocalizationProvider dateAdapter={AdapterDateFns} locale={vi}>
                <DatePicker
                  label="Ngày đến"
                  value={dateTo}
                  onChange={(newValue) => {
                    setDateTo(newValue);
                  }}
                  renderInput={(params) => <TextField {...params} />}
                />
              </LocalizationProvider>
            )}
          </Grid>
          <Grid item xs={6} />

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary title="Tổng số đơn hàng" total={totalBooking} icon={<BookingIllustration />} />
          </Grid>

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary title="Check In" total={311000} icon={<CheckInIllustration />} />
          </Grid>

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary title="Check Out" total={124000} icon={<CheckOutIllustration />} />
          </Grid>

          <Grid item xs={12} md={8}>
            <Grid container spacing={3}>
              {/* <Grid item xs={12} md={6}>
                <BookingTotalIncomes />
              </Grid> */}

              <Grid item xs={12} md={12}>
                <BookingStatuses centerId={centerId} from={dateFrom} to={dateTo} />
              </Grid>

              <Grid item xs={12} md={12}>
                <BookingCheckInWidgets />
              </Grid>
            </Grid>
          </Grid>

          <Grid item xs={12} md={4}>
            <BookingRoomAvailable centerId={centerId} from={dateFrom} to={dateTo} />
          </Grid>

          {/* <Grid item xs={12} md={8}>
            <BookingReservationStats />
          </Grid> */}

          {/* <Grid item xs={12} md={4}>
            <BookingCustomerReviews />
          </Grid> */}

          {/* <Grid item xs={12}>
            <BookingNewestBooking />
          </Grid> */}

          {/* <Grid item xs={12}>
            <BookingDetails />
          </Grid> */}
        </Grid>
      </Container>
    </Page>
  );
}
