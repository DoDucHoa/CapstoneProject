import PropTypes from 'prop-types';
import { useFieldArray, useFormContext } from 'react-hook-form';

// @mui
import { Button, Divider, Stack, Typography } from '@mui/material';
// hook form
import { RHFTextField } from '../../../../components/hook-form';
// components
import Iconify from '../../../../components/Iconify';

ServicePrice.propTypes = {
  createUser: PropTypes.number,
};

export default function ServicePrice({ createUser }) {
  const { control, watch, trigger } = useFormContext();

  const values = watch('servicePrice');

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'servicePrice',
  });

  const lastMaxWeight = () => {
    const lastPriceInList = values.at(-1);

    return lastPriceInList.maxWeight;
  };

  const handleAdd = async () => {
    const lastIndex = values.length - 1;
    const isMaxWeightInput = await trigger(`servicePrice[${lastIndex}].maxWeight`, { shouldFocus: true });

    if (isMaxWeightInput) {
      append({
        price: '',
        minWeight: values[lastIndex]?.maxWeight || 0,
        maxWeight: 0,
        createUser,
        modifyUser: createUser,
      });
    }
  };

  const handleRemove = (index) => {
    remove(index);
  };

  return (
    <>
      <Typography variant="h6" sx={{ color: 'text.disabled', mb: 3 }}>
        Chi tiết giá dịch vụ:
      </Typography>
      <Stack spacing={3} divider={<Divider sx={{ borderStyle: 'dashed' }} />}>
        {fields.map((item, index) => (
          <Stack key={item.id} alignItems="flex-end" spacing={1.5}>
            <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} sx={{ width: 1 }}>
              <RHFTextField name={`servicePrice[${index}].price`} label="Giá" type="number" />
              <RHFTextField
                name={`servicePrice[${index}].minWeight`}
                label="Trọng lượng tối thiểu (Kg)"
                type="number"
                disabled
              />
              <RHFTextField name={`servicePrice[${index}].maxWeight`} label="Trọng lượng tối đa (Kg)" type="number" />
            </Stack>

            <Button
              disabled={index === 0 || index !== values.length - 1}
              size="small"
              color="error"
              startIcon={<Iconify icon="eva:trash-2-outline" />}
              onClick={() => handleRemove(index)}
            >
              Xóa
            </Button>
          </Stack>
        ))}
      </Stack>
      <Divider sx={{ my: 3, borderStyle: 'dashed' }} />

      <Stack spacing={2} direction={{ xs: 'column', md: 'row' }} alignItems={{ xs: 'flex-start', md: 'center' }}>
        <Button size="small" startIcon={<Iconify icon="eva:plus-fill" />} onClick={handleAdd}>
          Thêm giá
        </Button>
      </Stack>

      <Stack spacing={2} direction="column" alignItems="flex-start" marginTop={2} sx={{ width: 1 }}>
        <Typography variant="body2">
          Giá khi thú cưng <b>{lastMaxWeight()} kg</b> trở lên:
        </Typography>
        <RHFTextField name="lastPrice" label="Giá" type="number" sx={{ width: 0.5 }} />
      </Stack>
    </>
  );
}
