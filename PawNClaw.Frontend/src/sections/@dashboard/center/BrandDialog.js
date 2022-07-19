import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';

// @mui
import { Box, Dialog, Divider, InputAdornment, ListItemButton, TextField, Typography } from '@mui/material';

// utils
import axios from '../../../utils/axios';

// components
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';

// --------------------------------------------------------------------------------------------------------------------

BrandDialog.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  selected: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
};

export default function BrandDialog({ open, onClose, selected, onSelect }) {
  const [filterName, setFilterName] = useState('');
  const [brandList, setBrandList] = useState([]);

  useEffect(() => {
    getBrandList(filterName).then((data) => setBrandList(data));
  }, [filterName]);

  const onEnterPress = (value) => {
    setFilterName(value);
  };

  function handleSelect(brandInfo) {
    onSelect(brandInfo);
    onClose();
  }

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="xs">
      <TextField
        sx={{ p: 3 }}
        fullWidth
        onKeyPress={(event) => event.key === 'Enter' && onEnterPress(event.target.value)}
        placeholder="Tìm thương thiệu..."
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Iconify icon={'eva:search-fill'} sx={{ color: 'text.disabled', width: 20, height: 20 }} />
            </InputAdornment>
          ),
        }}
      />
      <Typography sx={{ px: 3, pb: 2 }} variant="h6">
        Danh sách thương hiệu
      </Typography>

      <Scrollbar sx={{ p: 3, pt: 0, maxHeight: 80 * 5 }}>
        {brandList.map((brand) => (
          <Box key={brand.id}>
            <ListItemButton
              sx={{ p: 1, flexDirection: 'column', alignItems: 'flex-start' }}
              selected={selected(brand.id)}
              onClick={() => handleSelect(brand)}
            >
              <Typography sx={{ color: 'primary.main', fontWeight: 'fontWeightMedium' }} variant="subtitle2">
                {brand.name}
              </Typography>
              <Typography variant="caption" sx={{ my: 0.5 }}>
                Người sở hữu: {brand.owner.name}
              </Typography>
            </ListItemButton>
            <Divider />
          </Box>
        ))}
      </Scrollbar>
    </Dialog>
  );
}

// --------------------------------------------------------------------------------------------------------------------
getBrandList.propTypes = {
  filterName: PropTypes.string.isRequired,
};
async function getBrandList(filterName) {
  try {
    const response = await axios.get(`/api/brands?Name=${filterName}`);
    return response.data.data;
  } catch (error) {
    console.log(error);
    return [];
  }
}
