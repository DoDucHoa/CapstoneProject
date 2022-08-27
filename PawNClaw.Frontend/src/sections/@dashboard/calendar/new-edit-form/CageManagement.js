import { useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, Grid, Typography } from '@mui/material';
// reac-hooks-form
import { useFieldArray, useFormContext } from 'react-hook-form';
import { RHFTextField } from '../../../../components/hook-form';
// utils
import { fCurrency, fNumber } from '../../../../utils/formatNumber';
import Iconify from '../../../../components/Iconify';
// components

// ----------------------------------------------------------------------

CageManagement.propTypes = {
  statusId: PropTypes.number,
  centerId: PropTypes.any,
  isDesktop: PropTypes.bool,
  handleCheckSize: PropTypes.func,
  handleOpenCageDialogForm: PropTypes.func,
  isValidDate: PropTypes.bool,
};

export default function CageManagement({
  statusId,
  centerId,
  isDesktop,
  handleCheckSize,
  handleOpenCageDialogForm,
  isValidDate,
}) {
  const [isLoading, setIsLoading] = useState(false);

  const { trigger, control, watch } = useFormContext();
  const values = watch();
  const { cageSizeCheck: checks } = values;

  const { fields } = useFieldArray({
    control,
    name: 'petData',
  });

  return (
    <>
      <Typography paragraph variant="overline" sx={{ color: 'green', pl: 3 }}>
        Thông tin thú cưng
      </Typography>

      {/* Cage management */}
      {fields.map((cage, index) => {
        const cageIndex = index;
        const pet = cage.petBookingDetails;

        return (
          <Grid container spacing={3} sx={{ px: 3, pb: 3 }} key={cageIndex}>
            <Grid item xs={4} sm={2}>
              <Typography variant="caption">Mã chuồng</Typography>
              <Typography variant="h6">{cage.cageCode}</Typography>
            </Grid>
            <Grid item xs={4} sm={2}>
              <Typography variant="caption">Thời lượng</Typography>
              <Typography variant="h6">{fNumber(cage.duration)} ngày</Typography>
            </Grid>
            <Grid item xs={4} sm={2}>
              <Typography variant="caption">Giá tiền</Typography>
              <Typography variant="h6">{fCurrency(cage.price)} ₫</Typography>
            </Grid>

            {statusId === 1 && isDesktop && isValidDate && (
              <Grid item xs={12} sm={6} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end' }}>
                <Box display="flex" alignItems="center">
                  <Iconify
                    icon={checks[index].isValid ? 'flat-color-icons:ok' : 'flat-color-icons:high-priority'}
                    sx={{ color: checks[index].isValid ? 'green' : 'red' }}
                    width={30}
                    height={30}
                  />

                  <LoadingButton
                    sx={{ mx: 3 }}
                    variant="contained"
                    color="primary"
                    loading={isLoading}
                    onClick={() => {
                      trigger([`petData[${cageIndex}]`]).then(async (isValid) => {
                        if (isValid) {
                          setIsLoading(true);
                          await handleCheckSize(cageIndex, centerId);
                          setIsLoading(false);
                        }
                      });
                    }}
                  >
                    Kiểm tra kích thước
                  </LoadingButton>
                  <Button
                    variant="contained"
                    color="warning"
                    onClick={() => {
                      trigger([`petData[${cageIndex}]`]).then((isValid) => {
                        if (isValid) {
                          handleOpenCageDialogForm(cageIndex, cage.line);
                        }
                      });
                    }}
                  >
                    Đổi chuồng
                  </Button>
                </Box>
              </Grid>
            )}
            {statusId === 1 && !isDesktop && (
              <Grid item xs={12}>
                <Button
                  variant="contained"
                  color="warning"
                  onClick={() => {
                    trigger([`petData[${cageIndex}]`]).then((isValid) => {
                      if (isValid) {
                        handleOpenCageDialogForm(cageIndex, cage.line);
                      }
                    });
                  }}
                >
                  Đổi chuồng
                </Button>
              </Grid>
            )}

            {pet.map((pet, petIndex) => (
              <Grid item xs={12} key={petIndex}>
                <Grid container spacing={3}>
                  <Grid item xs={12} sm={2}>
                    <Typography variant="caption" color="textSecondary">
                      Tên thú cưng
                    </Typography>
                    <Typography variant="body1">{pet.name}</Typography>
                  </Grid>
                  <Grid item xs={6} sm={2}>
                    <RHFTextField
                      disabled={statusId !== 1}
                      name={`petData[${cageIndex}].petBookingDetails[${petIndex}].height`}
                      type="number"
                      isNumber
                      label="Chiều cao (cm)"
                    />
                  </Grid>
                  <Grid item xs={6} sm={2}>
                    <RHFTextField
                      disabled={statusId !== 1}
                      name={`petData[${cageIndex}].petBookingDetails[${petIndex}].length`}
                      type="number"
                      isNumber
                      label="Chiều dài (cm)"
                    />
                  </Grid>
                  <Grid item xs={6} sm={2}>
                    <RHFTextField
                      disabled={statusId !== 1}
                      name={`petData[${cageIndex}].petBookingDetails[${petIndex}].weight`}
                      type="number"
                      isNumber
                      label="Cân nặng (kg)"
                    />
                  </Grid>
                  <Grid item xs={6} sm={4}>
                    <RHFTextField
                      disabled={statusId !== 1}
                      name={`petData[${cageIndex}].petBookingDetails[${petIndex}].description`}
                      label="Tình trạng sức khỏe"
                    />
                  </Grid>
                </Grid>
              </Grid>
            ))}
          </Grid>
        );
      })}
    </>
  );
}
