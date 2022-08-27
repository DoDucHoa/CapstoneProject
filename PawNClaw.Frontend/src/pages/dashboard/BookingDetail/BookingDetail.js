import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { isEmpty } from 'lodash';
// form
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// redux
import { useDispatch } from '../../../redux/store';
import { updateBookingStatus, createPetHealthStatus, getBookingDetails } from '../../../redux/slices/calendar';
// hooks
import useResponsive from '../../../hooks/useResponsive';
// components
import { FormProvider } from '../../../components/hook-form';
import { compareBookingWithCurrentDate, fDateTime } from '../../../utils/formatTime';

import {
  SupplyDialogForm,
  CageDialogForm,
  PDFInvoiceDialog,
  ServiceDialogForm,
} from '../../../sections/@dashboard/calendar/dialogs';

import {
  BookingDetail,
  BookingStatusCombobox,
  CageManagement,
  FormAction,
  PaymentDetail,
  ServiceList,
  SupplyList,
} from '../../../sections/@dashboard/calendar/new-edit-form';

import { checkSize } from '../../../sections/@dashboard/calendar/useCalendarAPI';
import useAuth from '../../../hooks/useAuth';
import axios from '../../../utils/axios';

// ----------------------------------------------------------------------

BookingDetails.propTypes = {
  centerId: PropTypes.any,
  centerInfo: PropTypes.object,
  selectedEvent: PropTypes.object,
  onCancel: PropTypes.func,
  bookingStatuses: PropTypes.array,
  petData: PropTypes.array,
};

BookingDetails.defaultProps = {
  centerId: 0,
  centerInfo: {},
  selectedEvent: {},
  onCancel: () => {},
  bookingStatuses: [],
  petData: [],
};
BookingDetails.displayName = 'BookingDetails';

export default function BookingDetails({ centerId, centerInfo, selectedEvent, onCancel, bookingStatuses, petData }) {
  // STATE
  const [openSupplyDialogForm, setOpenSupplyDialogForm] = useState(false);
  const [openServiceDialogForm, setOpenServiceDialogForm] = useState(false);
  const [openCageDialogForm, setOpenCageDialogForm] = useState(false);
  const [openPDFDialog, setOpenPDFDialog] = useState(false);

  const [cageSearchParam, setCageSearchParam] = useState({});

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

  const isValidDate = compareBookingWithCurrentDate(startBooking);

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
    switch (statusId) {
      case 1:
        return status.id !== 3;
      case 2:
        return status.id === 2 || status.id === 3;
      case 3:
        return status.id === 3;
      case 4:
        return status.id === 4;
      default:
        break;
    }

    return status;
  });

  const cageSizeCheck = petData.map((cage) => ({ cageCode: cage.cageCode, isValid: false }));

  // * ----------------------------------------------------------------------
  // HOOKS
  const { enqueueSnackbar } = useSnackbar();
  const dispatch = useDispatch();
  const isDesktop = useResponsive('up', 'sm');

  // * ----------------------------------------------------------------------
  // CONFIGURE FORM
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
    defaultValues: { id, statusId, staffNote: '', petData, cageSizeCheck },
  });

  const {
    reset,
    watch,
    handleSubmit,
    setValue,
    formState: { isSubmitting, dirtyFields },
  } = methods;

  const values = watch();

  // check dirty fields
  const checkIsDirty = () => dirtyFields?.petData?.some((pet) => pet?.petBookingDetails);
  const getDirtyIndex = () => dirtyFields?.petData?.findIndex((pet) => pet?.petBookingDetails);
  const isDirty = checkIsDirty();
  const dirtyIndex = getDirtyIndex();

  useEffect(() => {
    if (isDirty) {
      setValue(`cageSizeCheck[${dirtyIndex}].isValid`, false);
    }
  }, [isDirty, dirtyIndex, setValue]);

  useEffect(() => {
    setValue('petData', petData);
  }, [petData, setValue]);

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

  const isSizeValid = values.cageSizeCheck?.every((cage) => cage.isValid);

  const onSubmit = async (data) => {
    try {
      // check if current date occurs before booking date
      if (values.statusId !== 2 || isValidDate) {
        if (values.statusId !== 2 || (!isDirty && isSizeValid)) {
          await dispatch(createPetHealthStatus(data, id));
          await dispatch(updateBookingStatus(data));

          enqueueSnackbar('Cập nhật thành công!');
          if (values.statusId !== 3) {
            onCancel();
          } else {
            setOpenPDFDialog(true);
          }
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
      const response = await checkSize(petBookingDetails, cageCode, centerId, id);

      await Promise.all(
        petBookingDetails.map(async (pet) => {
          await axios.post('/api/pethealthhistories', {
            isUpdatePet: true,
            createPetHealthHistoryParameter: {
              checkedDate: new Date(),
              description: 'Kiểm tra kích thước',
              centerName: centerInfo.name,
              petId: pet.id,
              length: pet.length,
              height: pet.height,
              weight: pet.weight,
              bookingId: id,
            },
          });
        })
      );

      if (response === true) {
        enqueueSnackbar('Kích thước thú cưng hợp lệ!');
        reset({ petData }, { keepValues: true });
        setValue(`cageSizeCheck[${cageIndex}].isValid`, true);
        dispatch(getBookingDetails(id));
      } else {
        enqueueSnackbar('Kích thước thú cưng không hợp lệ!', { variant: 'error' });
        setValue(`cageSizeCheck[${cageIndex}].isValid`, false);
      }
    } catch (error) {
      console.error(error);
    }
  };

  const [centerName, setCenterName] = useState('');
  const { accountInfo } = useAuth();

  useEffect(() => {
    async function fetchCenterName(staffId) {
      const res = await axios.get(`/api/petcenters/staff/${staffId}`);
      setCenterName(res.data.name);
    }

    if (!centerInfo) {
      fetchCenterName(accountInfo.id);
    } else {
      setCenterName(centerInfo?.name);
    }
    return () => {
      setCenterName('');
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

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
          isValidDate={isValidDate}
        />

        <SupplyList
          statusId={statusId}
          supplyOrders={supplyOrders}
          handleOpenSupplyDialogForm={handleOpenSupplyDialogForm}
          isValidDate={isValidDate}
        />

        <ServiceList
          statusId={statusId}
          serviceOrders={serviceOrders}
          handleOpenServiceDialogForm={handleOpenServiceDialogForm}
          isValidDate={isValidDate}
        />

        <PaymentDetail
          statusId={statusId}
          total={total}
          discount={discount}
          subTotal={subTotal}
          totalCage={totalCage}
          totalService={totalService}
          totalSupply={totalSupply}
          voucherCode={voucherCode}
          voucherCodeNavigation={voucherCodeNavigation}
        />

        <BookingStatusCombobox statusId={statusId} bookingStatuses={bookingStatuses} />

        <FormAction
          centerName={centerName}
          handleOpenPDFDialog={handleOpenPDFDialog}
          isSubmitting={isSubmitting}
          onCancel={onCancel}
          petData={petData}
          selectedEvent={selectedEvent}
          serviceOrders={serviceOrders}
          statusId={statusId}
          supplyOrders={supplyOrders}
          values={values}
        />
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

      <PDFInvoiceDialog
        centerName={centerName}
        handleClosePDFDialog={handleClosePDFDialog}
        openPDFDialog={openPDFDialog}
        petData={petData}
        selectedEvent={selectedEvent}
        serviceOrders={serviceOrders}
        supplyOrders={supplyOrders}
      />
    </>
  );
}
