import PropTypes from 'prop-types';

// @mui
import { TableRow, TableCell, Typography } from '@mui/material';

// components
import { fVNDateTime } from '../../../../utils/formatTime';

// ----------------------------------------------------------------------

LogTableRow.propTypes = {
  row: PropTypes.object,
};

export default function LogTableRow({ row }) {
  const { id, target, name, type, time } = row;

  return (
    <TableRow hover>
      <TableCell sx={{ display: 'flex', alignItems: 'center' }}>
        <Typography variant="subtitle2" noWrap>
          {id}
        </Typography>
      </TableCell>

      <TableCell align="left">{target}</TableCell>

      <TableCell align="left">{name}</TableCell>

      <TableCell align="left">{type}</TableCell>

      <TableCell align="left">{fVNDateTime(time)}</TableCell>
    </TableRow>
  );
}
