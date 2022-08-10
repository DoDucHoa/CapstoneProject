import PropTypes from 'prop-types';
import { PDFViewer } from '@react-pdf/renderer';
// @mui
import { Box, Dialog, DialogActions, IconButton, Tooltip } from '@mui/material';
// components
import Iconify from '../../../../components/Iconify';
import InvoicePDF from '../invoice/InvoicePDF';

// ----------------------------------------------------------------------
PDFInvoiceDialog.propTypes = {
  openPDFDialog: PropTypes.bool,
  handleClosePDFDialog: PropTypes.func,
  selectedEvent: PropTypes.object,
  petData: PropTypes.array,
  supplyOrders: PropTypes.array,
  serviceOrders: PropTypes.array,
  centerInfo: PropTypes.object,
};
PDFInvoiceDialog.defaultProps = {
  openPDFDialog: false,
  handleClosePDFDialog: () => {},
  selectedEvent: {},
  petData: [],
  supplyOrders: [],
  serviceOrders: [],
  centerInfo: {},
};
PDFInvoiceDialog.displayName = 'PDFInvoiceDialog';

export default function PDFInvoiceDialog({
  openPDFDialog,
  handleClosePDFDialog,
  selectedEvent,
  petData,
  supplyOrders,
  serviceOrders,
  centerInfo,
}) {
  return (
    <Dialog fullScreen open={openPDFDialog}>
      <Box sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
        <DialogActions
          sx={{
            zIndex: 9,
            padding: '12px !important',
            boxShadow: (theme) => theme.customShadows.z8,
          }}
        >
          <Tooltip title="Close">
            <IconButton color="inherit" onClick={handleClosePDFDialog}>
              <Iconify icon={'eva:close-fill'} />
            </IconButton>
          </Tooltip>
        </DialogActions>

        <Box sx={{ flexGrow: 1, height: '100%', overflow: 'hidden' }}>
          <PDFViewer width="100%" height="100%" style={{ border: 'none' }}>
            <InvoicePDF
              invoice={selectedEvent}
              petData={petData}
              supplyOrders={supplyOrders}
              serviceOrders={serviceOrders}
              centerInfo={centerInfo}
            />
          </PDFViewer>
        </Box>
      </Box>
    </Dialog>
  );
}
