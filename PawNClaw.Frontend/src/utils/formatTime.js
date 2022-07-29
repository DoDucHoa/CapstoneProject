import { format, getTime, formatDistanceToNow, add } from 'date-fns';

// ----------------------------------------------------------------------

export function fDate(date) {
  return format(new Date(date), 'dd MMMM yyyy');
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

export function getRandomDateWithTime(time) {
  return new Date(Date.now() + time);
}
