<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	String st_nm 	= request.getParameter("st_nm")==null?"":request.getParameter("st_nm");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_br 	= request.getParameter("s_br")==null?"":request.getParameter("s_br");
	
	
	Vector vt = rs_db.getRentStat1SubList(mode, st, s_dt, s_br);
	int vt_size = vt.size();
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
 	//계약서 내용 보기
	function view_cont(use_st, rent_st, s_cd, c_id){
	
		var fm = document.form1;
		
		fm.mode.value = 'c';
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
				
		if(use_st == '1'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}else if(use_st == '2'){ 	
			fm.action = '/acar/rent_mng/res_rent_u.jsp';
		}else if(use_st == '3'){ 
			fm.action = '/acar/rent_end/rent_settle_u.jsp';			
		}else if(use_st == '4'){ 	
			fm.action = '/acar/rent_end/rent_settle_u.jsp';
		}else if(use_st == '5'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}
				
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
 <input type='hidden' name='mode' value=''>
 <input type='hidden' name='s_cd' value=''>
 <input type='hidden' name='c_id' value=''>
 <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > <span class=style5>일일영업현황 <%=st_nm%> 세부리스트</span></span></td>
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
                    <td width=20% class=title>상호</td>
                    <td width=10% class=title>차량번호</td>
                    <td width=20% class=title>차명</td>
                    <%if(st.equals("1") || st.equals("2")){%>
                    <td width=10% class=title>계약일자</td>
                    <td width=15% class=title>대여개시일</td>
                    <td width=15% class=title>대여만료일</td>
                    <%}else{%>                    
                    <td width=20% class=title>배차(예정)일시</td>
                    <td width=20% class=title>반차(예정)일시</td>                                        
                    <%}%>
                    <td width=5% class=title>보기</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <%if(st.equals("1") || st.equals("2")){%>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <%}else{%>                    
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DELI_DT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RET_DT")))%></td>
                    <%}%>                    
                    <td align='center'><a href="javascript:parent.view_cont('<%=ht.get("USE_ST")%>','12','<%=ht.get("RENT_S_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true">보기</a></td>
                </tr>    				                                    				
		<%	}%>                																																	
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>