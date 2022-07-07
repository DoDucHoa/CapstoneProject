namespace PawNClaw.Data.Parameter
{
    public class CreateBrandParameter
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public int OwnerId { get; set; }
        public int CreateUser { get; set; }
        public int ModifyUser { get; set; }
    }
}