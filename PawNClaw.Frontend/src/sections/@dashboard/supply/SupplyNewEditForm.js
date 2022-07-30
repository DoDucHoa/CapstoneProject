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
import { FormProvider, RHFTextField, RHFUploadAvatar } from '../../../components/hook-form';
import { createSupply, updateSupply } from '../../../pages/dashboard/Supply/useSupplyAPI';

// ----------------------------------------------------------------------

SupplyNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  supplyData: PropTypes.object,
};

export default function SupplyNewEditForm({ isEdit, supplyData }) {
  // STATE
  const navigate = useNavigate();
  const { accountInfo } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    sellPrice: Yup.number().required('Bắt buộc nhập'),
    quantity: Yup.number().required('Bắt buộc nhập'),
    createUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    avatarUrl: Yup.mixed().test('required', 'Ảnh thương hiệu bắt buộc nhập', (value) => value !== ''),
    supplyTypeCode: Yup.string().required('Bắt buộc nhập'),
  });

  const defaultValues = useMemo(
    () => ({
      name: supplyData?.name || '',
      sellPrice: supplyData?.sellPrice || 0,
      quantity: supplyData?.quantity || 0,
      createUser: supplyData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      avatarUrl: supplyData?.avatarUrl || '',
      supplyTypeCode: supplyData?.supplyTypeCode || '',
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [supplyData]
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
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  useEffect(() => {
    if (isEdit && supplyData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, supplyData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await createSupply(values.name, values.description, values.ownerInfo.id, accountInfo.id, accountInfo.id);
      } else {
        await updateSupply(supplyData.id, values.name, values.description, values.ownerId);
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
                color={supplyData.status !== 'true' ? 'error' : 'success'}
                sx={{ textTransform: 'uppercase', position: 'absolute', top: 24, right: 24 }}
              >
                {supplyData.status !== 'true' ? 'Đã khóa' : 'Hoạt động'}
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
              <RHFTextField name="name" label="Tên đồ dùng" />

              <RHFTextField label="Giá bán" name="sellPrice" type="number" />

              <RHFTextField label="Số lượng" name="quantity" type="number" />
            </Box>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.supply.list} color="error" variant="contained" component={RouterLink}>
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
