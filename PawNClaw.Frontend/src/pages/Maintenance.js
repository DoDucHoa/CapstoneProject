import { Link as RouterLink } from 'react-router-dom';
// @mui
import { styled } from '@mui/material/styles';
import { Button, Typography, Container } from '@mui/material';
// components
import Page from '../components/Page';
//
import { MaintenanceIllustration } from '../assets';

// ----------------------------------------------------------------------

const RootStyle = styled('div')(({ theme }) => ({
  height: '100%',
  display: 'flex',
  alignItems: 'center',
  paddingTop: theme.spacing(15),
  paddingBottom: theme.spacing(10),
}));

// ----------------------------------------------------------------------

export default function Maintenance() {
  return (
    <Page title="Maintenance" sx={{ height: 1 }}>
      <RootStyle>
        <Container sx={{ textAlign: 'center' }}>
          <Typography variant="h3" paragraph>
            Trang web hiện đang bảo trì. Vui lòng quay lại sau!
          </Typography>
          <Typography sx={{ color: 'text.secondary' }}>
            Chúng tôi đang xây dựng trang web này hết sức có thể! Xin cảm ơn bạn đã quan tâm.
          </Typography>

          <MaintenanceIllustration sx={{ my: 10, height: 240 }} />

          <Button variant="contained" size="large" component={RouterLink} to="/">
            Trở về trang chủ
          </Button>
        </Container>
      </RootStyle>
    </Page>
  );
}
