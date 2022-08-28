import PropTypes from 'prop-types';
import { createContext, useEffect, useReducer, useState } from 'react';
import { initializeApp } from 'firebase/app';
import {
  getAuth,
  signOut,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  updatePassword,
  // updatePassword,
} from 'firebase/auth';
import { getFirestore, doc, getDoc } from 'firebase/firestore';
import { getStorage, ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';
//
import { FIREBASE_API } from '../config';

// utils
import axios from '../utils/axios';
import { setSession, setAccountInfoSession, setCenterInfoSession, setCenterIdSession } from '../utils/jwt';

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
  centerInfo: null,
  centerId: null,
};

const reducer = (state, action) => {
  if (action.type === 'INITIALIZE') {
    const { isAuthenticated, user, accountInfo, centerInfo, centerId } = action.payload;
    return {
      ...state,
      isAuthenticated,
      isInitialized: true,
      user,
      accountInfo,
      centerInfo,
      centerId,
    };
  }

  if (action.type === 'LOGIN') {
    const { user, accountInfo, centerInfo, centerId } = action.payload;
    return {
      ...state,
      isAuthenticated: true,
      user,
      accountInfo,
      centerInfo,
      centerId,
    };
  }

  if (action.type === 'LOGOUT') {
    return {
      ...state,
      isAuthenticated: false,
      user: null,
      accountInfo: null,
      centerInfo: null,
      centerId: null,
    };
  }

  if (action.type === 'CHANGE_CENTER') {
    const { centerId } = action.payload;
    return {
      ...state,
      centerId,
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
  uploadPhotoToFirebase: (path, file, idActor, photoType) => Promise.resolve(path, file, idActor, photoType),
  changeCenter: () => null,
  uploadFileToFirebase: (path, file, fileName) => Promise.resolve(path, file, fileName),
  updatePhoto: (path, file, idActor) => Promise.resolve(path, file, idActor),
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
    const centerInfo = JSON.parse(window.localStorage.getItem('centerInfo'));
    const centerId = window.localStorage.getItem('centerId');

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
            payload: { isAuthenticated: true, user, accountInfo, centerInfo, centerId },
          });
        } else {
          dispatch({
            type: 'INITIALIZE',
            payload: { isAuthenticated: false, user: null, accountInfo: null, centerInfo: null, centerId: null },
          });
        }
      });
    } else {
      dispatch({
        type: 'INITIALIZE',
        payload: { isAuthenticated: false, user: null, accountInfo: null, centerInfo: null, centerId: null },
      });
    }
  }, [dispatch]);

  const login = async (email, password) => {
    try {
      const userCredentials = await signInWithEmailAndPassword(AUTH, email, password);

      if (userCredentials) {
        const { accessToken } = userCredentials.user;

        const userData = await getBackendToken(accessToken, 'Email');

        let petCenter = null;
        if (userData?.role === 'Owner') {
          petCenter = await getPetCenter(userData.id);
        }

        let staffCenterId = null;
        if (userData?.role === 'Staff') {
          staffCenterId = await getStaffCenterId(userData.id);
        }

        if (userData) {
          dispatch({
            type: 'LOGIN',
            payload: {
              user: userCredentials.user,
              accountInfo: userData,
              centerInfo: petCenter || null,
              centerId: petCenter?.petCenters[0].id || staffCenterId || null,
            },
          });
        }
      }
    } catch (error) {
      throw new Error(error);
    }
  };

  const register = (email, password) => createUserWithEmailAndPassword(AUTH, email, password);

  const logout = () => {
    dispatch({ type: 'LOGOUT' });
    signOut(AUTH);
    setSession(null);
    setAccountInfoSession(null);
    setCenterInfoSession(null);
    setCenterIdSession(null);
    // window.location.reload();
  };

  // create function upload photo to Firebase use async
  const uploadPhotoToFirebase = async (path, file, idActor, photoType) => {
    const storageRef = ref(storage, `${path}/${file.name}`);
    const uploadTask = uploadBytesResumable(storageRef, file);

    await uploadTask;
    const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
    await uploadPhotoToBackend(idActor, downloadURL, photoType);
  };

  const updatePhoto = async (path, file, idActor) => {
    const storageRef = ref(storage, `${path}/${file.name}`);
    const uploadTask = uploadBytesResumable(storageRef, file);

    await uploadTask;
    const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
    await updatePhotoToBackend(idActor, downloadURL);
  };

  const uploadFileToFirebase = async (path, file, fileName) => {
    const storageRef = ref(storage, `${path}/${fileName}`);
    const uploadTask = uploadBytesResumable(storageRef, file);

    await uploadTask;
    const downloadURL = await getDownloadURL(uploadTask.snapshot.ref);
    return downloadURL;
  };

  const changeCenter = (centerId) => {
    setCenterIdSession(centerId);
    dispatch({
      type: 'CHANGE_CENTER',
      payload: { centerId },
    });
  };

  const changePassword = (password) => updatePassword(AUTH.currentUser, password);

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
        uploadPhotoToFirebase,
        changeCenter,
        uploadFileToFirebase,
        updatePhoto,
        changePassword,
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

const getPetCenter = async (idOwner) => {
  try {
    const response = await axios.get(`/api/brands/owner/${idOwner}`);
    if (response.statusText === 'OK') {
      setCenterInfoSession(JSON.stringify(response.data));
      return response.data;
    }
    return null;
  } catch (error) {
    throw new Error(error);
  }
};

const getStaffCenterId = async (idStaff) => {
  try {
    const response = await axios.get(`/api/petcenters/staff/${idStaff}`);
    if (response.statusText === 'OK') {
      setCenterIdSession(response.data.id);
      return response.data.id;
    }
    return null;
  } catch (error) {
    console.log('error: ', error);
    return null;
  }
};

const uploadPhotoToBackend = async (idActor, url, photoType) => {
  const response = await axios.post(`/api/photos/${photoType}`, {
    idActor,
    url,
    isThumbnail: false,
  });
  return response.data;
};

const updatePhotoToBackend = async (id, url) => {
  const response = await axios.put('/api/photos', {
    id,
    url,
  });
  return response.data;
};
