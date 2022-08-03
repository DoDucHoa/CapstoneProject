import { Font, StyleSheet } from '@react-pdf/renderer';

// ----------------------------------------------------------------------

Font.register({
  family: 'Roboto',
  fonts: [{ src: '/fonts/arial.ttf' }, { src: '/fonts/arial-bold.ttf' }],
});

const styles = StyleSheet.create({
  col2: { width: '10%' },
  col3: { width: '15%' },
  col4: { width: '25%' },
  col6: { width: '50%' },
  col8: { width: '75%' },

  mb8: { marginBottom: 8 },
  mb20: { marginBottom: 20 },
  mb40: { marginBottom: 40 },

  mr20: { marginRight: 20 },
  mr40: { marginRight: 40 },

  mt10: { marginTop: 10 },
  mt20: { marginTop: 20 },
  mt30: { marginTop: 30 },
  mt40: { marginTop: 40 },

  overline: {
    fontSize: 8,
    marginBottom: 8,
    fontWeight: 700,
    textTransform: 'uppercase',
  },

  title: { fontSize: 30, fontWeight: 700 },
  h1: { fontSize: 22, fontWeight: 700 },
  h2: { fontSize: 19, fontWeight: 700 },
  h3: { fontSize: 16, fontWeight: 700 },
  h4: { fontSize: 13, fontWeight: 700 },
  h5: { fontSize: 10, fontWeight: 700 },

  body1: { fontSize: 10 },
  body2: { fontSize: 10, textTransform: 'lowercase' },

  subtitle2: { fontSize: 9, fontWeight: 700 },

  alignRight: { textAlign: 'right' },
  alignCenter: { textAlign: 'center' },

  page: {
    padding: '40px 24px 0 24px',
    fontSize: 9,
    lineHeight: 1.6,
    fontFamily: 'Roboto',
    backgroundColor: '#fff',
    textTransform: 'capitalize',
  },
  footer: {
    left: 0,
    right: 0,
    bottom: 0,
    padding: 24,
    margin: 'auto',
    borderTopWidth: 1,
    borderStyle: 'solid',
    position: 'absolute',
    borderColor: '#DFE3E8',
  },

  gridContainer: { flexDirection: 'row', justifyContent: 'space-between' },
  gridContainer2: { flexDirection: 'row', justifyContent: 'flex-start' },
  gridContainerCenter: { flexDirection: 'row', justifyContent: 'center' },

  table: { display: 'flex', width: 'auto' },
  tableHeader: {},
  tableBody: {},
  tableRow: {
    padding: '8px 0',
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderStyle: 'solid',
    borderColor: '#DFE3E8',
  },
  noBorder: { paddingTop: 8, paddingBottom: 0, borderBottomWidth: 0 },

  tableCell_1: { width: '5%' },
  tableCell_2: { width: '50%', paddingRight: 16 },
  tableCell_3: { width: '15%' },
  tableCell_4: { width: '25%', paddingRight: 23 },
  tableCell_5: { width: '35%' },
});

export default styles;
