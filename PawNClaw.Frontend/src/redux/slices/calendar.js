import { createSlice } from '@reduxjs/toolkit';
// utils
import axios from '../../utils/axios';
//
import { dispatch } from '../store';

// ----------------------------------------------------------------------

const initialState = {
  isLoading: false,
  error: null,
  events: [],
  isOpenModal: false,
  selectedEventId: null,
  selectedRange: null,
  bookingDetails: {},
  bookingStatuses: [],
};

const slice = createSlice({
  name: 'calendar',
  initialState,
  reducers: {
    // START LOADING
    startLoading(state) {
      state.isLoading = true;
    },

    // HAS ERROR
    hasError(state, action) {
      state.isLoading = false;
      state.error = action.payload;
    },

    // GET EVENTS
    getEventsSuccess(state, action) {
      state.isLoading = false;
      state.events = action.payload;
    },

    // UPDATE BOOKING STATUS
    updateBookingStatusSuccess(state) {
      state.isLoading = false;
    },

    // UPDATE EVENT
    updateEventSuccess(state, action) {
      const event = action.payload;
      const updateEvent = state.events.map((_event) => {
        if (_event.id === event.id) {
          return event;
        }
        return _event;
      });

      state.isLoading = false;
      state.events = updateEvent;
    },

    // SELECT EVENT
    selectEvent(state, action) {
      const bookingDetails = action.payload;
      state.isOpenModal = true;
      state.bookingDetails = bookingDetails;
      state.isLoading = false;
    },

    // GET BOOKING STATUS
    getBookingStatusesSuccess(state, action) {
      state.bookingStatuses = action.payload;
      state.isLoading = false;
    },

    // OPEN MODAL
    openModal(state) {
      state.isOpenModal = true;
    },

    // CLOSE MODAL
    closeModal(state) {
      state.isOpenModal = false;
      state.selectedEventId = null;
      state.selectedRange = null;
    },
  },
});

// Reducer
export default slice.reducer;

// Actions
export const { openModal, closeModal, selectEvent } = slice.actions;

// ----------------------------------------------------------------------

export function getEvents() {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      const response = await axios.get('/api/bookings');

      const bookingData = response.data.map((booking) => ({
        id: booking.id,
        title: booking.customer.name,
        start: booking.startBooking,
        end: booking.endBooking,
        color: booking.color,
        textColor: booking.textColor,
      }));

      dispatch(slice.actions.getEventsSuccess(bookingData));
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}

// ----------------------------------------------------------------------

export function getBookingDetails(bookingId) {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      const response = await axios.get(`/api/bookings/for-staff/${bookingId}`);
      const bookingDetails = {
        id: response.data.id,
        customer: response.data.customer,
        total: response.data.total,
        createTime: response.data.createTime,
        startBooking: response.data.startBooking,
        endBooking: response.data.endBooking,
        statusId: response.data.statusId,
        customerNote: response.data.customerNote,
        staffNote: response.data.staffNote,
        bookingDetails: response.data.bookingDetails,
        serviceOrders: response.data.serviceOrders,
        supplyOrders: response.data.supplyOrders,
      };
      const bookingStatusesResponse = await axios.get('/api/bookingstatuses');

      dispatch(selectEvent(bookingDetails));
      dispatch(slice.actions.getBookingStatusesSuccess(bookingStatusesResponse.data));
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}

// ----------------------------------------------------------------------

export function updateBookingStatus({ id, statusId, staffNote }) {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      await axios.put('/api/bookings', { id, statusId, staffNote });
      dispatch(slice.actions.updateBookingStatusSuccess());
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}

// ----------------------------------------------------------------------

export function deleteEvent(eventId) {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      await axios.post('/api/calendar/events/delete', { eventId });
      dispatch(slice.actions.deleteEventSuccess({ eventId }));
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}
