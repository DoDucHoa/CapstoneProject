import PropTypes from 'prop-types';
// @mui
import { Grid, MenuItem } from '@mui/material';
// hooks form
import { RHFSelect } from '../../../../components/hook-form';

// ----------------------------------------------------------------------
BookingStatusCombobox.propTypes = {
  statusId: PropTypes.number,
  bookingStatuses: PropTypes.array,
};
BookingStatusCombobox.displayName = 'BookingStatusCombobox';
BookingStatusCombobox.defaultProps = {
  statusId: null,
  bookingStatuses: [],
};

export default function BookingStatusCombobox({ statusId, bookingStatuses }) {
  return (
    <Grid container spacing={3} sx={{ p: 3 }}>
      {bookingStatuses.length > 0 && (
        <Grid item xs={8} md={4}>
          <RHFSelect
            disabled={statusId === 3 || statusId === 4}
            fullWidth
            name="statusId"
            label="Trạng thái Booking"
            InputLabelProps={{ shrink: true }}
            SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
          >
            {bookingStatuses.map((option) => (
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
          </RHFSelect>
        </Grid>
      )}
    </Grid>
  );
}
