import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { useTheme } from '@mui/material/styles';
import { TableRow, TableCell, Typography, MenuItem, Checkbox } from '@mui/material';

// components
import Label from '../../../../components/Label';
import Iconify from '../../../../components/Iconify';
import { TableMoreMenu } from '../../../../components/table';

// utils
import { fNumber } from '../../../../utils/formatNumber';

// ----------------------------------------------------------------------

SupplyTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
};

export default function SupplyTableRow({ row, onEditRow, onDeleteRow }) {
  const theme = useTheme();

  const { name, height, length, width, isSingle, status } = row;

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

      <TableCell align="left">
        <Label
          variant={theme.palette.mode === 'light' ? 'ghost' : 'filled'}
          color={(status === false && 'error') || 'success'}
          sx={{ textTransform: 'capitalize' }}
        >
          {status ? 'Hoạt động' : 'Đã khóa'}
        </Label>
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
