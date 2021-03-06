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
import { checkSize } from './useCalendarAPI';

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------

CalendarForm.propTypes = {
  centerId: PropTypes.number,
  selectedEvent: PropTypes.object,
  onCancel: PropTypes.func,
  bookingStatuses: PropTypes.array,
  petData: PropTypes.array,
  updateStatusColor: PropTypes.func,
};

export default function CalendarForm({
  centerId,
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
  const [isSizeValid, setIsSizeValid] = useState(false);

  const [cageSearchParam, setCageSearchParam] = useState({});

  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();
  const { id, statusId, startBooking, endBooking, total, customerNote, serviceOrders, supplyOrders, bookingDetails } =
    selectedEvent;

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
      return status.id === 2 || status.id === 3;
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
    statusId: Yup.number().required('B???t bu???c nh???p'),
    staffNote: Yup.string().when('statusId', {
      is: 4,
      then: Yup.string().required('B???t bu???c nh???p l?? do h???y'),
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
              .required('B???t bu???c nh???p')
              .moreThan(0, 'Kh??ng ???????c nh??? h??n ho???c b???ng 0')
              .max(100, 'Kh??ng ???????c v?????t qu?? 100kg')
              .typeError('B???t bu???c nh???p'),
            height: Yup.number()
              .required('B???t bu???c nh???p')
              .moreThan(0, 'Kh??ng ???????c nh??? h??n ho???c b???ng 0')
              .max(250, 'Kh??ng ???????c v?????t qu?? 250cm')
              .typeError('B???t bu???c nh???p'),
            length: Yup.number()
              .required('B???t bu???c nh???p')
              .moreThan(0, 'Kh??ng ???????c nh??? h??n ho???c b???ng 0')
              .max(250, 'Kh??ng ???????c v?????t qu?? 250cm')
              .typeError('B???t bu???c nh???p'),
            description: Yup.string().required('B???t bu???c nh???p').typeError('B???t bu???c nh???p'),
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
    reset,
    watch,
    handleSubmit,
    trigger,
    formState: { isSubmitting, isDirty },
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
      if (!isDirty && isSizeValid) {
        dispatch(createPetHealthStatus(data, id));
        dispatch(updateBookingStatus(data));
        updateStatusColor(data.id, data.statusId);
        enqueueSnackbar('C???p nh???t th??nh c??ng!');
        onCancel();
      } else {
        enqueueSnackbar('Vui l??ng ki???m tra l???i k??ch th?????c c???a th?? c??ng!', { variant: 'error' });
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
        enqueueSnackbar('K??ch th?????c th?? c??ng h???p l???!');
        reset({ petData }, { keepValues: true });
        setIsSizeValid(true);
      } else {
        enqueueSnackbar('K??ch th?????c th?? c??ng kh??ng h???p l???!', { variant: 'error' });
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
        <Grid container spacing={3} sx={{ p: 3 }}>
          <Grid item xs={6} sm={3}>
            <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
              Th???i ??i???m b???t ?????u
            </Typography>
            <Typography variant="body2">{fDateTimeSuffix(startBooking)}</Typography>
          </Grid>

          <Grid item xs={6} sm={3}>
            <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
              Th???i ??i???m k???t th??c
            </Typography>
            <Typography variant="body2">{fDateTimeSuffix(endBooking)}</Typography>
          </Grid>

          <Grid item xs={12}>
            <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
              Ghi ch?? kh??ch h??ng
            </Typography>
            <Typography variant="body2">{customerNote || 'Kh??ng c?? ghi ch??'}</Typography>
          </Grid>

          {statusId === 1 && (
            <Grid item xs={12} sm={6}>
              <Typography paragraph variant="overline" sx={{ color: 'text.disabled' }}>
                Th??ng tin c?? c???a th?? c??ng
              </Typography>
              <Grid container>
                <Grid item xs={3}>
                  <Typography variant="caption">T??n</Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="caption">Cao (cm)</Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="caption">D??i (cm)</Typography>
                </Grid>
                <Grid item xs={3}>
                  <Typography variant="caption">N???ng (kg)</Typography>
                </Grid>

                {petOldInfo.map((pet, index) => (
                  <Grid container key={index}>
                    <Grid item xs={3}>
                      <Typography variant="body2">
                        <b>{pet.name}</b>
                      </Typography>
                    </Grid>
                    <Grid item xs={3}>
                      <Typography variant="body2">{pet.height}</Typography>
                    </Grid>
                    <Grid item xs={3}>
                      <Typography variant="body2">{pet.length}</Typography>
                    </Grid>
                    <Grid item xs={3}>
                      <Typography variant="body2">{pet.weight}</Typography>
                    </Grid>
                  </Grid>
                ))}
              </Grid>
            </Grid>
          )}
        </Grid>

        <Typography paragraph variant="overline" sx={{ color: 'green', pl: 3 }}>
          Th??ng tin th?? c??ng
        </Typography>

        {/* Cage management */}
        {fields.map((cage, index) => {
          const cageIndex = index;
          const pet = cage.petBookingDetails;
          return (
            <Grid container spacing={3} sx={{ px: 3, pb: 3 }} key={cageIndex}>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">M?? chu???ng</Typography>
                <Typography variant="h6">{cage.cageCode}</Typography>
              </Grid>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">Th???i l?????ng</Typography>
                <Typography variant="h6">{fNumber(cage.duration)} ti???ng</Typography>
              </Grid>
              <Grid item xs={4} sm={2}>
                <Typography variant="caption">Gi?? ti???n</Typography>
                <Typography variant="h6">{fCurrency(cage.price)} ???</Typography>
              </Grid>
              {statusId === 1 && isDesktop && (
                <Grid item xs={12} sm={6} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end' }}>
                  <Box>
                    <Button
                      sx={{ mr: 3 }}
                      variant="contained"
                      color="primary"
                      onClick={() => {
                        trigger('petData').then((isValid) => {
                          if (isValid) {
                            handleCheckSize(cageIndex, centerId);
                          }
                        });
                      }}
                    >
                      Ki???m tra k??ch th?????c
                    </Button>
                    <Button
                      variant="contained"
                      color="warning"
                      onClick={() => handleOpenCageDialogForm(cageIndex, cage.line)}
                    >
                      ?????i chu???ng
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
                    ?????i chu???ng
                  </Button>
                </Grid>
              )}

              {pet.map((pet, petIndex) => (
                <Grid item xs={12} key={petIndex}>
                  <Grid container spacing={3}>
                    <Grid item xs={12} sm={2}>
                      <Typography variant="caption" color="textSecondary">
                        T??n pet
                      </Typography>
                      <Typography variant="body1">{pet.name}</Typography>
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].height`}
                        type="number"
                        label="Chi???u cao (cm)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].length`}
                        type="number"
                        label="Chi???u d??i (cm)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={2}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].weight`}
                        type="number"
                        label="C??n n???ng (kg)"
                      />
                    </Grid>
                    <Grid item xs={6} sm={4}>
                      <RHFTextField
                        disabled={statusId !== 1}
                        name={`petData[${cageIndex}].petBookingDetails[${petIndex}].description`}
                        label="T??nh tr???ng s???c kh???e"
                      />
                    </Grid>
                  </Grid>
                </Grid>
              ))}
            </Grid>
          );
        })}

        {/* Supplies management */}
        <Box sx={{ px: 3, pt: 5 }}>
          <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
            <Typography paragraph variant="overline" sx={{ color: 'red' }}>
              ????? d??ng
            </Typography>
            {statusId === 1 && (
              <Button variant="contained" color="warning" onClick={handleOpenSupplyDialogForm}>
                Ch???nh s???a
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
                        M?? t???
                      </TableCell>
                      <TableCell align="right">S??? l?????ng</TableCell>
                      <TableCell align="right">Gi?? b??n (VND)</TableCell>
                      <TableCell align="right">T???ng c???ng (VND)</TableCell>
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
            <Typography>Kh??ng c?? ????? d??ng n??o ???????c ?????t h??ng</Typography>
          )}
        </Box>

        {/* Service management */}
        <Box sx={{ px: 3, mt: 6 }}>
          <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
            <Typography paragraph variant="overline" sx={{ color: 'blue' }}>
              D???ch v???
            </Typography>
            {statusId === 1 && (
              <Button variant="contained" color="warning" onClick={handleOpenServiceDialogForm}>
                Ch???nh s???a
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
                        M?? t???
                      </TableCell>
                      <TableCell align="right">S??? l?????ng</TableCell>
                      <TableCell align="right">Gi?? b??n (VND)</TableCell>
                      <TableCell align="right">T???ng c???ng (VND)</TableCell>
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
            <Typography>Kh??ng c?? d???ch v??? n??o ???????c ?????t h??ng</Typography>
          )}
        </Box>

        {/* Total */}
        <Grid container spacing={3} sx={{ p: 3, pt: 6 }}>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box>
              <Typography variant="h6" align="right">
                T???ng ti???n
              </Typography>
              <Typography variant="h4">{fCurrency(total)} ???</Typography>
            </Box>
          </Grid>
          <Grid item xs={12}>
            <RHFTextField disabled={statusId !== 1} name="staffNote" label="Ghi ch?? c???a nh??n vi??n" multiline rows={3} />
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
                label="Tr???ng th??i Booking"
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
            H???y
          </Button>

          <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
            X??c Nh???n
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
