
using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public partial class DatabaseContext
    {
        private readonly DateTime _dateTime = new(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local);


        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedBooks(modelBuilder);
            SeedPhotos(modelBuilder);
            SeedQuotes(modelBuilder);

        }

        private void SeedQuotes(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Quote>().HasData(
                new()
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Content="Citat iz tvrdjave",
                    BookId = 1,
                },
                new()
                {
                    Id = 2,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    BookId = 2,
                    Content="Citat na drini cuprija"
                }
                );
        }

        private void SeedPhotos(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Photo>().HasData(
                 new()
                 {
                     Id = 1,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                     Data= "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAM1BMVEXk5ueutLeqsbTn6eqpr7PJzc/j5ebf4eLZ3N2wtrnBxsjN0NLGysy6v8HT1tiss" +
            "ra8wMNxTKO9AAAFDklEQVR4nO2d3XqDIAxAlfivoO//tEOZ" +
            "WzvbVTEpic252W3PF0gAIcsyRVEURVEURVEURVEURVEURVEURVEURVEURVEURflgAFL/AirAqzXO9R7XNBVcy9TbuMHmxjN6lr92cNVVLKEurVfK/zCORVvW8iUBnC0" +
            "2dj+Wpu0z0Y6QlaN5phcwZqjkOkK5HZyPAjkIjSO4fIdfcOwFKkJlX4zPu7Ha1tIcwR3wWxyFhRG6g4Je0YpSPDJCV8a2Sv2zd1O1x/2WMDZCwljH+clRrHfWCLGK8REMiql//2si5+DKWKcWeAGcFMzzNrXC/0TUwQ2s6+Lhl" +
            "cwjTMlYsUIQzPOCb7YBiyHopyLXIEKPEkI/TgeuiidK/R9FniUDOjRDpvm0RhqjMyyXNjDhCfIMYl1gGjIMIuYsnGEYRMRZOMMunaLVwpWRW008v6fY" +
            "KDIzxCwVAeNSO90BJW6emelYBRF/kHpYGVaoxTDAaxOFsfP9y8hpJ4xd7gOcij7JNGQ1EYFgkPJa1jQEiYZXRaRINKxSDUW9n+FT82lSKadkiru9/4XPqSLWOekGPoY05TAvLm9orm+YWuwHoBHkZKijNBJGmeb61eL" +
            "6Ff/6q7bLr7yvv3vKGhpDRjvgjGaPz+gUg6YgcvpyAR2FIZ9U6nEEyZRTovmEU32KichpGn7C17XrfyH9gK/c0CMP05HZIM2uf9sEveizKveBy9/6Qt7o89ne33D525cfcIMW6ab+TMEukQbQbu+xu7X3A9bChmWaC" +
            "eAkG17bpntwXgWxHaMzGPmUaR5dQZiKqRVeUZ3047fi3nAu28h4CHxCsZAgmEH8Y27jJAhm8c+5RQzRQNVGhVFSfxOYIjp/pP7RxzjevYXVGf4eLt+BJ1vCuLuLkrgABgCGXZ2wik5uty+oBvNirI6mkzhAf4Gsb" +
            "58Hcm67Jzd+KwD10BYPLL3e0MjvKrgAULnOfveF/O4N2Xb9BZom3gJes3F9X5Zze8/6Yt09b4CrqsEjUv8oFBaR2rl+6CZr2xVrp24o/WitBKuGrrpl1+bFkmK2qXTON4VpbdfLa7o7y/WdLxG7lm2Lqh2clOwTeg" +
            "bvc/vj2U78CwhA87Bn8G5Nk3eOb0Nsr9flz3sG78UUtue4kpv1xvjg3TMay62BMl" +
            "TlP+vrOMnJsRmt/ze0jsfkPPYdAH57hK+34PeOyc8XIXu5xT2HsUkdZz+adwg8HGFfQ3K5jtDvbUiO4Di9/ywHGrL88pDizZ++oTp+an+SMX/ndymUCwmHMdO7yuOx83pUx/eEMU0AvxWndwgidAqOZ8ypCwdEfv" +
            "vEo6D9HwpA8wzvmOJEqAg9ySu8g4x0Hb9hSB/BANEKJ+LbPBU0lzbAJs4xt1AoshKkUGQmiH8/jJ0gdhTTLmSegHlPE0oOdXALnqDjKYh3px//fSgSWG8UqfrrIICzYYSJXRr9BSPbpNzw7gBjKjKOYI7ReIGqQRIap5" +
            "+5MdjyvuDkExvGeXSlONWZAP3/AZBwJohU7QJRGU+cTVH18ELmRPNBmibW6MT/k1b0XhdkRBvyT6SB6EYv/GvhSmRNpGngRULsAlxMCGNXp7w3FfdEbTEEDdLI9TdIKRUzUesa3I461ER8cpNT7gMRhpKmYVS9ELOgCU" +
            "Qsa4SsulciKiLbY+AnHD8cpuhISsnxpamI84sbDq9qYJgf8wiiOBrC7Ml7M7ZECCqKoiiKo" +
            "iiKoiiKoijv5AvJxlZRyNWWLwAAAABJRU5ErkJggg=="

        },
                 new()
                 {
                     Data= "iVBORw0KGgoAAAANSUhEUgAAAGwAAACFCAMAAACJ8+21AAAAUVBMVEXu7u7////w8PCfn5/MzMz4+PiioqLz8/Oc" +
                     "nJy+vr7IyMja2tr7+/uurq7g4OC1tbVmZmbU1NTm5uaDg4Nubm6oqKh2dnZ8fHyNjY2WlpZhYWFFUy57AAAG80lEQVRoge" +
                     "2aiZarKBCGAcViERAEl7z/g06hWezFLbenz5y5cvqYaAifVfxUlaQJZeSXGlDyayyk/R6K/KZdF+yCXbALdsEu2F8JY+xP7u" +
                     "7cdxmltIa3eee+WFMLyKP8vdLlFIxR7qTSJPNqft7AU98AauXUyvCWgadgNS2lIl5lHhpYn53BMzBGayc9EsCWE8+fNPAMDGi" +
                     "QcpowBITJQFVaOG7gGRinXjr6bDXTs0P97NB9xZyB0RqlQT80CJNDpbd8snd7uDPTS8E4S780ouVdMflsa8ATMKDeOf4Vli2ydw" +
                     "MDrX8GVlPl5Lesqc2K+SEYetE5v5gt8oXncUr5j8AwfDhH7rrnVAXFPsOktHRrzR2H4fhmEj7o0lsdiMw+rRcslqf0RwSSg7BRe" +
                     "W7KsrTe2NoZyYhfwPTOlB2DYcpklhJjMMFYhTC0wUg8JUot5Kkwlm1N2QEYA1y5blS0NI4ppb0vS0jGSMIRrFj5wGH6IdtbDzt" +
                     "LHklaVqMQI6NoDGSzsBEIjPl8osCEOwz1gyv8XRiD4J0QosAmKDPJ25lVak78/E6BUw8v4rtNL27BGHHFTEKWpDqlcCegQMpHI" +
                     "4+owqXbFv4mDNydlGGWuuQeXlw0bY2ZFYlU2PbiphurJ6sYaZ2SCl9YeMllSA4fbkf425aZl2GGWvSiXmC8z7L0hHIOnGIGdWj" +
                     "hTsregqmnG4WnKhmyYL1WVxYN+pc4syP8bYHYF4zQhPHiNWWTAq3GNpsJOHeu3pmy7XWWHrCKkqryegHLSZQ8zxVwafaEvw0D+" +
                     "RC+or4QzN6b1tZOK/lFK2uDi3uvytpc1Hp8Ct9Ui1Lnw3zNfgzJ7Al/BxYeXuS1qMxc5i9azZ/yDGXaFf7OnLF5WQtHdVFVonKe" +
                     "5fwVsjD0JP3HnHGMZbte3IZBOcFGTSXCsOGCU4HjelOfYglLie1vNm9bFuZJY3RmTU1UUnNmyyXO+rQv/N0UM4nfUILQFy4bWJI" +
                     "anzAeQObSvvB3YVn8KPx7LFnwKlFIy+FuIK+qcGDLfgdm0aQx0PRINR94RWXwOQbrRW+rdMCLe2UBE1NgJMqIFR7mAlLL4oDwd2" +
                     "FTTqtyuADvqm95VZFcKvS+8Pct82LKMCo/FfEgU/E9UGwXjAdhs/ix4ElS5wVN/LcOTUe8uFvKwTPyi3E0Za64uZYv3n2xb9f4h" +
                     "2GvDDoZWEzJhQaVxoWB4ojw92GLDPoEOk/uBo7iUaIcEP6BihiKzw0RzvN6NtBkA7HQO+LFAzAnPhqGSiF5u4zN2wTMuxypjz0z" +
                     "7Hbwr0oEk1oZCLx25thUn0I4Ej4Owe4ZVBSYzgJ82e+YDTy27bJvPmShi6Ts0qRPgxx8yjvQDZ9jym9MeqMdWh5/tn96DvZj7YJ" +
                     "dsAt2wS7YBcsNOGdYZECuNPDk3pFzPM0Xp4/zOcydp674EefrvySsf1B2bWA+SgDVN81g555xYLrrFGOq6zTm1Ni5TM5dOsNt7L" +
                     "uut2uDbsBiNNzfHFdNq1yMIZdv5IawGFvO2xgRJvE91jyy6SXWyFw3rTEmvANru5BhbdTAZWPgCRuing4M2i41nrEuhuxWphsBG" +
                     "9XKBqxxfaVvjnR47zjM+IQ1ZkjVYBoN4VbpWHF7G4BJqYhturYd1obchCkZZfOAxfHpxsapGJVDmGlKaPswwdCvwWY3urdgEgeK" +
                     "dze6hRsbw2PkaBnrY9d1sYTsRjp2CBP1e2psJC8bhJVN50wTCVvAvM8wfRuUdHGo5a1zss+W9fi09oYafauAVYNk4IfYibvEWsF" +
                     "sK7E2BtlaN2jUgxgCL4euw652yO08bP5ln8F0eEkM2KNkZY93+Th1gY9dz8D+hfY3wqYZmSfueSDPa48O8wssO6w/hqzCQA5jYKb" +
                     "V2EMMhFdDhRzVSi5bPw0bhkEBQTEOg8AwOWJ3wnSWY3sWxvuIq7q8JWD6NnLSxGhzxHU8NYpNd9PEtiYcw2OKN8b6DiWPaaJPVXES" +
                     "hvFJtANA7IBX0ePIKRpYwljbisYyhBE63ALr+zDBBF3dp1iDQbpZES1gUCd9j/cfWd+SBQzvprI3Awjr+5j4E4ahuF3ZqFiFxRYDls" +
                     "EMVXl8sbcCIX4Bw9so0XUZZkzfvSxrU5VWnufXHsnLmG+4B973IwZiM52KeoaVHMMEftp30deY9ajD6UUYRg8fR1rXa6OuGCYa59yA" +
                     "k4U5esizL53rOzLBojBJ4qgO43OBMON6NLrvkkleR0wyaSVXr13tWg7cxwQWOXi/CU9NLBVmAYMWdaKKGi+hH4c+x2BgQ74sdT7GlV" +
                     "C8ZjDn0xHmWmoqsrCEAvzLdRXPP5rNxRWZz8j9dbO++o+Eqwt2wS7YBbtgF+yCXbD/DewXcbD7/0s/yKL/AANtY9FhG0NOAAAAAElFT" +
                     "kSuQmCC",
                     Id = 2,
                     CreatedAt = _dateTime,
                     ModifiedAt = null,
                 }

            );
        }

        private void SeedBooks(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Book>().HasData(
                new()
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Title = "Tvrdjava",
                    PublishingDate = new DateTime(1980, 5, 27),
                    OpeningCount = 0,
                    CoverPhotoId = 1,
                },
                new()
                {
                    Id = 2,
                    CreatedAt = _dateTime,
                    ModifiedAt = null,
                    Title = "Na Drini cuprija",
                    PublishingDate = new DateTime(1980, 5, 27),
                    OpeningCount = 0,
                    CoverPhotoId = 1,


                }
                );
        }

        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Bosnia and Herzegovina",
                    Abbreviation = "BIH",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Croatia",
                    Abbreviation = "HR",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Serbia",
                    Abbreviation = "SRB",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 4,
                    Name = "Montenegro",
                    Abbreviation = "CG",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 5,
                    Name = "Slovenia",
                    Abbreviation = "SLO",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 6,
                    Name = "Austria",
                    Abbreviation = "AT",
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }

        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Mostar",
                    ZipCode = "88000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Sarajevo",
                    ZipCode = "77000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Zenica",
                    ZipCode = "72000",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }

    }
}
