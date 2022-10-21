<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");	

	String s_br 	= request.getParameter("s_br")		==null?"":request.getParameter("s_br");
	String s_br_nm 	= request.getParameter("s_br_nm")	==null?"":request.getParameter("s_br_nm");
	String car_kd 	= request.getParameter("car_kd")	==null?"":request.getParameter("car_kd");
	String car_kd_nm= request.getParameter("car_kd_nm")	==null?"":request.getParameter("car_kd_nm");
	String st 	= request.getParameter("st")		==null?"":request.getParameter("st");
	String st_nm 	= request.getParameter("st_nm")		==null?"":request.getParameter("st_nm");
	
	
	
	Vector vt = rs_db.getRmRentStat4SubList(gubun4, start_dt, end_dt, s_br, car_kd, st);
	int vt_size = vt.size();
	
	long tot_amt =0;
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
 	//계약서 내용 보기
	function view_cont(rent_mng_id, rent_l_cd){
	
		var fm = document.form1;
		
		fm.c_st.value = 'fee_rm';
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
				
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
 <input type='hidden' name='c_st' value=''>
 <input type='hidden' name='rent_mng_id' value=''>
 <input type='hidden' name='rent_l_cd' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리 > <span class=style5>계약종료관리 세부리스트 [<%=s_br_nm%> <%=car_kd_nm%> <%=st_nm%>]</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>상호</td>
                    <td width=10% class=title>차량번호</td>
                    <td width=10% class=title>차명</td>                                        
                    <td width=10% class=title>대여개시일</td>
                    <td width=10% class=title>반차<%if(st.equals("3")){%>예정일<%}else{%>일자<%}%></td>
                    <td width=10% class=title>기간</td>                    
                    <td width=10% class=title>매출</td>
                    <td width=10% class=title>미도래</td>   
                    <td width=5% class=title>보기</td>                                    
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					tot_amt = tot_amt + Long.parseLong(String.valueOf(ht.get("PAY_FEE")));
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>                    
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>                    
                    <td align='center'><%=ht.get("EXT_MONTHS")%>개월<%=ht.get("EXT_DAYS")%>일</td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("PAY_FEE")))%>&nbsp;</td>                    
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DLY_FEE")))%>&nbsp;</td>                                        
                    <td align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">보기</a></td>
                </tr>    				                                    				
		<%	}%>
				<tr>
					<td colspan = '7' class="title">매출합계</td>
					<td align="right"><%=Util.parseDecimal(tot_amt)%> 원&nbsp;</td>
					<td align="right" colspan='2'>&nbsp;</td>
					<td></td>
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>