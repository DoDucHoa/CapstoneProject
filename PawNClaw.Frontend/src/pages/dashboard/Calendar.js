import { useState, useRef, useEffect } from 'react';
//
import FullCalendar from '@fullcalendar/react'; // => request placed at the top
import listPlugin from '@fullcalendar/list';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import timelinePlugin from '@fullcalendar/timeline';
import interactionPlugin from '@fullcalendar/interaction';
import { isEmpty } from 'lodash';
// @mui
import { Card, Container, DialogTitle } from '@mui/material';
// hooks
import useAuth from '../../hooks/useAuth';
import useSettings from '../../hooks/useSettings';
import useResponsive from '../../hooks/useResponsive';
// redux
import { useDispatch, useSelector } from '../../redux/store';
import { getEvents, closeModal, getBookingDetails } from '../../redux/slices/calendar';
// routes
import { PATH_DASHBOARD } from '../../routes/paths';
// components
import Page from '../../components/Page';
import { DialogAnimate } from '../../components/animate';
import HeaderBreadcrumbs from '../../components/HeaderBreadcrumbs';
// sections
import { CalendarForm, CalendarStyle, CalendarToolbar } from '../../sections/@dashboard/calendar';
// config
import { BOOKING_STATUS_COLOR } from '../../config';
// ----------------------------------------------------------------------

export default function Calendar() {
  const { centerId } = useAuth();
  const { themeStretch } = useSettings();

  const dispatch = useDispatch();

  const isDesktop = useResponsive('up', 'sm');

  const calendarRef = useRef(null);

  const [date, setDate] = useState(new Date());
  const [bookings, setBookings] = useState([]);
  const [view, setView] = useState(isDesktop ? 'dayGridMonth' : 'listWeek');

  const { events, isOpenModal, bookingDetails, bookingStatuses, petData } = useSelector((state) => state.calendar);

  useEffect(() => {
    dispatch(getEvents(centerId));
  }, [dispatch, centerId]);

  useEffect(() => {
    setBookings(events);
  }, [events]);

  useEffect(() => {
    const calendarEl = calendarRef.current;
    if (calendarEl) {
      const calendarApi = calendarEl.getApi();
      const newView = isDesktop ? 'dayGridMonth' : 'listWeek';
      calendarApi.changeView(newView);
      setView(newView);
    }
  }, [isDesktop]);

  const handleClickDatePrev = () => {
    const calendarEl = calendarRef.current;
    if (calendarEl) {
      const calendarApi = calendarEl.getApi();
      calendarApi.prev();
      setDate(calendarApi.getDate());
    }
  };

  const handleClickDateNext = () => {
    const calendarEl = calendarRef.current;
    if (calendarEl) {
      const calendarApi = calendarEl.getApi();
      calendarApi.next();
      setDate(calendarApi.getDate());
    }
  };

  const handleSelectEvent = (arg) => {
    dispatch(getBookingDetails(arg.event.id));
  };

  const handleCloseModal = () => {
    dispatch(closeModal());
  };

  const handleChangeBookingStatusColor = (bookingId, statusId) => {
    const bookingIndex = bookings.findIndex((booking) => booking.id === bookingId);
    // eslint-disable-next-line no-var
    var data = [...bookings];
    if (bookingIndex !== -1) {
      const detail = data[bookingIndex];
      data.splice(bookingIndex, 1);
      const result = [
        { id: detail.id, title: detail.title, start: detail.start, textColor: BOOKING_STATUS_COLOR[statusId] },
        ...data,
      ];
      setBookings(result);
    }
  };

  return (
    <Page title="Calendar">
      <Container maxWidth={themeStretch ? false : 'xl'}>
        <HeaderBreadcrumbs
          heading="L???ch ?????t"
          links={[{ name: 'Trang ch???', href: PATH_DASHBOARD.root }, { name: 'L???ch ?????t' }]}
        />

        <Card>
          <CalendarStyle>
            <CalendarToolbar date={date} onNextDate={handleClickDateNext} onPrevDate={handleClickDatePrev} />
            <FullCalendar
              weekends
              defaultAllDay
              showNonCurrentDates={false}
              events={bookings}
              ref={calendarRef}
              rerenderDelay={10}
              initialDate={date}
              initialView={view}
              dayMaxEventRows={3}
              eventDisplay="block"
              headerToolbar={false}
              eventClick={handleSelectEvent}
              height={isDesktop ? 720 : 'auto'}
              plugins={[listPlugin, dayGridPlugin, timelinePlugin, timeGridPlugin, interactionPlugin]}
            />
          </CalendarStyle>
        </Card>

        <DialogAnimate open={isOpenModal} onClose={handleCloseModal}>
          <DialogTitle>Kh??ch h??ng: {isEmpty(bookingDetails) ? '' : bookingDetails.customer.name}</DialogTitle>
          <CalendarForm
            centerId={centerId}
            selectedEvent={bookingDetails || {}}
            onCancel={handleCloseModal}
            bookingStatuses={bookingStatuses}
            petData={petData}
            updateStatusColor={handleChangeBookingStatusColor}
          />
        </DialogAnimate>
      </Container>
    </Page>
  );
}
