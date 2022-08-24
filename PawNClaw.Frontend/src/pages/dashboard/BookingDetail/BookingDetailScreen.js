import { useEffect } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
// @mui
import { Container, Typography } from '@mui/material';
// hooks
import useSettings from '../../../hooks/useSettings';
import useAuth from '../../../hooks/useAuth';
// redux
import { useDispatch, useSelector } from '../../../redux/store';
import { getBookingDetails } from '../../../redux/slices/calendar';
// components
import Page from '../../../components/Page';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
// sections
import BookingDetails from './BookingDetail';
import { PATH_DASHBOARD } from '../../../routes/paths';
import { SkeletonBookingDetail } from '../../../components/skeleton';

// ----------------------------------------------------------------------

export default function BookingDetailScreen() {
  const navigate = useNavigate();
  const { centerId, centerInfo } = useAuth();
  const { bookingDetails, bookingStatuses, petData } = useSelector((state) => state.calendar);

  // * ----------------------------------------------------------------------
  // HOOKS
  const dispatch = useDispatch();
  const { themeStretch } = useSettings();

  const { pathname } = useLocation();
  const isList = pathname.includes('list');

  // * ----------------------------------------------------------------------
  // STARTUP
  const { id } = useParams();
  useEffect(() => {
    dispatch(getBookingDetails(id));
  }, [id, dispatch]);

  // * ----------------------------------------------------------------------
  // FUNCTIONS
  const handleCloseModal = () => {
    navigate(isList ? PATH_DASHBOARD.bookingList.root : PATH_DASHBOARD.booking.root);
  };

  return (
    <Page title="Chi tiết đơn hàng">
      <Container maxWidth={themeStretch ? false : 'lg'}>
        <HeaderBreadcrumbs
          heading="Chi tiết đơn hàng"
          links={[
            { name: 'Trang chủ', href: PATH_DASHBOARD.root },
            {
              name: isList ? 'Đơn hàng' : 'Lịch đặt',
              href: isList ? PATH_DASHBOARD.bookingList.root : PATH_DASHBOARD.booking.root,
            },
            { name: `Số đơn hàng: ${id}`, href: PATH_DASHBOARD.bookingDetail.bookingList(id) },
          ]}
        />

        {bookingDetails ? (
          <>
            <Typography sx={{ ml: 3 }} variant="h6">
              Khách hàng: {bookingDetails.customer.name}
            </Typography>

            <BookingDetails
              centerId={centerId}
              centerInfo={centerInfo}
              selectedEvent={bookingDetails || {}}
              onCancel={handleCloseModal}
              bookingStatuses={bookingStatuses}
              petData={petData}
            />
          </>
        ) : (
          <SkeletonBookingDetail />
        )}
      </Container>
    </Page>
  );
}
