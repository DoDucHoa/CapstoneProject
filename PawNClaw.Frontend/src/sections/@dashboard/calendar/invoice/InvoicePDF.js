import PropTypes from 'prop-types';
import { Page, View, Text, Document } from '@react-pdf/renderer';
// utils
import { fNumber } from '../../../../utils/formatNumber';
import { fVNDate } from '../../../../utils/formatTime';
//
import styles from './InvoiceStyle';

// ----------------------------------------------------------------------

InvoicePDF.propTypes = {
  invoice: PropTypes.object.isRequired,
  petData: PropTypes.array.isRequired,
  supplyOrders: PropTypes.array,
  serviceOrders: PropTypes.array,
  centerName: PropTypes.string,
};

export default function InvoicePDF({ invoice, petData, supplyOrders, serviceOrders, centerName }) {
  // const logoUrl = centerInfo.photos[0].url;

  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <View style={[styles.gridContainerCenter, styles.mb8]}>
          <Text style={styles.h1}>Hóa Đơn</Text>
        </View>
        <View style={[styles.gridContainer, styles.mb8]}>
          {/* <Image source={logoUrl} style={{ height: 32 }} /> */}
          <View style={styles.col6}>
            <Text style={styles.h5}>Thương hiệu</Text>
            <Text style={styles.title}>{centerName}</Text>
          </View>
          <View style={{ alignItems: 'flex-end', flexDirection: 'column' }}>
            <Text style={styles.h5}>Số chứng từ</Text>
            <Text style={styles.body1}> {invoice.id} </Text>
          </View>
        </View>

        <View style={[styles.gridContainer, styles.mb20]}>
          <View style={styles.col6}>
            <Text style={[styles.overline, styles.mb8]}>Khách hàng</Text>
            <Text style={styles.body1}>{invoice.customer.name}</Text>
          </View>
          <View style={styles.col6}>
            <Text style={[styles.overline, styles.mb8]}>Ngày xuất hóa đơn</Text>
            <Text style={styles.body1}>{fVNDate(new Date())}</Text>
          </View>
        </View>

        <View style={[styles.gridContainer, styles.mb20]}>
          <View style={styles.col6}>
            <Text style={[styles.overline, styles.mb8]}>Ngày bắt đầu đặt lịch</Text>
            <Text style={styles.body1}>{fVNDate(invoice.startBooking)}</Text>
          </View>
          <View style={styles.col6}>
            <Text style={[styles.overline, styles.mb8]}>Ngày kết thúc đặt lịch</Text>
            <Text style={styles.body1}>{fVNDate(invoice.endBooking)}</Text>
          </View>
        </View>

        <Text style={styles.h4}>Thông tin thuê chuồng</Text>
        <View style={styles.table}>
          <View style={styles.tableHeader}>
            <View style={styles.tableRow}>
              <View style={styles.tableCell_1}>
                <Text style={styles.subtitle2}>STT</Text>
              </View>

              <View style={styles.tableCell_2}>
                <Text style={styles.subtitle2}>Mã chuồng</Text>
              </View>

              <View style={[styles.tableCell_4, styles.alignRight]}>
                <Text style={styles.subtitle2}>Số lượng thú cưng</Text>
              </View>

              <View style={[styles.tableCell_3, styles.alignRight]}>
                <Text style={styles.subtitle2}>Thời lượng</Text>
              </View>

              <View style={[styles.tableCell_3, styles.alignRight]}>
                <Text style={styles.subtitle2}>Tổng cộng</Text>
              </View>
            </View>
          </View>
          <View style={styles.tableBody}>
            {petData.map((row, index) => (
              <View style={styles.tableRow} key={index}>
                <View style={styles.tableCell_1}>
                  <Text>{index + 1}</Text>
                </View>

                <View style={styles.tableCell_2}>
                  <Text>{row.cageCode}</Text>
                </View>

                <View style={[styles.tableCell_4, styles.alignRight]}>
                  <Text>{petData[index]?.petBookingDetails?.length}</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.body2}>{fNumber(row.duration)} ngày</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text>{fNumber(row.price)} ₫</Text>
                </View>
              </View>
            ))}
          </View>
        </View>

        <Text style={[styles.h4, styles.mt30]}>Thông tin đồ dùng</Text>
        {supplyOrders.length > 0 ? (
          <View style={styles.table}>
            <View style={styles.tableHeader}>
              <View style={styles.tableRow}>
                <View style={styles.tableCell_1}>
                  <Text style={styles.subtitle2}>STT</Text>
                </View>

                <View style={styles.tableCell_2}>
                  <Text style={styles.subtitle2}>Tên đồ dùng</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Giá bán</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Số lượng</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Tổng cộng</Text>
                </View>
              </View>
            </View>

            <View style={styles.tableBody}>
              {supplyOrders.map((row, index) => (
                <View style={styles.tableRow} key={index}>
                  <View style={styles.tableCell_1}>
                    <Text>{index + 1}</Text>
                  </View>

                  <View style={styles.tableCell_2}>
                    <Text>{row.supply.name}</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.sellPrice)} ₫</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.quantity)}</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.totalPrice)} ₫</Text>
                  </View>
                </View>
              ))}
            </View>
          </View>
        ) : (
          <View style={styles.body2}>
            <View style={styles.col6}>
              <Text>Không có đồ dùng</Text>
            </View>
          </View>
        )}

        <Text style={[styles.h4, styles.mt30]}>Thông tin dịch vụ</Text>
        {serviceOrders.length > 0 ? (
          <View style={styles.table}>
            <View style={styles.tableHeader}>
              <View style={styles.tableRow}>
                <View style={styles.tableCell_1}>
                  <Text style={styles.subtitle2}>STT</Text>
                </View>

                <View style={styles.tableCell_2}>
                  <Text style={styles.subtitle2}>Tên dịch vụ</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Giá bán</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Số lượng</Text>
                </View>

                <View style={[styles.tableCell_3, styles.alignRight]}>
                  <Text style={styles.subtitle2}>Tổng cộng</Text>
                </View>
              </View>
            </View>

            <View style={styles.tableBody}>
              {serviceOrders.map((row, index) => (
                <View style={styles.tableRow} key={index}>
                  <View style={styles.tableCell_1}>
                    <Text>{index + 1}</Text>
                  </View>

                  <View style={styles.tableCell_2}>
                    <Text>{row.service.name}</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.sellPrice)} ₫</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.quantity)}</Text>
                  </View>

                  <View style={[styles.tableCell_3, styles.alignRight]}>
                    <Text>{fNumber(row.totalPrice)} ₫</Text>
                  </View>
                </View>
              ))}
            </View>
          </View>
        ) : (
          <View style={styles.body2}>
            <View style={styles.col6}>
              <Text>Không có dịch vụ</Text>
            </View>
          </View>
        )}

        <View style={[styles.tableRow, styles.noBorder, styles.mt20]}>
          <View style={styles.tableCell_1} />
          <View style={styles.tableCell_2} />
          <View style={styles.tableCell_3} />
          <View style={styles.tableCell_3}>
            <Text>Tổng thuê chuồng</Text>
          </View>
          <View style={[styles.tableCell_3, styles.alignRight]}>
            <Text>{fNumber(invoice.totalCage)} ₫</Text>
          </View>
        </View>

        <View style={[styles.tableRow, styles.noBorder]}>
          <View style={styles.tableCell_1} />
          <View style={styles.tableCell_2} />
          <View style={styles.tableCell_3} />
          <View style={styles.tableCell_3}>
            <Text>Tổng đồ dùng</Text>
          </View>
          <View style={[styles.tableCell_3, styles.alignRight]}>
            <Text>{fNumber(invoice.totalSupply)} ₫</Text>
          </View>
        </View>

        <View style={[styles.tableRow, styles.noBorder]}>
          <View style={styles.tableCell_1} />
          <View style={styles.tableCell_2} />
          <View style={styles.tableCell_3} />
          <View style={styles.tableCell_3}>
            <Text>Tổng dịch vụ</Text>
          </View>
          <View style={[styles.tableCell_3, styles.alignRight]}>
            <Text>{fNumber(invoice.totalService)} ₫</Text>
          </View>
        </View>

        <View style={[styles.tableRow, styles.noBorder]}>
          <View style={styles.tableCell_1} />
          <View style={styles.tableCell_2} />
          <View style={styles.tableCell_3} />
          <View style={styles.tableCell_3}>
            <Text>Tổng tiền</Text>
          </View>
          <View style={[styles.tableCell_3, styles.alignRight]}>
            <Text>{fNumber(invoice.subTotal)} ₫</Text>
          </View>
        </View>

        {invoice?.voucherCodeNavigation && (
          <>
            <View style={[styles.tableRow, styles.noBorder]}>
              <View style={styles.tableCell_1} />
              <View style={styles.tableCell_2} />
              <View style={styles.tableCell_3} />
              <View style={styles.tableCell_3}>
                <Text>Chiết khấu</Text>
              </View>
              <View style={[styles.tableCell_3, styles.alignRight]}>
                <Text>-{fNumber(invoice.discount)} ₫</Text>
              </View>
            </View>
          </>
        )}

        <View style={[styles.tableRow, styles.noBorder, styles.mt10]}>
          <View style={styles.tableCell_1} />
          <View style={styles.tableCell_2} />
          <View style={styles.tableCell_3} />
          <View style={[styles.tableCell_5]}>
            <Text style={styles.h4}>Tổng thanh toán</Text>
          </View>
          <View style={[styles.tableCell_3, styles.alignRight]}>
            <Text style={styles.h4}>{fNumber(invoice.total)} ₫</Text>
          </View>
        </View>
      </Page>
    </Document>
  );
}
