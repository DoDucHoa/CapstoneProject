import { useState } from 'react';
import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { isEmpty } from 'lodash';
import { PDFDownloadLink, PDFViewer, BlobProvider } from '@react-pdf/renderer';
// form
import { useForm } from 'react-hook-form';
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
  Dialog,
  Tooltip,
  IconButton,
} from '@mui/material';
import { LoadingButton } from '@mui/lab';
// redux
import { useDispatch } from '../../../redux/store';
import { updateBookingStatus, createPetHealthStatus } from '../../../redux/slices/calendar';
// components
import Scrollbar from '../../../components/Scrollbar';
import { FormProvider, RHFSelect, RHFTextField } from '../../../components/hook-form';
import { fDateTime } from '../../../utils/formatTime';
import { fCurrency, fNumber } from '../../../utils/formatNumber';
import { SupplyDialogForm } from './dialogs/SupplyDialogForm';
import { ServiceDialogForm } from './dialogs/ServiceDialogForm';
import Iconify from '../../../components/Iconify';
import InvoicePDF from './invoice/InvoicePDF';
// hooks
import useAuth from '../../../hooks/useAuth';
import useResponsive from '../../../hooks/useResponsive';
import CageDialogForm from './dialogs/CageDialogForm';
import { checkSize, updateInvoiceUrl } from './useCalendarAPI';
import BookingDetail from './new-edit-form/BookingDetail';
import CageManagement from './new-edit-form/CageManagement';

// ----------------------------------------------------------------------

CalendarForm.propTypes = {
  centerId: PropTypes.number,
  centerInfo: PropTypes.object,
  selectedEvent: PropTypes.object,
  onCancel: PropTypes.func,
  bookingStatuses: PropTypes.array,
  petData: PropTypes.array,
  updateStatusColor: PropTypes.func,
};

export default function CalendarForm({
  centerId,
  centerInfo,
  selectedEvent,
  onCancel,
  bookingStatuses,
  petData,
  updateStatusColor,
}) {
  // STATE
  // ----------------------------------------------------------------------
  const [openSupplyDialogForm, setOpenSupplyDialogForm] = useState(false);
  const [openServiceDialogForm, setOpenServiceDialogForm] = useState(false);
  const [openCageDialogForm, setOpenCageDialogForm] = useState(false);
  const [openPDFDialog, setOpenPDFDialog] = useState(false);

  const [isSizeValid, setIsSizeValid] = useState(false);
  const [cageSearchParam, setCageSearchParam] = useState({});

  const { uploadFileToFirebase } = useAuth();

  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();
  const {
    id,
    statusId,
    startBooking,
    endBooking,
    serviceOrders,
    supplyOrders,
    bookingDetails,

    // money
    total,
    subTotal,
    discount,
    totalSupply,
    totalService,
    totalCage,
    voucherCode,
    voucherCodeNavigation,
  } = selectedEvent;

  const petOldInfo = bookingDetails
    .map((detail) =>
      detail.petBookingDetails.map((petData) => ({
        name: petData.pet.name,
        weight: petData.pet.weight,
        height: petData.pet.height,
        length: petData.pet.length,
      }))
    )
    .reduce((acc, cur) => acc.concat(cur), []);

  bookingStatuses = bookingStatuses.filter((status) => {
    if (statusId === 1) {
      return status.id !== 3;
    }

    if (statusId === 2) {
      return status.id === 2 || status.id === 3 || status.id === 4;
    }

    if (statusId === 3) {
      return status.id === 3;
    }

    if (statusId === 4) {
      return status.id === 4;
    }

    return status;
  });

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
              // .max(100, 'Không được vượt quá 100kg')
              .typeError('Bắt buộc nhập'),
            height: Yup.number()
              .required('Bắt buộc nhập')
              .moreThan(0, 'Không được nhỏ hơn hoặc bằng 0')
              // .max(250, 'Không được vượt quá 250cm')
              .typeError('Bắt buộc nhập'),
            length: Yup.number()
              .required('Bắt buộc nhập')
              .moreThan(0, 'Không được nhỏ hơn hoặc bằng 0')
              // .max(250, 'Không được vượt quá 250cm')
              .typeError('Bắt buộc nhập'),
            description: Yup.string(),
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
    reset,
    watch,
    handleSubmit,
    formState: { isSubmitting, isDirty },
  } = methods;

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

  const handleClosePDFDialog = () => {
    setOpenPDFDialog(false);
  };

  const handleOpenPDFDialog = () => {
    setOpenPDFDialog(true);
  };

  const handleOpenCageDialogForm = (cageIndex, bookingDetailLine) => {
    const searchParam = {
      listPets: values.petData[cageIndex].petBookingDetails,
      startBooking: fDateTime(startBooking),
      endBooking: fDateTime(endBooking),
      centerId,
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
      // get current date
      const currentDate = new Date();

      if (startBooking >= currentDate.toISOString()) {
        if (statusId !== 1 || (!isDirty && isSizeValid)) {
          dispatch(createPetHealthStatus(data, id));
          dispatch(updateBookingStatus(data));
          updateStatusColor(data.id, data.statusId);

          enqueueSnackbar('Cập nhật thành công!');
          onCancel();
        } else {
          enqueueSnackbar('Vui lòng kiểm tra lại kích thước của thú cưng!', { variant: 'error' });
        }
      } else {
        enqueueSnackbar('Chưa đến thời gian xác nhận đơn hàng!', { variant: 'error' });
      }
    } catch (error) {
      console.error(error);
    }
  };

  const handleCheckSize = async (cageIndex, centerId) => {
    const { cageCode, petBookingDetails } = values.petData[cageIndex];
    try {
      const response = await checkSize(petBookingDetails, cageCode, centerId);
      if (response === true) {
        enqueueSnackbar('Kích thước thú cưng hợp lệ!');
        reset({ petData }, { keepValues: true });
        setIsSizeValid(true);
      } else {
        enqueueSnackbar('Kích thước thú cưng không hợp lệ!', { variant: 'error' });
        setIsSizeValid(false);
      }
    } catch (error) {
      console.error(error);
    }
  };

  // RETURN
  // ----------------------------------------------------------------------
  return (
    <>
      <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
        <BookingDetail details={selectedEvent} petOldInfo={petOldInfo} />

        <CageManagement
          centerId={centerId}
          statusId={statusId}
          isDesktop={isDesktop}
          handleCheckSize={handleCheckSize}
          handleOpenCageDialogForm={handleOpenCageDialogForm}
        />

        {/* Supplies management */}
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

          {supplyOrders.length > 0 ? (
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
          ) : (
            <Typography>Không có đồ dùng nào được đặt hàng</Typography>
          )}
        </Box>

        {/* Service management */}
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
          {serviceOrders.length > 0 ? (
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
          ) : (
            <Typography>Không có dịch vụ nào được đặt hàng</Typography>
          )}
        </Box>

        {/* Total */}
        <Grid container spacing={1} sx={{ p: 3, pt: 6 }}>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="overline" align="right" mr={3}>
                Tổng giá chuồng
              </Typography>
              <Typography variant="body1" align="right" width={130}>
                {fCurrency(totalCage)} ₫
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="overline" align="right" mr={3}>
                Tổng đồ dùng
              </Typography>
              <Typography variant="body1" align="right" width={130}>
                {fCurrency(totalSupply)} ₫
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="overline" align="right" mr={3}>
                Tổng dịch vụ
              </Typography>
              <Typography variant="body1" align="right" width={130}>
                {fCurrency(totalService)} ₫
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="overline" align="right" mr={3}>
                Tổng tiền
              </Typography>
              <Typography variant="body1" align="right" width={130}>
                {fCurrency(subTotal)} ₫
              </Typography>
            </Box>
          </Grid>
          {voucherCodeNavigation && (
            <>
              <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Typography variant="overline" align="right" mr={3} color="primary">
                  Voucher giảm giá
                </Typography>
                <Typography variant="overline" align="right" width={130} />
              </Grid>
              <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <Typography variant="body2" align="right" mr={3} sx={{ fontWeight: 700 }}>
                    Mã:{' '}
                    {`${voucherCode} (${voucherCodeNavigation?.value}${
                      voucherCodeNavigation?.voucherTypeCode === '1' ? '%' : '₫'
                    })`}
                  </Typography>
                  <Typography variant="body1" align="right" width={130}>
                    -{fCurrency(discount)} ₫
                  </Typography>
                </Box>
              </Grid>
            </>
          )}
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end', mt: 3 }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="h6" align="right" mr={3}>
                Tổng thanh toán
              </Typography>
              <Typography variant="h4" align="right">
                {fCurrency(total)} ₫
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={12} sx={{ mt: 3 }}>
            <RHFTextField
              disabled={statusId === 3 || statusId === 4}
              name="staffNote"
              label="Ghi chú của nhân viên"
              multiline
              rows={3}
            />
          </Grid>
        </Grid>

        {/* Booking status */}
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

        {/* Buttons */}
        <DialogActions>
          <Box sx={{ flexGrow: 1 }} />
          {statusId === 3 && (
            <>
              <PDFDownloadLink
                document={
                  <InvoicePDF
                    invoice={selectedEvent}
                    petData={petData}
                    supplyOrders={supplyOrders}
                    serviceOrders={serviceOrders}
                    centerInfo={centerInfo}
                  />
                }
                fileName={`${selectedEvent.id}-invoice.pdf`}
                style={{ textDecoration: 'none' }}
              >
                {({ loading }) => (
                  <LoadingButton
                    color="info"
                    variant="text"
                    loading={loading}
                    startIcon={<Iconify icon="ant-design:download-outlined" />}
                  >
                    Tải hóa đơn
                  </LoadingButton>
                )}
              </PDFDownloadLink>

              <Button
                sx={{ ml: 2 }}
                onClick={handleOpenPDFDialog}
                color="inherit"
                variant="text"
                startIcon={<Iconify icon={'eva:eye-fill'} />}
              >
                Xem hóa đơn
              </Button>
            </>
          )}

          <Button variant="outlined" color="inherit" onClick={onCancel}>
            Hủy
          </Button>

          {values.statusId !== 3 ? (
            <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
              Xác Nhận
            </LoadingButton>
          ) : (
            <BlobProvider
              document={
                <InvoicePDF
                  invoice={selectedEvent}
                  petData={petData}
                  supplyOrders={supplyOrders}
                  serviceOrders={serviceOrders}
                  centerInfo={centerInfo}
                />
              }
            >
              {({ blob }) => {
                uploadFileToFirebase('invoices', blob, selectedEvent.id).then((downloadUrl) => {
                  updateInvoiceUrl(selectedEvent.id, downloadUrl);
                });
                return (
                  <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                    Xác Nhận
                  </LoadingButton>
                );
              }}
            </BlobProvider>
          )}
        </DialogActions>
      </FormProvider>

      {!isEmpty(cageSearchParam) && (
        <CageDialogForm
          open={openCageDialogForm}
          onClose={handleCloseCageDialogForm}
          cageSearchParam={cageSearchParam}
          bookingId={id}
        />
      )}

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

      <Dialog fullScreen open={openPDFDialog}>
        <Box sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
          <DialogActions
            sx={{
              zIndex: 9,
              padding: '12px !important',
              boxShadow: (theme) => theme.customShadows.z8,
            }}
          >
            <Tooltip title="Close">
              <IconButton color="inherit" onClick={handleClosePDFDialog}>
                <Iconify icon={'eva:close-fill'} />
              </IconButton>
            </Tooltip>
          </DialogActions>

          <Box sx={{ flexGrow: 1, height: '100%', overflow: 'hidden' }}>
            <PDFViewer width="100%" height="100%" style={{ border: 'none' }}>
              <InvoicePDF
                invoice={selectedEvent}
                petData={petData}
                supplyOrders={supplyOrders}
                serviceOrders={serviceOrders}
                centerInfo={centerInfo}
              />
            </PDFViewer>
          </Box>
        </Box>
      </Dialog>
    </>
  );
}
