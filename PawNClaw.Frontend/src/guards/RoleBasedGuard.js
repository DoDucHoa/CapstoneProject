import PropTypes from 'prop-types';
import { Container, Alert, AlertTitle } from '@mui/material';

// ----------------------------------------------------------------------

RoleBasedGuard.propTypes = {
  accessibleRoles: PropTypes.array,
  currentRole: PropTypes.string,
  children: PropTypes.node,
};

export default function RoleBasedGuard({ accessibleRoles, currentRole, children }) {
  if (!accessibleRoles.includes(currentRole.toLowerCase())) {
    return (
      <Container>
        <Alert severity="error">
          <AlertTitle>Từ chối quyền truy cập</AlertTitle>
          Bạn không có quyền truy cập vào trang này!
        </Alert>
      </Container>
    );
  }

  return <>{children}</>;
}
