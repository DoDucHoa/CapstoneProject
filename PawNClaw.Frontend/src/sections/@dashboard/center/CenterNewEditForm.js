import PropTypes from 'prop-types';
import { useCallback, useEffect, useMemo, useState } from 'react';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
// form
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Card, Grid, Stack, Typography, Button } from '@mui/material';
// utils
import { fData } from '../../../utils/formatNumber';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
import useResponsive from '../../../hooks/useResponsive';
// components
import Label from '../../../components/Label';
import { FormProvider, RHFTextField, RHFUploadAvatar, RHFTimePicker } from '../../../components/hook-form';
import { createCenter, updateCenter } from '../../../pages/dashboard/Center/useCenterAPI';
import BrandDialog from './BrandDialog';
import Iconify from '../../../components/Iconify';

// ----------------------------------------------------------------------

CenterNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  centerData: PropTypes.object,
};

export default function CenterNewEditForm({ isEdit, centerData }) {
  // STATE
  const navigate = useNavigate();
  const [openDialog, setOpenDialog] = useState(false);
  const { accountInfo, register } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  useEffect(() => {
    if (isEdit && centerData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, centerData]);

  // ----------------------------------------------------------------------
  // FORM
  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    address: Yup.string().required('Bắt buộc nhập'),
    phone: Yup.string().required('Bắt buộc nhập'),
    openTime: Yup.string().nullable().required('Bắt buộc nhập'),
    closeTime: Yup.string().nullable().required('Bắt buộc nhập'),
    description: Yup.string(),
    createUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    brandId: Yup.number().required('Bắt buộc nhập'),
    avatarUrl: Yup.mixed().test('required', 'Ảnh thương hiệu bắt buộc nhập', (value) => value !== ''),
    checkin: Yup.string().nullable().required('Bắt buộc nhập'),
    checkout: Yup.string().nullable().required('Bắt buộc nhập'),
    brandInfo: Yup.mixed().nullable().required('Thương hiệu bắt buộc nhập*'),
  });

  const defaultValues = useMemo(
    () => ({
      name: centerData?.name || '',
      address: centerData?.address || '',
      phone: centerData?.phone || '',
      openTime: centerData?.openTime || '',
      closeTime: centerData?.closeTime || '',
      description: centerData?.description || '',
      createUser: centerData?.createdUser || 0,
      modifyUser: centerData?.modifyUser || 0,
      brandId: centerData?.ownerId || 0,
      avatarUrl: centerData?.avatarUrl || '',
      checkin: centerData?.checkin || '',
      checkout: centerData?.checkout || '',
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [centerData]
  );

  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    setValue,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = methods;

  const values = watch();

  // ----------------------------------------------------------------------
  // HANDLE SUBMIT
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await Promise.all([
          createCenter(values.email, accountInfo.id, values.phoneNumber, values.name, values.gender), // create account on Backend
          register(values.email, values.password), // create account on Firebase
        ]);
      } else {
        await updateCenter(accountInfo.id, values.name, values.phoneNumber, values.gender);
      }

      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.owner.list);
    } catch (error) {
      console.error(error);
    }
  };

  // FUNCTION
  // function to handle change avatar
  const handleDrop = useCallback(
    (acceptedFiles) => {
      const file = acceptedFiles[0];

      if (file) {
        setValue(
          'avatarUrl',
          Object.assign(file, {
            preview: URL.createObjectURL(file),
          })
        );
      }
    },
    [setValue]
  );

  const handleClose = () => {
    setOpenDialog(false);
  };

  const handleOpen = () => {
    setOpenDialog(true);
  };

  const { brandInfo } = values;

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card sx={{ py: 10, px: 3 }}>
            {isEdit && (
              <Label
                color={centerData.status !== 'true' ? 'error' : 'success'}
                sx={{ textTransform: 'uppercase', position: 'absolute', top: 24, right: 24 }}
              >
                {centerData.status !== 'true' ? 'Đã khóa' : 'Hoạt động'}
              </Label>
            )}

            <Box sx={{ mb: 5 }}>
              <RHFUploadAvatar
                name="avatarUrl"
                accept="image/*"
                maxSize={3145728}
                onDrop={handleDrop}
                helperText={
                  <Typography
                    variant="caption"
                    sx={{
                      mt: 2,
                      mx: 'auto',
                      display: 'block',
                      textAlign: 'center',
                      color: 'text.secondary',
                    }}
                  >
                    Định dạng *.jpeg, *.jpg, *.png, *.gif
                    <br /> Dung lượng tối đa: {fData(3145728)}
                  </Typography>
                }
              />
            </Box>
          </Card>
        </Grid>

        <Grid item xs={12} md={8}>
          <Card sx={{ p: 3 }}>
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <RHFTextField name="name" label="Tên trung tâm" disabled={isEdit} />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="address" label="Địa chỉ" disabled={isEdit} />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="phone" label="Số điện thoại" />
              </Grid>

              <Grid item xs={6}>
                <RHFTimePicker name="openTime" label="Giờ mở cửa" />
              </Grid>
              <Grid item xs={6}>
                <RHFTimePicker name="closeTime" label="Giờ đóng cửa" />
              </Grid>

              <Grid item xs={6}>
                <RHFTimePicker name="checkin" label="Giờ checkin" />
              </Grid>
              <Grid item xs={6}>
                <RHFTimePicker name="checkout" label="Giờ checkout" />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="description" multiline rows={3} label="Mô tả" />
              </Grid>

              <Grid item xs={12}>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <Typography>Thương hiệu</Typography>
                  <Button
                    onClick={handleOpen}
                    sx={{ width: 100, ml: 5 }}
                    variant="text"
                    startIcon={<Iconify icon={brandInfo ? 'eva:edit-fill' : 'eva:plus-fill'} color="primary" />}
                  >
                    {brandInfo ? 'Thay đổi' : 'Thêm'}
                  </Button>
                </Box>
                {brandInfo ? (
                  <OwnerInfo brandName={brandInfo.name} ownerName={brandInfo.owner.name} />
                ) : (
                  <Typography typography="caption" sx={{ color: 'error.main' }}>
                    {errors.brandInfo ? errors.brandInfo.message : null}
                  </Typography>
                )}
              </Grid>
            </Grid>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.center.list} color="error" variant="contained" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>

      <BrandDialog
        open={openDialog}
        onClose={handleClose}
        selected={(brandId) => brandInfo?.id === brandId}
        onSelect={(brandInfo) => setValue('brandInfo', brandInfo)}
      />
    </FormProvider>
  );
}

// ----------------------------------------------------------------------
OwnerInfo.propTypes = {
  brandName: PropTypes.string.isRequired,
  ownerName: PropTypes.string.isRequired,
};
function OwnerInfo({ brandName, ownerName }) {
  const isDesktop = useResponsive('up', 'sm');

  return (
    <Box sx={{ border: '1px dashed grey', p: 1, borderRadius: 1, maxWidth: isDesktop ? '60%' : '100%' }}>
      <Typography sx={{ color: 'primary.main', fontWeight: 'fontWeightMedium' }} variant="subtitle2">
        {brandName}
      </Typography>
      <Typography sx={{ my: 0.5 }} variant="caption">
        Chủ sở hữu: <b>{ownerName}</b>
      </Typography>
    </Box>
  );
}
