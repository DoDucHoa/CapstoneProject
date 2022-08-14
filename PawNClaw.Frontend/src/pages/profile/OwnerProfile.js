import { useCallback, useEffect, useMemo, useState } from 'react';
import { useSnackbar } from 'notistack';
import * as Yup from 'yup';
import { Link as RouterLink } from 'react-router-dom';
// form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, Card, Container, Grid, IconButton, InputAdornment, Stack, Typography } from '@mui/material';
// hooks
import useSettings from '../../hooks/useSettings';
import useAuth from '../../hooks/useAuth';
// RHForm
import { FormProvider, RHFSelect, RHFTextField, RHFUploadAvatar } from '../../components/hook-form';
// path
import { PATH_DASHBOARD } from '../../routes/paths';
// utils
import axios from '../../utils/axios';
import { fData } from '../../utils/formatNumber';
// components
import HeaderBreadcrumbs from '../../components/HeaderBreadcrumbs';
import Page from '../../components/Page';
import Iconify from '../../components/Iconify';

// ----------------------------------------------------------------------

export default function OwnerProfile() {
  // STATE
  const [profileData, setProfileData] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  // * ----------------------------------------------------------------------
  // HOOKS
  const { themeStretch } = useSettings();
  const { accountInfo, changePassword, updatePhoto } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  // * ----------------------------------------------------------------------
  // FORM
  const NewUserSchema = Yup.object().shape({
    name: Yup.string().required('Bắt buộc nhập'),
    email: Yup.string().required('Bắt buộc nhập').email(),
    phone: Yup.string(),
    gender: Yup.number().required(),
    avatarUrl: Yup.mixed(),
    password: Yup.string().when('isChangingPassword', {
      is: (isChangingPassword) => isChangingPassword,
      then: Yup.string()
        .required('Bắt buộc nhập')
        .matches(
          /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&ÿ])[A-Za-z\d@$!%*?&ÿ]{6,}$/,
          'Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt'
        ),
    }),
    confirmPassword: Yup.string().when('isChangingPassword', {
      is: (isChangingPassword) => isChangingPassword,
      then: Yup.string()
        .required('Bắt buộc nhập')
        .oneOf([Yup.ref('password'), null], 'Mật khẩu không khớp')
        .matches(
          /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&ÿ])[A-Za-z\d@$!%*?&ÿ]{6,}$/,
          'Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt'
        ),
    }),
  });

  const defaultValues = useMemo(
    () => ({
      name: profileData?.name || '',
      email: profileData?.email || '',
      gender: profileData?.gender || 1,
      modifyUser: accountInfo.id,
      phone: profileData?.idNavigation?.phone || '',
      avatarUrl: profileData?.idNavigation?.avatarUrl || null,
      password: '',
      confirmPassword: '',
      isChangingPassword: false,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [profileData]
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

  // * ----------------------------------------------------------------------
  // STARTUP
  useEffect(() => {
    async function fetchProfileData() {
      const { data } = await axios.get(`/api/owners/${accountInfo.id}`);
      return data;
    }

    fetchProfileData().then((data) => {
      const profile = {
        id: data.id,
        name: data.name,
        email: data.email,
        gender: data.gender,
        phone: data.idNavigation.phone,
        avatarUrl: data.idNavigation.photos[0].url,
        modifyUser: accountInfo.id,
      };
      setProfileData(profile);
      reset(profile);
    });

    return () => {
      setProfileData({});
    };
  }, [accountInfo.id, reset]);

  // * ----------------------------------------------------------------------
  // HANDLE SUBMIT
  const onSubmit = async () => {
    try {
      await updateOwnerProfile(accountInfo.id, values).then(() => {
        updatePhoto('accounts', values.avatarUrl, accountInfo.id);
      });

      if (values.isChangingPassword) {
        changePassword(values.password);
      }

      reset();
      enqueueSnackbar('Cập nhật thành công');
    } catch (error) {
      console.error(error);
    }
  };

  // HANDLE FUNCTION
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
    <Page title="Thông tin cá nhân">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Thông tin cá nhân"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Thông tin cá nhân' }]}
        />

        <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={4}>
              <Card sx={{ py: 6, px: 3 }}>
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
                    <RHFTextField name="name" label="Họ và tên" />
                  </Grid>

                  <Grid item xs={12}>
                    <RHFTextField name="email" label="Email" disabled />
                  </Grid>

                  <Grid item xs={12}>
                    <RHFTextField name="phone" label="Số điện thoại" />
                  </Grid>

                  <Grid item xs={12}>
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
                  </Grid>

                  <Grid item xs={12}>
                    <Button
                      variant="contained"
                      color={values.isChangingPassword ? 'error' : 'primary'}
                      sx={{ width: 150 }}
                      onClick={() => setValue('isChangingPassword', !values.isChangingPassword)}
                    >
                      {values.isChangingPassword ? 'Hủy' : 'Đổi mật khẩu'}
                    </Button>
                  </Grid>

                  {values.isChangingPassword && (
                    <>
                      <Grid item xs={12}>
                        <RHFTextField
                          name="password"
                          label="Mật khẩu"
                          type={showPassword ? 'text' : 'password'}
                          InputProps={{
                            endAdornment: (
                              <InputAdornment position="end">
                                <IconButton onClick={() => setShowPassword(!showPassword)} edge="end">
                                  <Iconify icon={showPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} />
                                </IconButton>
                              </InputAdornment>
                            ),
                          }}
                        />
                      </Grid>

                      <Grid item xs={12}>
                        <RHFTextField
                          name="confirmPassword"
                          label="Nhập lại mật khẩu"
                          type={showConfirmPassword ? 'text' : 'password'}
                          InputProps={{
                            endAdornment: (
                              <InputAdornment position="end">
                                <IconButton onClick={() => setShowConfirmPassword(!showConfirmPassword)} edge="end">
                                  <Iconify icon={showConfirmPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} />
                                </IconButton>
                              </InputAdornment>
                            ),
                          }}
                        />
                      </Grid>
                    </>
                  )}
                </Grid>

                <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
                  <Button to={PATH_DASHBOARD.general.booking} color="error" variant="contained" component={RouterLink}>
                    Hủy
                  </Button>
                  <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                    Cập nhật
                  </LoadingButton>
                </Stack>
              </Card>
            </Grid>
          </Grid>
        </FormProvider>
      </Container>
    </Page>
  );
}

// ----------------------------------------------------------------------
async function updateOwnerProfile(profileId, values) {
  await axios.put(`/api/owners/${profileId}`, {
    id: profileId,
    name: values.name,
    phone: values.phone,
    modifyUser: values.modifyUser,
  });
}
