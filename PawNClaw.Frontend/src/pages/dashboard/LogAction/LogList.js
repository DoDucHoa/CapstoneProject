import PropTypes from 'prop-types';
import { useState, useEffect } from 'react';

// @mui
import { Table, TableBody, Container, TableContainer, TableHead, TableRow, TableCell, Paper } from '@mui/material';

// routes
import { PATH_DASHBOARD } from '../../../routes/paths';

// hooks
import useSettings from '../../../hooks/useSettings';
import useTable from '../../../hooks/useTable';

// components
import Page from '../../../components/Page';
import Scrollbar from '../../../components/Scrollbar';
import HeaderBreadcrumbs from '../../../components/HeaderBreadcrumbs';

// sections
import { LogTableRow } from '../../../sections/@dashboard/logAction/list';
import axios from '../../../utils/axios';

// ----------------------------------------------------------------------

const TABLE_HEAD = [
  { id: 'id', label: 'ID', align: 'left' },
  { id: 'target', label: 'Đối tượng', align: 'left' },
  { id: 'name', label: 'Người thực hiện', align: 'left' },
  { id: 'type', label: 'Loại thực hiện', align: 'left' },
  { id: 'time', label: 'Thời gian', align: 'left' },
];

// ----------------------------------------------------------------------

export default function UserList() {
  const [tableData, setTableData] = useState([]);
  const [metadata, setMetadata] = useState({});

  const {
    page,
    order,
    orderBy,
    rowsPerPage,
    //
  } = useTable();

  const getLogData = async () => {
    const logResponse = await fetchLog();

    const logs = logResponse.map((log) => ({
      id: log.id,
      target: log.target,
      name: log.name,
      type: log.type,
      time: log.time,
    }));
    setTableData(logs);
    setMetadata(metadata);
  };

  useEffect(() => {
    getLogData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, rowsPerPage]);

  const { themeStretch } = useSettings();

  return (
    <>
      <Page title="Log">
        <Container maxWidth={themeStretch ? false : 'lg'}>
          <HeaderBreadcrumbs
            heading="Log"
            links={[{ name: 'Trang chủ', href: PATH_DASHBOARD.root }, { name: 'Log' }]}
          />

          <Scrollbar>
            <TableContainer component={Paper}>
              <Table>
                <TableHeadCustom order={order} orderBy={orderBy} headLabel={TABLE_HEAD} />

                <TableBody>
                  {tableData.map((row, index) => (
                    <LogTableRow key={index} row={row} />
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>
        </Container>
      </Page>
    </>
  );
}

// ----------------------------------------------------------------------
async function fetchLog() {
  try {
    const response = await axios.get('/api/log');
    return response.data;
  } catch (error) {
    throw new Error(error);
  }
}

// ----------------------------------------------------------------------

TableHeadCustom.propTypes = {
  orderBy: PropTypes.string,
  headLabel: PropTypes.array,
  order: PropTypes.oneOf(['asc', 'desc']),
  sx: PropTypes.object,
};

function TableHeadCustom({ order, orderBy, headLabel, sx }) {
  return (
    <TableHead sx={sx}>
      <TableRow>
        {headLabel.map((headCell) => (
          <TableCell
            key={headCell.id}
            align={headCell.align || 'left'}
            sortDirection={orderBy === headCell.id ? order : false}
            sx={{ width: headCell.width, minWidth: headCell.minWidth }}
          >
            {headCell.label}
          </TableCell>
        ))}
      </TableRow>
    </TableHead>
  );
}
