import PropTypes from 'prop-types';
// form
import { useFormContext, Controller } from 'react-hook-form';
// @mui
import { FormHelperText, Slider, Typography } from '@mui/material';

// ----------------------------------------------------------------------

RHFSlider.propTypes = {
  name: PropTypes.string,
  label: PropTypes.string,
};

export default function RHFSlider({ name, label, ...other }) {
  const { control } = useFormContext();

  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState: { error } }) => (
        <div>
          <Typography>{label}</Typography>
          <Slider {...field} {...other} />
          {!!error && (
            <FormHelperText error sx={{ px: 2 }}>
              {error.message}
            </FormHelperText>
          )}
        </div>
      )}
    />
  );
}
