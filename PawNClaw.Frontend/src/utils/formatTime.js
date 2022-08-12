import { format, getTime, formatDistanceToNow, add, isValid } from 'date-fns';

// ----------------------------------------------------------------------

export function fDate(date) {
  return format(new Date(date), 'dd MMMM yyyy');
}

export function fVNDate(date) {
  return format(new Date(date), 'dd/MM/yyyy');
}

export function fVNDateTime(date) {
  return format(new Date(date), 'dd/MM/yyyy, HH:mm:ss');
}

export function fVNMonth(date) {
  return format(new Date(date), 'MM/yyyy');
}

export function fDateTime(date) {
  return format(new Date(date), 'yyyy-MM-dd HH:mm:ss');
}

export function fTimestamp(date) {
  return getTime(new Date(date));
}

export function fDateTimeSuffix(date) {
  return format(new Date(date), 'HH:mm, dd/MM/yyyy');
}

export function fToNow(date) {
  return formatDistanceToNow(new Date(date), {
    addSuffix: true,
  });
}

export function addTime(date) {
  return add(new Date(date), { hours: 7 });
}

export function formatTime(date) {
  if (!isValid(new Date(date))) return '';
  return format(new Date(date), 'HH:mm');
}

export function compareBookingWithCurrentDate(bookingDate) {
  const currentDate = new Date();
  const bookingDateTime = new Date(bookingDate);

  const currDateNum = currentDate.getFullYear() * 10000 + currentDate.getMonth() * 100 + currentDate.getDate();
  const bookingDateNum =
    bookingDateTime.getFullYear() * 10000 + bookingDateTime.getMonth() * 100 + bookingDateTime.getDate();

  if (currDateNum >= bookingDateNum) {
    return true;
  }

  return false;
}
