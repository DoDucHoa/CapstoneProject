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

ServiceList.propTypes = {
  statusId: PropTypes.number,
  serviceOrders: PropTypes.array,
  handleOpenServiceDialogForm: PropTypes.func,
  isValidDate: PropTypes.bool,
};
export default function ServiceList({ statusId, serviceOrders, handleOpenServiceDialogForm, isValidDate }) {
  return (
    <Box sx={{ px: 3, mt: 6 }}>
      <Box sx={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <Typography paragraph variant="overline" sx={{ color: 'blue' }}>
          Dịch vụ
        </Typography>
        {serviceOrders.length > 0 && statusId === 1 && isValidDate && (
          <Button variant="contained" color="warning" onClick={handleOpenServiceDialogForm}>
            Chỉnh sửa
          </Button>
        )}
      </Box>
      {serviceOrders.length > 0 ? (
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
                  <TableCell align="left" width={300}>
                    Mô tả
                  </TableCell>
                  <TableCell align="left" width={200}>
                    Tên thú cưng
                  </TableCell>
                  <TableCell align="right">Số lượng</TableCell>
                  <TableCell align="right">Giá bán (VND)</TableCell>
                  <TableCell align="right">Tổng cộng (VND)</TableCell>
                </TableRow>
              </TableHead>

              <TableBody>
                {serviceOrders.map((row, index) => (
                  <TableRow
                    key={index}
                    sx={{
                      borderBottom: (theme) => `solid 1px ${theme.palette.divider}`,
                    }}
                  >
                    <TableCell align="center">{index + 1}</TableCell>
                    <TableCell align="left">
                      <Box sx={{ maxWidth: 360 }}>
                        <Typography variant="subtitle2">{row.service.description}</Typography>
                      </Box>
                    </TableCell>
                    <TableCell align="left">
                      <Box sx={{ maxWidth: 260 }}>
                        <Typography variant="subtitle2">{row.pet.name}</Typography>
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
        <Typography>Không có dịch vụ nào được đặt hàng</Typography>
      )}
    </Box>
  );
}
