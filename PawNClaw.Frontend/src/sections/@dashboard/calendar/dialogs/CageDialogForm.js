import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';

// @mui
import { LoadingButton } from '@mui/lab';
import {
  Autocomplete,
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogTitle,
  Grid,
  TextField,
  Typography,
} from '@mui/material';

// form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm, Controller } from 'react-hook-form';

// hooks
import useAuth from '../../../../hooks/useAuth';

// redux
import { useDispatch } from '../../../../redux/store';
import { getBookingDetails } from '../../../../redux/slices/calendar';

// utils
import axios from '../../../../utils/axios';
import { FormProvider, RHFTextField } from '../../../../components/hook-form';
import { fCurrency } from '../../../../utils/formatNumber';

// ----------------------------------------------------------------------

CageDialogForm.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  cageSearchParam: PropTypes.object.isRequired,
  bookingId: PropTypes.number.isRequired,
};

export default function CageDialogForm({ open, onClose, cageSearchParam, bookingId }) {
  // STATE
  // ----------------------------------------------------------------------
  const [options, setOptions] = useState([]);
  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();

  const { centerInfo } = useAuth();

  useEffect(() => {
    const getCage = async () => {
      const { data } = await axios.post('/api/cagetypes/staff-booking', cageSearchParam);
      setOptions(data);
    };
    getCage();
  }, [cageSearchParam]);

  // CONFIG
  // ----------------------------------------------------------------------
  const EventSchema = Yup.object().shape({
    cageType: Yup.string().required('Bắt buộc nhập').typeError('Bắt buộc nhập'),
    cageCode: Yup.string().required('Bắt buộc nhập').typeError('Bắt buộc nhập'),
    note: Yup.string(),
  });

  const methods = useForm({
    resolver: yupResolver(EventSchema),
    defaultValues: { cageType: '', cageCode: '', note: '', bookingId, line: cageSearchParam.line, price: 0 },
  });

  const {
    control,
    reset,
    watch,
    setValue,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  // HANDLE
  // ----------------------------------------------------------------------
  const cages = options.find((option) => option.typeName === values.cageType)?.cages || [];
  const price = options.find((option) => option.typeName === values.cageType)?.totalPrice || 0;

  const onSubmit = async (data) => {
    try {
      // handle change cage
      await axios.put('/api/bookingdetails', {
        id: data.line,
        cageCode: data.cageCode,
        note: data.note,
        price,
      });

      await Promise.all(
        cageSearchParam.listPets.map(async (pet) => {
          await axios.post('/api/pethealthhistories', {
            isUpdatePet: true,
            createPetHealthHistoryParameter: {
              checkedDate: new Date(),
              description: 'Đổi chuồng',
              centerName: centerInfo.name,
              petId: pet.id,
              length: pet.length,
              height: pet.height,
              weight: pet.weight,
              bookingId,
            },
          });
        })
      ).then(() => {
        onClose();
        enqueueSnackbar('Cập nhật thành công!');
        dispatch(getBookingDetails(bookingId));
      });
    } catch (error) {
      console.log(error);
    }
  };

  const handleCloseDialog = () => {
    reset();
    onClose();
  };

  return (
    <Dialog open={open} onClose={handleCloseDialog} fullWidth maxWidth="md">
      <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
        <DialogTitle>Đổi chuồng</DialogTitle>

        <Grid container spacing={3} sx={{ p: 3 }}>
          <Grid item xs={3}>
            <Controller
              control={control}
              name="cageType"
              render={({ field, fieldState: { error } }) => (
                <Autocomplete
                  onChange={(event, newValue) => {
                    field.onChange(newValue);
                    setValue('cageCode', '');
                  }}
                  options={options.map((option) => option.typeName)}
                  noOptionsText="Không có loại chuồng phù hợp"
                  renderInput={(params) => (
                    <TextField error={!!error} helperText={error?.message} {...params} label="Loại chuồng" />
                  )}
                />
              )}
            />
          </Grid>
          <Grid item xs={3}>
            <Controller
              control={control}
              name="cageCode"
              render={({ field, fieldState: { error } }) => (
                <Autocomplete
                  value={field.value}
                  onChange={(event, newValue) => field.onChange(newValue)}
                  options={cages.map((option) => option.code)}
                  noOptionsText="Không có chuồng phù hợp"
                  renderInput={(params) => (
                    <TextField error={!!error} helperText={error?.message} {...params} label="Mã chuồng" />
                  )}
                />
              )}
            />
          </Grid>
          <Grid item xs={6}>
            <RHFTextField name="note" label="Ghi chú" />
          </Grid>
          <Grid item xs={12}>
            <Typography variant="caption">Giá tiền</Typography>
            <Typography variant="h6">{fCurrency(price)} ₫ /ngày</Typography>
          </Grid>
        </Grid>

        <DialogActions>
          <Box sx={{ flexGrow: 1 }} />
          <Button variant="outlined" color="inherit" onClick={() => handleCloseDialog()}>
            Hủy
          </Button>
          <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
            Xác Nhận
          </LoadingButton>
        </DialogActions>
      </FormProvider>
    </Dialog>
  );
}
