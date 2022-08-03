// import PropTypes from 'prop-types';
// @mui
import { Grid } from '@mui/material';
// hooks
import { RHFTextField } from '../../../../components/hook-form';

// ----------------------------------------------------------------------

// ServiceDetail.propTypes = {
//   isEdit: PropTypes.bool,
// };

export default function ServiceDetail() {
  return (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <RHFTextField name="service.name" label="Tên dịch vụ" />
      </Grid>
      <Grid item xs={12}>
        <RHFTextField name="service.description" multiline rows={3} label="Mô tả dịch vụ" />
      </Grid>
    </Grid>
  );
}
