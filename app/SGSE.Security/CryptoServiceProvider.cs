using System.Security.Cryptography;

namespace SGSE.Security
{
    /// <summary>
    /// Proveedor de criptografía
    /// </summary>
    internal class CryptoServiceProvider
    {
        internal enum CryptoAction
        {
            Encrypt,
            Desencrypt
        }

        internal enum CryptoProvider
        {
            DES,
            TripleDES,
            RC2,
            Rijndael
        }

        private CryptoProvider algorithm;

        private CryptoAction cAction;

        internal CryptoServiceProvider(CryptoProvider alg, CryptoAction action)
        {
            algorithm = alg;
            cAction = action;
        }

        internal ICryptoTransform GetServiceProvider(byte[] Key, byte[] IV)
        {
            ICryptoTransform cryptoTransform = null;
            ICryptoTransform result;
            switch (algorithm)
            {
                case CryptoProvider.DES:
                    {
                        DESCryptoServiceProvider dESCryptoServiceProvider = new DESCryptoServiceProvider();
                        CryptoAction cryptoAction = cAction;
                        if (cryptoAction != CryptoAction.Encrypt)
                        {
                            if (cryptoAction == CryptoAction.Desencrypt)
                            {
                                cryptoTransform = dESCryptoServiceProvider.CreateDecryptor(Key, IV);
                            }
                        }
                        else
                        {
                            cryptoTransform = dESCryptoServiceProvider.CreateEncryptor(Key, IV);
                        }
                        result = cryptoTransform;
                        break;
                    }
                case CryptoProvider.TripleDES:
                    {
                        TripleDESCryptoServiceProvider tripleDESCryptoServiceProvider = new TripleDESCryptoServiceProvider();
                        CryptoAction cryptoAction2 = cAction;
                        if (cryptoAction2 != CryptoAction.Encrypt)
                        {
                            if (cryptoAction2 == CryptoAction.Desencrypt)
                            {
                                cryptoTransform = tripleDESCryptoServiceProvider.CreateDecryptor(Key, IV);
                            }
                        }
                        else
                        {
                            cryptoTransform = tripleDESCryptoServiceProvider.CreateEncryptor(Key, IV);
                        }
                        result = cryptoTransform;
                        break;
                    }
                case CryptoProvider.RC2:
                    {
                        RC2CryptoServiceProvider rC2CryptoServiceProvider = new RC2CryptoServiceProvider();
                        CryptoAction cryptoAction3 = cAction;
                        if (cryptoAction3 != CryptoAction.Encrypt)
                        {
                            if (cryptoAction3 == CryptoAction.Desencrypt)
                            {
                                cryptoTransform = rC2CryptoServiceProvider.CreateDecryptor(Key, IV);
                            }
                        }
                        else
                        {
                            cryptoTransform = rC2CryptoServiceProvider.CreateEncryptor(Key, IV);
                        }
                        result = cryptoTransform;
                        break;
                    }
                case CryptoProvider.Rijndael:
                    {
                        Rijndael rijndael = new RijndaelManaged();
                        CryptoAction cryptoAction4 = cAction;
                        if (cryptoAction4 != CryptoAction.Encrypt)
                        {
                            if (cryptoAction4 == CryptoAction.Desencrypt)
                            {
                                cryptoTransform = rijndael.CreateDecryptor(Key, IV);
                            }
                        }
                        else
                        {
                            cryptoTransform = rijndael.CreateEncryptor(Key, IV);
                        }
                        result = cryptoTransform;
                        break;
                    }
                default:
                    throw new CryptographicException("Error al inicializar al proveedor de cifrado");
            }
            return result;
        }
    }
}
