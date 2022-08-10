import { useEffect } from 'react';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, Container, Grid, Typography } from '@mui/material';
import { styled } from '@mui/material/styles';
// hooks form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
import { FormProvider, RHFEditor } from '../../../components/hook-form';
// hooks
import useSettings from '../../../hooks/useSettings';
// utils
import axios from '../../../utils/axios';
// path
import { PATH_DASHBOARD } from '../../../routes/paths';
// components
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Page from '../../../components/Page';

// --------------------------------------------------------------

const LabelStyle = styled(Typography)(({ theme }) => ({
  ...theme.typography.subtitle2,
  color: theme.palette.text.secondary,
  marginBottom: theme.spacing(1),
}));

// --------------------------------------------------------------

export default function PolicyForm() {
  const { themeStretch } = useSettings();
  const { enqueueSnackbar } = useSnackbar();

  const NewBlogSchema = Yup.object().shape({
    content: Yup.string().min(0).required('Content is required'),
  });

  const defaultValues = {
    content: '',
  };

  const methods = useForm({
    resolver: yupResolver(NewBlogSchema),
    defaultValues,
  });

  const {
    watch,
    setValue,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  useEffect(() => {
    fetchPolicy()
      .then((content) => {
        setValue('content', content);
      })
      .catch((error) => {
        console.error(error);
      });
  }, [setValue]);

  const onSubmit = async () => {
    try {
      await updatePolicy(values.content);
      enqueueSnackbar('Cập nhật thành công!');
    } catch (error) {
      enqueueSnackbar('Có lỗi xảy ra, vui lòng thử lại sau!', { variant: 'error' });
    }
  };

  return (
    <Page title="Chính sách">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Chính sách"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Chính sách' }]}
        />
        <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
          <Grid container>
            <Grid item xs={12}>
              <LabelStyle>Nội dung</LabelStyle>
              <RHFEditor name="content" simple />

              <Box sx={{ float: 'right', mt: 1 }}>
                <Button variant="contained" sx={{ mr: 2 }} color="error" onClick={() => setValue('content', '')}>
                  Xóa
                </Button>
                <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                  Lưu
                </LoadingButton>
              </Box>
            </Grid>
          </Grid>
        </FormProvider>
      </Container>
    </Page>
  );
}

// ----------------------------------------------------------------------

async function fetchPolicy() {
  try {
    const { data } = await axios.get('/api/policies');
    return data.policy;
  } catch (error) {
    console.error(error);
    return {};
  }
}

async function updatePolicy(newPolicy) {
  try {
    await axios.post('/api/policies', {
      newPolicy,
    });
  } catch (error) {
    throw new Error(error);
  }
}
