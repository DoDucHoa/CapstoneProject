import PropTypes from 'prop-types';
import { useState, useCallback, useEffect, useMemo } from 'react';
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
import Label from '../../../components/Label';
import { FormProvider, RHFSelect, RHFTextField, RHFUploadAvatar } from '../../../components/hook-form';
import { createOwner, updateOwner } from '../../../pages/dashboard/Owner/useOwnerAPI';
import Iconify from '../../../components/Iconify';

// ----------------------------------------------------------------------

const specialString = 'Awz@******ÿ123';

AdminNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  adminData: PropTypes.object,
};

export default function AdminNewEditForm({ isEdit, adminData }) {
  const navigate = useNavigate();
  const { accountInfo, register } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    email: Yup.string().required('Bắt buộc nhập').email(),
    password: Yup.string()
      .required('Bắt buộc nhập')
      .matches(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&ÿ])[A-Za-z\d@$!%*?&ÿ]{6,}$/,
        'Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt'
      ),
    confirmPassword: Yup.string()
      .required('Bắt buộc nhập')
      .oneOf([Yup.ref('password'), null], 'Mật khẩu không khớp'),
    phoneNumber: Yup.string(),
    createdUser: Yup.number().required(),
    gender: Yup.number().required(),
    avatarUrl: Yup.mixed(),
  });

  const defaultValues = useMemo(
    () => ({
      name: adminData?.name || '',
      email: adminData?.email || '',
      password: isEdit ? specialString : '',
      confirmPassword: isEdit ? specialString : '',
      phoneNumber: adminData?.phone || '',
      createdUser: adminData?.createdUser || 0,
      gender: adminData?.gender || 1,
      avatarUrl: adminData?.avatarUrl || '',
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [adminData]
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
    if (isEdit && adminData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, adminData]);

  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await Promise.all([
          createOwner(values.email, accountInfo.id, values.phoneNumber, values.name, values.gender), // create account on Backend
          register(values.email, values.password), // create account on Firebase
          // TODO: handle avatar upload
        ]);
      } else {
        updateOwner(accountInfo.id, values.name, values.phoneNumber, values.gender);

        // change password on Firebase
        // if (values.password !== specialString) {
        //   changePassword(values.password);
        // }
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
                color={adminData.status !== 'true' ? 'error' : 'success'}
                sx={{ textTransform: 'uppercase', position: 'absolute', top: 24, right: 24 }}
              >
                {adminData.status !== 'true' ? 'Đã khóa' : 'Hoạt động'}
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
                gridTemplateColumns: { xs: 'repeat(1, 1fr)', sm: 'repeat(2, 1fr)' },
              }}
            >
              <RHFTextField name="name" label="Họ và tên" />

              <RHFTextField name="email" label="Email" disabled={isEdit} />

              <RHFTextField name="phoneNumber" label="Số điện thoại" />
              <RHFSelect name="gender" label="Giới tính">
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
              {!isEdit && (
                <>
                  <RHFTextField
                    name="password"
                    helperText="Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt"
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
              <Button to={PATH_DASHBOARD.owner.list} color="error" variant="contained" component={RouterLink}>
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
