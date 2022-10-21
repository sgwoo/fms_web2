<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %> 
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<%@ page import="acar.cont.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
 //   long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    
    long t_amt10[] = new long[1];   //보조금 
    
    String gov_chk_id = "";
    
    
    long r_amt = 0;
    
    Date d = new Date();
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	//System.out.println("현재날짜 : "+ sdf.format(d));
   	String filename = sdf.format(d)+"_세부내역서.xls";
   	filename = java.net.URLEncoder.encode(filename, "UTF-8");
   	response.setContentType("application/octer-stream");
   	response.setHeader("Content-Transper-Encoding", "binary");
   	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
   	response.setHeader("Content-Description", "JSP Generated Data");
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=30;	
	<%if(FineDocBn.getPrint_dt().equals("")){%>
		//print();
	<%}%>
	}
//-->
</script>
</head>

<body leftmargin="15" topmargin="1"  face="바탕">
<form action="" name="form1" method="POST" >

  <table width='1500' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="바탕"># 첨부: 세부 내역서 ( <%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%> ) </font></td>
    </tr>
	
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr> 
      <td align='center'> 
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
          <tr> 
            <td> 
			  <table width="100%" border="1" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="30" width="8%"  rowspan="3" style="font-size : 10pt;"><font face="바탕">구분</font></td>
                  <td height="30" width="57%"  colspan="5" style="font-size : 10pt;"><font face="바탕">자동차구입내용</font></td>
                  <td height="30" width="45%" colspan="4" style="font-size : 10pt;"><font face="바탕">대출취급내용</font></td>
                </tr>
                <tr bgcolor="#FFFFFF" align="center">               
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="바탕">자동차사항</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;"><font face="바탕">구입명세</font></td>
                  <td height="25" colspan="4" style="font-size : 10pt;"><font face="바탕">대출금</font></td>                  
                </tr>
                <tr bgcolor="#FFFFFF" align="center"> 
                  <td width="12%" height="25" style="font-size : 10pt;"><font face="바탕">차종</font></td>
                  <td width="8%" height="25" style="font-size : 10pt;"><font face="바탕">계출번호</font></td>              
                  <td width="8%" height="25" style="font-size : 10pt;"><font face="바탕">구입가격</font></td>   
                  <td width="15%" height="25" style="font-size : 10pt;"><font face="바탕">대리점</font></td>   
                  <td width="10%" height="25" style="font-size : 10pt;"><font face="바탕">전화번호</font></td>                                 
               
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">원금</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">상환기간</font></td> 
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="바탕">결제일</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">취급요청일</font></td>                
                </tr>
             
              </table></td>
          </tr>
        </table></td>
    </tr>
     <tr> 
      <td height="2" align="center"></td>
    </tr>	
    <tr>
     <td height="10" align='center'>
     <table width="100%" border="1" cellspacing="1" cellpadding="0">
       <tr> 
            <td> 
			  <table width="100%" border="1" cellspacing="1" cellpadding="0">
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);
					
					gov_chk_id = String.valueOf(ht.get("GOV_ID"));
					
					//영업소 담당자
					CommiBean emp1 	= a_db.getCommi(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "1");
					CommiBean emp2 	= a_db.getCommi(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "2");
					
					//출고정보
					ContPurBean pur = a_db.getContPur(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
					
					if(pur.getDir_pur_yn().equals("Y") && emp2.getEmp_id().equals("")){
						emp2 	= a_db.getCommi(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "1");
					}
						
					//영업사원
					CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
										
					r_amt =  AddUtil.parseLong(String.valueOf(ht.get("AMT3"))) - AddUtil.parseLong(String.valueOf(ht.get("SD_AMT"))) ;
				
					for(int j=0; j<1; j++){
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //대여료
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2"))); //총대여료
						t_amt3[j] += r_amt;	//구매가격 - 탁송가격 
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	//대출금액
			//			t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));	//소비자가격
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("PRE_AMT")));	//선납금액
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));	//취득세
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));	//담보시 사용할 금액
					//	t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("DAM_AMT")));	//삼성담보시 사용할 금액
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("ECAR_AMT")));	//보조금   
					
						
					//	t_amt9[j] +=1000000;	//무림 담보시 사용할 금액
					}			
					
		%>
          <tr align="center">
            <td  width="8%" height="30" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=i+1%></td>        
            <td  width="12%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NM")%></font></td>
            <td  width="8%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("RPT_NO")%></font></td>  
            <td  width="8%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(r_amt)%></font></font></td>       
            <td  width="15%" style="font-size : 8pt;" ><font face="바탕"><%=emp2.getCar_off_nm()%></font></td>
            <td  width="10%" style="font-size : 8pt;"><font face="바탕"><%=coe_bean.getCar_off_tel()%></font></td> <!--자동차  -->
            
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT4"))%></font></td>            
            <td  width="6%" style="font-size : 8pt;" ><font face="바탕"><%=ht.get("PAID_NO")%></font></td>    
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"></font></td> 
            <td  width="5%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("END_DT")%></font></td> <!--대출금  -->
           
          </tr>
          <% 	} %>
         <tr bgcolor="#FFFFFF" align="center">
            <td  colspan=3 height="30"  bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">합계</font></td>  
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt3[0])%></font></td>
            <td  colspan=2 style="font-size : 8pt;"><font face="바탕"></font></td> <!-- 출고예정일 -->
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt4[0])%></font></td>
            <td  colspan=3  style="font-size : 8pt;"><font face="바탕"></font></td> <!-- 상환기간 -->
          
          </tr>
		<%} %>
      </table></td>
        </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
    
  </table>
 
</form>
</body>
</html>
