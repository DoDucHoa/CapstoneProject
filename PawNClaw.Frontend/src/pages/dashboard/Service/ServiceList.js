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
import useAuth from '../../../hooks/useAuth';

// components
import Page from '../../../components/Page';
import Iconify from '../../../components/Iconify';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';
import { TableEmptyRows, TableHeadCustom, TableNoData } from '../../../components/table';

// sections
import { ServiceTableRow, ServiceTableToolbar } from '../../../sections/@dashboard/service/list';

// API
import { getServices, deleteService } from './useServiceAPI';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'name', label: 'Tên dịch vụ', align: 'left' },
  { id: 'description', label: 'Mô tả', align: 'left' },
  { id: 'createDate', label: 'Ngày tạo', align: 'center' },
  { id: 'status', label: 'Trạng thái', align: 'center' },
  { id: '' },
];

// ----------------------------------------------------------------------

export default function ServiceList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});
  const [filterName, setFilterName] = useState('');
  const [searchRequest, setSearchRequest] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectIdService, setSelectIdService] = useState();

  const {
    page,
    order,
    orderBy,
    rowsPerPage,
    setPage,
    //
    onSort,
    onChangePage,
    onChangeRowsPerPage,
  } = useTable();

  const { centerId } = useAuth();

  const getServiceData = async () => {
    const response = await getServices(centerId, page, rowsPerPage, searchRequest);

    const { data, metadata } = response;

    const services = data.map((service) => ({
      id: service.id,
      description: service.description,
      status: service.status,
      centerId: service.centerId,
      name: service.name,
      createDate: service.createDate,
      photoUrl: service?.photos?.length > 0 ? service?.photos[0].url : '',
    }));

    setTableData(services);
    setMetadata(metadata);
  };

  useEffect(() => {
    getServiceData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [centerId, page, rowsPerPage, searchRequest]);

  const { themeStretch } = useSettings();

  const navigate = useNavigate();

  const handleFilterName = (filterName) => {
    setFilterName(filterName);
  };

  const handleSearchRequest = (name) => {
    setSearchRequest(name);
    setPage(0);
  };

  const handleEditRow = (id) => {
    navigate(PATH_DASHBOARD.service.edit(id));
  };

  const handleDeleteService = async (id) => {
    await deleteService(id);
    await getServiceData();
  };

  const handleOpenDeleteServiceDialog = (idService) => {
    setSelectIdService(idService);
    setOpenDialog(true);
  };

  const handleCloseDeleteServiceDialog = () => {
    setOpenDialog(false);
  };

  const denseHeight = 72;

  const isNotFound = !metadata?.totalCount;

  return (
    <>
      <Page title="Dịch vụ">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Danh sách dịch vụ"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Danh sách dịch vụ' }]}
            action={
              <Button
                variant="contained"
                component={RouterLink}
                to={PATH_DASHBOARD.service.new}
                startIcon={<Iconify icon={'eva:plus-fill'} />}
              >
                Thêm mới dịch vụ
              </Button>
            }
          />

          <Card>
            {/* Filter dữ liệu */}
            <ServiceTableToolbar
              filterName={filterName}
              onFilterName={handleFilterName}
              onEnterPress={handleSearchRequest}
            />

            {/* Scrollbar dùng để tạo scroll ngang cho giao diện điện thoại */}
            <Scrollbar>
              <TableContainer sx={{ minWidth: 800, position: 'relative' }}>
                <Table size={'medium'}>
                  <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} onSort={onSort} />

                  <TableBody>
                    {tableData.map((row) => (
                      <ServiceTableRow
                        key={row.id}
                        row={row}
                        onEditRow={() => handleEditRow(row.id)}
                        onDeleteRow={() => handleOpenDeleteServiceDialog(row.id)}
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

      <DeleteServiceDialog
        open={openDialog}
        onClose={handleCloseDeleteServiceDialog}
        idService={selectIdService}
        handleDeleteService={handleDeleteService}
      />
    </>
  );
}

// ----------------------------------------------------------------------
DeleteServiceDialog.propTypes = {
  open: PropTypes.bool,
  onClose: PropTypes.func,
  idService: PropTypes.number,
  handleDeleteService: PropTypes.func,
};

function DeleteServiceDialog({ open, onClose, idService, handleDeleteService }) {
  const onConfirm = () => {
    handleDeleteService(idService);
    onClose();
  };

  return (
    <Dialog open={open} maxWidth="xs" onClose={onClose}>
      <DialogTitle>Bạn có chắc chắn muốn xóa?</DialogTitle>
      <DialogContent>
        <Typography variant="body2" sx={{ color: 'text.secondary' }}>
          Bạn không thể khôi phục lại nếu đã xóa!
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
