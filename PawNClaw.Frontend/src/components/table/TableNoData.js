// @mui
import PropTypes from 'prop-types';
import { TableRow, TableCell } from '@mui/material';
//
import EmptyContent from '../EmptyContent';

// ----------------------------------------------------------------------

TableNoData.propTypes = {
  isNotFound: PropTypes.bool,
};

export default function TableNoData({ isNotFound }) {
  return (
    <>
      {isNotFound ? (
        <TableRow>
          <TableCell colSpan={9}>
            <EmptyContent
              title="Không có dữ liệu"
              img={
                'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/SVG%2FNo-data.svg?alt=media&token=01cc2ff0-86c8-4750-862b-1f730ff1ee82'
              }
              sx={{
                '& span.MuiBox-root': { height: 160 },
              }}
            />
          </TableCell>
        </TableRow>
      ) : (
        <TableRow>
          <TableCell colSpan={9} sx={{ p: 0 }} />
        </TableRow>
      )}
    </>
  );
}
