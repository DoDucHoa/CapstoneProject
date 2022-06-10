import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';

// @mui
import { Box, Button, Dialog, DialogActions, DialogTitle, Grid, Typography } from '@mui/material';
import { LoadingButton } from '@mui/lab';

// form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm, useFieldArray } from 'react-hook-form';

// redux
import { useDispatch } from '../../../redux/store';
import { getBookingDetails, closeModal } from '../../../redux/slices/calendar';

// components
import axios from '../../../utils/axios';
import { FormProvider, RHFTextField } from '../../../components/hook-form';
import { fCurrency } from '../../../utils/formatNumber';

SupplyDialogForm.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  supplies: PropTypes.array.isRequired,
  bookingId: PropTypes.number.isRequired,
};

export function SupplyDialogForm({ open, onClose, supplies, bookingId }) {
  // STATE
  // ----------------------------------------------------------------------
  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();

  // CONFIG
  // ----------------------------------------------------------------------
  const suppliesData = supplies.map((supply) => ({
    supplyId: supply.supplyId,
    name: supply.supply.name,
    quantity: supply.quantity,
    sellPrice: supply.sellPrice,
    total: supply.quantity * supply.sellPrice,
  }));

  const EventSchema = Yup.object().shape({
    supplies: Yup.array().of(
      Yup.object().shape({
        supplyId: Yup.number(),
        quantity: Yup.number().required('Bắt buộc nhập').min(0, 'Không được nhỏ hơn 0').typeError('Bắt buộc nhập'),
        sellPrice: Yup.number().required('Bắt buộc nhập').min(0, 'Không được nhỏ hơn 0').typeError('Bắt buộc nhập'),
      })
    ),
  });

  const methods = useForm({
    resolver: yupResolver(EventSchema),
    defaultValues: { supplies: suppliesData },
  });

  const {
    control,
    watch,
    handleSubmit,
    setValue,
    formState: { isSubmitting },
  } = methods;

  const { fields } = useFieldArray({
    control,
    name: 'supplies',
  });

  const values = watch();

  // FUNCTIONS
  // ----------------------------------------------------------------------
  const onSubmit = async (data) => {
    try {
      await UpdateSupplyOrder(data, bookingId);
      onClose();
      enqueueSnackbar('Cập nhật thành công!');
      dispatch(closeModal());
      dispatch(getBookingDetails(bookingId));
    } catch (error) {
      enqueueSnackbar(error.message, { variant: 'error' });
    }
  };

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="md">
      <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
        <DialogTitle>Chỉnh sửa đồ dùng</DialogTitle>
        <Grid container sx={{ p: 3, alignItems: 'center' }} spacing={2}>
          <Grid item xs={5}>
            <Typography variant="h6">Mô tả</Typography>
          </Grid>
          <Grid item xs={2}>
            <Typography variant="h6">Số lượng</Typography>
          </Grid>
          <Grid item xs={2}>
            <Typography variant="h6">Giá (VND)</Typography>
          </Grid>
          <Grid item xs={3}>
            <Typography variant="h6">Tổng cộng</Typography>
          </Grid>
        </Grid>
        {fields.map((supply, index) => (
          <Grid container sx={{ px: 3, alignItems: 'center' }} spacing={2} key={index}>
            <Grid item xs={5}>
              {supply.name}
            </Grid>
            <Grid item xs={2}>
              <RHFTextField
                size="small"
                name={`supplies[${index}].quantity`}
                type="number"
                onChange={(event) => setValue(`supplies[${index}].quantity`, Number(event.target.value))}
              />
            </Grid>
            <Grid item xs={2}>
              <RHFTextField
                size="small"
                name={`supplies[${index}].sellPrice`}
                type="number"
                onChange={(event) => setValue(`supplies[${index}].sellPrice`, Number(event.target.value))}
              />
            </Grid>
            <Grid item xs={3}>
              <Typography fontWeight={700}>
                {fCurrency(values.supplies[index].quantity * values.supplies[index].sellPrice)} đồng
              </Typography>
            </Grid>
          </Grid>
        ))}

        <DialogActions sx={{ mt: 3 }}>
          <Box sx={{ flexGrow: 1 }} />
          <Button variant="outlined" color="inherit" onClick={() => onClose()}>
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

async function UpdateSupplyOrder({ supplies }, bookingId) {
  try {
    await axios.put('/api/supplyorders', {
      bookingId,
      listUpdateSupplyOrderParameters: supplies,
    });
  } catch (error) {
    console.log(error);
  }
}
