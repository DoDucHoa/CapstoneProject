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

const statusColor = {
  1: 'orange',
  2: 'blue',
  3: 'green',
  4: 'red',
};

export function getEvents() {
  return async () => {
    dispatch(slice.actions.startLoading());
    try {
      const response = await axios.get('/api/bookings');

      const bookingData = response.data.map((booking) => ({
        id: booking.id,
        title: booking.customer.name,
        start: booking.startBooking,
        color: booking.color,
        textColor: statusColor[booking.statusId],
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
      console.log(response.data);
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
      const petDataResponse = await axios.get(`/api/petbookingdetails/booking/${bookingId}`);

      const petData = petDataResponse.data.map((data) => ({
        id: data.pet.id,
        name: data.pet.name,
        weight: data.pet.petHealthHistories[0]?.weight,
        height: data.pet.petHealthHistories[0]?.height,
        length: data.pet.petHealthHistories[0]?.length,
        description: data.pet.petHealthHistories[0]?.description,
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
        await axios.post('/api/pethealthhistorys', {
          isUpdatePet: true,
          createPetHealthHistoryParameter: {
            petId: data.id,
            weight: data.weight,
            height: data.height,
            length: data.length,
            description: data.description,
            centerName: 'Runolfsson-Dickens',
            bookingId,
          },
        });
      });
      dispatch(slice.actions.createPetHealthDataSuccess());
    } catch (error) {
      dispatch(slice.actions.hasError(error));
    }
  };
}
