<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
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
	
	Vector vt2 = d_db.getCarPurPayEstDtStat(pur_pay_dt);
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
			<td width='3%' class='title'>연번</td>
		    <td width='10%' class='title'>계약번호</td>
		    <td width="20%" class='title'>고객</td>
		    <td width="7%" class='title'>출고일자</td>			
			<!--<td width='8%' class='title'>차량번호</td>-->
		    <td width="10%" class='title'>차종</td>					
       		<td width='14%' class='title'>지출처</td>
			<td width="6%" class='title'>지급수단</td>
		    <td width="9%" class='title'>금액</td>								
			<td width="6%" class='title'>종류</td>				  
			<td width="15%" class='title'>번호</td>
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("RENT_L_CD")%></td>
		    <td align='center'><%=ht.get("FIRM_NM")%></td>
		    <td align='center'><%=ht.get("DLV_DT")%></td>			
			<!--<td align='center'><%=ht.get("CAR_NO")%></td>-->
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
		    <td colspan="7" class=title>합계</td>
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
        <td><< 카드지출분집계표 >></td>
    </tr>  
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
        			            <td class=line2 style='height:1' colspan=11></td>
        			        </tr>
                            <tr valign="middle" align="center">
                                <td width='3%' rowspan="3" class=title>연번</td>
                                <td width='15%' rowspan="3" class=title>카드사명</td>
                                <td width='13%' rowspan="3" class=title>카드번호</td>
                                <td width='3%' rowspan="3" class=title>지출<br>구분</td>
                                <td colspan="5" class=title>거래내역</td>
                                <td width='18%' rowspan="3" class=title>거치기간</td>
                            </tr>
                            <tr valign="middle" align="center">
				<td colspan="2" class=title>당일거래금액</td>
                                <td colspan="3" class=title>당월누적거래금액</td>
                            </tr>
                            <tr valign="middle" align="center">
				<td width='10%' class=title>금액</td>
                                <td width='8%' class=title>결제예정일</td>
                                <td width='10%' class=title>기결제금액</td>
                                <td width='10%' class=title>미결제금액</td>
                                <td width='10%' class=title>합계</td>
                            </tr>                                                        
        		    <%	
        			for(int i = 0 ; i < vt_size2 ; i++){
        				Hashtable ht = (Hashtable)vt2.elementAt(i);
        				String cardno 		= String.valueOf(ht.get("CARDNO"));
        				String trf_st 		= String.valueOf(ht.get("TRF_ST"));
        				String use_s_m 		= String.valueOf(ht.get("USE_S_M"));
        				String use_s_day 	= String.valueOf(ht.get("USE_S_DAY"));
        				String use_e_m 		= String.valueOf(ht.get("USE_E_M"));
        				String use_e_day 	= String.valueOf(ht.get("USE_E_DAY"));        						
        				//당일거래금액
					long d_pay_amt 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					//당월누적거래금액
					long m_pay_amt 		= d_db.getCarPurPayCardAmt(cardno, trf_st);
					//당월누적거래금액
					Hashtable mon_amt_ht 	= d_db.getCarPurPayMonCardAmt(cardno, trf_st, String.valueOf(ht.get("PUR_EST_DT")));
        		    %>	
                            <tr valign="middle" align="center">
                                <td><%=i+1%></td>
                                <td><%=ht.get("COM_NAME")%></td>
                                <td><%=cardno%></td>
                                <td><%=trf_st%></td>
				<td align="right"><%=Util.parseDecimal(d_pay_amt)%></td>
				<td><%=AddUtil.ChangeDate2(af_db.getValidDt(String.valueOf(ht.get("PAY_DT"))))%></td>
				<td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT1"))))%></td>
				<td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT2"))))%></td>
                                <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("T_AMT"))))%><%//=Util.parseDecimal(m_pay_amt)%></td>
                                <td>
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){%>승인일 당일 마감시간<%}%>20151209승인후1영업일로 변경->20160217 승인후2영업일로 변경-->
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){%>승인후 2영업일(초일불산입)<%}%> 20170712  2영업일->3영업일 변경--> 
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){%>승인후 4영업일(초일불산입)<%}%>
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("우리BC카드")||String.valueOf(ht.get("CARD_KIND")).equals("부산비씨카드")||String.valueOf(ht.get("CARD_KIND")).equals("국민카드")){%>승인후 3영업일(초일불산입)<%}%>
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("광주카드")){%>승인후 2영업일(초일불산입)<%}%>
                                    <!--<%if(String.valueOf(ht.get("CARD_KIND")).equals("국민카드")){%>승인후 1영업일(초일불산입)<%}%>-->
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("현대카드")){%>1주간 승인건 합산후 익주 수요일<%}%>
                                </td>								
                            </tr>
        		    <%		total_amt14 = total_amt14 +d_pay_amt;
        				total_amt15 = total_amt15 +m_pay_amt;
        		      	}
        		    %>
                            <tr valign="middle" align="center">
                                <td colspan="4" class=title>합계</td>
                                <td class=title style='text-align:right'><%=Util.parseDecimal(total_amt14)%></td>
                                <td class=title></td>
                                <td class=title></td>
                                <td class=title></td>
            			<td class=title style='text-align:right'><%=Util.parseDecimal(total_amt15)%></td>
            			<td class=title></td>								
                            </tr>				
                        </table>			
        	    </td>	        	    
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

