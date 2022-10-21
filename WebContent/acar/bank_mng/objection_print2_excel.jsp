<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*" %>
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
	
		
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2_S(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    
    long t_amt11[] = new long[1];
    long t_amt12[] = new long[1];
    long t_amt13[] = new long[1];
    long t_amt14[] = new long[1];
    long t_amt15[] = new long[1];
    long t_amt16[] = new long[1];
    long t_amt17[] = new long[1];
    
    String gov_chk_id = "";
    
    Date d = new Date();
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	//System.out.println("현재날짜 : "+ sdf.format(d));
   	String filename = sdf.format(d)+"_조사표.xls";
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
      <td width="100%" height="30" align="center" style="font-size : 12pt;"><font face="바탕"><b>근저당권(등기, 등록) 조사표</b> </font></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="바탕">채무자 : 아마존카 </font></td>
    </tr>
    <tr>
     <td align='center'> 
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
          <tr> 
            <td> 
            
             <table width="100%" border="1" cellspacing="1" cellpadding="0">
		       <tr bgcolor="#FFFFFF" align="center">
		      <td  width="3%"  colspan="1" rowspan="3"  style="font-size : 10pt;"><font face="바탕">구분</font></td>
		      <td  height="25"  colspan="7" rowspan="1"    style="font-size : 10pt;"><font face="바탕">자동차구입내용</font></td>
		      <td colspan="3" rowspan="2"    style="font-size : 10pt;"><font face="바탕">갑구</font></td>
		      <td colspan="2" rowspan="2"    style="font-size : 10pt;"><font face="바탕">을구</font></td>
		      <td colspan="2" rowspan="2"   style="font-size : 10pt;"><font face="바탕">근저당설정비용</font></td>
		    </tr>
		      <tr bgcolor="#FFFFFF" align="center">
		      <td height="25"  colspan="2" rowspan="1"  style="font-size : 10pt;"><font face="바탕">자동차사항</font></td>
		      <td height="25" colspan="5" rowspan="1"  style="font-size : 10pt;" ><font face="바탕">구입명세</font></td>
		    </tr>
		     <tr bgcolor="#FFFFFF" align="center">
		      <td   width="7%" height="25" style="font-size : 10pt;"><font face="바탕">차종</font></td>
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">차량번호</font></td>		
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">구입가격</font></td>
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">구입가격<br>(세금제외)</font></td>
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">자동차</font></td>
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">탁송료</font></td>
		      <td   width="6%" height="25" style="font-size : 10pt;"><font face="바탕">세금계산서<br>발행일</font></td>
		      <td   width="5%"  height="25"  style="font-size : 10pt;"><font face="바탕">소유자</font></td>
		      <td   width="7%"  height="25"  style="font-size : 10pt;"><font face="바탕">취득원인과<br>일자</font></td>
		      <td   width="6%"  height="25"  style="font-size : 10pt;"><font face="바탕">근저당권<br>설정금액</font></td>
		      <td   width="8%"  height="25"  style="font-size : 10pt;"><font face="바탕">등록관청</font></td> 
		      <td   width="5%"  height="25"  style="font-size : 10pt;"><font face="바탕">접수번호</font></td> 
		      <td   width="5%"  height="25" style="font-size : 10pt;"><font face="바탕">등록세</font></td> 
		      <td   width="5%"  height="25" style="font-size : 10pt;"><font face="바탕">증지대</font></td> 
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
				
					for(int j=0; j<1; j++){
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //대여료
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2"))); //총대여료
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));	//구매가격
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	//대출금액
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_AMT")));	//소비자가격
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("PRE_AMT")));	//선납금액
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));	//취득세
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));	//담보시 사용할 금액
									
					
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_S_AMT")));	//구입가격(세금제외)
						t_amt12[j] += AddUtil.parseLong(String.valueOf(ht.get("R_CAR_AMT")));	//자동차
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("SD_CS_AMT")));	//탁송료
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("R1_AMT")));	//등록세
						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("R2_AMT")));	//증지대
					
					}			
					
		%>
          <tr bgcolor="#FFFFFF" align="center">
            <td  width="3%" height="30" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=i+1%></font></td>
            <td  width="7%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NM")%></font></td>
            <td  width="6%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NO")%></font></td>      
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT3"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("CAR_S_AMT"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("R_CAR_AMT"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("SD_CS_AMT"))%></font></td>
            <td  width="6%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("DLV_DT")%></font></td>
            <td  width="5%" style="font-size : 8pt;"><font face="바탕">(주)아마존카</font></td>
            <td  width="7%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("INIT_REG_DT")%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT6"))%></font></td>
            <td  width="8%" style="font-size : 8pt;"><font face="바탕">인천광역시 계양구청</font></td>
        	   <td  width="5%" style="font-size : 8pt;"><font face="바탕"></font></td>
        	   <td  width="5%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("R1_AMT"))%></font></td>
            <td  width="5%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("R2_AMT"))%></font></td>
        
          
          </tr>
          <% 	} %>
         <tr bgcolor="#FFFFFF" align="center">
            <td  colspan=3 height="30"  bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">합계</font></td>          
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt3[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt11[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt12[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt13[0])%></font></td>
            <td  style="font-size : 8pt;"><font face="바탕"></font></td>
            <td  style="font-size : 8pt;"><font face="바탕"></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt8[0])%></font></td>
            <td  style="font-size : 8pt;"><font face="바탕"></font></td>
            <td  style="font-size : 8pt;"><font face="바탕"></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt14[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt15[0])%></font></td>
          
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
