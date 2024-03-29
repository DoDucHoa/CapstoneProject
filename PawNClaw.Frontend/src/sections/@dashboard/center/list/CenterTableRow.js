import PropTypes from 'prop-types';
import { useState } from 'react';
import { Link as RouterLink } from 'react-router-dom';

// @mui
import { Link, MenuItem, TableCell, TableRow, Typography } from '@mui/material';
import { useTheme } from '@mui/material/styles';

// components
import Iconify from '../../../../components/Iconify';
import Image from '../../../../components/Image';
import Label from '../../../../components/Label';
import { TableMoreMenu } from '../../../../components/table';
import { PATH_DASHBOARD } from '../../../../routes/paths';

// ----------------------------------------------------------------------

BrandTableRow.propTypes = {
  row: PropTypes.object,
  onEditRow: PropTypes.func,
  onDeleteRow: PropTypes.func,
};

export default function BrandTableRow({ row, onEditRow, onDeleteRow }) {
  const theme = useTheme();

  const { name, photoUrl, brandName, address, status, brandId } = row;

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
        {address}
      </TableCell>

      <TableCell align="left">
        <Link component={RouterLink} to={PATH_DASHBOARD.brand.edit(brandId)} color="inherit">
          {brandName}
        </Link>
      </TableCell>

      <TableCell align="center">
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
