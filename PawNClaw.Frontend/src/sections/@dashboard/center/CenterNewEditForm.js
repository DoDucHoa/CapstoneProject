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
import { Box, Card, Grid, Stack, Typography, Button, MenuItem } from '@mui/material';
// utils
import { fData } from '../../../utils/formatNumber';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
import useResponsive from '../../../hooks/useResponsive';
// components
import { FormProvider, RHFSelect, RHFTextField, RHFTimePicker, RHFUploadPhoto } from '../../../components/hook-form';
import {
  createCenter,
  getCities,
  getDistricts,
  getWards,
  updateCenter,
  updateCenterForOwner,
} from '../../../pages/dashboard/Center/useCenterAPI';
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
  const [cities, setCities] = useState([]);
  const [districts, setDistricts] = useState([]);
  const [wards, setWards] = useState([]);

  // * ----------------------------------------------------------------------
  // HOOKS
  const { accountInfo, uploadPhotoToFirebase, centerId } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  // * ----------------------------------------------------------------------
  // FORM
  // TODO: validate lại thời gian chưa xài reset() do xài onChange
  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    address: Yup.string().required('Bắt buộc nhập'),
    phone: Yup.string().required('Bắt buộc nhập'),
    openTimeUI: Yup.string().nullable().required('Bắt buộc nhập'),
    closeTimeUI: Yup.string().nullable().required('Bắt buộc nhập'),
    description: Yup.string(),
    avatarUrl: Yup.mixed().test('required', 'Ảnh trung tâm bắt buộc nhập', (value) => value !== ''),
    checkinUI: Yup.string().nullable().required('Bắt buộc nhập'),
    checkoutUI: Yup.string().nullable().required('Bắt buộc nhập'),
    brandInfo: Yup.mixed().nullable().required('Thương hiệu bắt buộc nhập'),
    cityCode: Yup.string().required('Bắt buộc nhập'),
    districtCode: Yup.string().required('Bắt buộc nhập'),
    wardCode: Yup.string(),
  });

  const defaultValues = useMemo(
    () => ({
      id: centerData?.id || null,
      name: centerData?.name || '',
      address: centerData?.address || '',
      phone: centerData?.phone || '',
      description: centerData?.description || '',
      createUser: centerData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      brandId: centerData?.brandId || 0,
      avatarUrl: centerData?.photos?.length > 0 ? centerData?.photos[0].url : '',
      cityCode: centerData?.location?.cityCode || '',
      districtCode: centerData?.location?.districtCode || '',
      wardCode: centerData?.location?.wardCode || '',
      brandInfo: centerData?.brand || null,

      openTimeUI: new Date(centerData?.openTimeDate) || '',
      closeTimeUI: new Date(centerData?.closeTimeDate) || '',
      checkinUI: new Date(centerData?.checkinDate) || '',
      checkoutUI: new Date(centerData?.checkoutDate) || '',
      fullAddress: '',
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
    setError,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = methods;

  const values = watch();

  // * ----------------------------------------------------------------------
  // STARTUP
  useEffect(() => {
    if (isEdit && centerData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, centerData]);

  useEffect(() => {
    getCities().then((data) => setCities(data));
  }, []);

  useEffect(() => {
    setValue('wardCode', centerData?.location?.wardCode || '');
    setValue('districtCode', centerData?.location?.districtCode || '');
    getDistricts(values.cityCode).then((data) => setDistricts(data));
  }, [centerData?.location?.districtCode, centerData?.location?.wardCode, setValue, values.cityCode]);

  useEffect(() => {
    getWards(values.districtCode).then((data) => setWards(data));
  }, [values.cityCode, values.districtCode]);

  // * ----------------------------------------------------------------------
  // HANDLE SUBMIT
  const onSubmit = async () => {
    if (values.closeTimeUI < values.openTimeUI) {
      setError('closeTimeUI', {
        type: 'checkCloseTime',
        message: 'Thời gian đóng cửa phải lớn hơn thời gian mở cửa',
      });
      return;
    }

    if (values.checkoutUI < values.checkinUI) {
      setError('checkoutUI', {
        type: 'checkCheckoutTime',
        message: 'Thời gian checkout phải lớn hơn thời gian checkin',
      });
      return;
    }

    try {
      if (!isEdit) {
        const centerId = await createCenter(values);
        await uploadPhotoToFirebase('petCenters', values.avatarUrl, centerId, 'petcenter');
      } else if (centerId) {
        await updateCenterForOwner(values);
      } else {
        await updateCenter(values);
      }

      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      if (!centerId) {
        reset();
        navigate(PATH_DASHBOARD.center.list);
      }
    } catch (error) {
      console.error(error);
    }
  };

  // * ----------------------------------------------------------------------
  // HANDLE FUNCTION
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

  useEffect(() => {
    function getCityName(code) {
      const city = cities.find((city) => city.code === code);
      return city ? city.name : '';
    }

    function getDistrictName(code) {
      const district = districts.find((district) => district.code === code);
      return district ? district.name : '';
    }

    function getWardName(code) {
      const ward = wards.find((ward) => ward.code === code);
      return ward ? ward.name : '';
    }
    setValue(
      'fullAddress',
      `${values.address}, ${getWardName(values.wardCode)}, ${getDistrictName(values.districtCode)}, ${getCityName(
        values.cityCode
      )}`
    );
  }, [cities, districts, wards, setValue, values.address, values.cityCode, values.districtCode, values.wardCode]);

  const { brandInfo } = values;

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={3}>
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

        <Grid item xs={12} md={9}>
          <Card sx={{ p: 3 }}>
            <Grid container spacing={3}>
              <Grid item xs={12} sm={6}>
                <RHFTextField name="name" label="Tên trung tâm" disabled={!!centerId} />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFTextField name="phone" label="Số điện thoại" />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFSelect
                  name="cityCode"
                  label="Thành phố/Tỉnh"
                  InputLabelProps={{ shrink: true }}
                  SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
                  sx={{ maxHeight: 50 }}
                  disabled={!!centerId}
                >
                  {cities?.length > 0 ? (
                    cities?.map((city) => (
                      <MenuItem
                        key={city.code}
                        value={city.code}
                        sx={{
                          mx: 1,
                          my: 0.5,
                          borderRadius: 0.75,
                          typography: 'body2',
                          textTransform: 'capitalize',
                        }}
                      >
                        {city.name}
                      </MenuItem>
                    ))
                  ) : (
                    <MenuItem
                      value={''}
                      sx={{
                        mx: 1,
                        my: 0.5,
                        borderRadius: 0.75,
                        typography: 'body2',
                        textTransform: 'capitalize',
                      }}
                    >
                      <em>Đang tải dữ liệu</em>
                    </MenuItem>
                  )}
                </RHFSelect>
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFSelect
                  name="districtCode"
                  label="Quận/Huyện"
                  InputLabelProps={{ shrink: true }}
                  SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
                  sx={{ maxHeight: 50 }}
                  disabled={!!centerId}
                >
                  {districts?.length > 0 ? (
                    districts?.map((district) => (
                      <MenuItem
                        key={district.code}
                        value={district.code}
                        sx={{
                          mx: 1,
                          my: 0.5,
                          borderRadius: 0.75,
                          typography: 'body2',
                          textTransform: 'capitalize',
                        }}
                      >
                        {district.name}
                      </MenuItem>
                    ))
                  ) : (
                    <MenuItem
                      value={''}
                      sx={{
                        mx: 1,
                        my: 0.5,
                        borderRadius: 0.75,
                        typography: 'body2',
                        textTransform: 'capitalize',
                      }}
                    >
                      <em>Không có dữ liệu</em>
                    </MenuItem>
                  )}
                </RHFSelect>
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFSelect
                  name="wardCode"
                  label="Phường/Xã"
                  InputLabelProps={{ shrink: true }}
                  SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
                  sx={{ maxHeight: 50 }}
                  disabled={!!centerId}
                >
                  {wards?.length > 0 ? (
                    wards?.map((ward) => (
                      <MenuItem
                        key={ward.code}
                        value={ward.code}
                        sx={{
                          mx: 1,
                          my: 0.5,
                          borderRadius: 0.75,
                          typography: 'body2',
                          textTransform: 'capitalize',
                        }}
                      >
                        {ward.name}
                      </MenuItem>
                    ))
                  ) : (
                    <MenuItem
                      value={''}
                      sx={{
                        mx: 1,
                        my: 0.5,
                        borderRadius: 0.75,
                        typography: 'body2',
                        textTransform: 'capitalize',
                      }}
                    >
                      <em>Không có dữ liệu</em>
                    </MenuItem>
                  )}
                </RHFSelect>
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFTextField name="address" label="Địa chỉ" disabled={!!centerId} />
              </Grid>

              <Grid item xs={6}>
                <RHFTimePicker name="openTimeUI" label="Giờ mở cửa" />
              </Grid>
              <Grid item xs={6}>
                <RHFTimePicker name="closeTimeUI" label="Giờ đóng cửa" />
              </Grid>

              <Grid item xs={6}>
                <RHFTimePicker name="checkinUI" label="Giờ checkin" />
              </Grid>
              <Grid item xs={6}>
                <RHFTimePicker name="checkoutUI" label="Giờ checkout" />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="description" multiline rows={6} label="Mô tả" />
              </Grid>

              <Grid item xs={12}>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                  <Typography>Thương hiệu</Typography>
                  {!centerId && (
                    <Button
                      disabled={isEdit}
                      onClick={handleOpen}
                      sx={{ width: 100, ml: 5 }}
                      variant="text"
                      startIcon={<Iconify icon={brandInfo ? 'eva:edit-fill' : 'eva:plus-fill'} color="primary" />}
                    >
                      {brandInfo ? 'Thay đổi' : 'Thêm'}
                    </Button>
                  )}
                </Box>
                {brandInfo ? (
                  <BrandInfo brandName={brandInfo?.name} ownerName={brandInfo?.owner?.name} />
                ) : (
                  <Typography typography="caption" sx={{ color: 'error.main' }}>
                    {errors.brandInfo ? errors.brandInfo.message : null}
                  </Typography>
                )}
              </Grid>
            </Grid>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              {!centerId && (
                <Button to={PATH_DASHBOARD.center.list} color="error" variant="text" component={RouterLink}>
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
        <BrandDialog
          open={openDialog}
          onClose={handleClose}
          selected={(brandId) => brandInfo?.id === brandId}
          onSelect={(brandInfo) => setValue('brandInfo', brandInfo)}
        />
      )}
    </FormProvider>
  );
}

// ----------------------------------------------------------------------
BrandInfo.propTypes = {
  brandName: PropTypes.string,
  ownerName: PropTypes.string,
};
function BrandInfo({ brandName, ownerName }) {
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
