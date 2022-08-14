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

OwnerDialog.propTypes = {
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  selected: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
};

export default function OwnerDialog({ open, onClose, selected, onSelect }) {
  const [filterName, setFilterName] = useState('');
  const [ownerList, setOwnerList] = useState([]);

  useEffect(() => {
    getOwnerList(filterName).then((data) => setOwnerList(data));
  }, [filterName]);

  const onEnterPress = (value) => {
    setFilterName(value);
  };

  function handleSelect(ownerInfo) {
    onSelect(ownerInfo);
    onClose();
  }

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="xs">
      <TextField
        sx={{ p: 3 }}
        fullWidth
        onKeyPress={(event) => event.key === 'Enter' && onEnterPress(event.target.value)}
        placeholder="Tìm chủ trung tâm..."
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Iconify icon={'eva:search-fill'} sx={{ color: 'text.disabled', width: 20, height: 20 }} />
            </InputAdornment>
          ),
        }}
      />
      <Typography sx={{ px: 3, pb: 2 }} variant="h6">
        Danh sách chủ trung tâm
      </Typography>

      <Scrollbar sx={{ p: 3, pt: 0, maxHeight: 80 * 5 }}>
        {ownerList.map((owner) => (
          <Box key={owner.id}>
            <ListItemButton
              sx={{ p: 1, flexDirection: 'column', alignItems: 'flex-start' }}
              selected={selected(owner.id)}
              onClick={() => handleSelect(owner)}
            >
              <Typography variant="subtitle2">{owner.name}</Typography>
              <Typography variant="caption" sx={{ color: 'primary.main', my: 0.5, fontWeight: 'fontWeightMedium' }}>
                {owner.email}
              </Typography>
              <Typography variant="body2">Phone: {owner.idNavigation.phone}</Typography>
            </ListItemButton>
            <Divider />
          </Box>
        ))}
      </Scrollbar>
    </Dialog>
  );
}

// --------------------------------------------------------------------------------------------------------------------
getOwnerList.propTypes = {
  filterName: PropTypes.string.isRequired,
};
async function getOwnerList(filterName) {
  try {
    const response = await axios.get('/api/owners', {
      params: {
        Name: filterName,
        isLookup: true,
      },
    });
    return response.data.data;
  } catch (error) {
    console.log(error);
    return [];
  }
}
