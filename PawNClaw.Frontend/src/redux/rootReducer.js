import { combineReducers } from 'redux';
import storage from 'redux-persist/lib/storage';
// slices
import calendarReducer from './slices/calendar';

// ----------------------------------------------------------------------

const rootPersistConfig = {
  key: 'root',
  storage,
  keyPrefix: 'redux-',
  whitelist: [],
};

const rootReducer = combineReducers({
  calendar: calendarReducer,
});

export { rootPersistConfig, rootReducer };
