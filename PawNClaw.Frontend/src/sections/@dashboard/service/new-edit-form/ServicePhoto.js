import { useCallback } from 'react';
import { useFormContext } from 'react-hook-form';

// @mui
import { Box, Card, Typography } from '@mui/material';

// hook form
import { RHFUploadPhoto } from '../../../../components/hook-form';

export default function ServicePhoto() {
  const { setValue } = useFormContext();

  const handleDrop = useCallback(
    (acceptedFiles) => {
      const file = acceptedFiles[0];

      if (file) {
        setValue(
          'service.avatarUrl',
          Object.assign(file, {
            preview: URL.createObjectURL(file),
          })
        );
      }
    },
    [setValue]
  );

  return (
    <Card sx={{ py: 5, px: 3 }}>
      <Box>
        <RHFUploadPhoto
          name="service.avatarUrl"
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
            </Typography>
          }
        />
      </Box>
    </Card>
  );
}
