import { createSlice } from '@reduxjs/toolkit';
// utils
import axios from '../../utils/axios';
//
import { dispatch } from '../store';
import { BOOKING_STATUS_COLOR } from '../../config';

// ----------------------------------------------------------------------

const initialState = {
  isLoading: false,
  error: null,
  events: [],
  selectedEventId: null,
  bookingDetails: null,
  bookingStatuses: [],
  petData: [],
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

    // CREATE PET HEALTH DATA SUCCESS
    createPetHealthDataSuccess(state) {
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
      const { bookingDetails, petData, bookingStatus } = action.payload;
      state.bookingDetails = bookingDetails;
      state.petData = petData;
      state.bookingStatuses = bookingStatus;
      state.isLoading = false;
    },

    // RESET EVENT
    resetEvent(state) {
      state.bookingDetails = null;
      state.petData = [];
    },
  },
});

// Reducer
export default slice.reducer;

// Actions
export const { selectEvent, startLoading, resetEvent } = slice.actions;

// ----------------------------------------------------------------------

export function getEvents(CenterId) {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      const response = await axios.get(`/api/bookings?CenterId=${CenterId}`);

      const bookingData = response.data.map((booking) => ({
        id: booking.id,
        title: booking.customer.name,
        start: booking.startBooking,
        color: booking.color,
        textColor: BOOKING_STATUS_COLOR[booking.statusId],

        end: booking.endBooking,
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
    dispatch(startLoading());
    try {
      const response = await axios.get(`/api/bookings/for-staff/${bookingId}`);

      const bookingDetails = {
        ...response.data,
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
        petHealthHistories: response.data.petHealthHistories,
      };

      const bookingStatusesResponse = await axios.get('/api/bookingstatuses');

      const petData = bookingDetails.bookingDetails.map((data) => ({
        cageCode: data.cageCode,
        line: data.id,
        price: data.price,
        duration: data.duration,
        petBookingDetails: data.petBookingDetails.map((row) => ({
          id: row.pet.id,
          name: row.pet.name,
          weight: row.pet.petHealthHistories[0]?.weight || '',
          height: row.pet.petHealthHistories[0]?.height || '',
          length: row.pet.petHealthHistories[0]?.length || '',
          description: row.pet.petHealthHistories[0]?.description || '',
        })),
      }));

      dispatch(selectEvent({ bookingDetails, petData, bookingStatus: bookingStatusesResponse.data }));
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

// ----------------------------------------------------------------------

export function createPetHealthStatus({ petData }, bookingId) {
  return async () => {
    dispatch(slice.actions.startLoading());

    try {
      petData.map(async (data) => {
        data.petBookingDetails.map(async (pet) => {
          await axios.post('/api/pethealthhistories', {
            isUpdatePet: true,
            createPetHealthHistoryParameter: {
              petId: pet.id,
              bookingId,
              weight: pet.weight,
              height: pet.height,
              length: pet.length,
              description: pet.description,
              centerName: '',
            },
          });
        });
      });

      dispatch(slice.actions.createPetHealthDataSuccess());
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}
