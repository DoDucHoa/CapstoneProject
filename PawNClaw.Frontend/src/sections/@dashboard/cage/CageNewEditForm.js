import PropTypes from 'prop-types';
import { useEffect, useMemo, useState } from 'react';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
// form
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Card, Grid, Stack, Typography, Button } from '@mui/material';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
import useResponsive from '../../../hooks/useResponsive';
// components
import { FormProvider, RHFSwitch, RHFTextField } from '../../../components/hook-form';
import { createCage, updateCage } from '../../../pages/dashboard/Cage/useCageAPI';
import Iconify from '../../../components/Iconify';
import CageTypeDialog from './CageTypeDialog';

// ----------------------------------------------------------------------

CageNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  cageData: PropTypes.object,
};

export default function CageNewEditForm({ isEdit, cageData }) {
  // STATE
  const navigate = useNavigate();
  const [openDialog, setOpenDialog] = useState(false);
  const { accountInfo, centerId } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const NewUserSchema = Yup.object().shape({
    code: Yup.string().required('Bắt buộc nhập'),
    centerId: Yup.number().required('Bắt buộc nhập'),
    name: Yup.string().required('Bắt buộc nhập'),
    color: Yup.string(),
    isOnline: Yup.boolean(),
    createUser: Yup.number().required(),
    modifyUser: Yup.number().required(),
    cageTypeId: Yup.number().required('Bắt buộc nhập'),
    cageTypeInfo: Yup.mixed().nullable().required('Loại chuồng bắt buộc nhập'),
  });

  const defaultValues = useMemo(
    () => ({
      code: cageData?.code || '',
      centerId: cageData?.centerId || centerId,
      name: '',
      color: cageData?.color || '',
      isOnline: cageData?.isOnline || true,
      createUser: cageData?.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      status: cageData?.status || 1,
      cageTypeId: cageData?.cageTypeId || 0,
      cageTypeInfo: cageData?.cageType || null,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [cageData]
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
    if (isEdit && cageData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, cageData]);

  // ----------------------------------------------------------------------
  // FUNCTIONS
  const onSubmit = async () => {
    console.log(values);
    try {
      if (!isEdit) {
        await createCage(values);
      } else {
        await updateCage(values);
      }
      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công' : 'Cập nhật thành công');
      navigate(PATH_DASHBOARD.cage.list);
    } catch (error) {
      console.error(error);
    }
  };

  const handleClose = () => {
    setOpenDialog(false);
  };

  const handleOpen = () => {
    setOpenDialog(true);
  };

  const { cageTypeInfo } = values;

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={10}>
          <Card sx={{ p: 3 }}>
            <Box
              sx={{
                display: 'grid',
                columnGap: 2,
                rowGap: 3,
                gridTemplateColumns: { xs: 'repeat(1, 1fr)', sm: 'repeat(1, 1fr)' },
              }}
            >
              <RHFTextField name="code" label="Mã chuồng" disabled={isEdit} />

              <RHFTextField name="name" label="Tên chuồng" />

              <RHFTextField name="color" label="Màu sắc" />

              <RHFSwitch name="isOnline" label="Trạng thái" />

              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Typography>Loại chuồng</Typography>
                <Button
                  onClick={handleOpen}
                  sx={{ width: 100, ml: 5 }}
                  variant="text"
                  startIcon={<Iconify icon={cageTypeInfo ? 'eva:edit-fill' : 'eva:plus-fill'} color="primary" />}
                >
                  {cageTypeInfo ? 'Thay đổi' : 'Thêm'}
                </Button>
              </Box>
              {cageTypeInfo ? (
                <CageTypeInfo
                  name={cageTypeInfo.typeName}
                  isSingle={cageTypeInfo.isSingle}
                  length={cageTypeInfo.length}
                  height={cageTypeInfo.height}
                  width={cageTypeInfo.width}
                />
              ) : (
                <Typography typography="caption" sx={{ color: 'error.main' }}>
                  {errors.cageTypeInfo ? errors.cageTypeInfo.message : null}
                </Typography>
              )}
            </Box>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.cage.list} color="error" variant="contained" component={RouterLink}>
                Hủy
              </Button>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!isEdit ? 'Tạo' : 'Cập nhật'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>

      <CageTypeDialog
        centerId={centerId}
        open={openDialog}
        onClose={handleClose}
        selected={(cageTypeId) => cageTypeInfo?.id === cageTypeId}
        onSelect={(cageTypeInfo) => setValue('cageTypeInfo', cageTypeInfo)}
      />
    </FormProvider>
  );
}

// ----------------------------------------------------------------------

CageTypeInfo.propTypes = {
  name: PropTypes.string.isRequired,
  height: PropTypes.number.isRequired,
  width: PropTypes.number.isRequired,
  length: PropTypes.number.isRequired,
  isSingle: PropTypes.bool.isRequired,
};
function CageTypeInfo({ name, height, width, length, isSingle }) {
  const isDesktop = useResponsive('up', 'sm');

  return (
    <Box sx={{ border: '1px dashed grey', p: 1, borderRadius: 1, maxWidth: isDesktop ? '60%' : '100%' }}>
      <Typography variant="subtitle2">{name}</Typography>

      <Typography sx={{ my: 0.5, color: 'secondary.main', fontWeight: 'fontWeightMedium' }} variant="body2">
        {isSingle ? 'Chuồng nhốt riêng' : 'Chuồng nhốt chung'}
      </Typography>

      <Typography sx={{ my: 0.5, color: 'primary.main', fontWeight: 'fontWeightMedium' }} variant="caption">
        Cao: {height} cm | Dài: {length} cm | Rộng: {width} cm
      </Typography>
    </Box>
  );
}
