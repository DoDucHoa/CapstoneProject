import PropTypes from 'prop-types';
import { vi } from 'date-fns/locale';
// @mui
import { LocalizationProvider } from '@mui/lab';
import DatePicker from '@mui/lab/DatePicker';
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import { Card, Grid, MenuItem, TextField } from '@mui/material';

// config
import { BOOKING_STATUS } from '../../../config';

// ----------------------------------------------------------------------
BookingListToolbar.propTypes = {
  fromDate: PropTypes.any,
  toDate: PropTypes.any,
  bookingStatus: PropTypes.number,
  setFromDate: PropTypes.func,
  setToDate: PropTypes.func,
  setBookingStatus: PropTypes.func,
};

export default function BookingListToolbar({
  fromDate,
  setFromDate,
  toDate,
  setToDate,
  bookingStatus,
  setBookingStatus,
}) {
  return (
    <Card sx={{ p: 3 }}>
      <Grid container spacing={3}>
        {AdapterDateFns && (
          <Grid item md={4}>
            <LocalizationProvider dateAdapter={AdapterDateFns} locale={vi}>
              <DatePicker
                label="Từ ngày"
                value={fromDate}
                onChange={(newValue) => {
                  setFromDate(newValue);
                }}
                renderInput={(params) => <TextField {...params} />}
              />
            </LocalizationProvider>
          </Grid>
        )}

        {AdapterDateFns && (
          <Grid item md={4}>
            <LocalizationProvider dateAdapter={AdapterDateFns} locale={vi}>
              <DatePicker
                label="Đến ngày"
                value={toDate}
                onChange={(newValue) => {
                  setToDate(newValue);
                }}
                renderInput={(params) => <TextField {...params} />}
              />
            </LocalizationProvider>
          </Grid>
        )}

        {BOOKING_STATUS.length > 0 && (
          <Grid item xs={8} md={4}>
            <TextField
              label="Trạng thái booking"
              value={bookingStatus}
              onChange={(event) => setBookingStatus(event.target.value)}
              select
              fullWidth
              SelectProps={{ native: false }}
              InputLabelProps={{ shrink: true }}
            >
              <MenuItem
                key={0}
                value={0}
                sx={{
                  mx: 1,
                  my: 0.5,
                  borderRadius: 0.75,
                  typography: 'body2',
                  textTransform: 'capitalize',
                }}
              >
                Tất cả
              </MenuItem>
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
      </Grid>
    </Card>
  );
}
