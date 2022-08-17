import { useSnackbar } from 'notistack';
import PropTypes from 'prop-types';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';
import * as Yup from 'yup';
// form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, Card, Grid, Stack, Typography } from '@mui/material';
// utils
import { fData } from '../../../utils/formatNumber';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
import useResponsive from '../../../hooks/useResponsive';
// components
import { FormProvider, RHFSlider, RHFTextField, RHFUploadPhoto } from '../../../components/hook-form';
import Iconify from '../../../components/Iconify';
import { createSponsor, updateSponsor } from '../../../pages/dashboard/Sponsor/useSponsorAPI';
import BrandDialog from '../center/BrandDialog';

// ----------------------------------------------------------------------

SponsorNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  sponsorData: PropTypes.object,
};

export default function SponsorNewEditForm({ isEdit, sponsorData }) {
  // STATE
  const navigate = useNavigate();
  const [openDialog, setOpenDialog] = useState(false);
  const { accountInfo, uploadPhotoToFirebase } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    title: Yup.string().required('Bắt buộc nhập'),
    content: Yup.string(),
    duration: Yup.number().required('Bắt buộc nhập').typeError('Bắt buộc nhập').moreThan(0, 'Phải lớn hơn 0'),
    month: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .min(1, 'Tháng không hợp lệ')
      .max(12, 'Tháng không hợp lệ'),
    year: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .test('year', 'Năm không được nhỏ hơn năm hiện tại', (value) => value >= new Date().getFullYear()),
    avatarUrl: Yup.mixed().test('required', 'Ảnh quảng cáo bắt buộc nhập', (value) => value !== ''),
    brandInfo: Yup.mixed().nullable().required('Thương hiệu bắt buộc nhập'),
  });

  const defaultValues = useMemo(
    () => ({
      id: sponsorData?.id || null,
      title: sponsorData?.title || '',
      content: sponsorData?.content || '',
      duration: sponsorData?.duration || 0,
      year: new Date(sponsorData?.startDate)?.getFullYear() || '',
      month: new Date(sponsorData?.startDate)?.getMonth() + 1 || '',
      avatarUrl: sponsorData?.photos?.length > 0 ? sponsorData?.photos[0]?.url : '',

      brandId: sponsorData?.brand?.id || '',
      createUser: sponsorData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      createDate: sponsorData?.createDate || new Date(),
      modifyDate: new Date(),
      brandInfo: sponsorData?.brand || null,
      status: sponsorData?.status || true,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [sponsorData]
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
    if (isEdit && sponsorData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, sponsorData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await createSponsor(values)
          .then((response) => uploadPhotoToFirebase('sponsorBanners', values.avatarUrl, response, 'banner'))
          .then(() => {
            reset();
            enqueueSnackbar('Tạo mới thành công');
            navigate(PATH_DASHBOARD.sponsor.list);
          })
          .catch(() => enqueueSnackbar('Số lượng quảng cáo đạt quá giới hạn trong tháng', { variant: 'error' }));
      } else {
        await updateSponsor(values);
        reset();
        enqueueSnackbar('Cập nhật thành công');
        navigate(PATH_DASHBOARD.sponsor.list);
      }
    } catch (error) {
      console.error(error);
      reset();
      enqueueSnackbar('Có lỗi xảy ra, vui lòng thử lại sau!', { variant: 'error' });
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

  const { brandInfo } = values;

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Card sx={{ p: 3 }}>
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <RHFTextField name="title" label="Tiêu đề" disabled={isEdit} />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="content" multiline rows={6} label="Nội dung" />
              </Grid>

              {/* <Grid item xs={12}>
                <RHFTextField name="duration" label="Thời gian quảng cáo (giây)" tpye="number" />
              </Grid> */}

              <Grid item xs={6}>
                <RHFTextField name="month" label="Tháng" tpye="number" disabled={isEdit} />
              </Grid>

              <Grid item xs={6}>
                <RHFTextField name="year" label="Năm" tpye="number" disabled={isEdit} />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFSlider
                  name="duration"
                  label="Thời gian quảng cáo (giây)"
                  size="medium"
                  min={0}
                  max={20}
                  aria-label="Default"
                  valueLabelDisplay="auto"
                />
              </Grid>

              <Grid item xs={12}>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                  <Typography>Thương hiệu</Typography>
                  {!isEdit && (
                    <Button
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
                  <BrandInfo brandName={brandInfo.name} ownerName={'Viet Hong'} />
                ) : (
                  <Typography typography="caption" sx={{ color: 'error.main' }}>
                    {errors.brandInfo ? errors.brandInfo.message : null}
                  </Typography>
                )}
              </Grid>
            </Grid>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.sponsor.list} color="error" variant="text" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>

        <Grid item xs={12} md={4}>
          <Card sx={{ py: 5, px: 3 }}>
            <Box sx={{ mb: 2 }}>
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
BrandInfo.propTypes = {
  brandName: PropTypes.string.isRequired,
  ownerName: PropTypes.string.isRequired,
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
