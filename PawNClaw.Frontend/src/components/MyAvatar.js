// hooks
import useAuth from '../hooks/useAuth';
// utils
import createAvatar from '../utils/createAvatar';
//
import Avatar from './Avatar';

// ----------------------------------------------------------------------

export default function MyAvatar({ ...other }) {
  const { accountInfo } = useAuth();

  return (
    <Avatar
      src={accountInfo?.url}
      alt={accountInfo?.name}
      color={accountInfo?.url ? 'default' : createAvatar(accountInfo?.name).color}
      {...other}
    >
      {createAvatar(accountInfo?.name).name}
    </Avatar>
  );
}
