import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
// @mui
import { styled } from '@mui/material/styles';
import {
  Box,
  Card,
  Stack,
  Container,
  Typography,
  Link,
  Dialog,
  DialogContent,
  DialogContentText,
  DialogActions,
  Button,
} from '@mui/material';
import ReactQuill from 'react-quill';

// hooks
import useResponsive from '../../hooks/useResponsive';

// components
import Page from '../../components/Page';
import Logo from '../../components/Logo';
import Image from '../../components/Image';

// sections
import { LoginForm } from '../../sections/auth/login';

// utils
import axios from '../../utils/axios';

// ----------------------------------------------------------------------

const RootStyle = styled('div')(({ theme }) => ({
  [theme.breakpoints.up('md')]: {
    display: 'flex',
  },
}));

const HeaderStyle = styled('header')(({ theme }) => ({
  top: 0,
  zIndex: 9,
  lineHeight: 0,
  width: '100%',
  display: 'flex',
  alignItems: 'center',
  position: 'absolute',
  padding: theme.spacing(3),
  justifyContent: 'space-between',
  [theme.breakpoints.up('md')]: {
    alignItems: 'flex-start',
    padding: theme.spacing(7, 5, 0, 7),
  },
}));

const SectionStyle = styled(Card)(({ theme }) => ({
  width: '100%',
  maxWidth: 464,
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'center',
  margin: theme.spacing(2, 0, 2, 2),
}));

const ContentStyle = styled('div')(({ theme }) => ({
  maxWidth: 480,
  margin: 'auto',
  display: 'flex',
  minHeight: '100vh',
  flexDirection: 'column',
  justifyContent: 'center',
  padding: theme.spacing(12, 0),
}));

// ----------------------------------------------------------------------

export default function Login() {
  const [openPolicy, setOpenPolicy] = useState(false);
  const mdUp = useResponsive('up', 'md');

  const handleOpenPolicy = () => {
    setOpenPolicy(true);
  };

  const handleClosePolicy = () => {
    setOpenPolicy(false);
  };

  return (
    <Page title="Đăng nhập">
      <RootStyle>
        <HeaderStyle>
          <Logo />
        </HeaderStyle>

        {mdUp && (
          <SectionStyle>
            <Image
              visibleByDefault
              disabledEffect
              alt="login"
              src="	https://minimals.cc/assets/illustrations/illustration_login.png"
            />
          </SectionStyle>
        )}

        <Container maxWidth="sm">
          <ContentStyle>
            <Stack direction="row" alignItems="center" sx={{ mb: 5 }}>
              <Box sx={{ flexGrow: 1 }}>
                <Typography variant="h4" gutterBottom>
                  Đăng nhập vào PawNClaw
                </Typography>
              </Box>
            </Stack>

            <LoginForm />

            <Box>
              <Link
                component="button"
                variant="body2"
                sx={{ mt: 1 }}
                color="primary"
                onClick={() => handleOpenPolicy()}
              >
                Chính sách bảo mật
              </Link>
            </Box>
          </ContentStyle>
        </Container>

        <PolicyDialog open={openPolicy} onClose={handleClosePolicy} />
      </RootStyle>
    </Page>
  );
}

// ----------------------------------------------------------------------

PolicyDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
};
PolicyDialog.displayName = 'PolicyDialog';

function PolicyDialog({ open, onClose }) {
  const [policy, setPolicy] = useState('');

  async function fetchPolicy() {
    const { data } = await axios.get('/api/policies');
    return data.policy;
  }

  useEffect(() => {
    let isMounted = true;
    fetchPolicy().then((policy) => {
      if (isMounted) {
        setPolicy(policy);
      }
    });
    return () => {
      setPolicy('');
      isMounted = false;
    };
  }, []);

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md">
      <DialogContent>
        <DialogContentText>
          <ReactQuill value={policy} theme={'bubble'} readOnly />
        </DialogContentText>
      </DialogContent>

      <DialogActions>
        <Button onClick={onClose} color="primary" autoFocus>
          Đóng
        </Button>
      </DialogActions>
    </Dialog>
  );
}
