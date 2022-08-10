import PropTypes from 'prop-types';
import { vi } from 'date-fns/locale';
// form
import { useFormContext, Controller } from 'react-hook-form';
// @mui
import { TextField } from '@mui/material';
import { DatePicker, LocalizationProvider } from '@mui/lab';
import AdapterDateFns from '@mui/lab/AdapterDateFns';

// ----------------------------------------------------------------------

RHFDatePicker.propTypes = {
  name: PropTypes.string,
};

export default function RHFDatePicker({ name, ...other }) {
  const { control } = useFormContext();

  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState: { error } }) =>
        AdapterDateFns && (
          <LocalizationProvider dateAdapter={AdapterDateFns} locale={vi}>
            <DatePicker
              {...field}
              {...other}
              renderInput={(param) => <TextField {...param} fullWidth error={!!error} helperText={error?.message} />}
            />
          </LocalizationProvider>
        )
      }
    />
  );
}
