import { useState, useCallback, useEffect, useMemo } from 'react';
import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
// form
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Card, Grid, Stack, Typography, Button, InputAdornment, IconButton } from '@mui/material';
// utils
import { fData } from '../../../utils/formatNumber';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
// components
import { FormProvider, RHFTextField, RHFUploadAvatar } from '../../../components/hook-form';
import { createStaff, updateStaff } from '../../../pages/dashboard/Staff/useStaffAPI';
import Iconify from '../../../components/Iconify';

// ----------------------------------------------------------------------

const specialString = 'Awz@******ÿ123';

StaffNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  staffData: PropTypes.object,
};

export default function StaffNewEditForm({ isEdit, staffData }) {
  const navigate = useNavigate();
  const { accountInfo, register, uploadPhotoToFirebase, centerId } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    userName: Yup.string().required('Bắt buộc nhập').email(),
    password: Yup.string()
      .required('Bắt buộc nhập')
      .matches(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&ÿ])[A-Za-z\d@$!%*?&ÿ]{6,}$/,
        'Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt'
      ),
    confirmPassword: Yup.string()
      .required('Bắt buộc nhập')
      .oneOf([Yup.ref('password'), null], 'Mật khẩu không khớp'),
    phone: Yup.string(),
    createUser: Yup.number().required(),
    avatarUrl: Yup.mixed(),
  });

  const defaultValues = useMemo(
    () => ({
      name: staffData?.name || '',
      userName: staffData?.idNavigation?.userName || '',
      phone: staffData?.idNavigation?.phone || '',
      createUser: staffData?.createUser || accountInfo.id,
      centerId: staffData?.centerId || centerId,
      avatarUrl: staffData?.avatarUrl || '',
      password: isEdit ? specialString : '',
      confirmPassword: isEdit ? specialString : '',
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [staffData]
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
    if (isEdit && staffData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, staffData]);

  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await Promise.all([
          createStaff(values).then((staffId) => uploadPhotoToFirebase('staffs', values.avatarUrl, staffId, 12)), // create account on Backend
          register(values.userName, values.password), // create account on Firebase
        ]);
      } else {
        updateStaff(accountInfo.id, values.name, values.phone, values.gender);

        // change password on Firebase
        // if (values.password !== specialString) {
        //   changePassword(values.password);
        // }
      }

      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công!' : 'Cập nhật thành công!');
      navigate(PATH_DASHBOARD.staff.list);
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
              <RHFTextField name="userName" label="Email" disabled={isEdit} />

              <RHFTextField name="name" label="Họ và tên" />

              <RHFTextField name="phone" label="Số điện thoại" />

              {!isEdit && (
                <>
                  <RHFTextField
                    name="password"
                    label="Mật khẩu"
                    type={showPassword ? 'text' : 'password'}
                    InputProps={
                      !isEdit && {
                        endAdornment: (
                          <InputAdornment position="end">
                            <IconButton onClick={() => setShowPassword(!showPassword)} edge="end">
                              <Iconify icon={showPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} />
                            </IconButton>
                          </InputAdornment>
                        ),
                      }
                    }
                  />
                  <RHFTextField
                    name="confirmPassword"
                    label="Nhập lại mật khẩu"
                    type={showConfirmPassword ? 'text' : 'password'}
                    InputProps={
                      !isEdit && {
                        endAdornment: (
                          <InputAdornment position="end">
                            <IconButton onClick={() => setShowConfirmPassword(!showConfirmPassword)} edge="end">
                              <Iconify icon={showConfirmPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} />
                            </IconButton>
                          </InputAdornment>
                        ),
                      }
                    }
                  />
                </>
              )}
            </Box>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.staff.list} color="error" variant="contained" component={RouterLink}>
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
