import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { TableRow, TableCell, Typography, MenuItem } from '@mui/material';

// components
import Iconify from '../../../../components/Iconify';
// utils
import { TableMoreMenu } from '../../../../components/table';
import { fNumber } from '../../../../utils/formatNumber';
import { fVNDate } from '../../../../utils/formatTime';

// ----------------------------------------------------------------------

VoucherTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
  voucherTypes: PropTypes.array,
};

export default function VoucherTableRow({ row, onEditRow, onDeleteRow, voucherTypes }) {
  const { code, voucherType, value, description, expireDate } = row;

  const [openMenu, setOpenMenuActions] = useState(null);

  const handleOpenMenu = (event) => {
    setOpenMenuActions(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpenMenuActions(null);
  };

  const voucher = voucherTypes?.find((v) => v.code === voucherType);

  return (
    <TableRow hover>
      <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
        <Typography variant="subtitle2" noWrap>
          {code}
        </Typography>
      </TableCell>

      <TableCell
        sx={{ overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis', maxWidth: 300 }}
        align="left"
      >
        {description}
      </TableCell>

      <TableCell align="left">{voucher?.name}</TableCell>

      <TableCell align="right">{voucher?.code === '1' ? `${fNumber(value)}%` : `${fNumber(value)} ₫`}</TableCell>

      <TableCell align="center">{fVNDate(expireDate)}</TableCell>

      <TableCell align="right">
        <TableMoreMenu
          open={openMenu}
          onOpen={handleOpenMenu}
          onClose={handleCloseMenu}
          actions={
            <>
              <MenuItem
                onClick={() => {
                  onEditRow();
                  handleCloseMenu();
                }}
              >
                <Iconify icon={'eva:edit-fill'} />
                Sửa
              </MenuItem>
              <MenuItem
                onClick={() => {
                  onDeleteRow();
                  handleCloseMenu();
                }}
                sx={{ color: 'error.main' }}
              >
                <Iconify icon="eva:trash-2-outline" />
                Xóa
              </MenuItem>
            </>
          }
        />
      </TableCell>
    </TableRow>
  );
}
