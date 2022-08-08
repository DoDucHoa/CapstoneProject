import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { useFieldArray, useFormContext } from 'react-hook-form';

// @mui
import { Button, Divider, MenuItem, Stack, Typography } from '@mui/material';
// hook form
import { RHFSelect, RHFTextField } from '../../../../components/hook-form';
// components
import Iconify from '../../../../components/Iconify';
import { getPriceTypes } from '../../../../pages/dashboard/CageType/useCageTypeAPI';

CageTypePrice.propTypes = {
  createUser: PropTypes.number,
};

export default function CageTypePrice({ createUser }) {
  const { control } = useFormContext();
  const [priceTypes, setPriceTypes] = useState([]);

  useEffect(() => {
    getPriceTypes()
      .then((data) => setPriceTypes(data))
      .catch((err) => {
        console.log(err);
      });
  }, []);

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'createPriceParameters',
  });

  const handleAdd = () => {
    append({
      unitPrice: '',
      createUser,
      priceTypeCode: 'PRICE-001',
    });
  };

  const handleRemove = (index) => {
    remove(index);
  };

  return (
    <>
      <Typography variant="h6" sx={{ color: 'text.disabled', mb: 3 }}>
        Chi tiết giá:
      </Typography>
      <Stack spacing={3} divider={<Divider sx={{ borderStyle: 'dashed' }} />}>
        {fields.map((item, index) => (
          <Stack key={item.id} alignItems="flex-end" spacing={1.5}>
            <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} sx={{ width: 1 }}>
              <RHFSelect
                name={`createPriceParameters[${index}].priceTypeCode`}
                fullWidth
                label="Loại giá"
                InputLabelProps={{ shrink: true }}
                SelectProps={{ native: false, sx: { textTransform: 'capitalize' } }}
              >
                {priceTypes.map((priceType) => (
                  <MenuItem
                    key={priceType.code}
                    value={priceType.code}
                    sx={{
                      mx: 1,
                      my: 0.5,
                      borderRadius: 0.75,
                      typography: 'body2',
                      textTransform: 'capitalize',
                    }}
                  >
                    {priceType.typeName}
                  </MenuItem>
                ))}
              </RHFSelect>
              <RHFTextField name={`createPriceParameters[${index}].unitPrice`} label="Giá" type="number" />
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
          Thêm giá
        </Button>
      </Stack>
    </>
  );
}
