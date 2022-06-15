import PropTypes from 'prop-types';
// @mui
import { styled } from '@mui/material/styles';
import { Stack, Typography, IconButton } from '@mui/material';
// utils
import { fDate } from '../../../utils/formatTime';
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
    justifyContent: 'center',
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
      <Stack direction="row" alignItems="center" spacing={2}>
        <IconButton onClick={onPrevDate}>
          <Iconify icon="eva:arrow-ios-back-fill" width={20} height={20} />
        </IconButton>

        <Typography variant="h5">{fDate(date)}</Typography>

        <IconButton onClick={onNextDate}>
          <Iconify icon="eva:arrow-ios-forward-fill" width={20} height={20} />
        </IconButton>
      </Stack>
    </RootStyle>
  );
}
