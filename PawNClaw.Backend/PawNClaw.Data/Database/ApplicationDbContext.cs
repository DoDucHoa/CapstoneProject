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
        public virtual DbSet<BookingActivity> BookingActivities { get; set; }
        public virtual DbSet<BookingDetail> BookingDetails { get; set; }
        public virtual DbSet<BookingStatus> BookingStatuses { get; set; }
        public virtual DbSet<Brand> Brands { get; set; }
        public virtual DbSet<Cage> Cages { get; set; }
        public virtual DbSet<CageType> CageTypes { get; set; }
        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<Customer> Customers { get; set; }
        public virtual DbSet<CustomerAddress> CustomerAddresses { get; set; }
        public virtual DbSet<District> Districts { get; set; }
        public virtual DbSet<FoodSchedule> FoodSchedules { get; set; }
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
        public virtual DbSet<ServicePrice> ServicePrices { get; set; }
        public virtual DbSet<SponsorBanner> SponsorBanners { get; set; }
        public virtual DbSet<Staff> Staffs { get; set; }
        public virtual DbSet<Supply> Supplies { get; set; }
        public virtual DbSet<SupplyOrder> SupplyOrders { get; set; }
        public virtual DbSet<SupplyType> SupplyTypes { get; set; }
        public virtual DbSet<Voucher> Vouchers { get; set; }
        public virtual DbSet<VoucherType> VoucherTypes { get; set; }
        public virtual DbSet<Ward> Wards { get; set; }

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
                    .HasDefaultValueSql("('CUS')");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.RoleCodeNavigation)
                    .WithMany(p => p.Accounts)
                    .HasForeignKey(d => d.RoleCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Accounts__role_c__251C81ED");
            });

            modelBuilder.Entity<Admin>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Admin)
                    .HasForeignKey<Admin>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Admins__id__66603565");
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
                    .HasConstraintName("FK__Bookings__center__6AEFE058");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Bookings__custom__69FBBC1F");

                entity.HasOne(d => d.Status)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.StatusId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Bookings__status__681373AD");

                entity.HasOne(d => d.VoucherCodeNavigation)
                    .WithMany(p => p.Bookings)
                    .HasForeignKey(d => d.VoucherCode)
                    .HasConstraintName("FK__Bookings__vouche__690797E6");
            });

            modelBuilder.Entity<BookingActivity>(entity =>
            {
                entity.Property(e => e.ProvideTime).HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.BookingDetail)
                    .WithMany(p => p.BookingActivities)
                    .HasForeignKey(d => d.BookingDetailId)
                    .HasConstraintName("FK__BookingAc__booki__689D8392");

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.BookingActivities)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__BookingAc__booki__67A95F59");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.BookingActivities)
                    .HasForeignKey(d => d.PetId)
                    .HasConstraintName("FK__BookingAc__pet_i__6991A7CB");

                entity.HasOne(d => d.Service)
                    .WithMany(p => p.BookingActivities)
                    .HasForeignKey(d => d.ServiceId)
                    .HasConstraintName("FK__BookingAc__servi__6B79F03D");

                entity.HasOne(d => d.Supply)
                    .WithMany(p => p.BookingActivities)
                    .HasForeignKey(d => d.SupplyId)
                    .HasConstraintName("FK__BookingAc__suppl__6A85CC04");
            });

            modelBuilder.Entity<BookingDetail>(entity =>
            {
                entity.Property(e => e.CageCode).IsUnicode(false);

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.BookingDetails)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__BookingDe__booki__60FC61CA");

                entity.HasOne(d => d.C)
                    .WithMany(p => p.BookingDetails)
                    .HasForeignKey(d => new { d.CageCode, d.CenterId })
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__BookingDetails__60083D91");
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
                    .HasConstraintName("FK__Brands__create_u__3DB3258D");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.BrandModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Brands__modify_u__3EA749C6");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Brands)
                    .HasForeignKey(d => d.OwnerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Brands__owner_id__797309D9");
            });

            modelBuilder.Entity<Cage>(entity =>
            {
                entity.HasKey(e => new { e.Code, e.CenterId })
                    .HasName("PK_Cage");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CageType)
                    .WithMany(p => p.Cages)
                    .HasForeignKey(d => d.CageTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Cages__cage_type__2B0A656D");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Cages)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Cages__center_id__2BFE89A6");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.CageCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Cages__create_us__4B0D20AB");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.CageModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Cages__modify_us__4C0144E4");
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
                    .HasConstraintName("FK__CageTypes__cente__1AD3FDA4");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.CageTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__CageTypes__creat__473C8FC7");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.CageTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__CageTypes__modif__4830B400");
            });

            modelBuilder.Entity<City>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__City__357D4CF8389F18BC");

                entity.Property(e => e.Code).IsUnicode(false);
            });

            modelBuilder.Entity<Customer>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Customer)
                    .HasForeignKey<Customer>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Customers__id__6E01572D");
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

            modelBuilder.Entity<District>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__District__357D4CF8EA38B5CC");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CityCode).IsUnicode(false);

                entity.Property(e => e.Latitude).IsUnicode(false);

                entity.Property(e => e.Longtitude).IsUnicode(false);

                entity.HasOne(d => d.CityCodeNavigation)
                    .WithMany(p => p.Districts)
                    .HasForeignKey(d => d.CityCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__District__city_c__54CB950F");
            });

            modelBuilder.Entity<FoodSchedule>(entity =>
            {
                entity.HasOne(d => d.CageType)
                    .WithMany(p => p.FoodSchedules)
                    .HasForeignKey(d => d.CageTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__FoodSched__cage___7226EDCC");
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

                entity.Property(e => e.CityCode).IsUnicode(false);

                entity.Property(e => e.DistrictCode).IsUnicode(false);

                entity.Property(e => e.Latitude).IsUnicode(false);

                entity.Property(e => e.Longtitude).IsUnicode(false);

                entity.Property(e => e.WardCode).IsUnicode(false);

                entity.HasOne(d => d.CityCodeNavigation)
                    .WithMany(p => p.Locations)
                    .HasForeignKey(d => d.CityCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Locations__city___5B78929E");

                entity.HasOne(d => d.DistrictCodeNavigation)
                    .WithMany(p => p.Locations)
                    .HasForeignKey(d => d.DistrictCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Locations__distr__5C6CB6D7");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Location)
                    .HasForeignKey<Location>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Locations__id__03F0984C");

                entity.HasOne(d => d.WardCodeNavigation)
                    .WithMany(p => p.Locations)
                    .HasForeignKey(d => d.WardCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Locations__ward___5D60DB10");
            });

            modelBuilder.Entity<Owner>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.Owner)
                    .HasForeignKey<Owner>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Owners__id__6A30C649");
            });

            modelBuilder.Entity<Pet>(entity =>
            {
                entity.Property(e => e.PetTypeCode).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.Pets)
                    .HasForeignKey(d => d.CustomerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Pets__customer_i__367C1819");

                entity.HasOne(d => d.PetTypeCodeNavigation)
                    .WithMany(p => p.Pets)
                    .HasForeignKey(d => d.PetTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Pets__pet_type_c__37703C52");
            });

            modelBuilder.Entity<PetBookingDetail>(entity =>
            {
                entity.HasOne(d => d.BookingDetail)
                    .WithMany()
                    .HasForeignKey(d => d.BookingDetailId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetBookin__booki__62E4AA3C");

                entity.HasOne(d => d.Pet)
                    .WithMany()
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetBookin__pet_i__63D8CE75");
            });

            modelBuilder.Entity<PetCenter>(entity =>
            {
                entity.Property(e => e.CloseTime).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.OpenTime).IsUnicode(false);

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
                    .HasConstraintName("FK__PetCenter__creat__3F9B6DFF");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PetCenterModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PetCenter__modif__408F9238");
            });

            modelBuilder.Entity<PetHealthHistory>(entity =>
            {
                entity.Property(e => e.CheckedDate).HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.PetHealthHistories)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetHealth__booki__30592A6F");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.PetHealthHistories)
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__PetHealth__pet_i__2F650636");
            });

            modelBuilder.Entity<PetType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__PetTypes__357D4CF842B57910");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PetTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__PetTypes__create__4CF5691D");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PetTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PetTypes__modify__4DE98D56");
            });

            modelBuilder.Entity<Photo>(entity =>
            {
                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.PhotoType)
                    .WithMany(p => p.Photos)
                    .HasForeignKey(d => d.PhotoTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Photos__photo_ty__6F4A8121");
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
                    .HasConstraintName("FK__Prices__cage_typ__22751F6C");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PriceCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Prices__create_u__4924D839");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PriceModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Prices__modify_u__4A18FC72");

                entity.HasOne(d => d.PriceTypeCodeNavigation)
                    .WithMany(p => p.Prices)
                    .HasForeignKey(d => d.PriceTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Prices__price_ty__236943A5");
            });

            modelBuilder.Entity<PriceType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__PriceTyp__357D4CF8D672578B");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.PriceTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__PriceType__creat__436BFEE3");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.PriceTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__PriceType__modif__4460231C");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Roles__357D4CF86A02D9AA");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");
            });

            modelBuilder.Entity<Service>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.DiscountPrice).HasDefaultValueSql("((0))");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Services)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Services__center__093F5D4E");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.ServiceCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Services__create__4EDDB18F");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.ServiceModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Services__modify__4FD1D5C8");
            });

            modelBuilder.Entity<ServiceOrder>(entity =>
            {
                entity.HasKey(e => new { e.ServiceId, e.BookingId })
                    .HasName("PK_ServiceOrder");

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.ServiceOrders)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServiceOr__booki__0D0FEE32");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.ServiceOrders)
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServiceOr__pet_i__0E04126B");

                entity.HasOne(d => d.Service)
                    .WithMany(p => p.ServiceOrders)
                    .HasForeignKey(d => d.ServiceId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServiceOr__servi__0C1BC9F9");
            });

            modelBuilder.Entity<ServicePrice>(entity =>
            {
                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.ServicePriceCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__ServicePr__creat__5C37ACAD");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.ServicePriceModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__ServicePr__modif__5D2BD0E6");

                entity.HasOne(d => d.Service)
                    .WithMany(p => p.ServicePrices)
                    .HasForeignKey(d => d.ServiceId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ServicePr__servi__13BCEBC1");
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
                    .HasConstraintName("FK__SponsorBa__creat__5A4F643B");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SponsorBannerModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__SponsorBa__modif__5B438874");
            });

            modelBuilder.Entity<Staff>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.staff)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Staffs__center_i__0B91BA14");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.StaffCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Staffs__create_u__4183B671");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.StaffIdNavigation)
                    .HasForeignKey<Staff>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Staffs__id__0C85DE4D");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.StaffModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Staffs__modify_u__4277DAAA");
            });

            modelBuilder.Entity<Supply>(entity =>
            {
                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.DiscountPrice).HasDefaultValueSql("((0))");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.Property(e => e.SupplyTypeCode).IsUnicode(false);

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Supplies)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Supplies__center__7BE56230");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.SupplyCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Supplies__create__52AE4273");

                entity.HasOne(d => d.CreateUser1)
                    .WithMany(p => p.SupplyCreateUser1s)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Supplies__create__7908F585");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SupplyModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Supplies__modify__53A266AC");

                entity.HasOne(d => d.ModifyUser1)
                    .WithMany(p => p.SupplyModifyUser1s)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Supplies__modify__79FD19BE");

                entity.HasOne(d => d.SupplyTypeCodeNavigation)
                    .WithMany(p => p.Supplies)
                    .HasForeignKey(d => d.SupplyTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Supplies__supply__7AF13DF7");
            });

            modelBuilder.Entity<SupplyOrder>(entity =>
            {
                entity.HasKey(e => new { e.SupplyId, e.BookingId })
                    .HasName("PK_SupplyOrder");

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.SupplyOrders)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SupplyOrd__booki__7EC1CEDB");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.SupplyOrders)
                    .HasForeignKey(d => d.PetId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SupplyOrd__pet_i__00AA174D");

                entity.HasOne(d => d.Supply)
                    .WithMany(p => p.SupplyOrders)
                    .HasForeignKey(d => d.SupplyId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__SupplyOrd__suppl__7FB5F314");
            });

            modelBuilder.Entity<SupplyType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__SupplyTy__357D4CF89EB2CEFA");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.SupplyTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__SupplyTyp__creat__54968AE5");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.SupplyTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__SupplyTyp__modif__558AAF1E");
            });

            modelBuilder.Entity<Voucher>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Vouchers__357D4CF868D908FA");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.Property(e => e.VoucherTypeCode).IsUnicode(false);

                entity.HasOne(d => d.Center)
                    .WithMany(p => p.Vouchers)
                    .HasForeignKey(d => d.CenterId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Vouchers__center__607251E5");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.VoucherCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__Vouchers__create__58671BC9");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.VoucherModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__Vouchers__modify__595B4002");

                entity.HasOne(d => d.VoucherTypeCodeNavigation)
                    .WithMany(p => p.Vouchers)
                    .HasForeignKey(d => d.VoucherTypeCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Vouchers__vouche__6166761E");
            });

            modelBuilder.Entity<VoucherType>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__VoucherT__357D4CF861E2F723");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CreateDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.ModifyDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Status).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.CreateUserNavigation)
                    .WithMany(p => p.VoucherTypeCreateUserNavigations)
                    .HasForeignKey(d => d.CreateUser)
                    .HasConstraintName("FK__VoucherTy__creat__567ED357");

                entity.HasOne(d => d.ModifyUserNavigation)
                    .WithMany(p => p.VoucherTypeModifyUserNavigations)
                    .HasForeignKey(d => d.ModifyUser)
                    .HasConstraintName("FK__VoucherTy__modif__5772F790");
            });

            modelBuilder.Entity<Ward>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK__Ward__357D4CF82CE5E29A");

                entity.Property(e => e.Code).IsUnicode(false);

                entity.Property(e => e.CityCode).IsUnicode(false);

                entity.Property(e => e.DistrictCode).IsUnicode(false);

                entity.HasOne(d => d.CityCodeNavigation)
                    .WithMany(p => p.Wards)
                    .HasForeignKey(d => d.CityCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Ward__city_code__59904A2C");

                entity.HasOne(d => d.DistrictCodeNavigation)
                    .WithMany(p => p.Wards)
                    .HasForeignKey(d => d.DistrictCode)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Ward__district_c__5A846E65");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
