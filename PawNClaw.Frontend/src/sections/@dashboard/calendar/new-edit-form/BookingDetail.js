import PropTypes from 'prop-types';
// @mui
import { Grid, Typography } from '@mui/material';
// utils
import { fDateTimeSuffix } from '../../../../utils/formatTime';

// ----------------------------------------------------------------------

BookingDetail.propTypes = {
  details: PropTypes.object.isRequired,
  petOldInfo: PropTypes.array.isRequired,
};

export default function BookingDetail({ details, petOldInfo }) {
  const { startBooking, endBooking, customerNote, statusId } = details;

  return (
    <Grid container spacing={3} sx={{ p: 3 }}>
      <Grid item xs={6} sm={3}>
        <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
          Thời điểm bắt đầu
        </Typography>
        <Typography variant="body2">{fDateTimeSuffix(startBooking)}</Typography>
      </Grid>

      <Grid item xs={6} sm={3}>
        <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
          Thời điểm kết thúc
        </Typography>
        <Typography variant="body2">{fDateTimeSuffix(endBooking)}</Typography>
      </Grid>

      <Grid item xs={12}>
        <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
          Ghi chú khách hàng
        </Typography>
        <Typography variant="body2">{customerNote || 'Không có ghi chú'}</Typography>
      </Grid>

      {statusId === 1 && (
        <Grid item xs={12} sm={6}>
          <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
            Thông tin cũ của thú cưng
          </Typography>
          <Grid container>
            <Grid item xs={3}>
              <Typography variant="caption">Tên</Typography>
            </Grid>
            <Grid item xs={3}>
              <Typography variant="caption">Cao (cm)</Typography>
            </Grid>
            <Grid item xs={3}>
              <Typography variant="caption">Dài (cm)</Typography>
            </Grid>
            <Grid item xs={3}>
              <Typography variant="caption">Nặng (kg)</Typography>
            </Grid>

            {petOldInfo.map((pet, index) => (
              <Grid container key={index}>
                <Grid item xs={3}>
                  <Typography variant="body2">
                    <b>{pet.name}</b>
                  </Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="body2">{pet.height}</Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="body2">{pet.length}</Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="body2">{pet.weight}</Typography>
                </Grid>
              </Grid>
            ))}
          </Grid>
        </Grid>
      )}
    </Grid>
  );
}
