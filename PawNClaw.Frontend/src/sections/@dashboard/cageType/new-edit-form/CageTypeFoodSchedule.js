// @mui
import { Button, Divider, Stack, Typography } from '@mui/material';
// hooks
import { useFieldArray, useFormContext } from 'react-hook-form';
import { RHFTextField, RHFTimePicker } from '../../../../components/hook-form';
// components
import Iconify from '../../../../components/Iconify';
// utils
import { addTime } from '../../../../utils/formatTime';

export default function CageTypeFoodSchedule() {
  const { control, setValue } = useFormContext();
  const { fields, append, remove } = useFieldArray({
    control,
    name: 'foodSchedules',
  });

  const handleAdd = () => {
    append({
      fromTime: '',
      toTime: '',
      name: '',
      fromTimeUI: '',
      toTimeUI: '',
      cageTypeId: 0,
    });
  };

  const handleRemove = (index) => {
    remove(index);
  };

  return (
    <>
      <Typography variant="h6" sx={{ color: 'text.disabled', mb: 3 }}>
        Kế hoạch cho ăn:
      </Typography>
      <Stack spacing={3} divider={<Divider sx={{ borderStyle: 'dashed' }} />}>
        {fields.map((item, index) => (
          <Stack key={item.id} alignItems="flex-end" spacing={1.5}>
            <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} sx={{ width: 1 }}>
              <RHFTextField name={`foodSchedules[${index}].name`} label="Diễn giải" />
              <RHFTimePicker
                name={`foodSchedules[${index}].fromTimeUI`}
                label="Từ"
                onChange={(value) => {
                  setValue(`foodSchedules[${index}].fromTimeUI`, value);
                  setValue(`foodSchedules[${index}].fromTime`, addTime(value));
                }}
              />
              <RHFTimePicker
                name={`foodSchedules[${index}].toTimeUI`}
                label="Đến"
                onChange={(value) => {
                  setValue(`foodSchedules[${index}].toTimeUI`, value);
                  setValue(`foodSchedules[${index}].toTime`, addTime(value));
                }}
              />
            </Stack>

            <Button
              disabled={index === 0}
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
          Thêm kế hoạch
        </Button>
      </Stack>
    </>
  );
}
