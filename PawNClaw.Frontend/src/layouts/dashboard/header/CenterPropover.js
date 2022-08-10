import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import { Box, MenuItem, Stack, Typography } from '@mui/material';
// components
import Image from '../../../components/Image';
import MenuPopover from '../../../components/MenuPopover';
import { IconButtonAnimate } from '../../../components/animate';

// ----------------------------------------------------------------------
CenterPopover.propTypes = {
  petCenters: PropTypes.array,
  onChange: PropTypes.func,
};
export default function CenterPopover({ petCenters, onChange }) {
  const [selectedCenter, setSelectedCenter] = useState(petCenters[0]);
  const [open, setOpen] = useState(null);

  useEffect(() => {
    onChange(selectedCenter.id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedCenter]);

  const handleOpen = (event) => {
    setOpen(event.currentTarget);
  };

  const handleClose = () => {
    setOpen(null);
  };

  const handleChaneCenter = (center) => {
    setSelectedCenter(center);
    onChange(center.id);
    handleClose();
  };

  return (
    <>
      <Box display="flex" sx={{ border: '1px dashed grey', borderRadius: 1, pl: 2 }}>
        <Box mr={2} width={150}>
          <Typography variant="caption" color="textSecondary">
            Trung tâm
          </Typography>
          <Typography
            variant="body2"
            color="textPrimary"
            fontWeight={700}
            sx={{ overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis', maxWidth: 300 }}
          >
            {selectedCenter.name}
          </Typography>
        </Box>

        <IconButtonAnimate
          onClick={handleOpen}
          sx={{
            width: 50,
            height: 50,
            ...(open && { bgcolor: 'action.selected' }),
          }}
        >
          <Image
            ratio={'1/1'}
            borderRadius={3}
            disabledEffect
            src={selectedCenter?.photos?.length > 0 ? selectedCenter?.photos[0]?.url : ''}
            alt={selectedCenter?.name}
          />
        </IconButtonAnimate>
      </Box>

      <MenuPopover
        open={Boolean(open)}
        anchorEl={open}
        onClose={handleClose}
        sx={{
          mt: 1.5,
          ml: 0.75,
          width: 220,
          '& .MuiMenuItem-root': { px: 1, typography: 'body2', borderRadius: 0.75 },
        }}
      >
        <Stack spacing={0.75}>
          {petCenters.map((center) => (
            <MenuItem
              key={center.id}
              selected={center.id === selectedCenter.id}
              onClick={() => handleChaneCenter(center)}
            >
              <Image disabledEffect alt={center?.name} src={center?.photos[0]?.url} sx={{ width: 28, mr: 2 }} />
              <Typography
                variant="body2"
                sx={{ overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis', maxWidth: 140 }}
              >
                {center.name}
              </Typography>
            </MenuItem>
          ))}
        </Stack>
      </MenuPopover>
    </>
  );
}
