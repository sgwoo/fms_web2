/*
 * @ AddUtil.java
 *
 * TYPE : 공통 클래스 (com)
 *
 * 설명 : AddUtil Class
 *
 * 사용법
 *    - static method는 AddUtil.mehtod()로 호출한다.
 *    - 기타 메소드는 객체생성후 접근한다.
 */

package acar.util;

import java.util.*;
import java.io.*;
import java.sql.*;
import java.text.*;
import java.lang.*;
import acar.database.DBConnectionManager;

public class AddUtil{

    public AddUtil() {
    
    }
	
	
	
	public static String ChangeBr(String s) {

		String old = "\n";
		String replacement = "<br>";

		int i = s.indexOf(old);
		StringBuffer r = new StringBuffer();

		if (i == -1) return s;
		r.append(s.substring(0,i) + replacement);
		
		if (i + old.length() < s.length())
		r.append(ChangeBr(s.substring(i + old.length(), s.length())));
	 
		return r.toString();
	}
	
	
	  /**
      * lpad 함수
     *
      * @param str   대상문자열, len 길이, addStr 대체문자
     * @return      문자열
     */

     public static String lpad(String str, int len, String addStr) {
         String result = str;
         int templen   = len - result.length();

        for (int i = 0; i < templen; i++){
               result = addStr + result;
         }
         
         return result;
     }

 /**
      * rpad 함수
     *
      * @param str   대상문자열, len 길이, addStr 대체문자
     * @return      문자열
     */

     public static String rpad(String str, int len, String addStr) {
         String result = str;
         int templen   = len - result.length();

        for (int i = 0; i < templen; i++){
               result += addStr;
         }
         
         return result;
     }

    /**
     * 8859_1 -> KSC5601 (한글로 변환)
     */
    public static String toEN(String ko) 
    {
    	String new_str = null;		
    	try {		
    		if(ko != null ){
    			new_str=new String(ko.getBytes("KSC5601"),"8859_1");
    		} else {
				new_str = "";
			}		
    	} catch(UnsupportedEncodingException e) { }			
    	return new_str;
    }

    /**
     * KSC5601 -> 8859_1 (영어로 변환)
     */
    public static String toKSC(String en) 
    {
    	String new_str = null;		
    	try {
    		if(en != null){
    			new_str = new String (en.getBytes("8859_1"), "KSC5601");
    		} else {
				new_str = "";
			}
    	} catch (UnsupportedEncodingException e) {}
    	return new_str;
    }

	/**
     * space -> &nbsp;  (스페이스 한깐띄기로 변환)
     */
    public static String spaceToNBSP(String source) 
    {
    	StringBuffer sb = new StringBuffer(source);
    	StringBuffer result = new StringBuffer();
    	String ch = null;
    	for(int i=0; i<source.length(); i++) {
    	
    		if (Character.isSpaceChar(sb.charAt(i))) 
    			ch = "&nbsp;";
    		else 
    			ch = String.valueOf(sb.charAt(i));
    		
    		result.append(ch);
    	}
    	return result.toString();
    }

    /**
     * &nbsp -> ""
     */     
    public static String nbspToSpace(String nbsp){
    	String value = "";
    	if(nbsp != null && !nbsp.trim().equals("&nbsp;")){
    		value = nbsp;
    	}
    	return value;
    }
    
    /**
     * null -> "" 로 변환하는 메소드<br>
     * : 데이터 수정시 데이터 베이스로 부터 읽은 값이 null이면 수정 폼에 null이 들어가므로 이값을 변환하는 메소드 <br>
     * : 데이터 수정시 null 값을 수정 폼에 setting 할때 사용하면 유용한 메소드. <br>
     */     
    public static String nullToString(String str){
    	String value = str;
    	if(str == null){
    		value = "";
    	}
    	return value;
    }
    
    /**
     * null or "" --> "&nbsp;" <br>
     * : HTML에서 테이블의 셀에 "" 이 들어가면 테이블이 깨지므로(netscape) 공백문자(&nbsp;)로 대치하는 메소드<br>
     */   
    public static String nullToNbsp(String str){
    	String value = str;
    	if(str == null || str.equals("")){
    		value = "&nbsp;";
    	}
    	return value;
    }

    /**
     * Encode URL -> Decode URL : jdk 1.x 버전에서는 java.net.URLDecoder 클래스를 지원하지 않기 때문에<br>
     *  jdk1.x 에서 URL 디코딩시 사용. <br>
     */
    public static String decodeURL(String s){
    	 
    	ByteArrayOutputStream out = new ByteArrayOutputStream(s.length());
    	for (int i = 0; i < s.length(); i++){  
    		int c = (int) s.charAt(i);
    		if ( c == '+') 
    			out.write(' ');
    		else if (c == '%'){  
    				int c1 = Character.digit(s.charAt(++i), 16);
    				int c2 = Character.digit(s.charAt(++i), 16);
    				out.write((char) (c1 * 16 + c2));
    		}else 
    			out.write(c);
    	}
    	return out.toString();
    }

	/**
     * 문자열을 잘라서 리턴
     */
    public static String subData(String data, int num) {

		String subData = "";
		if (data.length()>num)
		{
			subData =  data.substring(0,num) + "...";
		}else{
			subData = data;
		}

		return subData;
	}

	/**
     * 문자열을 잘라서 리턴
     */
    public static String subDataCut(String data, int num) {

		String subData = "";
		if (data.length()>num)
		{
			subData =  data.substring(0,num);
		}else{
			subData = data;
		}

		return subData;
	}


	/**
	 * 한 자리 숫자에 앞에 '0'을 붙여 String으로 return하는 메소드<br>
	 * : argument : str, int
	 */

	public static String addZero(String str) {
		if(str.equals("") || str.equals(null) || str.equals("  ")) return str;

		return (Integer.toString(Integer.parseInt(str) + 100)).substring(1,3);
	}

	public static String addZero2(int num) {

		return (Integer.toString(num + 100)).substring(1,3);
	}

	public static String addZero5(String str) {
		if(str.equals("") || str.equals(null) || str.equals("  ")) return str;

		return (Integer.toString(Integer.parseInt(str) + 100000)).substring(1,6);

	}
	public static String addZero5(int num) {

		return (Integer.toString(num + 100000)).substring(1,6);
	}

    /**
    * ','로 분리되어 있는 문자열을 분리하여 Return
    * List에서 일괄 삭제시 ID값을 일괄로 받아와서 Parsing...
    */
    
    public static String[] getItemArray(String src) {
    
        String[] retVal = null;
        if (src.length() == 0) return null;
        
        int nitem = 1;
        
        for (int i = 0; i < src.length(); i++)
        		if (src.charAt(i) == ',') nitem++;
        
        retVal = new String[nitem];
        
        int ep = 0;
        int sp = 0;
        
        for (int i = 0; i < nitem; i++) {
        	ep = src.indexOf(",", sp);
        	if (ep == -1) ep = src.length();
        	retVal[i] = new String(src.substring(sp, ep));
        	sp = ep + 1;
        }
        
        return retVal; 
    }

    /**
     * 특정 문자열을 다른 문자열로 대체하는 메소드<br>
     * : 문자열 검색시 검색어에 색깔을 넣거나 ... 테그를 HTML 문자로 바꾸는데 사용하면 유용할거 같음.<br>
     */
    public static String replace(String line, String oldString, String newString){
        int index=0;
        while((index = line.indexOf(oldString, index)) >= 0){
        	line = line.substring(0, index) + newString + line.substring(index + oldString.length());
        	index += newString.length();
        }
        return line;
    }	

	//주민등록번호 0001012000000 -> 000101-2000000
	public static String ChangeSsn(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 13){
			Format = unFormat.substring(0,6)+"-"+unFormat.substring(6,13);
			//Format = unFormat.substring(0,6)";
			return Format;
		}else{
			return unFormat;
		}
	}

	//주민등록번호 0001012000000 -> 000101-2000000
	public static String ChangeSsnBdt(String unFormat)
	{
		String Format = "";
		if(replace(unFormat,"-","").length() == 13){
			Format = unFormat.substring(0,6);
			return Format;
		}else{
			return unFormat;
		}
	}

	//사업자번호 1288147957 -> 128-81-47957
	public static String ChangeEnt_no(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 10){
			Format = unFormat.substring(0,3)+"-"+unFormat.substring(3,5)+"-"+unFormat.substring(5,10);
			return Format;
		}else{
			return unFormat;
		}
	}
	//사업자등록번호
	public static String ChangeEnp(String unFormat)
	{
		String Format = replace(unFormat," ","");
		Format = replace(Format,"-","");
		if(Format.length() == 10){
			Format = Format.substring(0,3)+"-"+Format.substring(3,5)+"-"+Format.substring(5,10);
			return Format;
		}else if(Format.length() == 13){
			Format = Format.substring(0,6)+"-"+Format.substring(6,13);
			return Format;
		}else{
			return unFormat;
		}
	}

	//사업자등록번호
	public static String ChangeEnpH(String unFormat)
	{
		String Format = replace(unFormat," ","");
		Format = replace(Format,"-","");
		if(Format.length() == 10){
			Format = Format.substring(0,3)+"-"+Format.substring(3,5)+"-"+Format.substring(5,10);
			return Format;
		}else if(Format.length() == 13){
			Format = Format.substring(0,6)+"-"+Format.substring(6,7)+"******";
			return Format;
		}else{
			return unFormat;
		}
	}

	//카드번호
	public static String ChangeCard(String unFormat)
	{
		String Format = replace(unFormat," ","");
		Format = replace(Format,"-","");

		if(Format.length() == 16){
			Format = Format.substring(0,4)+"-"+Format.substring(4,8)+"-"+Format.substring(8,12)+"-"+Format.substring(12,16);
			return Format;
		}else{
			return unFormat;
		}
	}
	
	//카드번호
	public static String ChangeCardStar(String unFormat)
	{
		String Format = replace(unFormat," ","");
		Format = replace(Format,"-","");

		if(Format.length() == 16){
			Format = Format.substring(0,4)+"-"+Format.substring(4,8)+"-"+Format.substring(8,12)+"-****";
			return Format;
		}else{
			return unFormat;
		}
	}	

	public static String phoneFormat(String phoneNo){
  
		if (phoneNo.length() == 0){
		    return phoneNo;
		}
   
		String strTel = replace(phoneNo,"-","");
	    String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "012", "013", "015", "016", "017", "018", "019", "070"};
      
	    if (strTel.length() < 9) {
			return strTel;
		} else if (strTel.substring(0,2).equals(strDDD[0])) {
			strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4) + '-' + strTel.substring(strTel.length() -4, strTel.length());
		} else {
			for(int i=1; i < strDDD.length; i++) {
				if (strTel.substring(0,3).equals(strDDD[i])) {
					strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4) + '-' + strTel.substring(strTel.length() -4, strTel.length());
				}
			}
		}
		return strTel;
	}
	
	public static String phoneFormatAsterisk(String phoneNo){
		  
		if (phoneNo.length() == 0){
		    return phoneNo;
		}
   
		String strTel = replace(phoneNo,"-","");
	    String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "012", "013", "015", "016", "017", "018", "019", "070"};
      
	    if (strTel.length() < 9) {
			return strTel;
		} else if (strTel.substring(0,2).equals(strDDD[0])) {
			strTel = strTel.substring(0,2) + "-" + strTel.substring(2, strTel.length()-4) + "-" + strTel.substring(strTel.length() -4, strTel.length()-2)+"**";
		} else {
			for(int i=1; i < strDDD.length; i++) {
				if (strTel.substring(0,3).equals(strDDD[i])) {
					strTel = strTel.substring(0,3) + "-" + strTel.substring(3, strTel.length()-4) + "-" + strTel.substring(strTel.length() -4, strTel.length()-2)+"**";
				}
			}
		}
		return strTel;
	}	


	//숫자를 시간형식으로 ( 630 -> 6시간 30분 ) -- 2009-01-28 Ryu gill sun
	public static String ChangeTime(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 4){
			Format = unFormat.substring(0,2)+"시간 "+unFormat.substring(1,3)+"분";
			return Format;
		}else if(unFormat.length() == 3){
			Format = unFormat.substring(0,1)+"시간 "+unFormat.substring(1,3)+"분";
			return Format;
		}else{
			return unFormat;
		}
	}
	
	//숫자를 시간형식으로 ( 630 -> 06 : 30분 ) -- 2009-02-02 Ryu gill sun
	public static String ChangeTime2(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 4){
			Format = unFormat.substring(0,2)+" : "+unFormat.substring(2,4)+"";
			return Format;
		}else if(unFormat.length() == 3){
			Format = unFormat.substring(0,1)+" : "+unFormat.substring(1,3)+"";
			return Format;
		}else{
			return unFormat;
		}
	}

	//숫자를 시간형식으로 ( 630 -> 6시간 30분 ) -- 2009-02-03 Ryu gill sun
	public static String ChangeTime3(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 4){
			Format = unFormat.substring(0,2);
			return Format;
		}else if(unFormat.length() == 3){
			Format = unFormat.substring(0,1);
			return Format;
		}else{
			return unFormat;
		}
	}

	public static String ChangeTime4(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 5){
			Format = unFormat.substring(0,2)+"시 "+unFormat.substring(3,5)+"분";
			return Format;
		}else{
			return unFormat;
		}
	}

	//차종변수(esti_jg_var) 기준일자 가져오기
	public static String getJg_b_dt(String rent_dt)
	{
		String jg_b_dt	= "20121101";
		int i_rent_dt	= parseDigit(replace(rent_dt,"-",""));		

		if(i_rent_dt >= 20080901){
			if(i_rent_dt >= 20081001){
				if(i_rent_dt >= 20081009){
					if(i_rent_dt >= 20081027){
						if(i_rent_dt >= 20081114){
							if(i_rent_dt >= 20081222){
								if(i_rent_dt >= 20090117){
									if(i_rent_dt >= 20090223){
										if(i_rent_dt >= 20090330){
											if(i_rent_dt >= 20090421){
												if(i_rent_dt >= 20090610){
													if(i_rent_dt >= 20090617){
														if(i_rent_dt >= 20090701){
															if(i_rent_dt >= 20090724){
																if(i_rent_dt >= 20090806){
																	if(i_rent_dt >= 20090821){
																		if(i_rent_dt >= 20090915){
																			if(i_rent_dt >= 20090917){
																				if(i_rent_dt >= 20091125){
																					if(i_rent_dt >= 20100323){
																						if(i_rent_dt >= 20100429){
																							if(i_rent_dt >= 20100801){
																								if(i_rent_dt >= 20100914){
																									if(i_rent_dt >= 20101020){
																										if(i_rent_dt >= 20110101){
																											if(i_rent_dt >= 20110108){
																												if(i_rent_dt >= 20110210){
																													if(i_rent_dt >= 20110331){
																														if(i_rent_dt >= 20110408){
																															if(i_rent_dt >= 20110615){
																																if(i_rent_dt >= 20110719){
																																	if(i_rent_dt >= 20110819){
																																		if(i_rent_dt >= 20110907){
																																			if(i_rent_dt >= 20111020){
																																				if(i_rent_dt >= 20120106){
																																					if(i_rent_dt >= 20120203){
																																						if(i_rent_dt >= 20120315){
																																							if(i_rent_dt >= 20120425){
																																								if(i_rent_dt >= 20120725){
																																									if(i_rent_dt >= 20120911){
																																										if(i_rent_dt >= 20121009){
																																											if(i_rent_dt >= 20121101){
																																												jg_b_dt = "20121101";
																																											}else{
																																												jg_b_dt = "20121009";
																																											}
																																										}else{
																																											jg_b_dt = "20120911";
																																										}
																																									}else{
																																										jg_b_dt = "20120725";
																																									}
																																								}else{
																																									jg_b_dt = "20120425";
																																								}
																																							}else{
																																								jg_b_dt = "20120315";
																																							}
																																						}else{
																																							jg_b_dt = "20120203";
																																						}
																																					}else{
																																						jg_b_dt = "20120106";
																																					}
																																				}else{
																																					jg_b_dt = "20111020";
																																				}
																																			}else{
																																				jg_b_dt = "20110907";
																																			}
																																		}else{
																																			jg_b_dt = "20110819";
																																		}
																																	}else{
																																		jg_b_dt = "20110719";
																																	}
																																}else{
																																	jg_b_dt = "20110615";
																																}
																															}else{
																																jg_b_dt = "20110408";
																															}
																														}else{
																															jg_b_dt = "20110331";
																														}
																													}else{
																														jg_b_dt = "20110210";
																													}
																												}else{
																													jg_b_dt = "20110101";
																												}
																											}else{
																												jg_b_dt = "20110101";
																											}
																										}else{
																											jg_b_dt = "20101020";
																										}
																									}else{
																										jg_b_dt = "20100914";
																									}
																								}else{
																									jg_b_dt = "20100801";
																								}
																							}else{
																								jg_b_dt = "20100429";
																							}	
																						}else{
																							jg_b_dt = "20100323";
																						}	
																					}else{
																						jg_b_dt = "20091125";
																					}	
																				}else{
																					jg_b_dt = "20090917";
																				}	
																			}else{
																				jg_b_dt = "20090915";
																			}	
																		}else{
																			jg_b_dt = "20090821";
																		}	
																	}else{
																		jg_b_dt = "20090806";
																	}
																}else{
																	jg_b_dt = "20090724";
																}
															}else{
																jg_b_dt = "20090701";
															}
														}else{
															jg_b_dt = "20090617";
														}
													}else{
														jg_b_dt = "20090421";
													}
												}else{
													jg_b_dt = "20090421";
												}
											}else{
												jg_b_dt = "20090327";
											}
										}else{
											jg_b_dt = "20090223";
										}
									}else{
										jg_b_dt = "20090119";
									}
								}else{
									jg_b_dt = "20081222";
								}
							}else{
								jg_b_dt = "20081114";
							}
						}else{
							jg_b_dt = "20081001";
						}
					}else{
						jg_b_dt = "20081001";
					}
				}else{
					jg_b_dt = "20081001";
				}
			}else{
				jg_b_dt = "20080829";
			}
		}

		return jg_b_dt;

	}

	//견적공통변수(esti_comm_var) 기준일자 가져오기 em_a_j 견적공통변수
	public static String getA_j(String rent_dt)
	{
		String a_j		= "20121101";
		int i_rent_dt	= parseDigit(replace(rent_dt,"-",""));		

		if(i_rent_dt >= 20080901){
			if(i_rent_dt >= 20081001){
				if(i_rent_dt >= 20081009){
					if(i_rent_dt >= 20081027){
						if(i_rent_dt >= 20081114){
							if(i_rent_dt >= 20081222){
								if(i_rent_dt >= 20090117){
									if(i_rent_dt >= 20090223){
										if(i_rent_dt >= 20090330){
											if(i_rent_dt >= 20090421){
												if(i_rent_dt >= 20090610){
													if(i_rent_dt >= 20090617){
														if(i_rent_dt >= 20090701){
															if(i_rent_dt >= 20090724){
																if(i_rent_dt >= 20090806){
																	if(i_rent_dt >= 20090821){
																		if(i_rent_dt >= 20090915){
																			if(i_rent_dt >= 20090917){
																				if(i_rent_dt >= 20091125){
																					if(i_rent_dt >= 20100323){
																						if(i_rent_dt >= 20100429){
																							if(i_rent_dt >= 20100801){
																								if(i_rent_dt >= 20100914){
																									if(i_rent_dt >= 20101020){
																										if(i_rent_dt >= 20110101){
																											if(i_rent_dt >= 20110108){
																												if(i_rent_dt >= 20110210){
																													if(i_rent_dt >= 20110331){
																														if(i_rent_dt >= 20110408){
																															if(i_rent_dt >= 20110615){
																																if(i_rent_dt >= 20110719){
																																	if(i_rent_dt >= 20110907){
																																		if(i_rent_dt >= 20120101){
																																			if(i_rent_dt >= 20120203){
																																				if(i_rent_dt >= 20120315){
																																					if(i_rent_dt >= 20120425){
																																						if(i_rent_dt >= 20120725){
																																							if(i_rent_dt >= 20121009){
																																								if(i_rent_dt >= 20121101){
																																									a_j = "20121101";
																																								}else{
																																									a_j = "20121009";
																																								}
																																							}else{
																																								a_j = "20120725";
																																							}
																																						}else{
																																							a_j = "20120425";
																																						}	
																																					}else{
																																						a_j = "20120315";
																																					}	
																																				}else{
																																					a_j = "20120203";
																																				}	
																																			}else{
																																				a_j = "20120101";
																																			}	
																																		}else{
																																			a_j = "20110907";
																																		}	
																																	}else{
																																		a_j = "20110719";
																																	}	
																																}else{
																																	a_j = "20110615";
																																}	
																															}else{
																																a_j = "20110408";
																															}	
																														}else{
																															a_j = "20110331";
																														}	
																													}else{
																														a_j = "20110210";
																													}	
																												}else{
																													a_j = "20110108";
																												}	
																											}else{
																												a_j = "20110101";
																											}	
																										}else{
																											a_j = "20101020";
																										}	
																									}else{
																										a_j = "20100914";
																									}	
																								}else{
																									a_j = "20100429";
																								}	
																							}else{
																								a_j = "20100429";
																							}	
																						}else{
																							a_j = "20100323";
																						}	
																					}else{
																						a_j = "20090821";
																					}	
																				}else{
																					a_j = "20090821";
																				}	
																			}else{
																				a_j = "20090821";
																			}
																		}else{
																			a_j = "20090821";
																		}
																	}else{
																		a_j = "20090806";
																	}
																}else{
																	a_j = "20090724";
																}
															}else{
																a_j = "20090701";
															}
														}else{
															a_j = "20090610";
														}
													}else{
														a_j = "20090610";
													}
												}else{
													a_j = "20090421";
												}
											}else{
												a_j = "20090327";
											}
										}else{
											a_j = "20090223";
										}
									}else{
										a_j = "20090117";
									}
								}else{
									a_j = "20081222";
								}
							}else{
								a_j = "20081114";
							}
						}else{
							a_j = "20081027";
						}
					}else{
						a_j = "20081008";
					}
				}else{
					a_j = "20081001";
				}
			}else{
				a_j = "20080901";
			}
		}

		return a_j;

	}

	//견적차종별변수(esti_car_var) 기준일자 가져오기 ea_a_j 차종별변수
	public static String getA_j2(String rent_dt)
	{
		String a_j		= "20121009";
		int i_rent_dt	= parseDigit(replace(rent_dt,"-",""));		

		if(i_rent_dt >= 20080901){
			if(i_rent_dt >= 20081001){
				if(i_rent_dt >= 20081009){
					if(i_rent_dt >= 20081027){
						if(i_rent_dt >= 20081114){
							if(i_rent_dt >= 20081222){
								if(i_rent_dt >= 20090117){
									if(i_rent_dt >= 20090223){
										if(i_rent_dt >= 20090330){
											if(i_rent_dt >= 20090421){
												if(i_rent_dt >= 20090610){
													if(i_rent_dt >= 20090617){
														if(i_rent_dt >= 20090701){
															if(i_rent_dt >= 20090724){
																if(i_rent_dt >= 20090806){
																	if(i_rent_dt >= 20090821){
																		if(i_rent_dt >= 20090915){
																			if(i_rent_dt >= 20090917){
																				if(i_rent_dt >= 20091125){
																					if(i_rent_dt >= 20100323){
																						if(i_rent_dt >= 20100429){
																							if(i_rent_dt >= 20100801){
																								if(i_rent_dt >= 20100914){
																									if(i_rent_dt >= 20101020){
																										if(i_rent_dt >= 20110101){
																											if(i_rent_dt >= 20110108){
																												if(i_rent_dt >= 20110210){
																													if(i_rent_dt >= 20110331){
																														if(i_rent_dt >= 20110408){
																															if(i_rent_dt >= 20110615){
																																if(i_rent_dt >= 20110719){
																																	if(i_rent_dt >= 20110907){
																																		if(i_rent_dt >= 20120203){
																																			if(i_rent_dt >= 20120315){
																																				if(i_rent_dt >= 20120425){
																																					if(i_rent_dt >= 20120725){
																																						if(i_rent_dt >= 20121009){
																																							a_j = "20121009";
																																						}else{
																																							a_j = "20120725";
																																						}
																																					}else{
																																						a_j = "20120425";
																																					}
																																				}else{
																																					a_j = "20120315";
																																				}
																																			}else{
																																				a_j = "20120203";
																																			}
																																		}else{
																																			a_j = "20110907";
																																		}
																																	}else{
																																		a_j = "20110719";
																																	}
																																}else{
																																	a_j = "20110615";
																																}
																															}else{
																																a_j = "20110408";
																															}
																														}else{
																															a_j = "20110331";
																														}
																													}else{
																														a_j = "20110210";
																													}
																												}else{
																													a_j = "20110108";
																												}
																											}else{
																												a_j = "20110101";
																											}
																										}else{
																											a_j = "20100914";
																										}
																									}else{
																										a_j = "20100914";
																									}
																								}else{
																									a_j = "20100429";
																								}
																							}else{
																								a_j = "20100429";
																							}
																						}else{
																							a_j = "20100323";
																						}
																					}else{
																						a_j = "20090701";
																					}
																				}else{
																					a_j = "20090701";
																				}																						
																			}else{
																				a_j = "20090701";
																			}
																		}else{
																			a_j = "20090701";
																		}
																	}else{
																		a_j = "20090701";
																	}
																}else{
																	a_j = "20090701";
																}
															}else{
																a_j = "20090701";
															}
														}else{
															a_j = "20090421";
														}
													}else{
														a_j = "20090421";
													}
												}else{
													a_j = "20090421";
												}
											}else{
												a_j = "20081001";
											}
										}else{
											a_j = "20081001";
										}
									}else{
										a_j = "20081001";
									}
								}else{
									a_j = "20081001";
								}
							}else{
								a_j = "20081001";
							}
						}else{
							a_j = "20081001";
						}
					}else{
						a_j = "20080401";
					}
				}else{
					a_j = "20080401";
				}
			}else{
				a_j = "20080401";
			}
		}

		return a_j;

	}

	//기준일자에 따른 공통변수(렌트) 일련번호 가져오기
	public static String geEm_var_seq(String a_j)
	{
		String em_var_seq = "109";

		if(a_j.equals("20080901")) em_var_seq = "052";
		if(a_j.equals("20081001")) em_var_seq = "054";
		if(a_j.equals("20081008")) em_var_seq = "056";
		if(a_j.equals("20081027")) em_var_seq = "058";
		if(a_j.equals("20081114")) em_var_seq = "060";
		if(a_j.equals("20081222")) em_var_seq = "060";
		if(a_j.equals("20090117")) em_var_seq = "062";
		if(a_j.equals("20090223")) em_var_seq = "064";
		if(a_j.equals("20090327")) em_var_seq = "066";
		if(a_j.equals("20090421")) em_var_seq = "068";
		if(a_j.equals("20090610")) em_var_seq = "070";
		if(a_j.equals("20090701")) em_var_seq = "072";
		if(a_j.equals("20090724")) em_var_seq = "074";
		if(a_j.equals("20090806")) em_var_seq = "076";
		if(a_j.equals("20090821")) em_var_seq = "078";
		if(a_j.equals("20100323")) em_var_seq = "080";
		if(a_j.equals("20100429")) em_var_seq = "082";
		if(a_j.equals("20100914")) em_var_seq = "084";
		if(a_j.equals("20101020")) em_var_seq = "086";
		if(a_j.equals("20110101")) em_var_seq = "088";
		if(a_j.equals("20110108")) em_var_seq = "090";
		if(a_j.equals("20110210")) em_var_seq = "092";
		if(a_j.equals("20110331")) em_var_seq = "094";
		if(a_j.equals("20110408")) em_var_seq = "096";
		if(a_j.equals("20110615")) em_var_seq = "098";
		if(a_j.equals("20110719")) em_var_seq = "100";
		if(a_j.equals("20110907")) em_var_seq = "101";
		if(a_j.equals("20120101")) em_var_seq = "102";
		if(a_j.equals("20120203")) em_var_seq = "103";
		if(a_j.equals("20120223")) em_var_seq = "104";
		if(a_j.equals("20120315")) em_var_seq = "105";
		if(a_j.equals("20120425")) em_var_seq = "106";
		if(a_j.equals("20120725")) em_var_seq = "107";
		if(a_j.equals("20121009")) em_var_seq = "108";
		if(a_j.equals("20121101")) em_var_seq = "109";

		return em_var_seq;

	}



	/**********************************************/	
	/*                                            */
	/*           날    짜     관    련            */
	/*                                            */
	/**********************************************/	

    /**
     * 날짜형을 20020101 -> 2002-01-01 변환
     */
	public static String ChangeDate(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 10){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(5,7)+'-'+unFormat.substring(8,10);		
			return Format;
		}else{
			return unFormat;
		}
	}
	public static String ChangeDate(String unFormat, String mode)
	{
		String Format = "";
		if(unFormat.length() >= 8){
			if(mode.equals("YYYYMM")){ 	
				Format = unFormat.substring(0,4)+""+unFormat.substring(4,6);		
			}else if(mode.equals("YYYY-MM")){ 	
				Format = unFormat.substring(0,4)+"-"+unFormat.substring(4,6);		
			}else if(mode.equals("MM/YY")){ 	
				Format = unFormat.substring(4,6)+"/"+unFormat.substring(2,4);		
			}else if(mode.equals("MM/DD")){ 	
				Format = unFormat.substring(4,6)+"/"+unFormat.substring(6,8);		
			}else if(mode.equals("MM월DD일")){ 	
				Format = unFormat.substring(4,6)+"월"+unFormat.substring(6,8)+"일";		
			}else if(mode.equals("YYYY-MM-DD")){ 	
				Format = unFormat.substring(0,4)+"-"+unFormat.substring(4,6)+"-"+unFormat.substring(6,8);		
			}
			return Format;
		}else{
			return unFormat;
		}
	}
	public static String ChangeDate2(String unFormat)
	{
		String Format = "";
	
		if(unFormat == null){		
			return Format;	 //  null로 표시되지 않게
	//		return unFormat;
		}else{
			unFormat = replace(unFormat,"-","");	
			if(unFormat.length() == 8){
				Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8);
				return Format;
			}else if(unFormat.length() == 6){
				Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6);
				return Format;
			}else if(unFormat.length() == 10){
				Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8);
				return Format;
			}else if(unFormat.length() == 12){
				Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8);
				return Format;
			}else{
				return unFormat;
			}
		}
	}
	public static String ChangeDate3(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 8){
			Format = ChangeDate2(unFormat);
			return Format;
		}else if(unFormat.length() == 12){
			Format = ChangeDate2(unFormat.substring(0,8))+" "+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분";
			return Format;
		}else if(unFormat.length() == 10){
			Format = ChangeDate2(unFormat.substring(0,8))+" "+unFormat.substring(8,10)+"시";
			return Format;

		}else if(unFormat.length() == 14){
			Format = ChangeDate2(unFormat.substring(0,8))+" "+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분"+unFormat.substring(12,14)+"초";
			return Format;

		}else if(unFormat.length() == 21){
			Format = ChangeDate2(unFormat.substring(0,10))+" "+unFormat.substring(11,13)+"시"+unFormat.substring(14,16)+"분";
			return Format;

		}else{
			return unFormat;

		}
	}
	public static String ChangeDate3_2(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 8){
			Format = ChangeDate2(unFormat);
			return Format;
		}else if(unFormat.length() == 12){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분";
			return Format;
		}else if(unFormat.length() == 10){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시";
			return Format;

		}else if(unFormat.length() == 14){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분"+unFormat.substring(12,14)+"초";
			return Format;

		}else if(unFormat.length() == 21){
			Format = ChangeDate2(unFormat.substring(0,10))+"<br>"+unFormat.substring(11,13)+"시"+unFormat.substring(14,16)+"분";
			return Format;

		}else{
			return unFormat;

		}
	}

	public static String ChangeDate4(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 10){
			Format = ChangeDate2(unFormat.substring(0,8))+" "+unFormat.substring(8,10);
			return Format;

		}else{
			return unFormat;

		}
	}

	public static String ChangeDate5(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 12){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분";
			return Format;
		}else if(unFormat.length() == 10){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시";
			return Format;

		}else if(unFormat.length() == 14){
			Format = ChangeDate2(unFormat.substring(0,8))+"<br>"+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분"+unFormat.substring(12,14)+"초";
			return Format;

		}else if(unFormat.length() == 21){
			Format = ChangeDate2(unFormat.substring(0,10))+"<br>"+unFormat.substring(11,13)+"시"+unFormat.substring(14,16)+"분";
			return Format;

		}else{
			return unFormat;

		}
	}

  /* 년도 제외 */
	public static String ChangeDate6(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 12){
			Format = unFormat.substring(4,6)+'-'+unFormat.substring(6,8) +" "+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분";
			return Format;
		}else if(unFormat.length() == 10){
			Format = unFormat.substring(4,6)+'-'+unFormat.substring(6,8) +" "+unFormat.substring(8,10)+"시";
			return Format;

		}else if(unFormat.length() == 14){
			Format = unFormat.substring(4,6)+'-'+unFormat.substring(6,8) +" "+unFormat.substring(8,10)+"시"+unFormat.substring(10,12)+"분"+unFormat.substring(12,14)+"초";
			return Format;

		}else if(unFormat.length() == 21){
			Format = unFormat.substring(4,6)+'-'+unFormat.substring(6,8) +" "+unFormat.substring(11,13)+"시"+unFormat.substring(14,16)+"분";
			return Format;

		}else{
			return unFormat;

		}
	}
	
	public static String ChangeDate7(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 8){
			Format = ChangeDate2(unFormat.substring(4,6))+"/"+unFormat.substring(2,4);
			return Format;

		}else{
			return unFormat;

		}
	}
	
	public static String ChangeDate8(String unFormat)
	{
		String Format = "";
		if(unFormat.length() >= 8){
			Format = ChangeDate2(unFormat.substring(0,8));
			return Format;
		}else{
			return unFormat;
		}
	}	
	public static String ChangeDate10(String unFormat)
	{
		String Format = "";
		if(unFormat.length() >= 10){
			Format = unFormat.substring(0,10);
			return Format;
		}else{
			return unFormat;
		}
	}		

    /**
     * 날짜형을 2002-01-01 -> 20020101 변환
     */	   
	public static String ChangeString(String Format)
	{
		String unFormat = "";	
		if(Format.length() == 10){
			unFormat = Format.substring(0,4)+Format.substring(5,7)+Format.substring(8,10);		
			return unFormat;
		}else{
			return Format;
		}
	}

    /**
     * 날짜형을 2002-01-01 -> 20020101 변환
     */	   
	public static int ChangeStringInt(String Format)
	{
		String unFormat = "";	
		int i;
		unFormat = Format.substring(0,4)+Format.substring(5,7)+Format.substring(8,10);		
		i = parseInt(unFormat);
		return i;
	}

	/**	
     * 현재날짜를 지정된 포맷으로 만들어 리턴
     */  
    public static String dateFormat(String format)
    {
    	String date=null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat(format);
    		date = sdf.format(d);
    	} catch(Exception kkkk) { }
    	return date;
    }
	
    /**
     * 현재날짜를 YYYY-MM-DD 형식으로 만들어 리턴 <br>
     */  
    public static String getDate()
    {
    	String ch = null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd");
    		ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }

	/**
     * 현재날짜를 YYYY.MM.DD 형식으로 만들어 리턴 <br>
     */  
    public static String getDateDot()
    {
    	String ch = null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'.   &nbsp;&nbsp;&nbsp;'MM'.&nbsp;&nbsp;   'dd");
    		ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }


    /**
     * 입력받은 Date 오브젝트를 YYYY-MM-DD 형식의 String 으로 만들어 리턴 <br>
     */  
    public static String dateToString(java.util.Date d)
    {
    	String ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd");
            ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }
    
    /**
     * 입력받은 Date 오브젝트를 특정한 포멧 형식의 String 으로 만들어 리턴 <br>
     * 예) dateToString(new Date(), "MMM d,  yyyy")<br>
     */  
    public static String dateToString(java.util.Date d, String format)
    {
    	String ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }    

    /**
     * 입력받은 String오브젝트를 특정한 포멧 형식의 Date 형으로 만들어 리턴 <br>
     * 예) stringToDate("2001-06-01", "yyyy-'-'MM'-'dd")<br>
     */  
    public static java.util.Date stringToDate(String d, String format)
    {
    	java.util.Date ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            ch = sdf.parse(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }         
     
    /**
     * 현재날짜를 YYYY-MM-DD HH:MM:SS 형식으로 만들어 리턴 <br>
     */  
    public static String getTime(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH'-'mm'-'ss");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 
	

    /**
     * 현재날짜를 YYYY-MM-DD HH:MM:SS 형식으로 만들어 리턴 <br>
     */  
    public static String getTimeHMS(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("HH':'mm':'ss");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 


    public static String getTimeHMS2(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("HH'시 'mm'분'");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 

    public static String getTimeAM(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("aa");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 



    /**
     * 현재 날짜를 타입에 따라 년, 월,일 만을 리턴 <br>
     */  
    public static String getDate(int type)
    {
    	String ch = getDate();
    	String format = null;		
    	switch(type){
    		case 1:
    			format = ch.substring(0,4);
    			break;
    		case 2:
    			format = ch.substring(5,7);
    			break;
    		case 4:
    			format = ch.substring(0,4)+ch.substring(5,7)+ch.substring(8,10);
    			break;
    		case 5:
    			format = ch.substring(0,4)+ch.substring(5,7);
    			break;
			case 6:
    			format = ch.substring(0,4)+"-"+ch.substring(5,7);
    			break;
    		case 7:
    			format = ch.substring(2,4);
    			break;
    		default:
    			format = ch.substring(8,10);
    			break;
    	}
    	return format;
    }

    /**
     * 현재 날짜를 타입에 따라 년, 월,일 만을 리턴 <br>
     */  
    public static int getDate2(int type)
    {
    	String ch = getDate();
    	String format = null;		
    	switch(type){
    		case 1:
    			format = ch.substring(0,4);
    			break;
    		case 2:
    			format = ch.substring(5,7);
    			break;
    		case 4:
    			format = ch.substring(0,4)+ch.substring(5,7)+ch.substring(8,10);
    			break;
    		default:
    			format = ch.substring(8,10);
    			break;
    	}
    	return parseInt(format);
    }

    /**
     * 현재 날짜를 2000년 1월 1일 타입으로 리턴
     */  
    public static String getDate3()
    {
    	String ch = getDate();
    	String format = null;		
		format = ch.substring(0,4)+"년 "+ch.substring(5,7)+"월 "+ch.substring(8,10)+"일";
    	return format;
    }

    /**
     * 날짜를 2000년 1월 1일 타입으로 리턴
     */  
    public static String getDate3(String date)
    {
    	String format = "";		
    	if(date.length() == 6){ 
			format = date.substring(0,4)+"년 "+date.substring(4,6)+"월 ";
		}else if(date.length() == 10){//2000-01-01 
			format = date.substring(0,4)+"년 "+date.substring(5,7)+"월 "+date.substring(8,10)+"일";
		}
    	else if(date.length() == 8){//20000101
			format = date.substring(0,4)+"년 "+date.substring(4,6)+"월 "+date.substring(6,8)+"일";
		}
		else if(date.length() == 12){//200001011143
			format = date.substring(0,4)+"년 "+date.substring(4,6)+"월 "+date.substring(6,8)+"일 "+date.substring(8,10)+"시 "+date.substring(10,12)+"분";
		}
		else if(date.length() == 14){//20000101114315
			format = date.substring(0,4)+"년 "+date.substring(4,6)+"월 "+date.substring(6,8)+"일 "+date.substring(8,10)+"시 "+date.substring(10,12)+"분 "+date.substring(12,14)+"초";
		}
		return format;
    }

	
    /**
     * 날짜형을 년, 월, 일로 나누어 리턴하는 메소드<br>
     */
    public static String parseDate(String date, int type){
    	String parse = "";
    	if(date != null && date.length() == 8){
    		switch(type){
    			case 1: //년
    				parse = date.substring(0, 4);
    				break; 
    			case 2: //월
    				parse = date.substring(4, 6);
    				break;
    			default: //일
    				parse = date.substring(6, 8);
    				break;
    		}
    	}
    	return parse;
    }

    /**
     * 특정 날짜를 'YYYY/MM/DD' 형식으로 return<br>
     */
    public static String returnDate(String date) {

		String year = date.substring(0,4);
		String month = date.substring(4,6);
		String day = date.substring(6,8);

		return year + "/" + month + "/" + day;
	}
    
    /**
     * 윤년 check Method...
     * : 올해가 윤년인지를 check하여 booelan으로 return;
     */
	 public static boolean checkEmbolism(int year) {

		 int remain = 0;
		 int remain_1 = 0;
		 int remain_2 = 0;

		 remain = year % 4;
		 remain_1 = year % 100;
		 remain_2 = year % 400;

		 // the ramain is 0 when year is divided by 4;
		 if (remain == 0) {

			 // the ramain is 0 when year is divided by 100;
			 if (remain_1 == 0) {

			 	// the remain is 0 when year is divided by 400;
				if (remain_2 == 0) return true;
				else return false;

			 } else  return true;
		 }

		 return false;
	 }

    /**
     * 각 월의 마지막 일을 return
     * 해당 월의 마지막일을 return. 윤년 check후 해당 일을 return
     */
	public static int getMonthDate(int year, int month) {

		int[] dateMonth = new int[12];

		dateMonth[0] = 31;
		dateMonth[1] = 28;
		dateMonth[2] = 31;
		dateMonth[3] = 30;
		dateMonth[4] = 31;
		dateMonth[5] = 30;
		dateMonth[6] = 31;
		dateMonth[7] = 31;
		dateMonth[8] = 30;
		dateMonth[9] = 31;
		dateMonth[10] = 30;
		dateMonth[11] = 31;

		if (checkEmbolism(year)) dateMonth[1] = 29;

		return dateMonth[month - 1];
	}

    /**
     * 날짜형식 체크
     */
	 public static boolean checkDate(String c_dt) {

	     String ch_date		= replace(c_dt,"-","");

		 if(c_dt.equals("")) return false;

		 if(ch_date.length() == 0) return false;

		 if(ch_date.length() == 8){
		
			   String ch_year	= ch_date.substring(0,4);
			   String ch_month	= ch_date.substring(4,6);
			   String ch_day	= ch_date.substring(6,8);
			   int    ck_day = 0;
			   //월 체크	
			   if(parseInt(ch_month)>12){				
			       return false;
			   }
               //월 말일자 가져오기
			   ck_day = getMonthDate(parseInt(ch_year),parseInt(ch_month));
			   //윤년일때 2월 말일자 처리
               if(parseInt(ch_month)==2 && checkEmbolism(parseInt(ch_year))){
					ck_day = ck_day+1;
			   }
   			   //일 체크
               if(parseInt(ch_day)>ck_day){				
			       return false;
			   }

			   return true;
	    
		 }else{
			   return false;
		 }

	 }

    /**
     * 주일을 받아 한글/한문으로 보낸다.
     */
    public static String parseDateWeek(String gubun, int type){
    	String whatday_k = "";
		String whatday_c = "";
   		switch(type){
   			case 1: 
   				whatday_k = " 일";
   				whatday_c = " 日";
   				break; 
   			case 2: 
   				whatday_k = " 월";
   				whatday_c = " 月";
   				break;
   			case 3: 
   				whatday_k = " 화";
   				whatday_c = " 火";
   				break;
   			case 4: 
   				whatday_k = " 수";
   				whatday_c = " 水";
   				break;
   			case 5: 
   				whatday_k = " 목";
   				whatday_c = " 木";
   				break;
   			case 6: 
   				whatday_k = " 금";
   				whatday_c = " 金";
   				break;
   			default:
   				whatday_k = " 토";
   				whatday_c = " 土";
   				break;
   		}
		if(gubun.equals("1")) 
	    	return whatday_k;
		else
			return whatday_c;
    }

	/**
	*	날수 구하기
	*/
	 public static String gapDate(String st, String ed)
    {
    	java.util.Date ch = null;
		java.util.Date ch2 = null;
		long gap = 0;
		double gap2 = 0.0;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            ch = sdf.parse(st); 
			ch2 = sdf.parse(ed);
			gap = ch2.getTime() - ch.getTime();
			gap2 = Math.floor(gap / (1000 * 60 * 60 * 24));
    	} catch(Exception dfdf) { }
		return parseDecimal(gap2,"#0");
    }    
	/**
	*	날수 구하기2 --20050115 견적내기
	*/
	 public static int gapDate2(String st, String ed)
    {
    	java.util.Date ch = null;
		java.util.Date ch2 = null;
		long gap = 0;
		double gap2 = 0.0;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            ch = sdf.parse(st); 
			ch2 = sdf.parse(ed);
			gap = ch2.getTime() - ch.getTime();
			gap2 = Math.floor(gap / (1000 * 60 * 60 * 24));
    	} catch(Exception dfdf) { }
		return parseDigit(parseDecimal(gap2,"#0"));
    }
	 
	 //yyyyMMdd 날짜형식을 받아 해당날짜 요일 리턴
	 public static String getDateDay(String date) throws Exception {
		 
		 String day = "";
		 SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		 java.util.Date nDate = dateFormat.parse(date);
	     
		 Calendar cal = Calendar.getInstance();
		 cal.setTime(nDate);
	     
		 int dayNum = cal.get(Calendar.DAY_OF_WEEK);
	     
		 switch (dayNum) {
		 	case 1:
	            day = "일";
	            break;
	        case 2:
	            day = "월";
	            break;
	        case 3:
	            day = "화";
	            break;
	        case 4:
	            day = "수";
	            break;
	        case 5:
	            day = "목";
	            break;
	        case 6:
	            day = "금";
	            break;
	        case 7:
	            day = "토";
	            break;
		 }
		 
		 return day;
	 }


	 /**
     * 현재날짜를 YYYY-MM-DD HH:MM:SS 형식으로 만들어 리턴 <br> - 수정
     */  
    public static String getTimeYMDHMS(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd' 'HH':'mm':'ss");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 

	 public static String getTimeYMDHM(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 

	/**********************************************/	
	/*                                            */
	/*           금    액    관    련            */
	/*                                            */
	/**********************************************/	

    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(float unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        String format = df.format(unFormat);
        return format;
    }
		
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(double unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        String format = df.format(unFormat);
        return format;
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(Object unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        double unFormat1 = parseInt(toString(unFormat));
        String format = df.format(unFormat1);
        return format;
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(String unFormat){

		if(unFormat == null){
			return unFormat;
		}else{
			if(unFormat.length() == 1){
				return unFormat;
			}else{	        
				DecimalFormat df = new DecimalFormat("###,###.##");
				double unFormat1 = parseInt(unFormat);       
				String format = df.format(unFormat1);
				return format;
			}
		}
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal2(String unFormat){
		if(unFormat.length() == 1){
			return unFormat;
		}else{	        
	        DecimalFormat df = new DecimalFormat("###,###.##");
 			double unFormat1 = parseLong(unFormat);       
			String format = df.format(unFormat1);
	        return format;
		}
	}
	/**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(int unFormat){
		if(unFormat == 0){
			return Integer.toString(unFormat);
		}else{
			DecimalFormat df = new DecimalFormat("###,###.##");
		    String format = df.format(unFormat);
			return format;
		}
	}
	
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    */        
    public static String parseDecimal(double unFormat, String foramt){
        DecimalFormat df = new DecimalFormat(foramt);
        String format = df.format(unFormat);
        return format;
    }
    /**
     * 추가 - 이민영(2002. 3. 21)
     */        
    public static String parseDecimalLong(String unFormat){
		if(unFormat.length() == 1 || unFormat.equals("0")){
			return unFormat;
		}else if(unFormat.equals("null") || unFormat.equals("")){
			return "0";
		}else{
	        DecimalFormat df = new DecimalFormat("###,##0.##");
 			double unFormat1 = Double.parseDouble(unFormat);       
			String format = df.format(unFormat1);
	        return format;
		}
    } 
    /**
     * 추가 - Yongsoon Kwon(2005. 10. 12)
     */        
    public static String parseDecimalLong(long unFormat){
		if(unFormat == 0){
			return Long.toString(unFormat);
		}else{
	        DecimalFormat df = new DecimalFormat("###,##0.##"); 			       
			String format = df.format(unFormat);
	        return format;
		}
    } 

	/* 금액을 숫자에서 한글로 바꾸기*/
	public static String parseDecimalHan(String num){
		if(num.equals("") || num.equals("0")){	
			return num;
		}else{
			String price_unit0[]= {"","일","이","삼","사","오","육","칠","팔","구"};
			String price_unit1[]= {"","십","백","천"};
			String price_unit2[]= {"","만","억","조","경","해","시","양","구","간","정"};		
			int len = num.length();
			String won [] = new String[50];
			String format = "";
		
			for(int i = len-1; i >= 0; i-- ){
				won[i] = price_unit0[AddUtil.parseInt(num.substring(len-1-i,len-1-i+1))];
				if( i > 0 && won[i] != "" ) { 		won[i]+= price_unit1[i%4]; }
				if( i % 4 == 0 ) { 					won[i]+= price_unit2[(i/4)]; }
			}
			for(int i = len-1; i >= 0; i-- ){
				if(!won[i].equals("")) format += won[i];
			}
			return format;
		}	
	}

	/* 십만원 절사*/
	public static int hun_th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 7){
				format = format.substring(0,len-6)+"000000";
			}			
			return parseInt(format);
		}	
	}
	
	/* 만원 절사*/
	public static String ten_th_rnd(String num){
		String format="";
		if(num.equals("") || num.equals("0")){	
			return "0";
		}else{
			int len=num.length();
			if(len >= 6){
				format = num.substring(0,len-5)+"00000";
			}			
			return format;
		}	
	}
	
	/* 만원 절사*/
	public static int ten_th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 6){
				format = format.substring(0,len-5)+"00000";
			}			
			return parseInt(format);
		}	
	}

	/* 천원 절사*/
	public static String th_rnd(String num){
		String format="";
		if(num.equals("") || num.equals("0")){	
			return "0";
		}else{
			int len=num.length();
			if(len >= 5){
				format = num.substring(0,len-4)+"0000";
			}			
			return format;
		}	
	}
	
	/* 천원 절사*/
	public static int th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 5){
				format = format.substring(0,len-4)+"0000";
			}			
			return parseInt(format);
		}	
	}

	/* 천원 절사-나머지 버림*/
	public static int trunc_num(int num, int cut_size){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= cut_size){
				format = format.substring(0,len-cut_size);
			}			
			return parseInt(format);
		}	
	}

	/* 백원 절사*/
	public static int ml_th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 4){
				format = format.substring(0,len-3)+"000";
			}			
			return parseInt(format);
		}	
	}
	

	/* 백원 절사*/
	public static String ml_th_rnd(String num){
		String format="";
		if(num.equals("") || num.equals("0")){	
			return "0";
		}else{
			int len=num.length();
			if(len >= 4){
				format = num.substring(0,len-3)+"000";
			}			
			return format;
		}	
	}

	/* 십원 절사*/
	public static int sl_th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 3){
				format = format.substring(0,len-2)+"00";
			}			
			return parseInt(format);
		}	
	}
	

	/* 십원 절사*/
	public static String sl_th_rnd(String num){
		String format="";
		if(num.equals("") || num.equals("0")){	
			return "0";
		}else{
			int len=num.length();
			if(len >= 3){
				format = num.substring(0,len-2)+"00";
			}			
			return format;
		}	
	}
	
		/* 일원 절사*/
	public static int l_th_rnd(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 2){
				format = format.substring(0,len-1)+"0";
			}			
			return parseInt(format);
		}	
	}
	
		/* 일원 절사*/
	public static long l_th_rnd_long(long num){
		String format=Long.toString(num);
				
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 2){
				format = format.substring(0,len-1)+"0";
			}			
			return parseLong(format);			
		}	
	}
	
	
	/* 백만원 단위로 자르기*/
	public static int million(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 7){
				format = format.substring(0,len-6);
			}			
			return parseInt(format);
		}	
	}

	/* 백만원 단위로 자르기*/
	public static String million(String num){
		String format="";
		if(num.equals("") || num.equals("0")){	
			return "0";
		}else{
			int len=num.length();
			if(len >= 7){
				format = num.substring(0,len-6);
			}			
			return format;
		}	
	}

	/* 만원 단위로 자르기*/
	public static int ten_thous(int num){
		String format=Integer.toString(num);
		if(num == 0){	
			return 0;
		}else{
			int len=format.length();
			if(len >= 6){
				format = format.substring(0,len-4);
			}			
			return parseInt(format);
		}	
	}
	
	/**
    * 통화형식(comma)의 문자열을 일반 숫자형식으로 리턴
    */        
    public static int parseDigit(String format){
        int str_size = format.length();
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return parseInt(new_str.toString());
    }

	/**
    * 통화형식(comma)의 문자열을 일반 숫자형식으로 리턴
    */        
    public static float parseDigit2(String format){
        int str_size = format.length();	
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return parseFloat(new_str.toString());
    }

	/**
    * 통화형식(comma)의 문자열을 일반 숫자형식으로 리턴
    */        
    public static String parseDigit3(String format){
        int str_size = format.length();	
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return new_str.toString();
    }

	/**
    * 통화형식(comma)의 문자열을 일반 숫자형식으로 리턴
    */        
    public static long parseDigit4(String format){
        int str_size = format.length();	
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return parseLong(new_str.toString());
    }

    /**
    * 소수점 자리수 절사
    */        
    public static float parseFloatCipher(float unFormat, int cipher){
		String format = Float.toString(unFormat);
		if(format.equals("NaN")){
			return 0;
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				return unFormat;
			}else{
				int len = format.substring(dot_post+1).length();
				if(len <= cipher){
					return Float.parseFloat(format);
				}else{
					format = format.substring(0, dot_post+1)+format.substring(dot_post+1, dot_post+1+cipher);
					return Float.parseFloat(format);
				}
			}
		}
    }

    /**
    * 소수점 자리수 절사
    */        
    public static String parseFloatCipher2(float unFormat, int cipher){
		String format = Float.toString(unFormat);
		if(format.equals("NaN")){
			return "0.00";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(cipher == 0){
				if(dot_post == -1){
					return format;
				}else{
					return format.substring(0,dot_post);
				}
			}else{

				if(dot_post == -1){
					return format;
				}else{
					int len = format.substring(dot_post+1).length();
					if(len == cipher){
						return format;
					}else if(len < cipher){
						return format+"0";
					}else{
						format = format.substring(0, dot_post+1)+format.substring(dot_post+1, dot_post+1+cipher);
						return format;
					}
				}
			}
		}
    }

    /**
    * 소수점 자리수 절사
    */        
    public static String parseFloatCipher(String unFormat, int cipher){
		String format = unFormat;
		if(format == null || format.equals("NaN") ){
			if(cipher == 1)					return "0.0";
			else if(cipher == 2)			return "0.00";
			else if(cipher == 3)			return "0.000";
			else if(cipher == 4)			return "0.0000";
			else							return "0.00";
		}else{
			if(format.indexOf(".")==0){
				format = "0"+format;
			}
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				if(cipher == 1)				return unFormat+".0";
				else if(cipher == 2)		return unFormat+".00";
				else if(cipher == 3)		return unFormat+".000";
				else if(cipher == 4)		return unFormat+".0000";
				else						return unFormat+".00";
			}else{
				int len = format.substring(dot_post+1).length();
				if(len == cipher){
					if(format.substring(0,2).equals("-.")) format = "-0."+format.substring(2);	
					return format;
				}else if(len < cipher){
					if((cipher-len) ==2){
						format = format+"00";	
					}else if((cipher-len) ==3){
						format = format+"000";	
					}else{
						format = format+"0";	
					}
					if(format.substring(0,2).equals("-.")) format = "-0."+format.substring(2);
					return format;
				}else{
					format = format.substring(0, dot_post+1)+format.substring(dot_post+1, dot_post+1+cipher);
					if(format.substring(0,2).equals("-.")) format = "-0."+format.substring(2);
					return format;
				}
			}
		}
    }

    /**
    * 소수점 자리수 절사
    */        
    public static String parseFloatTruncZero(String unFormat){
		String format = unFormat;
		if(format == null || format.equals("NaN")){
			return "0";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				return unFormat;
			}else{
				if(tot_len>0){
					format = format.substring(0, dot_post);
					return format;
				}else{
					return unFormat;
				}
			}
		}
    }

    /**
    * 소수점 자리수 반올림
    */        
    public static String parseFloatRoundZero(String unFormat){
		String format = unFormat;
		if(format == null || format.equals("NaN")){
			return "0";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				return unFormat;
			}else{
				if(tot_len>0){
					int i_amt = Math.round(parseFloat(unFormat));
					//format = format.substring(0, dot_post);
					format = String.valueOf(i_amt);
					return format;
				}else{
					return unFormat;
				}
			}
		}
    }

    /**
    * 원단위 절사
    */        
    public static String parseFloatTruncTenZero(String unFormat){
		String format = unFormat;
		if(format == null || format.equals("NaN")){
			return "0";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			//. 없음
			if(dot_post == -1){				
				if(tot_len>0){
					format = format.substring(0, tot_len-1)+"0";
					return format;
				}else{
					return unFormat;	
				}
			//. 있음
			}else{
				if(tot_len>0){
					format = format.substring(0, dot_post-1)+"0";
					return format;
				}else{
					return unFormat;
				}
			}
		}
    }
      
   
    /**
    * 소수점 자리수 .0 정리
    */        
    public static String parseFloatNotDot(float unFormat){
		String format = Float.toString(unFormat);
		if(format.equals("NaN")){
			return "0";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				return format;
			}else{				
				if(format.substring(dot_post).equals(".0")){
					format = format.substring(0, dot_post);
				}
				return format;
			}
		}
    }


    /**
    * 소수점 자리수 .0 정리
    */        
    public static String parseFloatNotDot2(float unFormat){
		String format = Float.toString(unFormat);
		if(format.equals("NaN")){
			return "0";
		}else{
			int tot_len = format.length();
			int dot_post = format.indexOf(".");
			if(dot_post == -1){
				return format;
			}else{								
				format = format.substring(0, dot_post);				
				return format;
			}
		}
    }


	/**********************************************/	
	/*                                            */
	/*        데  이  타  타  입  변  환          */
	/*                                            */
	/**********************************************/	

    /**
     * String을 int로 변환. NumberFormatException, NullPointerException 을 검사하기 위해, Exception 발생시 0 리턴
     */
    public static int parseInt(String str){
    	int parseInt = 0;
    	try{
    		parseInt = Integer.parseInt(str);
    	}catch(Exception nf){}
    	return parseInt;
    }
	
	/**
     * String을 float로 변환.
     */
    public static float parseFloat(String str){
    	float parseFloat = 0.0f;
    	try{
    		parseFloat = Float.parseFloat(str);
    	}catch(Exception nf){}
    	return parseFloat;
    }
   
	/**
     * String을 double로 변환.
     */
    public static double parseDouble(String str){
    	double parseDouble = 0.0f;
    	try{
    		parseDouble = Double.parseDouble(str);
    	}catch(Exception nf){}
    	return parseDouble;
    }
	
    /**
     * String을 long로 변환.
     */
    public static long parseLong(String str){
    	long parseLong = 0L;
    	try{
    		parseLong = Long.parseLong(str);
    	}catch(Exception nf){}
    	return parseLong;
    }	
    /**
     * String을 int로 변환. NumberFormatException, NullPointerException을 검사하기 위해, Exception 발생시 default value 리턴<br>
     */
    public static int parseInt(String str, int def){
    	int parseInt = 0;
    	try{
    		parseInt = Integer.parseInt(str);
    	}catch(Exception nf){parseInt = def;}
    	return parseInt;
    }

    /**
     * Object 형을 String 으로 변환<br>
     * : Object 가 null 일때 NullpointerException 을 검사하기 위해서 사용.<br>
     * : ResultSet 으로부터 getObject()로 값을 가져왔을경우 String으로 변환할때 사용하면 유용한 메소드.<br>
     */
    public static String toString(Object obj){
        String str = "";
    	if(obj != null)
    	    str = obj.toString();
    	return str;
    }

	
	/**********************************************/	
	/*                                            */
	/*              체           크               */
	/*                                            */
	/**********************************************/	

	/**
     * 파라미터의 값이 "" 일때 null 을 리턴하게끔 하는 메소드<br>
     * URL에서 파라미터를 받을때 name 값이 존재하면 "" 이 넘어올 수 있기 때문에 null 값을 검사할때 사용.<br>
     */
    public static String checkNull(String key){
    	String value = key;
    	if(key == null || key.equals(""))
    		value = null;
    	return value;			
    }
	
    /**
     * 문자열의 값이 null 이거나 ""이면 default 값을 리턴하는 메소드<br>
     */
    public static String getString(String line, String def){
        if(line == null || line.equals(""))
            return def;
        return line;  
    } 
         
    /**
     * 현재일이  특정 기간에 속해있는지 검사하는 메소드<br>
     * : argument : 시작일(yyyy-mm-dd), 종료일(yyyy-mm-dd)
     */
    public static boolean betweenDate(String first, String second){
        boolean flag = false;
        java.util.Date start = null;
        java.util.Date end = null;
        java.util.Date current = null;
        
        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.KOREA);
        
        try{			
            start = df.parse(first);
            end = df.parse(second);
            current = df.parse(getDate());
        }catch(Exception pe){
            return false;				
        }
        
        if((start.before(current) && end.after(current)) || start.equals(current) || end.equals(current)) 
            flag= true;
        
        return flag;
    }
       
    /**
     * 문자열을 substring할때 문자열 길이를 넘어설 경우 "" 를리턴하는 메소드
     */
    public static String substring(String str, int start, int end){
        String val = null;
        try{
            val = str.substring(start, end);
        }catch(Exception e){
            return "";  
        }
        return val;
    }
	
    /**
     * 문자열을 substring할때 제한된 길이까지만
     */
    public static String substring(String str, int max_len){
        String val = null;
		int len = str.length();
	
		if(len > max_len) len = max_len;
        try{
            val = str.substring(0, len);
        }catch(Exception e){
            return "";  
        }
        return val;
     //   System.out.println(val);
    }

    /**
     * 문자열을 substring할때 제한된 바이트 길이까지만
     */
    public static String substringb(String str, int max_len){
        String val = "";
		byte[] temp = str.getBytes();
		int lenb = temp.length;
		int len = str.length();
		int lenc = 0;

        try{

			if(lenb > max_len){
				for(int i=0; i<len; i++) {					
					String cs = String.valueOf(str.charAt(i));		
					int    ci = (int)str.charAt(i);

					if(ci > 256) 	lenc+=2;	//1 바이트로 표현할 수 있는 크기인 256 보다 크다면 2바이트
					else 			lenc++;

					if(lenc <= max_len)		val = val + cs;	
					else					continue;

				}		
			}else{
				val = str;
			}

        }catch(Exception e){
            return "";  
        }
        return val;
    }

    /**
     * 문자열을 substring할때 제한된 바이트 길이까지만
     */
    public static String substringbdot(String str, int max_len){
        String val = "";
		byte[] temp = str.getBytes();
		int lenb = temp.length;
		int len = str.length();
		int lenc = 0;

        try{

			if(lenb > max_len){
				for(int i=0; i<len; i++) {					
					String cs = String.valueOf(str.charAt(i));		
					int    ci = (int)str.charAt(i);

					if(ci > 256) 	lenc+=2;	//1 바이트로 표현할 수 있는 크기인 256 보다 크다면 2바이트
					else 			lenc++;

					if(lenc <= max_len)		val = val + cs;	
					else					continue;

				}	
				
				val = val+"..";
			}else{
				val = str;
			}

        }catch(Exception e){
            return "";  
        }
        return val;
    }

    /**
     * 문자열을 바이트 length
     */
    public static int lengthb(String str){
        int len = 0;
		byte[] temp = str.getBytes();
		int lenb = temp.length;

        try{
			if(lenb > 0){
				len = lenb;
			}

        }catch(Exception e){
            return 0;  
        }
        return len;
    }


	/**
	 * 절상, 절하, 반올림 처리
	 * @param strMode  - 수식
	 * @param nCalcVal - 처리할 값(소수점 이하 데이터 포함)
	 * @param nDigit   - 연산 기준 자릿수(오라클의 ROUND함수 자릿수 기준)
	 *                   -2:십단위, -1:원단위, 0:소수점 1자리
	 *                   1:소수점 2자리, 2:소수점 3자리, 3:소수점 4자리, 4:소수점 5자리 처리
	 * @return String nCalcVal
	 */

	public static String calcMath(String strMode, String strCalcVal, int nDigit) {
		double nCalcVal = 	parseDouble(strCalcVal);
		if(strMode.equals("ROUND")) {        //반올림
	        if(nDigit < 0) {
	            nDigit = -(nDigit);
	            nCalcVal = Math.round(nCalcVal / Math.pow(10, nDigit)) * Math.pow(10, nDigit);
	        } else {
	            nCalcVal = Math.round(nCalcVal * Math.pow(10, nDigit)) / Math.pow(10, nDigit);
	        }
	    } else if(strMode.equals("CEIL")) {  //절상
	        if(nDigit == 0) {
	        	nCalcVal = Math.ceil(nCalcVal);
	        }else if(nDigit < 0) {
	            nDigit = -(nDigit);
	            nCalcVal = Math.ceil(nCalcVal / Math.pow(10, nDigit)) * Math.pow(10, nDigit);
	        } else {
	            nCalcVal = Math.ceil(nCalcVal * Math.pow(10, nDigit)) / Math.pow(10, nDigit);
	        }
	    } else if(strMode.equals("FLOOR")) { //절하
	        if(nDigit < 0) {
	            nDigit = -(nDigit);
	            nCalcVal = Math.floor(nCalcVal / Math.pow(10, nDigit)) * Math.pow(10, nDigit);
	        } else {
	            nCalcVal = Math.floor(nCalcVal * Math.pow(10, nDigit)) / Math.pow(10, nDigit);
	        }
	    } else {                        //그대로(무조건 소수점 첫째 자리에서 반올림)
	        nCalcVal = Math.round(nCalcVal);
	    }

	    return String.valueOf(nCalcVal);
	}





	/**********************************************/	
	/*                                            */
	/*           게        시        판           */
	/*                                            */
	/**********************************************/	
        
    /**
     * 전체 데이터수로 마지막페이지를 계산해오기 위한 Method.<br>
     * : 게시판 목록 같은 경우 몇 페이지 까지 있는지 계산할때 사용하면 유용한 메소드<br>
     */    
    public static int getPageCount(int token, int allPage){
    	int lastPage =(int)(((allPage-1)/token)+1);	
    	return lastPage;
    }
	
    /**
     * 데이터의 번호를 주기위해 번호를 계산해오는 Method <br>
     * : 게시판 목록 같은 경우 페이지별 데이터의 번호를 계산해 주는 메소드. <br>
     */    
    public static int getDataNum(int token, int page, int allPage){
    	if(allPage<=token){
    		return allPage;
    	}
    	int num = allPage - (token*page) + token;	
    	return num;
    }
        
    /**
     * 숫자 만큼 공백문자를 붙혀서 리턴하는 메소드<br>
     * 답변에서 Depth 처리 하는데 사용하면 유용할꺼 같음.<br>
     */
    public static String levelCount(int level){
        StringBuffer sb = new StringBuffer("");
        for(int i=0; i<level; i++){
            sb.append("&nbsp;&nbsp;");
        }
        return sb.toString();
    }        

	/**
    * Object 의 복제하여 주는 메소드<br>
    * 일반적으로 java.lang.Object.clone() 메소드를 사용하여 Object를 복제하면 Object내에 있는 Primitive type을 제외한 Object <br>
    * field들은 복제가 되는 것이 아니라 같은 Object의 reference를 갖게 된다.<br>
    * 그러나 이 Method를 사용하면 각 field의 동일한 Object를 새로 복제(clone)하여 준다.<br>
    * java.lang.reflect API 를 사용하였음. <br>
    */        
    public static Object clone(Object object){
        Class c = object.getClass();
        Object newObject = null;
        try {
            newObject = c.newInstance();
        }catch(Exception e ){
            return null;
        }
        
        java.lang.reflect.Field[] field = c.getFields();
        for (int i=0 ; i<field.length; i++) {
            try {
                Object f = field[i].get(object);
                field[i].set(newObject, f);
            }catch(Exception e){}
        }
        return newObject;
    }
        
    /**
    * 디버깅시 Servlet 에서는 PrintWriter 를 넣어서 쉽게 디버깅을 할 수 있었지만 <br>
    * JSP 에서 처럼 PrintWriter가 없을때 디버깅을 쉽게 하기 위하여 메세지를 문자열로 만들어 리턴하게 하였음.<br>
    */                
    public static String getStackTrace(Throwable e) {
        java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
        java.io.PrintWriter writer = new java.io.PrintWriter(bos);
        e.printStackTrace(writer);
        writer.flush();
        return bos.toString();
    } 
    
    
   	public static String getReplace_dt(String check_dt)
	{
		
		return  replace(check_dt,"-","");		       
	}

	public static String getReplace_ss(String ssnum)
	{
		
		return  replace(ssnum,".","");		       
	}
		
	public static String getSTRFilter(String str){ 
	   int str_length = str.length(); 
	   String strlistchar   = ""; 
	   String str_imsi   = ""; 
	  	  	   
	   str = str.replace("\"", " ");	   
	
//	   String []filter_word = {"","\\.","\\?","\\/">\\~","\\!","\\@","\\#","\\$","\\%","\\^","\\&","\\*","\\(","\\)","\\_","\\+","\\=","\\|","\\\\","\\}","\\]","\\{","\\[","\\\"","\\'","\\:","\\;","\\<","\\,","\\>","\\.","\\?","\\/"}; 
//	   String []filter_word = {"","\\.","\\?","\\/">\\~","\\!","\\@","\\#","\\$","\\%","\\^","\\&","\\*","\\(","\\)","\\_","\\+","\\=","\\|","\\\\","\\}","\\]","\\{","\\[","\\\"","\\'","\\:","\\;","\\<","\\,","\\>","\\.","\\?","\\/"}; 
	 
//	  for(int i=0;i<filter_word.length;i++){ 
//	    //while(str.indexOf(filter_word[i]) >= 0){ 
//	       str_imsi = str.replaceAll(filter_word[i],""); 
//	       str = str_imsi; 
//	    //} 
//	   } 
 
  	return str; 
 
 	} 

}

