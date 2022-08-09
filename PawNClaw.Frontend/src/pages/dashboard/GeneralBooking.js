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
  // BookingCheckInWidgets,
  // BookingCustomerReviews,
  // BookingReservationStats,
  BookingStatuses,
} from '../../sections/@dashboard/general/booking';
// API
import {
  getBookingCount,
  getTotalService,
  getTotalSupply,
} from '../../sections/@dashboard/general/booking/useOwnerDashboardAPI';

// ----------------------------------------------------------------------

export default function GeneralBooking() {
  // STATE
  const [dateFrom, setDateFrom] = useState(new Date());
  const [dateTo, setDateTo] = useState(new Date());

  const [totalBooking, setTotalBooking] = useState(0);
  const [totalService, setTotalService] = useState(0);
  const [totalSupply, setTotalSupply] = useState(0);

  // HOOKS
  const { centerId } = useAuth();
  const { themeStretch } = useSettings();

  useEffect(() => {
    getBookingCount(centerId, dateFrom, dateTo).then((data) => {
      setTotalBooking(data.totalBooking);
    });
    getTotalService(centerId, dateFrom, dateTo).then((data) => {
      setTotalService(data);
    });
    getTotalSupply(centerId, dateFrom, dateTo).then((data) => {
      setTotalSupply(data);
    });

    return () => {
      setTotalBooking(0);
      setTotalService(0);
      setTotalSupply(0);
    };
  }, [centerId, dateFrom, dateTo]);

  return (
    <Page title="Biểu đồ">
      <Container maxWidth={themeStretch ? false : 'xl'}>
        <Grid container spacing={3}>
          <Grid item xs={6} sm={3}>
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
          <Grid item xs={6} sm={3}>
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
          <Grid item xs={0} sm={6} />

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary
              title="Tổng số đơn hàng"
              total={totalBooking}
              imgSrc={
                'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/PNG%2Fbooking.png?alt=media&token=daec8193-b681-4938-8154-36572acc7567'
              }
              alt={'Booking'}
            />
          </Grid>

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary
              title="Tổng dịch vụ"
              total={totalService}
              imgSrc={
                'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/PNG%2Fservice-dog.png?alt=media&token=4acda24a-9260-450d-8845-313da605ea98'
              }
              alt={'Dog chewing bone'}
            />
          </Grid>

          <Grid item xs={12} md={4}>
            <BookingWidgetSummary
              title="Tổng đồ dùng"
              total={totalSupply}
              imgSrc={
                'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/PNG%2Fbone.png?alt=media&token=4a673bbb-8f58-436f-a522-d7c945abc5c0'
              }
              alt={'Dog having bath'}
            />
          </Grid>

          <Grid item xs={12} md={5}>
            {/* <Grid item xs={12} md={6}>
                <BookingTotalIncomes />
              </Grid> */}

            <BookingStatuses centerId={centerId} from={dateFrom} to={dateTo} />

            {/* <Grid item xs={12} md={12}>
                <BookingCheckInWidgets />
              </Grid> */}
          </Grid>

          <Grid item xs={12} md={7}>
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
