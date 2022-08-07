import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import merge from 'lodash/merge';
import ReactApexChart from 'react-apexcharts';
// @mui
import { useTheme } from '@mui/material/styles';
import { Card, CardHeader, Stack, Box, Typography } from '@mui/material';
// utils
import { fNumber } from '../../../../utils/formatNumber';
// chart
import { BaseOptionChart } from '../../../../components/chart';
// API
import { getTotalCage } from './useOwnerDashboardAPI';

// ----------------------------------------------------------------------
BookingCageAvailable.propTypes = {
  centerId: PropTypes.number.isRequired,
  from: PropTypes.any,
  to: PropTypes.any,
};

export default function BookingCageAvailable({ centerId, from, to }) {
  const [totalCage, setTotalCage] = useState(0);
  const [totalCageAvailable, setTotalCageAvailable] = useState(0);

  const AVAILABLE = totalCageAvailable;
  const SOLD_OUT = totalCage - totalCageAvailable;
  const CHART_DATA = [totalCage === 0 ? 0 : (SOLD_OUT * 100) / totalCage];

  // HOOKS
  const theme = useTheme();

  useEffect(() => {
    getTotalCage(centerId, from, to).then((data) => {
      setTotalCage(data.totalCage);
      setTotalCageAvailable(data.totalCageAvailable);
    });
  }, [centerId, from, to]);

  const chartOptions = merge(BaseOptionChart(), {
    legend: { show: false },
    grid: {
      padding: { top: -32, bottom: -32 },
    },
    fill: {
      type: 'gradient',
      gradient: {
        colorStops: [
          [
            { offset: 0, color: theme.palette.primary.light },
            { offset: 100, color: theme.palette.primary.main },
          ],
        ],
      },
    },
    plotOptions: {
      radialBar: {
        hollow: { size: '64%' },
        dataLabels: {
          name: { offsetY: -16 },
          value: { offsetY: 8 },
          total: {
            label: 'Tổng chuồng',
            formatter: () => fNumber(totalCage),
          },
        },
      },
    },
  });

  return (
    <Card>
      <CardHeader title="Chuồng trống" sx={{ mb: 8 }} />
      <ReactApexChart type="radialBar" series={CHART_DATA} options={chartOptions} height={310} />

      <Stack spacing={2} sx={{ p: 5 }}>
        <Legend label="Đang đặt" number={SOLD_OUT} />
        <Legend label="Còn trống" number={AVAILABLE} />
      </Stack>
    </Card>
  );
}

// ----------------------------------------------------------------------

Legend.propTypes = {
  label: PropTypes.string,
  number: PropTypes.number,
};

function Legend({ label, number }) {
  return (
    <Stack direction="row" alignItems="center" justifyContent="space-between">
      <Stack direction="row" alignItems="center" spacing={1}>
        <Box
          sx={{
            width: 16,
            height: 16,
            bgcolor: 'grey.50016',
            borderRadius: 0.75,
            ...(label === 'Đang đặt' && {
              bgcolor: 'primary.main',
            }),
          }}
        />
        <Typography variant="subtitle2" sx={{ color: 'text.secondary' }}>
          {label}
        </Typography>
      </Stack>
      <Typography variant="subtitle1">{number} chuồng</Typography>
    </Stack>
  );
}
