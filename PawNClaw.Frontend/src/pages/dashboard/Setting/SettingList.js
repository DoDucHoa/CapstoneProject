import { useEffect, useMemo, useState } from 'react';
import { useForm } from 'react-hook-form';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';

// @mui
import { LoadingButton } from '@mui/lab';
import { Container, Grid, Stack } from '@mui/material';
// form
import { yupResolver } from '@hookform/resolvers/yup';
// hooks
import useSettings from '../../../hooks/useSettings';
import { FormProvider, RHFTextField } from '../../../components/hook-form';
// path
import { PATH_DASHBOARD } from '../../../routes/paths';
// components
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import Page from '../../../components/Page';
import axios from '../../../utils/axios';

// ----------------------------------------------------------------------

export default function SettingList() {
  const { themeStretch } = useSettings();
  const { enqueueSnackbar } = useSnackbar();

  const [config, setConfig] = useState({});

  useEffect(() => {
    getConfig()
      .then((data) => {
        setConfig(data);
        reset(data);
      })
      .catch((err) => {
        enqueueSnackbar(err.message, { variant: 'error' });
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const NewUserSchema = Yup.object().shape({
    kmSearch: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .max(50, 'Không được quá 50km')
      .min(5, 'Không được nhỏ hơn 5km'),
    numOfSponsor: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .moreThan(0, 'Phải lớn hơn 0')
      .max(15, 'Không được quá 15'),
  });

  const defaultValues = useMemo(
    () => ({
      kmSearch: config?.kmSearch || 0,
      numOfSponsor: config?.numOfSponsor || 0,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [config]
  );

  // ----------------------------------------------------------------------
  // FORM
  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const {
    reset,
    handleSubmit,
    watch,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  const onSubmit = async () => {
    try {
      await updateConfig(values);
      enqueueSnackbar('Lưu thành công');
    } catch (error) {
      console.error(error);
      enqueueSnackbar(error.message, { variant: 'error' });
    }
  };

  return (
    <Page title="Cài đặt">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Thông số cài đặt"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Thông số cài đặt' }]}
        />

        <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
          <Grid container spacing={3}>
            <Grid item xs={12} sm={4}>
              <Stack direction={'column'} sx={{ width: 1 }} spacing={3}>
                <RHFTextField name="kmSearch" label="Phạm vi tìm trung tâm (km)" type="number" />
                <RHFTextField name="numOfSponsor" label="Số lượng sponsor trong 1 tháng" type="number" />

                <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                  Lưu
                </LoadingButton>
              </Stack>
            </Grid>
          </Grid>
        </FormProvider>
      </Container>
    </Page>
  );
}

// ----------------------------------------------------------------------
async function getConfig() {
  const response = await axios.get('/api/consts');
  return response.data;
}

async function updateConfig(data) {
  const response = await axios.put('/api/consts', data);
  return response.data;
}
