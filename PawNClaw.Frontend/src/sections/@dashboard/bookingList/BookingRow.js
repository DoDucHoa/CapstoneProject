import PropTypes from 'prop-types';
// @mui
import { Button, TableCell, TableRow, Typography } from '@mui/material';
import { useTheme } from '@mui/material/styles';

// components
import Label from '../../../components/Label';
import { fVNDate } from '../../../utils/formatTime';

// ----------------------------------------------------------------------

BrandTableRow.propTypes = {
  row: PropTypes.object,
  onClick: PropTypes.func,
};

export default function BrandTableRow({ row, onClick }) {
  const theme = useTheme();

  const { id, customerName, startBooking, endBooking, status } = row;

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
    </TableRow>
  );
}
