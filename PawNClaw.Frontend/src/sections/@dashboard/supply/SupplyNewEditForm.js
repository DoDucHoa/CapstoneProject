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
import { Box, Card, Grid, Stack, Typography, Button, MenuItem } from '@mui/material';
// utils
import { fData } from '../../../utils/formatNumber';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
// components
import { FormProvider, RHFSelect, RHFTextField, RHFUploadPhoto } from '../../../components/hook-form';
import { createSupply, updateSupply } from '../../../pages/dashboard/Supply/useSupplyAPI';

// ----------------------------------------------------------------------

SupplyNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  supplyData: PropTypes.object,
};

const SUPPLY_TYPES = [
  { key: 1, value: 'FOOD', label: 'Đồ ăn' },
  { key: 2, value: 'DRINK', label: 'Thức uống' },
  { key: 3, value: 'MED', label: 'Thuốc men' },
  { key: 4, value: 'OTHER', label: 'Khác' },
];

export default function SupplyNewEditForm({ isEdit, supplyData }) {
  // STATE
  const navigate = useNavigate();
  const { accountInfo, uploadPhotoToFirebase, centerId } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    sellPrice: Yup.number().required('Bắt buộc nhập').typeError('Bắt buộc nhập').min(0, 'Số tiền phải lớn hơn 0'),
    quantity: Yup.number().required('Bắt buộc nhập').typeError('Bắt buộc nhập').min(0, 'Số lượng phải lớn hơn 0'),
    createUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    avatarUrl: Yup.mixed().test('required', 'Ảnh đồ dùng bắt buộc nhập', (value) => value !== ''),
    supplyTypeCode: Yup.string().required('Bắt buộc nhập'),
  });

  const defaultValues = useMemo(
    () => ({
      id: supplyData?.id || 0,
      name: supplyData?.name || '',
      sellPrice: supplyData?.sellPrice || 0,
      discountPrice: 0,
      quantity: supplyData?.quantity || 0,
      createUser: supplyData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      avatarUrl: supplyData?.photos?.length > 0 ? supplyData?.photos[0].url : '',
      supplyTypeCode: supplyData?.supplyTypeCode || 'FOOD',
      createDate: supplyData?.createDate || new Date(),
      modifyDate: new Date(),
      centerId: supplyData?.centerId || centerId,
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
        const supplyId = await createSupply(values);
        uploadPhotoToFirebase('supplies', values.avatarUrl, supplyId, 'supply');
      } else {
        await updateSupply(values, accountInfo.id);
      }
      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.supply.list);
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
        <Grid item xs={12} md={7}>
          <Card sx={{ p: 3 }}>
            <Box
              sx={{
                display: 'grid',
                columnGap: 2,
                rowGap: 3,
                gridTemplateColumns: { xs: 'repeat(1, 1fr)', sm: 'repeat(1, 1fr)' },
              }}
            >
              <RHFTextField name="name" label="Tên đồ dùng" disabled={isEdit} />

              <RHFTextField label="Giá bán" name="sellPrice" type="number" />

              <RHFTextField label="Số lượng" name="quantity" type="number" />

              <RHFSelect
                name="supplyTypeCode"
                label="Loại đồ dùng"
                disabled={isEdit}
                InputLabelProps={{ shrink: true }}
                SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
              >
                {SUPPLY_TYPES.map((item) => (
                  <MenuItem
                    key={item.key}
                    value={item.value}
                    sx={{
                      mx: 1,
                      my: 0.5,
                      borderRadius: 0.75,
                      typography: 'body2',
                      textTransform: 'capitalize',
                    }}
                  >
                    {item.label}
                  </MenuItem>
                ))}
              </RHFSelect>
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

        <Grid item xs={12} md={4}>
          <Card sx={{ py: 7, px: 3 }}>
            <Box>
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
      </Grid>
    </FormProvider>
  );
}
