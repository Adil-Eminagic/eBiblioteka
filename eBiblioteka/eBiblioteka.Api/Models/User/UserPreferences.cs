namespace eBiblioteka.Api
{
    public class UserPreferences
    {
        public string[] Authors { get; set; }
    }

    public class BookPrediction
    {
        public float[] Score { get; set; }
        public int[] BookId { get; set; }
    }
}
