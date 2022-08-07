import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import { MenuItem, Stack, Typography } from '@mui/material';
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
      <IconButtonAnimate
        onClick={handleOpen}
        sx={{
          width: 40,
          height: 40,
          ...(open && { bgcolor: 'action.selected' }),
        }}
      >
        <Image
          disabledEffect
          src={
            'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/sponsor%2FBin-Bon-Dog-Shop.jpg?alt=media&token=c776bac1-52e0-44e1-9ef4-147f90488b8d' // FIXME: center photo is static
          }
          alt={selectedCenter.name}
        />
      </IconButtonAnimate>

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
              <Image
                disabledEffect
                alt={center.name}
                src={
                  'https://firebasestorage.googleapis.com/v0/b/pawnclaw-4b6ba.appspot.com/o/sponsor%2FBin-Bon-Dog-Shop.jpg?alt=media&token=c776bac1-52e0-44e1-9ef4-147f90488b8d'
                }
                sx={{ width: 28, mr: 2 }}
              />
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
