import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';

// @mui
import { Box, Dialog, Divider, InputAdornment, ListItemButton, TextField, Typography } from '@mui/material';

// components
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import { getCageTypes } from '../../../pages/dashboard/Cage/useCageAPI';

// --------------------------------------------------------------------------------------------------------------------

CageTypeDialog.propTypes = {
  centerId: PropTypes.number.isRequired,
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  selected: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
};

export default function CageTypeDialog({ centerId, open, onClose, selected, onSelect }) {
  const [filterName, setFilterName] = useState('');
  const [cageTypeList, setCageTypeList] = useState([]);

  useEffect(() => {
    getCageTypes(centerId, filterName).then((response) => setCageTypeList(response.data));
  }, [centerId, filterName]);

  const onEnterPress = (value) => {
    setFilterName(value);
  };

  function handleSelect(cageTypeInfo) {
    onSelect(cageTypeInfo);
    onClose();
  }

  return (
    <Dialog open={open} onClose={onClose} fullWidth maxWidth="xs">
      <TextField
        sx={{ p: 3 }}
        fullWidth
        onKeyPress={(event) => event.key === 'Enter' && onEnterPress(event.target.value)}
        placeholder="Tìm loại chuồng..."
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Iconify icon={'eva:search-fill'} sx={{ color: 'text.disabled', width: 20, height: 20 }} />
            </InputAdornment>
          ),
        }}
      />
      <Typography sx={{ px: 3, pb: 2 }} variant="h6">
        Danh sách loại chuồng
      </Typography>

      <Scrollbar sx={{ p: 3, pt: 0, maxHeight: 80 * 5 }}>
        {cageTypeList.map((cageType) => (
          <Box key={cageType.id}>
            <ListItemButton
              sx={{ p: 1, flexDirection: 'column', alignItems: 'flex-start' }}
              selected={selected(cageType.id)}
              onClick={() => handleSelect(cageType)}
            >
              <Typography variant="subtitle2">{cageType.typeName}</Typography>
              <Typography variant="body2" sx={{ color: 'secondary.main', my: 0.5, fontWeight: 'fontWeightMedium' }}>
                {cageType.isSingle ? 'Chuồng nhốt riêng' : 'Chuồng nhốt chung'}
              </Typography>
              <Typography variant="caption" sx={{ color: 'primary.main', my: 0.5, fontWeight: 'fontWeightMedium' }}>
                Cao: {cageType.height} cm | Dài: {cageType.width} cm | Rộng: {cageType.length} cm
              </Typography>
              <Typography variant="body2">{cageType.description}</Typography>
            </ListItemButton>
            <Divider />
          </Box>
        ))}
      </Scrollbar>
    </Dialog>
  );
}
