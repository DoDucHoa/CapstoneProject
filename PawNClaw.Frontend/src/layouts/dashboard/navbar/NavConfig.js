// routes
import { PATH_DASHBOARD } from '../../../routes/paths';
// components
// import Label from '../../../components/Label';
import SvgIconStyle from '../../../components/SvgIconStyle';

// ----------------------------------------------------------------------

const getIcon = (name) => <SvgIconStyle src={`/icons/${name}.svg`} sx={{ width: 1, height: 1 }} />;

const ICONS = {
  admin: getIcon('ic_admin'),
  owner: getIcon('ic_owner'),
  booking: getIcon('ic_booking'),
  chart: getIcon('ic_chart'),
  brand: getIcon('ic_brand'),
  center: getIcon('ic_center'),
  list: getIcon('ic_list'),
};

const navConfig = [
  // GENERAL
  // ----------------------------------------------------------------------
  {
    subheader: 'general',
    items: [{ title: 'Biểu Đồ', path: PATH_DASHBOARD.general.booking, icon: ICONS.chart }],
  },

  // BOOKING
  // ----------------------------------------------------------------------
  {
    subheader: 'booking',
    items: [
      { title: 'Booking', path: PATH_DASHBOARD.bookingList.list, icon: ICONS.list },
      {
        title: 'Lịch Đặt',
        path: PATH_DASHBOARD.booking.calendar,
        icon: ICONS.booking,
      },
    ],
  },

  // MANAGEMENT
  // ----------------------------------------------------------------------
  {
    subheader: 'Quản Lý',
    items: [
      // MODERATOR
      {
        title: 'Người điều hành',
        path: PATH_DASHBOARD.admin.list,
        icon: ICONS.admin,
      },
      {
        title: 'Chủ trung tâm',
        path: PATH_DASHBOARD.owner.list,
        icon: ICONS.owner,
      },
    ],
  },

  // CENTER
  // ----------------------------------------------------------------------
  {
    subheader: 'Trung Tâm',
    items: [
      // MODERATOR
      {
        title: 'Thương hiệu',
        path: PATH_DASHBOARD.brand.list,
        icon: ICONS.brand,
      },
      {
        title: 'Trung tâm',
        path: PATH_DASHBOARD.center.list,
        icon: ICONS.center,
      },
    ],
  },
];

export default navConfig;
