import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { Button, MenuItem, TableCell, TableRow, Typography } from '@mui/material';
import { useTheme } from '@mui/material/styles';

// components
import Iconify from '../../../components/Iconify';
import Label from '../../../components/Label';
import { TableMoreMenu } from '../../../components/table';
import { fVNDate } from '../../../utils/formatTime';

// ----------------------------------------------------------------------

BrandTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
  onClick: PropTypes.func,
};

export default function BrandTableRow({ row, onEditRow, onDeleteRow, onClick }) {
  const theme = useTheme();

  const { id, customerName, startBooking, endBooking, status } = row;

  const [openMenu, setOpenMenuActions] = useState(null);

  const handleOpenMenu = (event) => {
    setOpenMenuActions(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpenMenuActions(null);
  };

  const statusColor = (statusId) => {
    let color = '';
    switch (statusId) {
      case 1:
        color = 'warning';
        break;
      case 2:
        color = 'info';
        break;
      case 3:
        color = 'success';
        break;
      case 4:
        color = 'error';
        break;
      default:
        color = 'default';
        break;
    }

    return color;
  };

  return (
    <TableRow hover>
      <TableCell>
        <Button variant="text" color="inherit" onClick={() => onClick(id)}>
          <Typography variant="subtitle2" noWrap>
            {id}
          </Typography>
        </Button>
      </TableCell>

      <TableCell align="left">{customerName}</TableCell>

      <TableCell align="center">{fVNDate(startBooking)}</TableCell>

      <TableCell align="center">{fVNDate(endBooking)}</TableCell>

      <TableCell align="left">
        <Label
          variant={theme.palette.mode === 'light' ? 'ghost' : 'filled'}
          color={statusColor(status.id)}
          sx={{ textTransform: 'capitalize' }}
        >
          {status.name}
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
