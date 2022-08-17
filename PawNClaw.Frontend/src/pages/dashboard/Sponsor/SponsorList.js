import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';
import { Link as RouterLink, useNavigate } from 'react-router-dom';

// @mui
import {
  Box,
  Card,
  Dialog,
  Table,
  Button,
  TableBody,
  Container,
  TableContainer,
  TablePagination,
  DialogTitle,
  DialogActions,
  Typography,
  DialogContent,
} from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';
import useTable, { emptyRows } from '../../../hooks/useTable';

// components
import Page from '../../../components/Page';
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { SponsorTableRow } from '../../../sections/@dashboard/sponsor/list';

// API
import { getSponsors, banSponsor, extendSponsor } from './useSponsorAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'title', label: 'Tiêu đề', align: 'left' },
  { id: 'content', label: 'Nội dung', align: 'left' },
  { id: 'brandName', label: 'Thương hiệu', align: 'left' },
  { id: 'endDate', label: 'Tháng', align: 'center' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function SponsorList() {
  // STATE
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdAdmin, setSelectIdAdmin] = useState();

  // HOOKS
  const { themeStretch } = useSettings();
  const navigate = useNavigate();
  const {
    page,
    order,
    orderBy,
    rowsPerPage,
    //
    onSort,
    onChangePage,
    onChangeRowsPerPage,
  } = useTable({ defaultRowsPerPage: 10 });

  // STARTUP
  const getSponsorData = async () => {
    const response = await getSponsors(page, rowsPerPage);
    const { data, metadata } = response;

    const sponsors = data.map((sponsor) => ({
      id: sponsor.id,
      title: sponsor.title,
      content: sponsor.content,
      brandName: sponsor.brand.name,
      endDate: sponsor.endDate,
      photoUrl: sponsor?.photos?.length > 0 ? sponsor?.photos[0].url : '',
      ...sponsor,
    }));

    setTableData(sponsors);
    setMetadata(metadata);
  };

  useEffect(() => {
    getSponsorData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage]);

  // HANDLE FUNCTIONS
  const handleOpenBanDialog = (idAdmin) => {
    setSelectIdAdmin(idAdmin);
    setOpenDialog(true);
  };

  const handleCloseBanDialog = () => {
    setOpenDialog(false);
  };

  const handleEditRow = (id) => {
    navigate(PATH_DASHBOARD.sponsor.edit(id));
  };

  const handleDeleteSponsor = async (id) => {
    await banSponsor(id);
    await getSponsorData();
  };

  const handleExtendSponsor = async (sponsorData) => {
    const month = new Date(sponsorData.endDate).getMonth() + 1;
    const year = new Date(sponsorData.endDate).getFullYear();

    if (month === 12) {
      const newYear = year + 1;
      const newMonth = 1;
      await extendSponsor({ ...sponsorData, year: newYear, month: newMonth });
    } else {
      const newMonth = month + 1;
      await extendSponsor({ ...sponsorData, year, month: newMonth });
    }

    await getSponsorData();
  };

  const denseHeight = 72;

  const isNotFound = !(metadata.totalCount ? metadata.totalCount : 0);

  return (
    <>
      <Page title="Quảng cáo">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách quảng cáo"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách quảng cáo' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.sponsor.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm quảng cáo mới
              </Button>
            }
          />

          <Card sx={{ p: 1 }}>
            {/* Scrollbar dùng để tạo scroll ngang cho giao diện điện thoại */}
            <Scrollbar>
              <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
                <Table size={'medium'}>
                  <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                  <TableBody>
                    {tableData.map((row) => (
                      <SponsorTableRow
                        key={row.id}
                        row={row}
                        onEditRow={() => handleEditRow(row.id)}
                        onDeleteRow={() => handleOpenBanDialog(row.id)}
                        onExtend={() => handleExtendSponsor(row)}
                      />
                    ))}

                    <TableEmptyRows
                      height={denseHeight}
                      emptyRows={emptyRows(page, rowsPerPage, metadata.totalCount ? metadata.totalCount : 0)}
                    />

                    <TableNoData isNotFound={isNotFound} />
                  </TableBody>
                </Table>
              </TableContainer>
            </Scrollbar>

            <Box sx={{ position: 'relative' }}>
              <TablePagination
                labelRowsPerPage="Số dòng trên trang"
                labelDisplayedRows={({ from, to, count }) => `${from} đến ${to} trên ${count}`}
                rowsPerPageOptions={[5, 10, 15, 20]}
                component="div"
                count={metadata.totalCount ? metadata.totalCount : 0}
                rowsPerPage={rowsPerPage}
                page={page}
                onPageChange={onChangePage}
                onRowsPerPageChange={onChangeRowsPerPage}
              />
            </Box>
          </Card>
        </Container>
      </Page>

      <DeleteSponsorDialog
        open={openDialog}
        onClose={handleCloseBanDialog}
        idAdmin={selectIdAdmin}
        handleBanAdmin={handleDeleteSponsor}
      />
    </>
  );
}

// ----------------------------------------------------------------------
DeleteSponsorDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idSponsor: PropTypes.number,
  handleDeleteSponsor: PropTypes.func,
};
DeleteSponsorDialog.displayName = 'DeleteSponsorDialog';

function DeleteSponsorDialog({ open, onClose, idSponsor, handleDeleteSponsor }) {
  const onConfirm = () => {
    handleDeleteSponsor(idSponsor);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn khóa quảng cáo?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn vẫn có thể mở khóa quảng cáo này sau khi xác nhận!
        </Typography>
      </DialogContent>
      <DialogActions>
        <Button color="error" onClick={onClose}>
          Hủy
        </Button>
        <Button color="primary" onClick={onConfirm} autoFocus>
          Xác Nhận
        </Button>
      </DialogActions>
    </Dialog>
  );
}
