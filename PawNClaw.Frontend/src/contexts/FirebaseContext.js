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
import { getStorage, ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';
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

const storage = getStorage(firebaseApp);

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
  uploadPhoto: (path, file) => Promise.resolve(path, file),
  // changePassword: (password) => Promise.resolve(password),
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

  // create function upload photo to Firebase use async
  const uploadPhoto = (path, file) => {
    const storageRef = ref(storage, `${path}/${file.name}`);
    const uploadTask = uploadBytesResumable(storageRef, file);
    uploadTask.on(
      'state_changed',
      (snapshot) => {
        // const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        // console.log("Upload is " + progress + "% done");
        switch (snapshot.state) {
          case 'paused':
            console.log('Upload is paused');
            break;
          case 'running':
            console.log('Upload is running');
            break;
          default:
            break;
        }
      },
      (error) => {
        console.log(error.code);
      },
      () => {
        getDownloadURL(uploadTask.snapshot.ref).then((downloadURL) => console.log('downloadURL: ', downloadURL));
      }
    );
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
        uploadPhoto,
        // changePassword,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export { AuthContext, AuthProvider };

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
