import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
// form
import { useForm, useFieldArray } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import {
  Box,
  Button,
  DialogActions,
  Grid,
  Typography,
  TableContainer,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  MenuItem,
  Divider,
} from '@mui/material';
import { LoadingButton } from '@mui/lab';
// redux
import { useDispatch } from '../../../redux/store';
import { updateBookingStatus } from '../../../redux/slices/calendar';
// components
import Scrollbar from '../../../components/Scrollbar';
import { FormProvider, RHFSelect, RHFTextField } from '../../../components/hook-form';
import { fDateTimeSuffix } from '../../../utils/formatTime';
import { fCurrency, fNumber } from '../../../utils/formatNumber';

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------

CalendarForm.propTypes = {
  selectedEvent: PropTypes.object,
  onCancel: PropTypes.func,
  bookingStatuses: PropTypes.array,
  petData: PropTypes.array,
};

export default function CalendarForm({ selectedEvent, onCancel, bookingStatuses, petData }) {
  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();
  const { id, statusId, startBooking, endBooking, total, customerNote, serviceOrders, supplyOrders } = selectedEvent;

  const EventSchema = Yup.object().shape({
    id: Yup.number(),
    statusId: Yup.number().required('Bắt buộc nhập'),
  });

  const methods = useForm({
    resolver: yupResolver(EventSchema),
    defaultValues: { id, statusId, staffNote: '', petData },
  });

  const {
    reset,
    control,
    // watch,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const { fields } = useFieldArray({
    control,
    name: 'petData',
  });

  // const values = watch();

  const onSubmit = async (data) => {
    try {
      dispatch(updateBookingStatus(data));
      enqueueSnackbar('Cập nhật thành công!');
      onCancel();
      reset();
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3} sx={{ p: 3 }}>
        <Grid item xs={6} sm={6}>
          <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
            Thời điểm bắt đầu
          </Typography>
          <Typography variant="body2">{fDateTimeSuffix(startBooking)}</Typography>
        </Grid>

        <Grid item xs={6} sm={6}>
          <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
            Thời điểm kết thúc
          </Typography>
          <Typography variant="body2">{fDateTimeSuffix(endBooking)}</Typography>
        </Grid>

        <Grid item xs={12}>
          <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
            Ghi chú khách hàng
          </Typography>
          <Typography variant="body2">{customerNote || ''}</Typography>
        </Grid>
      </Grid>

      {supplyOrders.length > 0 && (
        <Box sx={{ px: 3 }}>
          <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
            <Typography paragraph variant="overline" sx={{ color: 'red' }}>
              Đồ dùng
            </Typography>
            <Button variant="contained" color="warning" onClick={onCancel}>
              Chỉnh sửa
            </Button>
          </Box>
          <Scrollbar>
            <TableContainer sx={{ minWidth: 300 }}>
              <Table>
                <TableHead
                  sx={{
                    borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                    '& th': { backgroundColor: 'transparent' },
                  }}
                >
                  <TableRow>
                    <TableCell align="center" width={40}>
                      Stt
                    </TableCell>
                    <TableCell align="left">Mô tả</TableCell>
                    <TableCell align="right">Số lượng</TableCell>
                    <TableCell align="right">Giá bán</TableCell>
                    <TableCell align="right">Tổng cộng</TableCell>
                  </TableRow>
                </TableHead>

                <TableBody>
                  {supplyOrders.map((row, index) => (
                    <TableRow
                      key={index}
                      sx={{
                        borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                      }}
                    >
                      <TableCell align="center">{index + 1}</TableCell>
                      <TableCell align="left">
                        <Box sx={{ maxWidth: 560 }}>
                          <Typography variant="subtitle2">{row.supply.name}</Typography>
                        </Box>
                      </TableCell>
                      <TableCell align="right">{fNumber(row.quantity)}</TableCell>
                      <TableCell align="right">{fCurrency(row.sellPrice)}</TableCell>
                      <TableCell align="right">{fCurrency(row.totalPrice)}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>
        </Box>
      )}

      {serviceOrders.length > 0 && (
        <Box sx={{ px: 3, mt: 5 }}>
          <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
            <Typography paragraph variant="overline" sx={{ color: 'blue' }}>
              Dịch vụ
            </Typography>
            <Button variant="contained" color="warning" onClick={onCancel}>
              Chỉnh sửa
            </Button>
          </Box>
          <Scrollbar>
            <TableContainer sx={{ minWidth: 300 }}>
              <Table>
                <TableHead
                  sx={{
                    borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                    '& th': { backgroundColor: 'transparent' },
                  }}
                >
                  <TableRow>
                    <TableCell align="center" width={40}>
                      Stt
                    </TableCell>
                    <TableCell align="left">Mô tả</TableCell>
                    <TableCell align="right">Số lượng</TableCell>
                    <TableCell align="right">Giá bán</TableCell>
                    <TableCell align="right">Tổng cộng</TableCell>
                  </TableRow>
                </TableHead>

                <TableBody>
                  {serviceOrders.map((row, index) => (
                    <TableRow
                      key={index}
                      sx={{
                        borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                      }}
                    >
                      <TableCell align="center">{index + 1}</TableCell>
                      <TableCell align="left">
                        <Box sx={{ maxWidth: 560 }}>
                          <Typography variant="subtitle2">{row.service.description}</Typography>
                        </Box>
                      </TableCell>
                      <TableCell align="right">{fNumber(row.quantity)}</TableCell>
                      <TableCell align="right">{fCurrency(row.sellPrice)}</TableCell>
                      <TableCell align="right">{fCurrency(row.totalPrice)}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>
        </Box>
      )}

      <Grid container spacing={3} sx={{ p: 3 }}>
        <Grid item xs={12}>
          <Typography variant="h6">Tổng tiền</Typography>
          <Typography variant="body2">{fCurrency(total)} đồng</Typography>
        </Grid>
        <Grid item xs={12}>
          <RHFTextField name="staffNote" label="Ghi chú của nhân viên" multiline rows={3} />
        </Grid>
      </Grid>

      <Divider sx={{ borderStyle: 'dashed', borderColor: 'black', my: 3 }} />

      {fields.map((pet, index) => (
        <Grid container spacing={3} sx={{ p: 3 }} key={index}>
          <Grid item xs={2}>
            <Typography variant="caption">Tên pet</Typography>
            <Typography variant="body1">{pet.name}</Typography>
          </Grid>
          <Grid item xs={2}>
            <RHFTextField name={`petData[${index}].height`} type="number" label="Chiều cao (cm)" />
          </Grid>
          <Grid item xs={2}>
            <RHFTextField name={`petData[${index}].length`} type="number" label="Chiều dài (cm)" />
          </Grid>
          <Grid item xs={2}>
            <RHFTextField name={`petData[${index}].weight`} type="number" label="Cân nặng (kg)" />
          </Grid>
          <Grid item xs={4}>
            <RHFTextField name={`petData[${index}].description`} label="Tình trạng sức khỏe" />
          </Grid>
        </Grid>
      ))}

      <Grid container spacing={3} sx={{ p: 3 }}>
        {bookingStatuses.length > 0 && (
          <Grid item xs={4}>
            <RHFSelect
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

      <DialogActions>
        <Box sx={{ flexGrow: 1 }} />

        <Button variant="outlined" color="inherit" onClick={onCancel}>
          Hủy
        </Button>

        <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
          Xác Nhận
        </LoadingButton>
      </DialogActions>
    </FormProvider>
  );
}
