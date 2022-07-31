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
  service: getIcon('ic_service'),
  food: getIcon('ic_food'),
  cage: getIcon('ic_cage'),
  cageType: getIcon('ic_cage_type'),
  staff: getIcon('ic_staff'),
};

// nav config for owner
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

  // CENTER MANAGEMENT
  // ----------------------------------------------------------------------
  {
    subheader: 'Quản Lý Trung Tâm',
    items: [
      // OWNER
      {
        title: 'Nhân viên',
        path: PATH_DASHBOARD.staff.list,
        icon: ICONS.staff,
      },

      // STAFF
      {
        title: 'Loại chuồng',
        path: PATH_DASHBOARD.cageType.list,
        icon: ICONS.cageType,
      },
      {
        title: 'Chuồng',
        path: PATH_DASHBOARD.cage.list,
        icon: ICONS.cage,
      },
      {
        title: 'Đồ dùng',
        path: PATH_DASHBOARD.supply.list,
        icon: ICONS.food,
      },
      {
        title: 'Dịch vụ',
        path: PATH_DASHBOARD.service.list,
        icon: ICONS.service,
      },
    ],
  },
];

export const navConfigForStaff = [
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

  // CENTER MANAGEMENT
  // ----------------------------------------------------------------------
  {
    subheader: 'Quản Lý Trung Tâm',
    items: [
      // STAFF
      {
        title: 'Loại chuồng',
        path: PATH_DASHBOARD.cageType.list,
        icon: ICONS.cageType,
      },
      {
        title: 'Chuồng',
        path: PATH_DASHBOARD.cage.list,
        icon: ICONS.cage,
      },
      {
        title: 'Đồ dùng',
        path: PATH_DASHBOARD.supply.list,
        icon: ICONS.food,
      },
      {
        title: 'Dịch vụ',
        path: PATH_DASHBOARD.service.list,
        icon: ICONS.service,
      },
    ],
  },
];

export const navConfigForAdmin = [
  // GENERAL
  // ----------------------------------------------------------------------
  {
    subheader: 'general',
    items: [{ title: 'Biểu Đồ', path: PATH_DASHBOARD.general.booking, icon: ICONS.chart }],
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

export const navConfigForModerator = [
  // GENERAL
  // ----------------------------------------------------------------------
  {
    subheader: 'general',
    items: [{ title: 'Biểu Đồ', path: PATH_DASHBOARD.general.booking, icon: ICONS.chart }],
  },

  // MANAGEMENT
  // ----------------------------------------------------------------------
  {
    subheader: 'Quản Lý',
    items: [
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
