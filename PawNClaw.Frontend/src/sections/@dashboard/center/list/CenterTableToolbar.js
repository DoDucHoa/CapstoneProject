import PropTypes from 'prop-types';
import { Stack, InputAdornment, TextField } from '@mui/material';
// components
import Iconify from '../../../../components/Iconify';

// ----------------------------------------------------------------------

CenterTableToolbar.propTypes = {
  filterName: PropTypes.string,
  filterBrandName: PropTypes.string,
  onFilterName: PropTypes.func,
  onEnterPress: PropTypes.func,
  onFilterBrandName: PropTypes.func,
  onEnterPressBrandName: PropTypes.func,
};

export default function CenterTableToolbar({
  filterName,
  filterBrandName,
  onFilterName,
  onEnterPress,
  onFilterBrandName,
  onEnterPressBrandName,
}) {
  return (
    <Stack spacing={2} direction={{ xs: 'column', sm: 'row' }} sx={{ py: 2.5, px: 3 }}>
      <TextField
        fullWidth
        value={filterName}
        onChange={(event) => onFilterName(event.target.value)}
        onKeyPress={(event) => event.key === 'Enter' && onEnterPress(event.target.value)}
        placeholder="Tìm trung tâm..."
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Iconify icon={'eva:search-fill'} sx={{ color: 'text.disabled', width: 20, height: 20 }} />
            </InputAdornment>
          ),
        }}
      />

      <TextField
        fullWidth
        value={filterBrandName}
        onChange={(event) => onFilterBrandName(event.target.value)}
        onKeyPress={(event) => event.key === 'Enter' && onEnterPressBrandName(event.target.value)}
        placeholder="Tìm tên thương hiệu..."
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Iconify icon={'eva:search-fill'} sx={{ color: 'text.disabled', width: 20, height: 20 }} />
            </InputAdornment>
          ),
        }}
      />
    </Stack>
  );
}
