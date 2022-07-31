import PropTypes from 'prop-types';
import { useEffect, useMemo } from 'react';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
// form
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, Card, Grid, Stack } from '@mui/material';
// routes
import { PATH_DASHBOARD } from '../../../../routes/paths';
// hooks
import useAuth from '../../../../hooks/useAuth';
// components
import { FormProvider } from '../../../../components/hook-form';
import { createCageType, updateCageType } from '../../../../pages/dashboard/CageType/useCageTypeAPI';
import CageTypeDetail from './CageTypeDetail';
import CageTypePrice from './CageTypePrice';
import CageTypeFoodSchedule from './CageTypeFoodSchedule';
import CageTypePhoto from './CageTypePhoto';

// ----------------------------------------------------------------------

CageTypeNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  cageTypeData: PropTypes.object,
};

export default function CageTypeNewEditForm({ isEdit, cageTypeData }) {
  // STATE
  const navigate = useNavigate();
  const { accountInfo, centerId, uploadPhotoToFirebase } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    createCageTypeParameter: Yup.object().shape({
      typeName: Yup.string().required('Bắt buộc nhập'),
      description: Yup.string(),
      height: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
      width: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
      length: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
      isSingle: Yup.boolean(),
      createUser: Yup.number().required(),
      modifyUser: Yup.number().required(),
      centerId: Yup.number().required('Bắt buộc nhập'),
      avatarUrl: Yup.mixed().test('required', 'Ảnh loại chuồng bắt buộc nhập', (value) => value !== ''),
    }),
    createPriceParameters: Yup.array().of(
      Yup.object().shape({
        unitPrice: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
        createUser: Yup.number().required(),
        priceTypeCode: Yup.string().required('Bắt buộc nhập'),
      })
    ),
    foodSchedules: Yup.array().of(
      Yup.object().shape({
        fromTime: Yup.string().required('Bắt buộc nhập'),
        toTime: Yup.string().required('Bắt buộc nhập'),
        name: Yup.string().required('Bắt buộc nhập'),
        cageTypeId: Yup.number().required('Bắt buộc nhập'),
      })
    ),
  });

  const defaultValues = useMemo(
    () => ({
      createCageTypeParameter: {
        id: isEdit ? cageTypeData.id : null,
        typeName: cageTypeData?.typeName || '',
        description: cageTypeData?.description || '',
        height: cageTypeData?.height || '',
        width: cageTypeData?.width || '',
        length: cageTypeData?.length || '',
        isSingle: cageTypeData?.isSingle || false,
        createUser: cageTypeData?.createUser || accountInfo.id,
        modifyUser: accountInfo.id,
        modifyDate: new Date(),
        centerId,
        avatarUrl: cageTypeData?.photos?.length > 0 ? cageTypeData?.photos[0].url : '',
      },
      createPriceParameters: cageTypeData?.prices || [
        {
          unitPrice: '',
          createUser: accountInfo.id,
          priceTypeCode: 'PRICE-001',
        },
      ],
      foodSchedules: cageTypeData?.foodSchedules?.map((foodSchedules) => ({
        ...foodSchedules,
        fromTime: new Date(foodSchedules.fromTimeDate),
        fromTimeUI: new Date(foodSchedules.fromTimeDate),
        toTime: new Date(foodSchedules.toTimeDate),
        toTimeUI: new Date(foodSchedules.toTimeDate),
      })) || [
        {
          fromTime: '',
          toTime: '',
          name: '',
          cageTypeId: 0,
          fromTimeUI: '',
          toTimeUI: '',
        },
      ],
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [cageTypeData]
  );

  // ----------------------------------------------------------------------
  // FORM
  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  useEffect(() => {
    if (isEdit && cageTypeData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, cageTypeData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        const idCageType = await createCageType(values);
        await uploadPhotoToFirebase('cageTypes', values.createCageTypeParameter.avatarUrl, idCageType, 5);
      } else {
        await updateCageType(values);
      }
      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.cageType.list);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} sm={8}>
          <Card sx={{ p: 3 }}>
            <CageTypeDetail isEdit={isEdit} />

            <Box sx={{ my: 3 }} />

            <CageTypePrice createUser={accountInfo.id} />

            <Box sx={{ my: 3 }} />

            <CageTypeFoodSchedule />

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.cageType.list} color="error" variant="contained" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>

        <Grid item xs={12} sm={4}>
          <CageTypePhoto />
        </Grid>
      </Grid>
    </FormProvider>
  );
}
