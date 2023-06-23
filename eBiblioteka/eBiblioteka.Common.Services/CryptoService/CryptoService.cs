using System.Text;
using System.Security.Cryptography;

using Microsoft.AspNetCore.Cryptography.KeyDerivation;

namespace eBiblioteka.Shared.Services
{
    public class CryptoService : ICryptoService
    {
        public string GenerateHash(string input, string salt)
        {
            var valueBytes = KeyDerivation.Pbkdf2(
                password: input,
                salt: Encoding.UTF8.GetBytes(salt),
                prf: KeyDerivationPrf.HMACSHA512,
                iterationCount: 10000,
                numBytesRequested: 256 / 8
            );

            return Convert.ToBase64String(valueBytes);
        }

        public string GenerateSalt()
        {
            byte[] randomBytes = new byte[128 / 8];

            using (var generator = RandomNumberGenerator.Create())
            {
                generator.GetBytes(randomBytes);
                return Convert.ToBase64String(randomBytes);
            }
        }
        public bool Verify(string hash, string salt, string input)
        {
            var genHash = GenerateHash(input, salt);
            return genHash == hash;
        }
    }
}
