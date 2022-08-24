import PropTypes from 'prop-types';
// @mui
import { Grid } from '@mui/material';
// hooks
import { RHFCheckbox, RHFTextField } from '../../../../components/hook-form';

// ----------------------------------------------------------------------

CageTypeDetail.propTypes = {
  isEdit: PropTypes.bool,
};

export default function CageTypeDetail({ isEdit }) {
  return (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <RHFTextField name="createCageTypeParameter.typeName" label="Loại chuồng" />
      </Grid>
      <Grid item xs={12}>
        <RHFTextField name="createCageTypeParameter.description" multiline rows={3} label="Mô tả" />
      </Grid>
      <Grid item xs={12} sm={4}>
        <RHFTextField
          name="createCageTypeParameter.height"
          label="Chiều cao (cm)"
          type="number"
          isNumber
          disabled={isEdit}
        />
      </Grid>
      <Grid item xs={12} sm={4}>
        <RHFTextField
          name="createCageTypeParameter.width"
          label="Chiều rộng (cm)"
          type="number"
          isNumber
          disabled={isEdit}
        />
      </Grid>
      <Grid item xs={12} sm={4}>
        <RHFTextField
          name="createCageTypeParameter.length"
          label="Chiều dài (cm)"
          type="number"
          isNumber
          disabled={isEdit}
        />
      </Grid>
      <Grid item xs={12} sm={4}>
        <RHFCheckbox name="createCageTypeParameter.isSingle" label="Chuồng riêng" />
      </Grid>
    </Grid>
  );
}
