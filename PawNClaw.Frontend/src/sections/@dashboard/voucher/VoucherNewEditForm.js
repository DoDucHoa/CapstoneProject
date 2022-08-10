import { useSnackbar } from 'notistack';
import PropTypes from 'prop-types';
import { useEffect, useMemo, useState } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';
import * as Yup from 'yup';
// form
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
// @mui
import { LoadingButton } from '@mui/lab';
import { Button, Card, Grid, MenuItem, Stack } from '@mui/material';
// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// hooks
import useAuth from '../../../hooks/useAuth';
// components
import { FormProvider, RHFSelect, RHFTextField } from '../../../components/hook-form';
import { createVoucher, getVoucherType, updateVoucher } from '../../../pages/dashboard/Voucher/useVoucherAPI';

// ----------------------------------------------------------------------

VoucherNewEditForm.propTypes = {
  isEdit: PropTypes.bool,
  voucherData: PropTypes.object,
};

export default function VoucherNewEditForm({ isEdit, voucherData }) {
  const navigate = useNavigate();
  const { accountInfo, centerId } = useAuth();
  const { enqueueSnackbar } = useSnackbar();

  const [voucherType, setVoucherType] = useState([]);

  const NewUserSchema = Yup.object().shape({
    code: Yup.string().required('Bắt buộc nhập'),
    minCondition: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .min(0, 'Giá trị không được nhỏ hơn 0'),
    value: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .moreThan(0, 'Giá trị phải lớn hơn 0')
      .when('voucherTypeCode', {
        is: '1',
        then: Yup.number()
          .required('Bắt buộc nhập')
          .typeError('Bắt buộc nhập')
          .moreThan(0, 'Giá trị phải lớn hơn 0')
          .max(100, 'Giá trị không được lớn hơn 100'),
      }),
    releaseAmount: Yup.number()
      .required('Bắt buộc nhập')
      .typeError('Bắt buộc nhập')
      .moreThan(0, 'Giá trị phải lớn hơn 0'),
    voucherTypeCode: Yup.string().required('Bắt buộc nhập'),
    description: Yup.string(),
  });

  const defaultValues = useMemo(
    () => ({
      code: voucherData.code || '',
      minCondition: voucherData.minCondition || 0,
      value: voucherData.value || 0,
      voucherTypeCode: voucherData.voucherTypeCode || '1',
      description: voucherData.description || '',
      releaseAmount: voucherData.releaseAmount || 0,

      createDate: voucherData.createDate || new Date(),
      modifyDate: new Date(),
      createUser: voucherData.createUser || accountInfo.id,
      modifyUser: accountInfo.id,
      centerId: voucherData.centerId || centerId,
      status: voucherData.status || true,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [voucherData]
  );

  const methods = useForm({
    resolver: yupResolver(NewUserSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  useEffect(() => {
    if (isEdit && voucherData) {
      reset(defaultValues);
    }
    if (!isEdit) {
      reset(defaultValues);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEdit, voucherData]);

  // get voucher type
  useEffect(() => {
    getVoucherType().then((res) => {
      setVoucherType(res);
    });
  }, []);

  const onSubmit = async () => {
    try {
      if (!isEdit) {
        await createVoucher(values);
      } else {
        await updateVoucher(values);
      }

      reset();
      enqueueSnackbar(!isEdit ? 'Tạo mới thành công!' : 'Cập nhật thành công!');
      navigate(PATH_DASHBOARD.voucher.list);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <FormProvider methods={methods} onSubmit={handleSubmit(onSubmit)}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Card sx={{ p: 3 }}>
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <RHFTextField name="code" label="Mã voucher" disabled={isEdit} />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFSelect
                  disabled={isEdit}
                  name="voucherTypeCode"
                  label="Loại giảm giá"
                  fullWidth
                  InputLabelProps={{ shrink: true }}
                  SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
                >
                  {voucherType.map((type) => (
                    <MenuItem
                      key={type.code}
                      value={type.code}
                      sx={{
                        mx: 1,
                        my: 0.5,
                        borderRadius: 0.75,
                        typography: 'body2',
                        textTransform: 'capitalize',
                      }}
                    >
                      {type.name}
                    </MenuItem>
                  ))}
                </RHFSelect>
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFTextField
                  disabled={isEdit}
                  name="value"
                  type="number"
                  label={values?.voucherTypeCode === '1' ? 'Giá trị giảm (%)' : 'Giá trị giảm (VND)'}
                />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFTextField
                  name="minCondition"
                  label="Điều kiện đơn hàng tối thiểu"
                  disabled={isEdit}
                  type="number"
                />
              </Grid>

              <Grid item xs={12} sm={6}>
                <RHFTextField name="releaseAmount" label="Số lượng phát hành" disabled={isEdit} type="number" />
              </Grid>

              <Grid item xs={12}>
                <RHFTextField name="description" label="Mô tả điều kiện" multiline rows={5} />
              </Grid>
            </Grid>

            <Stack direction="row" alignItems="flex-end" justifyContent="flex-end" spacing={3} sx={{ mt: 3 }}>
              <Button to={PATH_DASHBOARD.voucher.list} color="error" variant="contained" component={RouterLink}>
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
