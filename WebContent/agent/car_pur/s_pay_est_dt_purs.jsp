<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String pur_pay_dt = pur.getPur_pay_dt();
	
	if(pur_pay_dt.equals(""))	pur_pay_dt = pur.getPur_est_dt();
	
	if(pur_pay_dt.equals(""))	pur_pay_dt = pur.getCon_est_dt();
	
	
	Vector vt = d_db.getCarPurPayEstDtList("", pur_pay_dt);
	int vt_size = vt.size();
	
	Vector vt2 = d_db.getCarPurPayEstDtStat("", pur_pay_dt);
	int vt_size2 = vt2.size();
	
	
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
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
//-->
</script>
</head>

<body leftmargin="15">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>차량대금결제(예상)금액</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
      <td>[지출일자] <%=AddUtil.ChangeDate2(pur_pay_dt)%></td>
    </tr>  	
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
		    <td width='90' class='title'>계약번호</td>
		    <td width="110" class='title'>고객</td>
		    <td width="70" class='title'>출고일자</td>			
			<td width='80' class='title'>차량번호</td>
		    <td width="100" class='title'>차종</td>					
       		<td width='120' class='title'>지출처</td>
			<td width="60" class='title'>지급수단</td>
		    <td width="90" class='title'>금액</td>								
			<td width="80" class='title'>종류</td>				  
			<td width="150" class='title'>번호</td>
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("RENT_L_CD")%></td>
		    <td align='center'><%=ht.get("FIRM_NM")%></td>
		    <td align='center'><%=ht.get("DLV_DT")%></td>			
			<td align='center'><%=ht.get("CAR_NO")%></td>
       		<td align='center'><%=ht.get("CAR_NM")%></td>					
       		<td align='center'><font color="#CCCCCC"><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%></font><br><%=ht.get("DLV_BRCH")%></td>
			<td align='center'><%=ht.get("TRF_ST")%></td>
			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
			<td align='center'><%=ht.get("CARD_KIND")%></td>
			<td align='center'><%=ht.get("CARDNO")%></td>						
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="8" class=title>합계</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>		
			<td class='title'></td>									
			<td class='title'></td>												
		  </tr>
		</table>
	  </td>
    </tr> 
    <tr>
      <td class=h></td>
    </tr>  	
    <tr>
      <td>&nbsp;<카드/계좌별 집계></td>
    </tr>  
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='30' class='title'>연번</td>
			<td width="100" class='title'>종류</td>				  
			<td width="300" class='title'>번호</td>
			<td width="100" class='title'>한도금액</td>			
			<td width="100" class='title'>만기일자</td>
		    <td width="350" class='title'>금액</td>											
		  </tr>		
		  <%	total_amt1 = 0;
		  		for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
			<td align='center'><%=ht.get("CARD_KIND")%></td>
			<td align='center'><%=ht.get("CARDNO")%></td>						
			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LIMIT_AMT")))%></td>
			<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>									
			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("TRF_AMT")));
		 		}%>
		  <tr>
		    <td colspan="5" class=title>합계</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>		
		  </tr>
		</table>
	  </td>
    </tr>  	
</table>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

