import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { Avatar, TableRow, TableCell, Typography, MenuItem } from '@mui/material';

// components
import Iconify from '../../../../components/Iconify';
import { TableMoreMenu } from '../../../../components/table';

// utils
import { fCurrency, fNumber } from '../../../../utils/formatNumber';

// ----------------------------------------------------------------------

SupplyTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
};

export default function SupplyTableRow({ row, onEditRow, onDeleteRow }) {
  const { name, avatarUrl, sellPrice, quantity, status } = row;

  const [openMenu, setOpenMenuActions] = useState(null);

  const handleOpenMenu = (event) => {
    setOpenMenuActions(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpenMenuActions(null);
  };

  return (
    <TableRow hover>
      <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
        <Avatar alt={name} src={avatarUrl} sx={{ mr: 2 }} />
        <Typography variant="subtitle2" noWrap>
          {name}
        </Typography>
      </TableCell>

      <TableCell align="right">{fCurrency(sellPrice)}</TableCell>

      <TableCell align="right">{fNumber(quantity)}</TableCell>

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
                sx={{ color: status ? 'error.main' : 'success.main' }}
              >
                <Iconify icon={status ? 'eva:slash-outline' : 'eva:checkmark-square-outline'} />
                {status ? 'Khóa' : 'Mở khóa'}
              </MenuItem>
            </>
          }
        />
      </TableCell>
    </TableRow>
  );
}
