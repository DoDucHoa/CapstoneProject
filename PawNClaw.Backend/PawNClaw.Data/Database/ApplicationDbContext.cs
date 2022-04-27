using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext()
        {
        }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Account> Accounts { get; set; }
        public virtual DbSet<Admin> Admins { get; set; }
        public virtual DbSet<Booking> Bookings { get; set; }
        public virtual DbSet<BookingDetail> BookingDetails { get; set; }
        public virtual DbSet<BookingStatus> BookingStatuses { get; set; }
        public virtual DbSet<Brand> Brands { get; set; }
        public virtual DbSet<Cage> Cages { get; set; }
        public virtual DbSet<CageType> CageTypes { get; set; }
        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<CustomerAddress> CustomerAddresses { get; set; }
        public virtual DbSet<GeneralLedger> GeneralLedgers { get; set; }
        public virtual DbSet<Location> Locations { get; set; }
        public virtual DbSet<Owner> Owners { get; set; }
        public virtual DbSet<Pet> Pets { get; set; }
        public virtual DbSet<PetBookingDetail> PetBookingDetails { get; set; }
        public virtual DbSet<PetCenter> PetCenters { get; set; }
        public virtual DbSet<PetHealthHistory> PetHealthHistories { get; set; }
        public virtual DbSet<PetType> PetTypes { get; set; }
        public virtual DbSet<Photo> Photos { get; set; }
        public virtual DbSet<PhotoType> PhotoTypes { get; set; }
        public virtual DbSet<Price> Prices { get; set; }
        public virtual DbSet<PriceType> PriceTypes { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Service> Services { get; set; }
        public virtual DbSet<ServiceOrder> ServiceOrders { get; set; }
        public virtual DbSet<SponsorBanner> SponsorBanners { get; set; }
        public virtual DbSet<Supply> Supplies { get; set; }
        public virtual DbSet<SupplyOrder> SupplyOrders { get; set; }
        public virtual DbSet<SupplyType> SupplyTypes { get; set; }
        public virtual DbSet<Voucher> Vouchers { get; set; }
        public virtual DbSet<VoucherType> VoucherTypes { get; set; }
        public virtual DbSet<Staff> Staff { get; set; }

//        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//        {
//            if (!optionsBuilder.IsConfigured)
//            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//                optionsBuilder.UseSqlServer("Server=pawnclaw.database.windows.net;Database=PawNClaw;User Id=pawnclaw;Password=Sa123321;");
//            }
//        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "SQL_Latin1_General_CP1_CI_AS");

            modelBuilder.Entity<Account>(entity =>
            {
                entity.Property(e => e.CreatedUser).HasDefaultValueSql("((0))");

                entity.Property(e => e.DeviceId).IsUnicode(false);

                entity.Property(e => e.Phone).IsUnicode(false);

                entity.Property(e => e.RoleCode)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('CUS')")
                    .IsFixedLength(true);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.RoleCodeNavigation)
                    .WithMany(p => p.Accounts)
                    .HasForeignKey(d => d.RoleCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Account__role_co__628FA481");
            });

            modelBuilder.Entity<Admin>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Admin)
                    .HasForeignKey<Admin>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Admin__id__66603565");
            });

            modelBuilder.Entity<Booking>(entity =>
            {
                entity.Property(e => e.CreateTime).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.StatusId).HasDefaultValueSql("((1))");

                entity.Property(e => e.VoucherCode).IsUnicode(false);

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Booking__center___6AEFE058");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Booking__custome__69FBBC1F");

                entity.HasOne(d => d.Status)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.StatusId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Booking__status___681373AD");

                entity.HasOne(d => d.VoucherCodeNavigation)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.VoucherCode)
                    .HasConstraintName("FK__Booking__voucher__690797E6");
            });

            modelBuilder.Entity<BookingDetail>(entity =>
            {
                entity.HasKey(e => new { e.BookingId, e.Line });

                entity.Property(e => e.CageCode).IsUnicode(false);

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.BookingDetails)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__BookingDe__booki__76619304");

                entity.HasOne(d => d.C)
                    .WithMany(p => p.BookingDetails)
                    .HasForeignKey(d => new { d.CageCode, d.CenterId })
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__BookingDetail__756D6ECB");
            });

            modelBuilder.Entity<BookingStatus>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();
            });

            modelBuilder.Entity<Brand>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.BrandCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Brand__create_us__778AC167");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.BrandModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Brand__modify_us__787EE5A0");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Brands)
                    .HasForeignKey(d => d.OwnerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Brand__owner_id__797309D9");
            });

            modelBuilder.Entity<Cage>(entity =>
            {
                entity.HasKey(e => new { e.Code, e.CenterId });

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CageType)
                    .WithMany(p => p.Cages)
                    .HasForeignKey(d => d.CageTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Cage__cage_type___2B0A656D");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Cages)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Cage__center_id__2BFE89A6");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.CageCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Cage__create_use__29221CFB");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.CageModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Cage__modify_use__2A164134");
            });

            modelBuilder.Entity<CageType>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.CageTypes)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__CageType__center__1AD3FDA4");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.CageTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__CageType__create__18EBB532");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.CageTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__CageType__modify__19DFD96B");
            });

            modelBuilder.Entity<Customer>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Customer)
                    .HasForeignKey<Customer>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Customer__id__6E01572D");
            });

            modelBuilder.Entity<CustomerAddress>(entity =>
            {
                entity.Property(e => e.Latitude).IsUnicode(false);

                entity.Property(e => e.Longtitude).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.CustomerAddresses)
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__CustomerA__custo__71D1E811");
            });

            modelBuilder.Entity<GeneralLedger>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.GeneralLedgers)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__GeneralLe__cente__7A3223E8");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.GeneralLedger)
                    .HasForeignKey<GeneralLedger>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__GeneralLedge__id__793DFFAF");
            });

            modelBuilder.Entity<Location>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Latitude).IsUnicode(false);

                entity.Property(e => e.Longtitude).IsUnicode(false);

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Location)
                    .HasForeignKey<Location>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Location__id__03F0984C");
            });

            modelBuilder.Entity<Owner>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Owner)
                    .HasForeignKey<Owner>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Owner__id__6A30C649");
            });

            modelBuilder.Entity<Pet>(entity =>
            {
                entity.Property(e => e.PetTypeCode).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.Pets)
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Pet__customer_id__367C1819");

                entity.HasOne(d => d.PetTypeCodeNavigation)
                    .WithMany(p => p.Pets)
                    .HasForeignKey(d => d.PetTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Pet__pet_type_co__37703C52");
            });

            modelBuilder.Entity<PetBookingDetail>(entity =>
            {
                entity.HasKey(e => new { e.BookingId, e.Line, e.PetId });

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.PetBookingDetails)
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetBookin__pet_i__7E02B4CC");

                entity.HasOne(d => d.BookingDetail)
                    .WithMany(p => p.PetBookingDetails)
                    .HasForeignKey(d => new { d.BookingId, d.Line })
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetBookingDetail__7D0E9093");
            });

            modelBuilder.Entity<PetCenter>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Phone).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Brand)
                    .WithMany(p => p.PetCenters)
                    .HasForeignKey(d => d.BrandId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetCenter__brand__01142BA1");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PetCenterCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__PetCenter__creat__7F2BE32F");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PetCenterModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PetCenter__modif__00200768");
            });

            modelBuilder.Entity<PetHealthHistory>(entity =>
            {
                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.PetHealthHistories)
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetHealth__pet_i__3A4CA8FD");
            });

            modelBuilder.Entity<PetType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__PetType__357D4CF8469BEF28");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PetTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__PetType__create___31B762FC");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PetTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PetType__modify___32AB8735");
            });

            modelBuilder.Entity<Photo>(entity =>
            {
                entity.HasKey(e => new { e.PhotoTypeId, e.IdActor, e.Line });

                entity.Property(e => e.Line).ValueGeneratedOnAdd();

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.PhotoType)
                    .WithMany(p => p.Photos)
                    .HasForeignKey(d => d.PhotoTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Photo__photo_typ__04AFB25B");
            });

            modelBuilder.Entity<PhotoType>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");
            });

            modelBuilder.Entity<Price>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.PriceTypeCode).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CageType)
                    .WithMany(p => p.Prices)
                    .HasForeignKey(d => d.CageTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Price__cage_type__22751F6C");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PriceCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Price__create_us__208CD6FA");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PriceModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Price__modify_us__2180FB33");

                entity.HasOne(d => d.PriceTypeCodeNavigation)
                    .WithMany(p => p.Prices)
                    .HasForeignKey(d => d.PriceTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Price__price_typ__236943A5");
            });

            modelBuilder.Entity<PriceType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__PriceTyp__357D4CF8A4FAE60E");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PriceTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__PriceType__creat__123EB7A3");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PriceTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PriceType__modif__1332DBDC");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Role__357D4CF89F812551");

                entity.Property(e => e.Code)
                    .IsUnicode(false)
                    .IsFixedLength(true);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");
            });

            modelBuilder.Entity<Service>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Service__357D4CF8A4702825");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.DiscountPrice).HasDefaultValueSql("((0))");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Services)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Service__center___42E1EEFE");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.ServiceCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Service__create___40F9A68C");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.ServiceModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Service__modify___41EDCAC5");
            });

            modelBuilder.Entity<ServiceOrder>(entity =>
            {
                entity.HasKey(e => new { e.ServiceCode, e.BookingId });

                entity.Property(e => e.ServiceCode).IsUnicode(false);

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.ServiceOrders)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServiceOr__booki__72910220");

                entity.HasOne(d => d.ServiceCodeNavigation)
                    .WithMany(p => p.ServiceOrders)
                    .HasForeignKey(d => d.ServiceCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServiceOr__servi__719CDDE7");
            });

            modelBuilder.Entity<SponsorBanner>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Brand)
                    .WithMany(p => p.SponsorBanners)
                    .HasForeignKey(d => d.BrandId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SponsorBa__brand__0C50D423");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.SponsorBannerCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__SponsorBa__creat__0A688BB1");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SponsorBannerModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__SponsorBa__modif__0B5CAFEA");
            });

            modelBuilder.Entity<Supply>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Supply__357D4CF800C4C58E");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.DiscountPrice).HasDefaultValueSql("((0))");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.Property(e => e.SupplyTypeCode).IsUnicode(false);

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.SupplyCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Supply__create_u__503BEA1C");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SupplyModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Supply__modify_u__51300E55");

                entity.HasOne(d => d.SupplyTypeCodeNavigation)
                    .WithMany(p => p.Supplies)
                    .HasForeignKey(d => d.SupplyTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Supply__supply_t__5224328E");
            });

            modelBuilder.Entity<SupplyOrder>(entity =>
            {
                entity.HasKey(e => new { e.SupplyCode, e.BookingId });

                entity.Property(e => e.SupplyCode).IsUnicode(false);

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.SupplyOrders)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SupplyOrd__booki__6DCC4D03");

                entity.HasOne(d => d.SupplyCodeNavigation)
                    .WithMany(p => p.SupplyOrders)
                    .HasForeignKey(d => d.SupplyCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SupplyOrd__suppl__6EC0713C");
            });

            modelBuilder.Entity<SupplyType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__SupplyTy__357D4CF8A03372CA");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.SupplyTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__SupplyTyp__creat__0F2D40CE");

                entity.HasOne(d => d.CreateUser1)
                    .WithMany(p => p.SupplyTypeCreateUser1s)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__SupplyTyp__creat__489AC854");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SupplyTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__SupplyTyp__modif__10216507");

                entity.HasOne(d => d.ModifyUser1)
                    .WithMany(p => p.SupplyTypeModifyUser1s)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__SupplyTyp__modif__498EEC8D");
            });

            modelBuilder.Entity<Voucher>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Voucher__357D4CF82C36A9C8");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.Property(e => e.VoucherTypeCode).IsUnicode(false);

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Vouchers)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Voucher__center___607251E5");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.VoucherCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Voucher__create___5E8A0973");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.VoucherModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Voucher__modify___5F7E2DAC");

                entity.HasOne(d => d.VoucherTypeCodeNavigation)
                    .WithMany(p => p.Vouchers)
                    .HasForeignKey(d => d.VoucherTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Voucher__voucher__6166761E");
            });

            modelBuilder.Entity<VoucherType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__VoucherT__357D4CF87E3A3AAB");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.VoucherTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__VoucherTy__creat__1B9317B3");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.VoucherTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__VoucherTy__modif__1C873BEC");
            });

            modelBuilder.Entity<Staff>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Staff)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Staff__center_id__0B91BA14");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.StaffCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Staff__create_us__09A971A2");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Staff)
                    .HasForeignKey<Staff>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Staff__id__0C85DE4D");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.StaffModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Staff__modify_us__0A9D95DB");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
