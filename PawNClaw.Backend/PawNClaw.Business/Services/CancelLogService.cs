using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class CancelLogService
    {
        ICancelLogRepository _cancelLogRepository;

        public CancelLogService(ICancelLogRepository cancelLogRepository)
        {
            _cancelLogRepository = cancelLogRepository;
        }
    }
}
