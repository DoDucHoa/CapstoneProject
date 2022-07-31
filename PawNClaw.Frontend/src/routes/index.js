import { Suspense, lazy } from 'react';
import { Navigate, useRoutes, useLocation } from 'react-router-dom';
// layouts
// import MainLayout from '../layouts/main';
import DashboardLayout from '../layouts/dashboard';
import LogoOnlyLayout from '../layouts/LogoOnlyLayout';
// guards
import GuestGuard from '../guards/GuestGuard';
import AuthGuard from '../guards/AuthGuard';
import RoleBasedGuard from '../guards/RoleBasedGuard';
// config
import { PATH_AFTER_LOGIN } from '../config';
// components
import LoadingScreen from '../components/LoadingScreen';
import useAuth from '../hooks/useAuth';

// ----------------------------------------------------------------------

const Loadable = (Component) => (props) => {
  // eslint-disable-next-line react-hooks/rules-of-hooks
  const { pathname } = useLocation();

  return (
    <Suspense fallback={<LoadingScreen isDashboard={pathname.includes('/dashboard')} />}>
      <Component {...props} />
    </Suspense>
  );
};

export default function Router() {
  const { accountInfo } = useAuth();
  const currentRole = accountInfo?.role;

  return useRoutes([
    {
      path: 'auth',
      children: [
        {
          path: 'login',
          element: (
            <GuestGuard>
              <Login />
            </GuestGuard>
          ),
        },
        {
          path: 'register',
          element: (
            <GuestGuard>
              <Register />
            </GuestGuard>
          ),
        },
        { path: 'login-unprotected', element: <Login /> },
        // { path: 'register-unprotected', element: <Register /> },
        { path: 'reset-password', element: <ResetPassword /> },
        { path: 'verify', element: <VerifyCode /> },
      ],
    },

    // Dashboard Routes
    {
      path: 'dashboard',
      element: (
        <AuthGuard>
          <DashboardLayout />
        </AuthGuard>
      ),
      children: [
        { element: <Navigate to={PATH_AFTER_LOGIN} replace />, index: true },
        { path: 'bookingchart', element: <GeneralBooking /> },
        {
          path: 'admin',
          children: [
            { path: '', element: <Navigate to="/dashboard/admin/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['admin']} currentRole={currentRole}>
                  <AdminList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['admin']} currentRole={currentRole}>
                  <AdminCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['admin']} currentRole={currentRole}>
                  <AdminCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'brand',
          children: [
            { path: '', element: <Navigate to="/dashboard/brand/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <BrandList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <BrandCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <BrandCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'center',
          children: [
            { path: '', element: <Navigate to="/dashboard/center/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <CenterList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <CenterCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <CenterCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'owner',
          children: [
            { path: '', element: <Navigate to="/dashboard/owner/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <OwnerList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <OwnerCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['admin', 'moderator']} currentRole={currentRole}>
                  <OwnerCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'staff',
          children: [
            { path: '', element: <Navigate to="/dashboard/staff/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['owner']} currentRole={currentRole}>
                  <StaffList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['owner']} currentRole={currentRole}>
                  <StaffCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['owner']} currentRole={currentRole}>
                  <StaffCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'cage-type',
          children: [
            { path: '', element: <Navigate to="/dashboard/cage-type/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageTypeList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageTypeCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageTypeCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'cage',
          children: [
            { path: '', element: <Navigate to="/dashboard/cage/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':code/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <CageCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'supply',
          children: [
            { path: '', element: <Navigate to="/dashboard/supply/list" replace />, index: true },
            {
              path: 'list',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <SupplyList />
                </RoleBasedGuard>
              ),
            },
            {
              path: 'new',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <SupplyCreate />
                </RoleBasedGuard>
              ),
            },
            {
              path: ':id/edit',
              element: (
                <RoleBasedGuard accessibleRoles={['staff', 'owner']} currentRole={currentRole}>
                  <SupplyCreate />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'booking',
          children: [
            { path: '', element: <Navigate to="/dashboard/booking/calendar" replace />, index: true },
            {
              path: 'calendar',
              element: (
                <RoleBasedGuard accessibleRoles={['owner', 'staff']} currentRole={currentRole}>
                  <BookingCalendar />
                </RoleBasedGuard>
              ),
            },
          ],
        },
        {
          path: 'booking-list',
          children: [
            { path: '', element: <Navigate to="/dashboard/booking-list/list" replace />, index: true },
            { path: 'list', element: <BookingList /> },
            { path: 'new', element: <OwnerCreate /> },
            { path: ':id/edit', element: <OwnerCreate /> },
          ],
        },
      ],
    },

    // Main Routes
    {
      path: '*',
      element: <LogoOnlyLayout />,
      children: [
        { path: 'coming-soon', element: <ComingSoon /> },
        { path: 'maintenance', element: <Maintenance /> },
        { path: '500', element: <Page500 /> },
        { path: '404', element: <NotFound /> },
        { path: '*', element: <Navigate to="/404" replace /> },
      ],
    },
    {
      path: '/',
      // element: <MainLayout />,
      element: <Navigate to="/auth/login" />,
      children: [
        { element: <HomePage />, index: true },
        { path: 'about-us', element: <About /> },
        { path: 'contact-us', element: <Contact /> },
        { path: 'faqs', element: <Faqs /> },
      ],
    },
    { path: '*', element: <Navigate to="/404" replace /> },
  ]);
}

// AUTHENTICATION
const Login = Loadable(lazy(() => import('../pages/auth/Login')));
const Register = Loadable(lazy(() => import('../pages/auth/Register')));
const ResetPassword = Loadable(lazy(() => import('../pages/auth/ResetPassword')));
const VerifyCode = Loadable(lazy(() => import('../pages/auth/VerifyCode')));

// DASHBOARD

// GENERAL
const GeneralBooking = Loadable(lazy(() => import('../pages/dashboard/GeneralBooking')));

// MAIN
const HomePage = Loadable(lazy(() => import('../pages/Home')));
const About = Loadable(lazy(() => import('../pages/About')));
const Contact = Loadable(lazy(() => import('../pages/Contact')));
const Faqs = Loadable(lazy(() => import('../pages/Faqs')));
const ComingSoon = Loadable(lazy(() => import('../pages/ComingSoon')));
const Maintenance = Loadable(lazy(() => import('../pages/Maintenance')));
const Page500 = Loadable(lazy(() => import('../pages/Page500')));
const NotFound = Loadable(lazy(() => import('../pages/Page404')));

// ADMIN
const AdminList = Loadable(lazy(() => import('../pages/dashboard/Admin/AdminList')));
const AdminCreate = Loadable(lazy(() => import('../pages/dashboard/Admin/AdminCreate')));

// OWNER
const OwnerList = Loadable(lazy(() => import('../pages/dashboard/Owner/OwnerList')));
const OwnerCreate = Loadable(lazy(() => import('../pages/dashboard/Owner/OwnerCreate')));

// STAFF
const StaffList = Loadable(lazy(() => import('../pages/dashboard/Staff/StaffList')));
const StaffCreate = Loadable(lazy(() => import('../pages/dashboard/Staff/StaffCreate')));

// BRAND
const BrandList = Loadable(lazy(() => import('../pages/dashboard/Brand/BrandList')));
const BrandCreate = Loadable(lazy(() => import('../pages/dashboard/Brand/BrandCreate')));

// SUPPLY
const SupplyList = Loadable(lazy(() => import('../pages/dashboard/Supply/SupplyList')));
const SupplyCreate = Loadable(lazy(() => import('../pages/dashboard/Supply/SupplyCreate')));

// CAGE TYPE
const CageTypeList = Loadable(lazy(() => import('../pages/dashboard/CageType/CageTypeList')));
const CageTypeCreate = Loadable(lazy(() => import('../pages/dashboard/CageType/CageTypeCreate')));

// CAGE
const CageList = Loadable(lazy(() => import('../pages/dashboard/Cage/CageList')));
const CageCreate = Loadable(lazy(() => import('../pages/dashboard/Cage/CageCreate')));

// BOOKING CALENDAR
const BookingCalendar = Loadable(lazy(() => import('../pages/dashboard/Calendar')));

// BOOKING LIST
const BookingList = Loadable(lazy(() => import('../pages/dashboard/BookingList/BookingList')));

// CENTER
const CenterList = Loadable(lazy(() => import('../pages/dashboard/Center/CenterList')));
const CenterCreate = Loadable(lazy(() => import('../pages/dashboard/Center/CenterCreate')));
