import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router';
//
import FullCalendar from '@fullcalendar/react'; // => request placed at the top
import listPlugin from '@fullcalendar/list';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import timelinePlugin from '@fullcalendar/timeline';
import interactionPlugin from '@fullcalendar/interaction';
// @mui
import { Card, Container } from '@mui/material';
// hooks
import useAuth from '../../hooks/useAuth';
import useSettings from '../../hooks/useSettings';
import useResponsive from '../../hooks/useResponsive';
// redux
import { useDispatch, useSelector } from '../../redux/store';
import { getEvents, resetEvent } from '../../redux/slices/calendar';
// routes
import { PATH_DASHBOARD } from '../../routes/paths';
// components
import Page from '../../components/Page';
import HeaderBreadcrumbs from '../../components/HeaderBreadcrumbs';
// sections
import { CalendarStyle, CalendarToolbar } from '../../sections/@dashboard/calendar';

// ----------------------------------------------------------------------

export default function Calendar() {
  const { centerId } = useAuth();
  const { themeStretch } = useSettings();
  const navigate = useNavigate();

  const dispatch = useDispatch();

  const isDesktop = useResponsive('up', 'sm');

  const calendarRef = useRef(null);

  const [date, setDate] = useState(new Date());
  const [bookings, setBookings] = useState([]);
  const [view, setView] = useState(isDesktop ? 'dayGridMonth' : 'listWeek');

  const { events } = useSelector((state) => state.calendar);

  useEffect(() => {
    dispatch(getEvents(centerId));
    dispatch(resetEvent());
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
    navigate(PATH_DASHBOARD.bookingDetail.bookingCalendar(arg.event.id));
  };

  return (
    <Page title="Lịch đặt">
      <Container maxWidth={themeStretch ? false : 'xl'}>
        <HeaderBreadcrumbs
          heading="Lịch đặt"
          links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Lịch đặt' }]}
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
      </Container>
    </Page>
  );
}
