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
import { createService, updateService } from '../../../../pages/dashboard/Service/useServiceAPI';
import { FormProvider } from '../../../../components/hook-form';
import ServiceDetail from './ServiceDetail';
import ServicePrice from './ServicePrice';
import ServicePhoto from './ServicePhoto';

// ----------------------------------------------------------------------

ServiceNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  serviceData: PropTypes.object,
};

export default function ServiceNewEditForm({ isEdit, serviceData }) {
  // STATE
  const navigate = useNavigate();
  const { accountInfo, centerId, uploadPhotoToFirebase } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    lastPrice: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
    service: Yup.object().shape({
      name: Yup.string().required('Bắt buộc nhập'),
      description: Yup.string(),
      avatarUrl: Yup.mixed().test('required', 'Ảnh dịch vụ bắt buộc nhập', (value) => value !== ''),
    }),
    servicePrice: Yup.array()
      .min(1, 'Vui lòng nhập giá dịch vụ')
      .of(
        Yup.object().shape({
          price: Yup.number().required('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0').typeError('Bắt buộc nhập'),
          minWeight: Yup.number().required('Bắt buộc nhập').typeError('Bắt buộc nhập'),
          maxWeight: Yup.number()
            .required('Bắt buộc nhập')
            .moreThan(0, 'Phải lớn hơn 0')
            .typeError('Bắt buộc nhập')
            .moreThan(Yup.ref('minWeight'), 'Phải lớn hơn trọng lượng tối thiểu'),
        })
      ),
  });

  const lastPriceInList = serviceData?.servicePrices?.at(-1);
  serviceData?.servicePrices?.pop();

  const defaultValues = useMemo(
    () => ({
      service: {
        id: isEdit ? serviceData.id : null,
        name: serviceData?.name || '',
        description: serviceData?.description || '',
        discountPrice: 0,
        createUser: serviceData?.createUser || accountInfo.id,
        modifyUser: accountInfo.id,
        createDate: serviceData?.createDate || new Date(),
        modifyDate: new Date(),
        centerId,
        avatarUrl: serviceData?.photos?.length > 0 ? serviceData?.photos[0].url : '',
      },
      servicePrice: serviceData?.servicePrices || [
        {
          price: '',
          minWeight: 0,
          maxWeight: 0,
          createUser: accountInfo.id,
          modifyUser: accountInfo.id,
        },
      ],
      lastPrice: lastPriceInList?.price || 0,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [serviceData]
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
    if (isEdit && serviceData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, serviceData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        const idService = await createService(values);
        await uploadPhotoToFirebase('services', values.service.avatarUrl, idService, 'service');
      } else {
        await updateService(values);
      }
      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.service.list);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} sm={8}>
          <Card sx={{ p: 3 }}>
            <ServiceDetail isEdit={isEdit} />

            <Box sx={{ my: 3 }} />

            <ServicePrice createUser={accountInfo.id} />

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.service.list} color="error" variant="contained" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>

        <Grid item xs={12} sm={4}>
          <ServicePhoto />
        </Grid>
      </Grid>
    </FormProvider>
  );
}
