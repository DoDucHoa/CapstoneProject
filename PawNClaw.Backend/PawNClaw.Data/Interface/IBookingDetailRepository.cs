using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IBookingDetailRepository : IRepository<BookingDetail>
    {
        public IEnumerable<BookingDetail> GetBookingDetailForSearch(int Id);

        public BookingDetail GetBookingDetail(int BookingId, int Line);
    }
}
