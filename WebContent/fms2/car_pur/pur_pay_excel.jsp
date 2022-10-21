<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_pay_excel.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	
	Vector vt = d_db.getCarPurPayDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<% int col_cnt = 27;%>
<table border="0" cellspacing="0" cellpadding="0" width='2240'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 구매자금</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='2240'>
                <tr> 
                    <td width='30' rowspan="3" class='title'>연번</td>
                    <td width='90' rowspan="3" class='title'>계약번호</td>
                    <td width='100' rowspan="3" class='title'>상호</td>
                    <td width="100" rowspan="3" class='title'>차명</td>                    
                    <td width='70' rowspan="3" class='title'>출고예정일</td>
                    <td width="80" rowspan="3" class='title'>구매가격</td>        	    
                    <td width="30" rowspan="3" class='title'>과세<br>구분</td>       		
                    <td colspan="4" class='title'>구매자금대출</td>       		
        	    <td colspan="4" class='title'>구매자금지출</td>     
                  <td colspan="9" class='title'>선불(캐쉬백)카드</td>
        	      <td colspan="4" class='title'>신용카드결재내역</td>        	            	            	            	    
        	    <td width='80' rowspan="3" class='title'>비고</td>
        	</tr>
                <tr>
                  <td width="80" rowspan="2" class='title'>대출예정금액</td>
                  <td width="70" rowspan="2" class='title'>대출일자</td>
                  <td width="80" rowspan="2" class='title'>대출금액</td>
                  <td width='80' rowspan="2" class='title'>시행처</td>
                  <td width='80' rowspan="2" class='title'>지출예정금액</td>
                  <td width='70' rowspan="2" class='title'>지출일자</td>
                  <td width='80' rowspan="2" class='title'>지출금액</td>
                  <td width='80' rowspan="2" class='title'>지출처</td>
                  <td width="80" rowspan="2" class='title'>우리BC카드</td>
                  <td colspan="3" class='title'>삼성카드</td>
                  <td width='80' rowspan="2" class='title'>롯데카드</td>
                  <td width='80' rowspan="2" class='title'>KB카드</td>
                  <td width='80' rowspan="2" class='title'>전북카드</td>
                  <td width='80' rowspan="2" class='title'>광주카드</td>
                  <td width='80' rowspan="2" class='title'>합계</td>
                  <td width='80' rowspan="2" class='title'>우리</td>
                  <td width='80' rowspan="2" class='title'>엘지카드</td>
                  <td width='80' rowspan="2" class='title'>씨티/하나/<br>
                  국민/외환..</td>
                  <td width='80' rowspan="2" class='title'>소계</td>
                </tr>
                <tr>
                  <td width="80" class='title'>자동차</td>
                  <td width='80' class='title'>삼성화재</td>
                  <td width='80' class='title'>동부화재</td>
                </tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);
    			
    			int card_amt1 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("우리BC카드"))	card_amt1 = card_amt1 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("우리BC카드"))	card_amt1 = card_amt1 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("우리BC카드"))	card_amt1 = card_amt1 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("우리BC카드"))	card_amt1 = card_amt1 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));
    			
    			int card_amt2 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("국민카드"))	card_amt2 = card_amt2 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("국민카드"))	card_amt2 = card_amt2 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("국민카드"))	card_amt2 = card_amt2 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("국민카드"))	card_amt2 = card_amt2 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt3 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("삼성카드"))	card_amt3 = card_amt3 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("삼성카드"))	card_amt3 = card_amt3 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("삼성카드"))	card_amt3 = card_amt3 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("삼성카드"))	card_amt3 = card_amt3 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt4 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("우리BC카드"))	card_amt4 = card_amt4 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("우리BC카드"))	card_amt4 = card_amt4 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("우리BC카드"))	card_amt4 = card_amt4 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("우리BC카드"))	card_amt4 = card_amt4 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));
    			
    			int card_amt5 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("엘지카드"))	card_amt5  = card_amt5  + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("엘지카드"))	card_amt5  = card_amt5  + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("엘지카드"))	card_amt5  = card_amt5  + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("후불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("엘지카드"))	card_amt5  = card_amt5  + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt6 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("후불카드") && !String.valueOf(ht.get("CARD_KIND1")).equals("우리BC카드") && !String.valueOf(ht.get("CARD_KIND1")).equals("엘지카드"))	card_amt6 = card_amt6 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("후불카드") && !String.valueOf(ht.get("CARD_KIND2")).equals("우리BC카드") && !String.valueOf(ht.get("CARD_KIND2")).equals("엘지카드"))	card_amt6 = card_amt6 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("후불카드") && !String.valueOf(ht.get("CARD_KIND3")).equals("우리BC카드") && !String.valueOf(ht.get("CARD_KIND3")).equals("엘지카드"))	card_amt6 = card_amt6 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("후불카드") && !String.valueOf(ht.get("CARD_KIND4")).equals("우리BC카드") && !String.valueOf(ht.get("CARD_KIND4")).equals("엘지카드"))	card_amt6 = card_amt6 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt7 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("롯데카드"))	card_amt7 = card_amt7 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("롯데카드"))	card_amt7 = card_amt7 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("롯데카드"))	card_amt7 = card_amt7 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("롯데카드"))	card_amt7 = card_amt7 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt8 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("광주카드"))	card_amt8 = card_amt8 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("광주카드"))	card_amt8 = card_amt8 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("광주카드"))	card_amt8 = card_amt8 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("광주카드"))	card_amt8 = card_amt8 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			int card_amt9 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND1")).equals("전북카드"))	card_amt9 = card_amt9 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND2")).equals("전북카드"))	card_amt9 = card_amt9 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND3")).equals("전북카드"))	card_amt9 = card_amt9 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드") && String.valueOf(ht.get("CARD_KIND4")).equals("전북카드"))	card_amt9 = card_amt9 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

				int card_amt10 = 0;
    			
    			if(String.valueOf(ht.get("TRF_ST1")).equals("카드할부") && String.valueOf(ht.get("CARD_KIND1")).equals("우리BC카드"))	card_amt10 = card_amt10 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT1")));
    			if(String.valueOf(ht.get("TRF_ST2")).equals("카드할부") && String.valueOf(ht.get("CARD_KIND2")).equals("우리BC카드"))	card_amt10 = card_amt10 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT2")));
    			if(String.valueOf(ht.get("TRF_ST3")).equals("카드할부") && String.valueOf(ht.get("CARD_KIND3")).equals("우리BC카드"))	card_amt10 = card_amt10 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT3")));
    			if(String.valueOf(ht.get("TRF_ST4")).equals("카드할부") && String.valueOf(ht.get("CARD_KIND4")).equals("우리BC카드"))	card_amt10 = card_amt10 + AddUtil.parseInt(String.valueOf(ht.get("TRF_AMT4")));

    			
    			%>
                <tr> 
                    <td align='center'><%=i+1%></td>  
                    <td align='center'><%=ht.get("RENT_L_CD")%></td>                             
                    <td align='center'><%=ht.get("FIRM_NM")%></td>                    
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=ht.get("DLV_EST_DT")%></td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>                        	    
                    <td align='center'><%=ht.get("PURC_GU")%></td>   
                    <td align='right'><%=AddUtil.parseDecimal(card_amt10)%></td>                                                
                    <td align='center'>&nbsp;</td>
                    <td align='center'>&nbsp;</td>
                    <td align='center'><%if(card_amt10>0){%>우리카드<%}else{%>&nbsp;<%}%></td>                                        
                    <td align='right'><%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><%=AddUtil.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%><%}else{%>0<%}%></td>
                    <td align='center'><%=ht.get("PUR_PAY_DT")%><%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%>&nbsp;<%}%></td>
                    <td align='right'><%if(!String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><%=AddUtil.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%><%}else{%>0<%}%></td>        	    
        	    <td align='center'><%=ht.get("DLV_BRCH")%></td>					
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt1)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt3)%></td>
        	    <td align='right'>0</td>        	    
        	    <td align='right'>0</td>        	    
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt7)%></td>        	    
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt2)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt9)%></td>        	    
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt8)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt1+card_amt2+card_amt3+card_amt7+card_amt8+card_amt9)%></td>        	    
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt4)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt5)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt6)%></td>
        	    <td align='right'><%=AddUtil.parseDecimal(card_amt4+card_amt5+card_amt6)%></td>        	    
        	    <td align='center'>&nbsp;</td>	     		    	        		    
                </tr>
<%		}	%>
</table>
</form>
<script language='javascript'>
<!--	
//-->
</script>
</body>
</html>
