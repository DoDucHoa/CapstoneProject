import { useState } from 'react';
import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { isEmpty } from 'lodash';
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
} from '@mui/material';
import { LoadingButton } from '@mui/lab';
// redux
import { useDispatch } from '../../../redux/store';
import { updateBookingStatus, createPetHealthStatus } from '../../../redux/slices/calendar';
// components
import Scrollbar from '../../../components/Scrollbar';
import { FormProvider, RHFSelect, RHFTextField } from '../../../components/hook-form';
import { fDateTimeSuffix, fDateTime } from '../../../utils/formatTime';
import { fCurrency, fNumber } from '../../../utils/formatNumber';
import { SupplyDialogForm } from './SupplyDialogForm';
import { ServiceDialogForm } from './ServiceDialogForm';
// hooks
import useResponsive from '../../../hooks/useResponsive';
import CageDialogForm from './CageDialogForm';

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------

CalendarForm.propTypes = {
  selectedEvent: PropTypes.object,
  onCancel: PropTypes.func,
  bookingStatuses: PropTypes.array,
  petData: PropTypes.array,
  updateStatusColor: PropTypes.func,
};

export default function CalendarForm({ selectedEvent, onCancel, bookingStatuses, petData, updateStatusColor }) {
  // STATE
  // ----------------------------------------------------------------------
  const [openSupplyDialogForm, setOpenSupplyDialogForm] = useState(false);
  const [openServiceDialogForm, setOpenServiceDialogForm] = useState(false);
  const [openCageDialogForm, setOpenCageDialogForm] = useState(false);

  const [cageSearchParam, setCageSearchParam] = useState({});

  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();
  const { id, statusId, startBooking, endBooking, total, customerNote, serviceOrders, supplyOrders } = selectedEvent;

  // bookingStatuses = bookingStatuses.filter((status) => {
  //   if (statusId === 2) {
  //     return status.id === 2 || status.id === 3;
  //   }

  //   if (statusId === 3) {
  //     return status.id === 3;
  //   }

  //   if (statusId === 4) {
  //     return status.id === 4;
  //   }

  //   return status;
  // });

  const isDesktop = useResponsive('up', 'sm');

  // CONFIGURE FORM
  // ----------------------------------------------------------------------
  const EventSchema = Yup.object().shape({
    id: Yup.number(),
    statusId: Yup.number().required('Bắt buộc nhập'),
    staffNote: Yup.string().when('statusId', {
      is: 4,
      then: Yup.string().required('Bắt buộc nhập lý do hủy'),
    }),
    petData: Yup.array().of(
      Yup.object().shape({
        cageCode: Yup.string(),
        line: Yup.number(),
        price: Yup.number(),
        duration: Yup.number(),
        petBookingDetails: Yup.array().of(
          Yup.object().shape({
            id: Yup.number(),
            name: Yup.string(),
            weight: Yup.number()
              .required('Bắt buộc nhập')
              .moreThan(0, 'Không được nhỏ hơn hoặc bằng 0')
              .max(100, 'Không được vượt quá 100kg')
              .typeError('Bắt buộc nhập'),
            height: Yup.number()
              .required('Bắt buộc nhập')
              .moreThan(0, 'Không được nhỏ hơn hoặc bằng 0')
              .max(250, 'Không được vượt quá 250cm')
              .typeError('Bắt buộc nhập'),
            length: Yup.number()
              .required('Bắt buộc nhập')
              .moreThan(0, 'Không được nhỏ hơn hoặc bằng 0')
              .max(250, 'Không được vượt quá 250cm')
              .typeError('Bắt buộc nhập'),
            description: Yup.string().required('Bắt buộc nhập').typeError('Bắt buộc nhập'),
          })
        ),
      })
    ),
  });

  const methods = useForm({
    resolver: yupResolver(EventSchema),
    defaultValues: { id, statusId, staffNote: '', petData },
  });

  const {
    control,
    watch,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const { fields } = useFieldArray({
    control,
    name: 'petData',
  });

  const values = watch();

  // FUNCTIONS
  // ----------------------------------------------------------------------

  const handleOpenSupplyDialogForm = () => {
    setOpenSupplyDialogForm(true);
  };

  const handleCloseSupplyDialogForm = () => {
    setOpenSupplyDialogForm(false);
  };

  const handleOpenServiceDialogForm = () => {
    setOpenServiceDialogForm(true);
  };

  const handleCloseServiceDialogForm = () => {
    setOpenServiceDialogForm(false);
  };

  const handleOpenCageDialogForm = (cageIndex, bookingDetailLine) => {
    const searchParam = {
      listPets: values.petData[cageIndex].petBookingDetails,
      startBooking: fDateTime(startBooking),
      endBooking: fDateTime(endBooking),
      centerId: 1,
      line: bookingDetailLine,
    };

    setCageSearchParam(searchParam);
    setOpenCageDialogForm(true);
  };

  const handleCloseCageDialogForm = () => {
    setOpenCageDialogForm(false);
  };

  const onSubmit = async (data) => {
    try {
      dispatch(createPetHealthStatus(data, id));
      dispatch(updateBookingStatus(data));
      updateStatusColor(data.id, data.statusId);
      enqueueSnackbar('Cập nhật thành công!');
      onCancel();
    } catch (error) {
      console.error(error);
    }
  };

  // RETURN
  // ----------------------------------------------------------------------
  return (
    <>
      <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
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
            <Typography variant="body2">{customerNote || ''}</Typography>
          </Grid>
        </Grid>

        <Typography paragraph variant="overline" sx={{ color: 'green', pl: 3 }}>
          Thông tin thú cưng
        </Typography>

        {/* Cage management */}
        {fields.map((cage, index) => {
          const cageIndex = index;
          const pet = cage.petBookingDetails;
          return (
            <Grid container spacing={3} sx={{ px: 3, pb: 3 }} key={cageIndex}>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">Mã chuồng</Typography>
                <Typography variant="h6">{cage.cageCode}</Typography>
              </Grid>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">Thời lượng</Typography>
                <Typography variant="h6">{fNumber(cage.duration)} tiếng</Typography>
              </Grid>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">Giá tiền</Typography>
                <Typography variant="h6">{fCurrency(cage.price)} ₫</Typography>
              </Grid>
              {statusId === 1 && isDesktop && (
                <Grid item xs={12} sm={6} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end' }}>
                  <Box>
                    <Button
                      variant="contained"
                      color="warning"
                      onClick={() => handleOpenCageDialogForm(cageIndex, cage.line)}
                    >
                      Đổi chuồng
                    </Button>
                  </Box>
                </Grid>
              )}
              {statusId === 1 && !isDesktop && (
                <Grid item xs={12}>
                  <Button
                    variant="contained"
                    color="warning"
                    onClick={() => handleOpenCageDialogForm(cageIndex, cage.line)}
                  >
                    Đổi chuồng
                  </Button>
                </Grid>
              )}

              {pet.map((pet, petIndex) => (
                <Grid item xs={12} key={petIndex}>
                  <Grid container spacing={3}>
                    <Grid item xs={12} sm={2}>
                      <Typography variant="caption" color="textSecondary">
                        Tên pet
                      </Typography>
                      <Typography variant="body1">{pet.name}</Typography>
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].height`}
                        type="number"
                        label="Chiều cao (cm)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].length`}
                        type="number"
                        label="Chiều dài (cm)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].weight`}
                        type="number"
                        label="Cân nặng (kg)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={4}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].description`}
                        label="Tình trạng sức khỏe"
                      />
                    </Grid>
                  </Grid>
                </Grid>
              ))}
            </Grid>
          );
        })}

        {/* Supplies management */}
        {supplyOrders.length > 0 && (
          <Box sx={{ px: 3, pt: 5 }}>
            <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <Typography paragraph variant="overline" sx={{ color: 'red' }}>
                Đồ dùng
              </Typography>
              {statusId === 1 && (
                <Button variant="contained" color="warning" onClick={handleOpenSupplyDialogForm}>
                  Chỉnh sửa
                </Button>
              )}
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
                        STT
                      </TableCell>
                      <TableCell align="left" width={500}>
                        Mô tả
                      </TableCell>
                      <TableCell align="right">Số lượng</TableCell>
                      <TableCell align="right">Giá bán (VND)</TableCell>
                      <TableCell align="right">Tổng cộng (VND)</TableCell>
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

        {/* Service management */}
        {serviceOrders.length > 0 && (
          <Box sx={{ px: 3, mt: 6 }}>
            <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <Typography paragraph variant="overline" sx={{ color: 'blue' }}>
                Dịch vụ
              </Typography>
              {statusId === 1 && (
                <Button variant="contained" color="warning" onClick={handleOpenServiceDialogForm}>
                  Chỉnh sửa
                </Button>
              )}
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
                        STT
                      </TableCell>
                      <TableCell align="left" width={500}>
                        Mô tả
                      </TableCell>
                      <TableCell align="right">Số lượng</TableCell>
                      <TableCell align="right">Giá bán (VND)</TableCell>
                      <TableCell align="right">Tổng cộng (VND)</TableCell>
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

        {/* Total */}
        <Grid container spacing={3} sx={{ p: 3, pt: 6 }}>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box>
              <Typography variant="h6" align="right">
                Tổng tiền
              </Typography>
              <Typography variant="h4">{fCurrency(total)} ₫</Typography>
            </Box>
          </Grid>
          <Grid item xs={12}>
            <RHFTextField disabled={statusId !== 1} name="staffNote" label="Ghi chú của nhân viên" multiline rows={3} />
          </Grid>
        </Grid>

        {/* Booking status */}
        <Grid container spacing={3} sx={{ p: 3 }}>
          {bookingStatuses.length > 0 && (
            <Grid item xs={8} md={4}>
              <RHFSelect
                // disabled={statusId === 3 || statusId === 4}
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

        {/* Buttons */}
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

      <SupplyDialogForm
        open={openSupplyDialogForm}
        onClose={handleCloseSupplyDialogForm}
        supplies={supplyOrders}
        bookingId={id}
      />

      <ServiceDialogForm
        open={openServiceDialogForm}
        onClose={handleCloseServiceDialogForm}
        services={serviceOrders}
        bookingId={id}
      />

      {!isEmpty(cageSearchParam) && (
        <CageDialogForm
          open={openCageDialogForm}
          onClose={handleCloseCageDialogForm}
          cageSearchParam={cageSearchParam}
          bookingId={id}
        />
      )}
    </>
  );
}
