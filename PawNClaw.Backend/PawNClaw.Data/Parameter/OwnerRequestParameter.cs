﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class OwnerRequestParameter
    {
        public int? Id { get; set; } = null;
        public string Name { get; set; } = null;
        public string Email { get; set; } = null;
        public int? Gender { get; set; }
        public bool? Status { get; set; } = null;
        public string Phone { get; set; } = null;
        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
        public int ModifyUser { get; set; }
    }
}
