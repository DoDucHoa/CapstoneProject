import PropTypes from 'prop-types';
// @mui
import { useEffect, useState } from 'react';
import { Card, CardHeader, Typography, Stack, LinearProgress, Box } from '@mui/material';
// utils
import { fNumber, fShortenNumber } from '../../../../utils/formatNumber';
import { getBookingCountStatus } from './useOwnerDashboardAPI';

// ----------------------------------------------------------------------
BookingStatuses.propTypes = {
  centerId: PropTypes.number.isRequired,
  from: PropTypes.any,
  to: PropTypes.any,
};
export default function BookingStatuses({ centerId, from, to }) {
  // STATE
  const [bookingCountStatus, setBookingCountStatus] = useState(null);

  // STARTUP
  useEffect(() => {
    getBookingCountStatus(centerId, from, to).then((data) => {
      setBookingCountStatus(data);
    });
  }, [centerId, from, to]);

  const totalBooking =
    bookingCountStatus?.totalPending +
    bookingCountStatus?.totalProcessing +
    bookingCountStatus?.totalDone +
    bookingCountStatus?.totalCancelled;

  const _bookingsOverview = [
    {
      status: 'Đang chờ',
      quantity: bookingCountStatus?.totalPending,
      value: totalBooking === 0 ? 0 : (bookingCountStatus?.totalPending * 100) / totalBooking,
    },
    {
      status: 'Đang xử lý',
      quantity: bookingCountStatus?.totalProcessing,
      value: totalBooking === 0 ? 0 : (bookingCountStatus?.totalProcessing * 100) / totalBooking,
    },
    {
      status: 'Hoàn thành',
      quantity: bookingCountStatus?.totalDone,
      value: totalBooking === 0 ? 0 : (bookingCountStatus?.totalDone * 100) / totalBooking,
    },
    {
      status: 'Đã hủy',
      quantity: bookingCountStatus?.totalCancelled,
      value: totalBooking === 0 ? 0 : (bookingCountStatus?.totalCancelled * 100) / totalBooking,
    },
  ];

  return (
    <Card>
      <CardHeader title="Trạng thái đơn hàng" />
      <Typography sx={{ px: 3, mt: 1 }}>Tổng số đơn hàng: {fNumber(totalBooking)}</Typography>
      <Stack spacing={3} sx={{ px: 3, my: 3 }}>
        {_bookingsOverview.map((progress) => (
          <LinearProgress
            variant="determinate"
            key={progress.status}
            value={progress.value}
            color={
              (progress.status === 'Đang chờ' && 'warning') ||
              (progress.status === 'Đã hủy' && 'error') ||
              (progress.status === 'Đang xử lý' && 'info') ||
              'success'
            }
            sx={{ height: 8, bgcolor: 'grey.50016' }}
          />
        ))}
      </Stack>

      <Stack direction="row" justifyContent="space-between" sx={{ px: 3, pb: 3 }}>
        {_bookingsOverview.map((progress) => (
          <Stack key={progress.status} alignItems="center">
            <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 1 }}>
              <Box
                sx={{
                  width: 12,
                  height: 12,
                  borderRadius: 0.5,
                  bgcolor: 'success.main',
                  ...(progress.status === 'Đang chờ' && { bgcolor: 'warning.main' }),
                  ...(progress.status === 'Đã hủy' && { bgcolor: 'error.main' }),
                  ...(progress.status === 'Đang xử lý' && { bgcolor: 'info.main' }),
                }}
              />
              <Typography variant="subtitle2" sx={{ color: 'text.secondary' }}>
                {progress.status}
              </Typography>
            </Stack>

            <Typography variant="h6">{fShortenNumber(progress.quantity)}</Typography>
          </Stack>
        ))}
      </Stack>
    </Card>
  );
}
