// ----------------------------------------------------------------------

function path(root, sublink) {
  return `${root}${sublink}`;
}

const ROOTS_AUTH = '/auth';
const ROOTS_DASHBOARD = '/dashboard';

// ----------------------------------------------------------------------

export const PATH_AUTH = {
  root: ROOTS_AUTH,
  login: path(ROOTS_AUTH, '/login'),
  register: path(ROOTS_AUTH, '/register'),
  loginUnprotected: path(ROOTS_AUTH, '/login-unprotected'),
  registerUnprotected: path(ROOTS_AUTH, '/register-unprotected'),
  verify: path(ROOTS_AUTH, '/verify'),
  resetPassword: path(ROOTS_AUTH, '/reset-password'),
};

export const PATH_PAGE = {
  comingSoon: '/coming-soon',
  maintenance: '/maintenance',
  pricing: '/pricing',
  payment: '/payment',
  about: '/about-us',
  contact: '/contact-us',
  faqs: '/faqs',
  page404: '/404',
  page500: '/500',
  components: '/components',
};

export const PATH_DASHBOARD = {
  root: ROOTS_DASHBOARD,
  general: {
    booking: path(ROOTS_DASHBOARD, '/bookingchart'),
  },
  admin: {
    root: path(ROOTS_DASHBOARD, '/admin'),
    list: path(ROOTS_DASHBOARD, '/admin/list'),
    new: path(ROOTS_DASHBOARD, '/admin/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/admin/${id}/edit`),
  },
  owner: {
    root: path(ROOTS_DASHBOARD, '/owner'),
    list: path(ROOTS_DASHBOARD, '/owner/list'),
    new: path(ROOTS_DASHBOARD, '/owner/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/owner/${id}/edit`),
  },
  user: {
    root: path(ROOTS_DASHBOARD, '/user'),
    new: path(ROOTS_DASHBOARD, '/user/new'),
    list: path(ROOTS_DASHBOARD, '/user/list'),
    cards: path(ROOTS_DASHBOARD, '/user/cards'),
    profile: path(ROOTS_DASHBOARD, '/user/profile'),
    account: path(ROOTS_DASHBOARD, '/user/account'),
    edit: (name) => path(ROOTS_DASHBOARD, `/user/${name}/edit`),
    demoEdit: path(ROOTS_DASHBOARD, `/user/reece-chung/edit`),
  },
  booking: {
    root: path(ROOTS_DASHBOARD, '/booking'),
    calendar: path(ROOTS_DASHBOARD, '/booking/calendar'),
    new: path(ROOTS_DASHBOARD, '/booking/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/booking/${id}/edit`),
  },
  bookingList: {
    root: path(ROOTS_DASHBOARD, '/booking-list'),
    list: path(ROOTS_DASHBOARD, '/booking-list/list'),
    new: path(ROOTS_DASHBOARD, '/booking-list/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/booking-list/${id}/edit`),
  },
  brand: {
    root: path(ROOTS_DASHBOARD, '/brand'),
    list: path(ROOTS_DASHBOARD, '/brand/list'),
    new: path(ROOTS_DASHBOARD, '/brand/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/brand/${id}/edit`),
  },
  center: {
    root: path(ROOTS_DASHBOARD, '/center'),
    list: path(ROOTS_DASHBOARD, '/center/list'),
    new: path(ROOTS_DASHBOARD, '/center/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/center/${id}/edit`),
  },
  staff: {
    root: path(ROOTS_DASHBOARD, '/staff'),
    list: path(ROOTS_DASHBOARD, '/staff/list'),
    new: path(ROOTS_DASHBOARD, '/staff/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/staff/${id}/edit`),
  },
  cageType: {
    root: path(ROOTS_DASHBOARD, '/cage-type'),
    list: path(ROOTS_DASHBOARD, '/cage-type/list'),
    new: path(ROOTS_DASHBOARD, '/cage-type/new'),
    edit: (code) => path(ROOTS_DASHBOARD, `/cage-type/${code}/edit`),
  },
  cage: {
    root: path(ROOTS_DASHBOARD, '/cage'),
    list: path(ROOTS_DASHBOARD, '/cage/list'),
    new: path(ROOTS_DASHBOARD, '/cage/new'),
    edit: (code) => path(ROOTS_DASHBOARD, `/cage/${code}/edit`),
  },
  price: {
    root: path(ROOTS_DASHBOARD, '/price'),
    list: path(ROOTS_DASHBOARD, '/price/list'),
    new: path(ROOTS_DASHBOARD, '/price/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/price/${id}/edit`),
  },
  supply: {
    root: path(ROOTS_DASHBOARD, '/supply'),
    list: path(ROOTS_DASHBOARD, '/supply/list'),
    new: path(ROOTS_DASHBOARD, '/supply/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/supply/${id}/edit`),
  },
  service: {
    root: path(ROOTS_DASHBOARD, '/service'),
    list: path(ROOTS_DASHBOARD, '/service/list'),
    new: path(ROOTS_DASHBOARD, '/service/new'),
    edit: (id) => path(ROOTS_DASHBOARD, `/service/${id}/edit`),
  },
};
