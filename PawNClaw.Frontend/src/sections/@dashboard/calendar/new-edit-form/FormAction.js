import PropTypes from 'prop-types';
import { BlobProvider, PDFDownloadLink } from '@react-pdf/renderer';
// @mui
import { LoadingButton } from '@mui/lab';
import { Box, Button, DialogActions } from '@mui/material';
// hooks
import useAuth from '../../../../hooks/useAuth';
// components
import Iconify from '../../../../components/Iconify';
import InvoicePDF from '../invoice/InvoicePDF';
import { updateInvoiceUrl } from '../useCalendarAPI';

// ----------------------------------------------------------------------

FormAction.propTypes = {
  values: PropTypes.object,
  statusId: PropTypes.number,
  selectedEvent: PropTypes.object,
  petData: PropTypes.array,
  supplyOrders: PropTypes.array,
  serviceOrders: PropTypes.array,
  centerInfo: PropTypes.object,
  handleOpenPDFDialog: PropTypes.func,
  onCancel: PropTypes.func,
  isSubmitting: PropTypes.bool,
};
FormAction.defaultProps = {
  values: {},
  statusId: 0,
  selectedEvent: {},
  petData: [],
  supplyOrders: [],
  serviceOrders: [],
  centerInfo: {},
  handleOpenPDFDialog: () => {},
  onCancel: () => {},
  isSubmitting: false,
};
FormAction.displayName = 'FormAction';

export default function FormAction({
  values,
  statusId,
  selectedEvent,
  petData,
  supplyOrders,
  serviceOrders,
  centerInfo,
  handleOpenPDFDialog,
  onCancel,
  isSubmitting,
}) {
  const { uploadFileToFirebase } = useAuth();

  return (
    <DialogActions>
      <Box sx={{ flexGrow: 1 }} />
      {statusId === 3 && (
        <>
          <PDFDownloadLink
            document={
              <InvoicePDF
                invoice={selectedEvent}
                petData={petData}
                supplyOrders={supplyOrders}
                serviceOrders={serviceOrders}
                centerInfo={centerInfo}
              />
            }
            fileName={`${selectedEvent.id}-invoice.pdf`}
            style={{ textDecoration: 'none' }}
          >
            {({ loading }) => (
              <LoadingButton
                color="info"
                variant="text"
                loading={loading}
                startIcon={<Iconify icon="ant-design:download-outlined" />}
              >
                Tải hóa đơn
              </LoadingButton>
            )}
          </PDFDownloadLink>

          <Button
            sx={{ ml: 2 }}
            onClick={handleOpenPDFDialog}
            color="inherit"
            variant="text"
            startIcon={<Iconify icon={'eva:eye-fill'} />}
          >
            Xem hóa đơn
          </Button>
        </>
      )}

      <Button variant="outlined" color="inherit" onClick={onCancel}>
        {statusId !== 3 && statusId !== 4 ? 'Hủy' : 'Thoát'}
      </Button>

      {statusId !== 3 && statusId !== 4 && (
        <>
          {values.statusId !== 3 ? (
            <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
              Xác Nhận
            </LoadingButton>
          ) : (
            <BlobProvider
              document={
                <InvoicePDF
                  invoice={selectedEvent}
                  petData={petData}
                  supplyOrders={supplyOrders}
                  serviceOrders={serviceOrders}
                  centerInfo={centerInfo}
                />
              }
            >
              {({ blob }) => {
                uploadFileToFirebase('invoices', blob, selectedEvent.id).then((downloadUrl) => {
                  updateInvoiceUrl(selectedEvent.id, downloadUrl);
                });
                return (
                  <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                    Xác Nhận
                  </LoadingButton>
                );
              }}
            </BlobProvider>
          )}
        </>
      )}
    </DialogActions>
  );
}
