import PropTypes from 'prop-types';
// form
import { useFormContext, Controller } from 'react-hook-form';
// @mui
import { TextField } from '@mui/material';
import { TimePicker } from '@mui/lab';

// ----------------------------------------------------------------------

RHFTimePicker.propTypes = {
  name: PropTypes.string,
};

export default function RHFTimePicker({ name, ...other }) {
  const { control } = useFormContext();

  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState: { error } }) => (
        <TimePicker
          ampm={false}
          {...field}
          {...other}
          renderInput={(param) => <TextField {...param} fullWidth error={!!error} helperText={error?.message} />}
        />
      )}
    />
  );
}
