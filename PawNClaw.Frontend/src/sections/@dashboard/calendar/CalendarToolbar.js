import PropTypes from 'prop-types';
// @mui
import { styled } from '@mui/material/styles';
import { Stack, Typography, IconButton, Tooltip, Box } from '@mui/material';
// utils
import { fVNMonth } from '../../../utils/formatTime';
// components
import Iconify from '../../../components/Iconify';

// ----------------------------------------------------------------------

const RootStyle = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  flexDirection: 'column',
  padding: theme.spacing(2.5),
  [theme.breakpoints.up('sm')]: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
}));

// ----------------------------------------------------------------------

CalendarToolbar.propTypes = {
  date: PropTypes.instanceOf(Date).isRequired,
  onNextDate: PropTypes.func,
  onPrevDate: PropTypes.func,
};

export default function CalendarToolbar({ date, onNextDate, onPrevDate }) {
  return (
    <RootStyle>
      <Tooltip
        arrow
        placement="right"
        title={
          <>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Iconify icon={'material-symbols:circle'} color="#FFD384" width={16} height={16} />
              <Typography variant="body1" sx={{ ml: 2 }}>
                đang chờ
              </Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Iconify icon={'material-symbols:circle'} color="#8484FF" width={16} height={16} />
              <Typography variant="body1" sx={{ ml: 2 }}>
                đang xử lý
              </Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Iconify icon={'material-symbols:circle'} color="#84C384" width={16} height={16} />
              <Typography variant="body1" sx={{ ml: 2 }}>
                hoàn thành
              </Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Iconify icon={'material-symbols:circle'} color="#FF8484" width={16} height={16} />
              <Typography variant="body1" sx={{ ml: 2 }}>
                hủy
              </Typography>
            </Box>
          </>
        }
      >
        <IconButton>
          <Iconify icon={'bi:info-circle-fill'} color="#637381" width={20} height={20} />
        </IconButton>
      </Tooltip>

      <Stack direction="row" alignItems="center" spacing={2}>
        <IconButton onClick={onPrevDate}>
          <Iconify icon="eva:arrow-ios-back-fill" width={20} height={20} />
        </IconButton>

        <Typography variant="h5">Tháng {fVNMonth(date)}</Typography>

        <IconButton onClick={onNextDate}>
          <Iconify icon="eva:arrow-ios-forward-fill" width={20} height={20} />
        </IconButton>
      </Stack>

      <Box />
    </RootStyle>
  );
}
