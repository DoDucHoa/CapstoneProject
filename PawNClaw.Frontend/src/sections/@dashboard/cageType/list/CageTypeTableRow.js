import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { TableRow, TableCell, Typography, MenuItem, Checkbox } from '@mui/material';

// components
import Iconify from '../../../../components/Iconify';
import { TableMoreMenu } from '../../../../components/table';

// utils
import { fNumber } from '../../../../utils/formatNumber';
import Image from '../../../../components/Image';

// ----------------------------------------------------------------------

SupplyTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
};

export default function SupplyTableRow({ row, onEditRow, onDeleteRow }) {
  const { name, height, length, width, isSingle, photoUrl } = row;

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
        <Image disabledEffect src={photoUrl} sx={{ borderRadius: 1.5, width: 50, height: 50, mr: 2 }} />
        <Typography variant="subtitle2" noWrap>
          {name}
        </Typography>
      </TableCell>

      <TableCell align="right">{fNumber(height)}</TableCell>

      <TableCell align="right">{fNumber(width)}</TableCell>

      <TableCell align="right">{fNumber(length)}</TableCell>

      <TableCell align="center">
        <Checkbox checked={isSingle} disabled />
      </TableCell>

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
                <Iconify icon={'eva:trash-2-outline'} />
                Xóa
              </MenuItem>
            </>
          }
        />
      </TableCell>
    </TableRow>
  );
}
