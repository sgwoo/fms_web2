package acar.util;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

public class SecurityUtil {
	
	private Key getSecurityKey(){
		
		Key secureKey = new SecretKeySpec("AMAZONCAR2015!@#".getBytes(), "AES");
		return secureKey;
	}
	//AES 128bit 암호화
	public String encodeAES(String str) throws IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException{
		
		Cipher cipher = null;
		byte[] encryptedData = null;
		cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, getSecurityKey());
		encryptedData = cipher.doFinal(str.getBytes());
		
		return byteArrayToHex(encryptedData);
	}
	
	//AES 128bit 복호화
	public String decodeAES(String str){
		        
		Cipher cipher = null;
		try {
			cipher = Cipher.getInstance("AES");
		} catch (NoSuchAlgorithmException e) {} 
			catch (NoSuchPaddingException e) {}
		try {
			cipher.init(Cipher.DECRYPT_MODE, getSecurityKey());
		} catch (InvalidKeyException e) {}
		byte[] plainText = null;
		try {
			plainText = cipher.doFinal(hexToByteArray(str));
		} catch (IllegalBlockSizeException e) {} 
			catch (BadPaddingException e) {}
		
		return new String(plainText);
	}
	
	public static String byteArrayToHex(byte[] ba) {
		if (ba == null || ba.length == 0)  return null;
		StringBuffer sb = new StringBuffer(ba.length * 2);
		String hexNumber;
		for (int x = 0; x < ba.length; x++) {
			hexNumber = "0" + Integer.toHexString(0xff & ba[x]);
			sb.append(hexNumber.substring(hexNumber.length() - 2));
		}
		return sb.toString();
	}
	
	public static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() == 0)  return null;
		byte[] ba = new byte[hex.length() / 2];
		for (int i = 0; i < ba.length; i++) {
			ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
		}
		return ba;
	}	
	
	public List<String> createRandomPassword() {
		List<String> result = new ArrayList<String>();
		String oriPass = "";
		String encodingPass = "";
		
		int index = 0;  
		char[] charSet = new char[] {  
		            '0','1','2','3','4','5','6','7','8','9'  
		            ,'A','B','C','D','E','F','G','H','I','J','K','L','M'  
		            ,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'  
		            ,'a','b','c','d','e','f','g','h','i','j','k','l','m'  
		            ,'n','o','p','q','r','s','t','u','v','w','x','y','z'
		};  
		  
		StringBuffer sb = new StringBuffer();  
		for (int i=0; i<10; i++) {  
		    index =  (int) (charSet.length * Math.random());  
		    sb.append(charSet[index]);  
		}
			
	        oriPass = sb.toString();  
	        try {
				encodingPass = encodeAES(oriPass);
			} catch (InvalidKeyException e) {
			} catch (IllegalBlockSizeException e) {
			} catch (BadPaddingException e) {
			} catch (NoSuchAlgorithmException e) {
			} catch (NoSuchPaddingException e) {
			}
	        
	        result.add(oriPass);
	        result.add(encodingPass);
		return result;
	}
}
