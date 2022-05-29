import PropTypes from 'prop-types';
import { createContext, useEffect, useReducer, useState } from 'react';
import { initializeApp } from 'firebase/app';
import {
  getAuth,
  signOut,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  // updatePassword,
} from 'firebase/auth';
import { getFirestore, doc, getDoc } from 'firebase/firestore';
//
import { FIREBASE_API } from '../config';

// utils
import axios from '../utils/axios';
import { setSession, setAccountInfoSession } from '../utils/jwt';

// ----------------------------------------------------------------------

const token = window.localStorage.getItem('accessToken');
if (token) {
  axios.defaults.headers.common.Authorization = `Bearer ${token}`;
}

const ADMIN_EMAILS = ['hhoa0978@gmail.com', 'pawnclaw.ad@gmail.com'];

const firebaseApp = initializeApp(FIREBASE_API);

const AUTH = getAuth(firebaseApp);

const DB = getFirestore(firebaseApp);

// user: chứa thông tin user của firebase
// accountInfo: chứa thông tin user của backend
const initialState = {
  isAuthenticated: false,
  isInitialized: false,
  user: null,
  accountInfo: null,
};

const reducer = (state, action) => {
  if (action.type === 'INITIALIZE') {
    const { isAuthenticated, user, accountInfo } = action.payload;
    return {
      ...state,
      isAuthenticated,
      isInitialized: true,
      user,
      accountInfo,
    };
  }

  if (action.type === 'LOGIN') {
    const { user, accountInfo } = action.payload;
    return {
      ...state,
      isAuthenticated: true,
      user,
      accountInfo,
    };
  }

  if (action.type === 'LOGOUT') {
    return {
      ...state,
      isAuthenticated: false,
      user: null,
      accountInfo: null,
    };
  }

  return state;
};

const AuthContext = createContext({
  ...initialState,
  method: 'firebase',
  login: () => Promise.resolve(),
  register: (email, password) => Promise.resolve(email, password),
  logout: () => Promise.resolve(),
  changePassword: (password) => Promise.resolve(password),
});

// ----------------------------------------------------------------------

AuthProvider.propTypes = {
  children: PropTypes.node,
};

function AuthProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  const [profile, setProfile] = useState(null);

  useEffect(() => {
    const accountInfo = JSON.parse(window.localStorage.getItem('accountInfo'));
    if (accountInfo) {
      onAuthStateChanged(AUTH, async (user) => {
        if (user) {
          const userRef = doc(DB, 'users', user.uid);

          const docSnap = await getDoc(userRef);

          if (docSnap.exists()) {
            setProfile(docSnap.data());
          }

          dispatch({
            type: 'INITIALIZE',
            payload: { isAuthenticated: true, user, accountInfo },
          });
        } else {
          dispatch({
            type: 'INITIALIZE',
            payload: { isAuthenticated: false, user: null, accountInfo: null },
          });
        }
      });
    } else {
      dispatch({
        type: 'INITIALIZE',
        payload: { isAuthenticated: false, user: null, accountInfo: null },
      });
    }
  }, [dispatch]);

  const getBackendToken = async (idToken, signInMethod) => {
    try {
      const response = await axios.post('/api/auth/sign-in', {
        idToken,
        signInMethod,
      });

      if (response.statusText === 'OK') {
        const { jwtToken, ...userData } = response.data;
        console.log('jwtToken: ', jwtToken);
        setSession(jwtToken);
        setAccountInfoSession(JSON.stringify(userData));
        return userData;
      }
      return null;
    } catch (error) {
      console.log('error: ', error);
      return null;
    }
  };

  const login = async (email, password) => {
    const userCredentials = await signInWithEmailAndPassword(AUTH, email, password);

    if (userCredentials) {
      const { accessToken } = userCredentials.user;
      console.log('accessToken: ', accessToken);
      const userData = await getBackendToken(accessToken, 'Email');
      if (userData) {
        dispatch({
          type: 'LOGIN',
          payload: {
            user: userCredentials.user,
            accountInfo: userData,
          },
        });
      }
    }
  };

  const register = (email, password) => createUserWithEmailAndPassword(AUTH, email, password);

  const logout = () => {
    signOut(AUTH);
    setSession(null);
    setAccountInfoSession(null);
    dispatch({ type: 'LOGOUT' });
  };

  // const changePassword = (password) => updatePassword(AUTH.currentUser, password);

  return (
    <AuthContext.Provider
      value={{
        ...state,
        method: 'firebase',
        user: {
          id: state?.user?.uid,
          email: state?.user?.email,
          photoURL: state?.user?.photoURL || profile?.photoURL,
          displayName: state?.user?.displayName || profile?.displayName,
          role: ADMIN_EMAILS.includes(state?.user?.email) ? 'admin' : 'user',
          phoneNumber: state?.user?.phoneNumber || profile?.phoneNumber || '',
          country: profile?.country || '',
          address: profile?.address || '',
          state: profile?.state || '',
          city: profile?.city || '',
          zipCode: profile?.zipCode || '',
          about: profile?.about || '',
          isPublic: profile?.isPublic || false,
        },
        login,
        register,
        logout,
        // changePassword,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export { AuthContext, AuthProvider };
