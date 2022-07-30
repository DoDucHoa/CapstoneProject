import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { Avatar, TableRow, TableCell, Typography, MenuItem, Checkbox, Switch } from '@mui/material';

// components
import Iconify from '../../../../components/Iconify';
import { TableMoreMenu } from '../../../../components/table';
import { shiftCage } from '../../../../pages/dashboard/Cage/useCageAPI';

// ----------------------------------------------------------------------

BrandTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
  centerId: PropTypes.number,
};

export default function BrandTableRow({ row, onEditRow, onDeleteRow, centerId }) {
  const { isSingle, avatarUrl, code, isOnline, typeName, status, canShift } = row;

  const [openMenu, setOpenMenuActions] = useState(null);
  const [isCageOnline, setIsCageOnline] = useState(isOnline);

  const handleOpenMenu = (event) => {
    setOpenMenuActions(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpenMenuActions(null);
  };

  const handleChangeOnlineStatus = async (cageCode) => {
    setIsCageOnline(!isCageOnline);
    shiftCage(cageCode, centerId);
  };

  return (
    <TableRow hover>
      <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
        <Avatar alt={typeName} src={avatarUrl} sx={{ mr: 2 }} />
        <Typography variant="subtitle2" noWrap>
          {code}
        </Typography>
      </TableCell>

      <TableCell align="left">{typeName}</TableCell>

      <TableCell align="center">
        <Checkbox checked={isSingle} disabled />
      </TableCell>

      <TableCell align="left">
        <Switch checked={isCageOnline} onChange={() => handleChangeOnlineStatus(code)} disabled={!canShift} />
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
