import PropTypes from 'prop-types';
import { useCallback, useEffect, useMemo } from 'react';
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
// components
import Label from '../../../components/Label';
import { FormProvider, RHFSelect, RHFTextField, RHFUploadAvatar } from '../../../components/hook-form';
import { createBrand, updateBrand } from '../../../pages/dashboard/Brand/useBrandAPI';

// ----------------------------------------------------------------------

BrandNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  brandData: PropTypes.object,
};

export default function BrandNewEditForm({ isEdit, brandData }) {
  const navigate = useNavigate();
  const { accountInfo, register } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    description: Yup.string(),
    createdUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    ownerId: Yup.number().required('Bắt buộc nhập'),
    avatarUrl: Yup.mixed().test('required', 'Ảnh thương hiệu bắt buộc nhập', (value) => value !== ''),
  });

  const defaultValues = useMemo(
    () => ({
      name: brandData?.name || '',
      description: brandData?.description || '',
      createdUser: brandData?.createdUser || 0,
      modifyUser: brandData?.modifyUser || 0,
      ownerId: brandData?.ownerId || 0,
      avatarUrl: brandData?.avatarUrl || '',
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [brandData]
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
    formState: { isSubmitting },
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

  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await Promise.all([
          createBrand(values.email, accountInfo.id, values.phoneNumber, values.name, values.gender), // create account on Backend
          register(values.email, values.password), // create account on Firebase
        ]);
      } else {
        await updateBrand(accountInfo.id, values.name, values.phoneNumber, values.gender);
      }

      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.owner.list);
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

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card sx={{ py: 10, px: 3 }}>
            {isEdit && (
              <Label
                color={brandData.status !== 'true' ? 'error' : 'success'}
                sx={{ textTransform: 'uppercase', position: 'absolute', top: 24, right: 24 }}
              >
                {brandData.status !== 'true' ? 'Đã khóa' : 'Hoạt động'}
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
            <Box
              sx={{
                display: 'grid',
                columnGap: 2,
                rowGap: 3,
                gridTemplateColumns: { xs: 'repeat(1, 1fr)', sm: 'repeat(1, 1fr)' },
              }}
            >
              <RHFTextField name="name" label="Tên thương hiệu" disabled={isEdit} />

              <RHFTextField name="description" multiline rows={3} label="Mô tả" />

              <RHFSelect name="ownerId" label="Giới tính">
                <option key="1" value="1">
                  Nam
                </option>
                <option key="2" value="2">
                  Nữ
                </option>
                <option key="3" value="3">
                  Khác
                </option>
              </RHFSelect>
            </Box>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.brand.list} color="error" variant="contained" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>
    </FormProvider>
  );
}
