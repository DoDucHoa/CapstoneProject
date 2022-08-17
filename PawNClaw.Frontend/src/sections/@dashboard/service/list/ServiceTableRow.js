import PropTypes from 'prop-types';
import { useState } from 'react';

// @mui
import { TableRow, TableCell, Typography, MenuItem } from '@mui/material';

// components
import Iconify from '../../../../components/Iconify';
import { TableMoreMenu } from '../../../../components/table';
import Image from '../../../../components/Image';

// utils
import { fVNDate } from '../../../../utils/formatTime';

// ----------------------------------------------------------------------

SupplyTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
};

export default function SupplyTableRow({ row, onEditRow, onDeleteRow }) {
  const { name, description, photoUrl, createDate } = row;

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

      <TableCell
        sx={{ overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis', maxWidth: 300 }}
        align="left"
      >
        {description}
      </TableCell>

      <TableCell align="center">
        <Typography variant="subtitle2" noWrap>
          {fVNDate(createDate)}
        </Typography>
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
