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
  isOpenModal: false,
  selectedEventId: null,
  bookingDetails: {},
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

    // GET PET DATA
    getPetDataSuccess(state, action) {
      state.petData = action.payload;
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
    },
  },
});

// Reducer
export default slice.reducer;

// Actions
export const { openModal, closeModal, selectEvent, getBookingStatusesSuccess, getPetDataSuccess, startLoading } =
  slice.actions;

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

      dispatch(selectEvent(bookingDetails));
      dispatch(getBookingStatusesSuccess(bookingStatusesResponse.data));
      dispatch(getPetDataSuccess(petData));
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
