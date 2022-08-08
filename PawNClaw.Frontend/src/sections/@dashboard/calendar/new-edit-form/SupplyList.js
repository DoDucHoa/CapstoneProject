import PropTypes from 'prop-types';
// @mui
import {
  Box,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from '@mui/material';
// components
import Scrollbar from '../../../../components/Scrollbar';
// utils
import { fCurrency, fNumber } from '../../../../utils/formatNumber';

// ----------------------------------------------------------------------
SupplyList.propTypes = {
  statusId: PropTypes.number,
  supplyOrders: PropTypes.array,
  handleOpenSupplyDialogForm: PropTypes.func,
};
export default function SupplyList({ statusId, supplyOrders, handleOpenSupplyDialogForm }) {
  return (
    <Box sx={{ px: 3, pt: 5 }}>
      <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <Typography paragraph variant="overline" sx={{ color: 'red' }}>
          Đồ dùng
        </Typography>

        {supplyOrders.length > 0 && statusId === 1 && (
          <Button variant="contained" color="warning" onClick={handleOpenSupplyDialogForm}>
            Chỉnh sửa
          </Button>
        )}
      </Box>

      {supplyOrders.length > 0 ? (
        <Scrollbar>
          <TableContainer sx={{ minWidth: 300 }}>
            <Table>
              <TableHead
                sx={{
                  borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                  '& th': { backgroundColor: 'transparent' },
                }}
              >
                <TableRow>
                  <TableCell align="center" width={40}>
                    STT
                  </TableCell>
                  <TableCell align="left" width={500}>
                    Mô tả
                  </TableCell>
                  <TableCell align="right">Số lượng</TableCell>
                  <TableCell align="right">Giá bán (VND)</TableCell>
                  <TableCell align="right">Tổng cộng (VND)</TableCell>
                </TableRow>
              </TableHead>

              <TableBody>
                {supplyOrders.map((row, index) => (
                  <TableRow
                    key={index}
                    sx={{
                      borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                    }}
                  >
                    <TableCell align="center">{index + 1}</TableCell>
                    <TableCell align="left">
                      <Box sx={{ maxWidth: 560 }}>
                        <Typography variant="subtitle2">{row.supply.name}</Typography>
                      </Box>
                    </TableCell>
                    <TableCell align="right">{fNumber(row.quantity)}</TableCell>
                    <TableCell align="right">{fCurrency(row.sellPrice)}</TableCell>
                    <TableCell align="right">{fCurrency(row.totalPrice)}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Scrollbar>
      ) : (
        <Typography>Không có đồ dùng nào được đặt hàng</Typography>
      )}
    </Box>
  );
}
