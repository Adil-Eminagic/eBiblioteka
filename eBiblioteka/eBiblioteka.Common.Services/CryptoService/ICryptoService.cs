namespace eBiblioteka.Shared.Services
{
    public interface ICryptoService
    {
        string GenerateSalt();
        string GenerateHash(string input, string salt);
        bool Verify(string hash, string salt, string input);
    }
}
