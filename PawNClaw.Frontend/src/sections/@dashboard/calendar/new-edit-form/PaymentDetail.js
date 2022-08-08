import PropTypes from 'prop-types';
// @mui
import { Box, Grid, Typography } from '@mui/material';
// hooks field
import { RHFTextField } from '../../../../components/hook-form';
// utils
import { fCurrency } from '../../../../utils/formatNumber';

// ----------------------------------------------------------------------

PaymentDetail.propTypes = {
  statusId: PropTypes.number,
  totalCage: PropTypes.number,
  totalSupply: PropTypes.number,
  totalService: PropTypes.number,
  subTotal: PropTypes.number,
  voucherCodeNavigation: PropTypes.object,
  voucherCode: PropTypes.string,
  discount: PropTypes.number,
  total: PropTypes.number,
};

export default function PaymentDetail({
  statusId,
  totalCage,
  totalSupply,
  totalService,
  subTotal,
  voucherCodeNavigation,
  voucherCode,
  discount,
  total,
}) {
  return (
    <Grid container spacing={1} sx={{ p: 3, pt: 6 }}>
      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <Typography variant="overline" align="right" mr={3}>
            Tổng giá chuồng
          </Typography>
          <Typography variant="body1" align="right" width={130}>
            {fCurrency(totalCage)} ₫
          </Typography>
        </Box>
      </Grid>
      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <Typography variant="overline" align="right" mr={3}>
            Tổng đồ dùng
          </Typography>
          <Typography variant="body1" align="right" width={130}>
            {fCurrency(totalSupply)} ₫
          </Typography>
        </Box>
      </Grid>
      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <Typography variant="overline" align="right" mr={3}>
            Tổng dịch vụ
          </Typography>
          <Typography variant="body1" align="right" width={130}>
            {fCurrency(totalService)} ₫
          </Typography>
        </Box>
      </Grid>
      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <Typography variant="overline" align="right" mr={3}>
            Tổng tiền
          </Typography>
          <Typography variant="body1" align="right" width={130}>
            {fCurrency(subTotal)} ₫
          </Typography>
        </Box>
      </Grid>
      {voucherCodeNavigation && (
        <>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Typography variant="overline" align="right" mr={3} color="primary">
              Voucher giảm giá
            </Typography>
            <Typography variant="overline" align="right" width={130} />
          </Grid>
          <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography variant="body2" align="right" mr={3} sx={{ fontWeight: 700 }}>
                Mã:{' '}
                {`${voucherCode} (${fCurrency(voucherCodeNavigation?.value)}${
                  voucherCodeNavigation?.voucherTypeCode === '1' ? '%' : '₫'
                })`}
              </Typography>
              <Typography variant="body1" align="right" width={130}>
                -{fCurrency(discount)} ₫
              </Typography>
            </Box>
          </Grid>
        </>
      )}
      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end', mt: 3 }}>
        <Box sx={{ display: 'flex', alignItems: 'center' }}>
          <Typography variant="h6" align="right" mr={3}>
            Tổng thanh toán
          </Typography>
          <Typography variant="h4" align="right">
            {fCurrency(total)} ₫
          </Typography>
        </Box>
      </Grid>
      <Grid item xs={12} sx={{ mt: 3 }}>
        <RHFTextField
          disabled={statusId === 3 || statusId === 4}
          name="staffNote"
          label="Ghi chú của nhân viên"
          multiline
          rows={3}
        />
      </Grid>
    </Grid>
  );
}
