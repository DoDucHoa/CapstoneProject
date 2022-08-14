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
import { FormProvider, RHFTextField, RHFUploadPhoto } from '../../../components/hook-form';
import { createBrand, updateBrand } from '../../../pages/dashboard/Brand/useBrandAPI';
import Iconify from '../../../components/Iconify';
import OwnerDialog from './OwnerDialog';

// ----------------------------------------------------------------------

BrandNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  brandData: PropTypes.object,
};

export default function BrandNewEditForm({ isEdit, brandData }) {
  // STATE
  const navigate = useNavigate();
  const [openDialog, setOpenDialog] = useState(false);
  const { accountInfo, uploadPhotoToFirebase, centerId, centerInfo } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    description: Yup.string(),
    createUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    ownerId: Yup.number().required('Bắt buộc nhập'),
    avatarUrl: Yup.mixed().test('required', 'Ảnh thương hiệu bắt buộc nhập', (value) => value !== ''),
    ownerInfo: Yup.mixed().nullable().required('Chủ trung tâm bắt buộc nhập'),
  });

  const defaultValues = useMemo(
    () => ({
      name: brandData?.name || '',
      description: brandData?.description || '',
      createUser: brandData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      ownerId: brandData?.ownerId || 0,
      avatarUrl: brandData?.photos?.length > 0 ? brandData?.photos[0].url : '',
      ownerInfo: brandData?.owner || null,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [brandData]
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
    setValue,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = methods;

  const values = watch();

  useEffect(() => {
    if (isEdit && brandData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, brandData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        const brandId = await createBrand(
          values.name,
          values.description,
          values.ownerInfo.id,
          accountInfo.id,
          accountInfo.id
        );
        await uploadPhotoToFirebase('brands', values.avatarUrl, brandId, 'brand');
      } else if (centerId) {
        await updateBrand(centerInfo.id, values.name, values.description, accountInfo.id);
      } else {
        await updateBrand(brandData.id, values.name, values.description, values.ownerId);
      }
      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      if (!centerId) navigate(PATH_DASHBOARD.brand.list);
    } catch (error) {
      console.error(error);
    }
  };

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

  const { ownerInfo } = values;

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card sx={{ py: 6, px: 3 }}>
            <Box sx={{ mb: 3 }}>
              <RHFUploadPhoto
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
            <Box
              sx={{
                display: 'grid',
                columnGap: 2,
                rowGap: 3,
                gridTemplateColumns: { xs: 'repeat(1, 1fr)', sm: 'repeat(1, 1fr)' },
              }}
            >
              <RHFTextField name="name" label="Tên thương hiệu" disabled={isEdit} />

              <RHFTextField name="description" multiline rows={6} label="Mô tả" />

              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Typography>Chủ trung tâm</Typography>
                {!centerId && (
                  <Button
                    disabled={isEdit}
                    onClick={handleOpen}
                    sx={{ width: 100, ml: 5 }}
                    variant="text"
                    startIcon={<Iconify icon={ownerInfo ? 'eva:edit-fill' : 'eva:plus-fill'} color="primary" />}
                  >
                    {ownerInfo ? 'Thay đổi' : 'Thêm'}
                  </Button>
                )}
              </Box>
              {ownerInfo ? (
                <OwnerInfo name={ownerInfo.name} email={ownerInfo.email} phone={ownerInfo.idNavigation.phone} />
              ) : (
                <Typography typography="caption" sx={{ color: 'error.main' }}>
                  {errors.ownerInfo ? errors.ownerInfo.message : null}
                </Typography>
              )}
            </Box>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              {!centerId && (
                <Button to={PATH_DASHBOARD.brand.list} color="error" variant="text" component={RouterLink}>
                  Hủy
                </Button>
              )}
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>

      {!centerId && (
        <OwnerDialog
          open={openDialog}
          onClose={handleClose}
          selected={(ownerId) => ownerInfo?.id === ownerId}
          onSelect={(ownerInfo) => setValue('ownerInfo', ownerInfo)}
        />
      )}
    </FormProvider>
  );
}

// ----------------------------------------------------------------------
OwnerInfo.propTypes = {
  name: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  phone: PropTypes.string,
};
function OwnerInfo({ name, email, phone }) {
  const isDesktop = useResponsive('up', 'sm');

  return (
    <Box sx={{ border: '1px dashed grey', p: 1, borderRadius: 1, maxWidth: isDesktop ? '60%' : '100%' }}>
      <Typography variant="subtitle2">{name}</Typography>
      <Typography sx={{ my: 0.5, color: 'primary.main', fontWeight: 'fontWeightMedium' }} variant="caption">
        {email}
      </Typography>
      <Typography variant="body2">Phone: {phone}</Typography>
    </Box>
  );
}
