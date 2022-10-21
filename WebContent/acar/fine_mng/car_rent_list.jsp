<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.res_search.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	AddForfeitDatabase cdb = AddForfeitDatabase.getInstance();
	RentListBean rl_r [] = cdb.getCarRentListAll(gubun,l_cd,firm_nm,car_no);
	String c_id = "";
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript">
<!--
function SetCarRent(car_mng_id,rent_mng_id,rent_l_cd,firm_nm,client_nm,car_no,car_name,rent_way_nm,con_mon,rent_start_dt,o_tel,fax)
{
	var fm = opener.document.form1;
	fm.c_id.value = car_mng_id;
	fm.m_id.value = rent_mng_id;
	fm.l_cd.value = rent_l_cd;
	fm.seq_no.value = '';	
	fm.target = 'd_content';	
	fm.action = 'fine_mng_frame.jsp';
	fm.submit();
	self.close();	
}
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>계약조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="3%">연번</td>
                  <td class=title width="3%">구분</td>
                  <td class=title width="10%">계약번호</td>
				  <td class=title width="7%">계약일</td>
                  <td class=title width="12%">상호/성명</td>
                  <td class=title width="10%">차량번호</td>
                  <td class=title width="10%">차명</td>
                  <td class=title width="7%">인도일</td>
                  <td class=title width="7%">대여개시일</td>
                  <td class=title width="7%">대여만료일</td>
                  <td class=title width="7%">회수일</td>
                  <td class=title width="7%">해지일</td>
                  <td class=title width="7%">승계일자</td>				  
                </tr>
                <%  for(int i=0; i<rl_r.length; i++){
            	rl_bean = rl_r[i];
        		c_id = rl_bean.getCar_mng_id();%>
                <tr> 
                  <td align="center"><%=i+1%></td>
                  <td align="center"> 
                    <%if(rl_bean.getUse_yn().equals("Y")) {%>
                    대여 
                    <%}else{%>
                    해지 
                    <%}%>
                  </td>
                  <td align="center"><a href="javascript:SetCarRent('<%=rl_bean.getCar_mng_id()%>','<%=rl_bean.getRent_mng_id()%>','<%=rl_bean.getRent_l_cd()%>','<%=rl_bean.getFirm_nm()%>','<%=rl_bean.getClient_nm()%>','<%=rl_bean.getCar_no()%>','<%=rl_bean.getCar_nm()%>','<%=rl_bean.getRent_way_nm()%>','<%=rl_bean.getCon_mon()%>','<%=rl_bean.getRent_start_dt()%>','<%=rl_bean.getO_tel()%>','<%=rl_bean.getFax()%>')"><%= rl_bean.getRent_l_cd() %></a></td>
				  <td align="center"><%= rl_bean.getRent_dt() %></td>
                  <td align="center"><span title='<%=rl_bean.getFirm_nm()%>'><%=Util.subData(rl_bean.getFirm_nm(), 8)%></span></td>
                  <td align="center"><%= rl_bean.getCar_no() %></td>
                  <td align="center"><span title='<%=rl_bean.getCar_nm()+" "+rl_bean.getCar_name()%>'><%=Util.subData(rl_bean.getCar_nm()+" "+rl_bean.getCar_name(), 8)%></span></td>
                  <td align="center"><%=rl_bean.getCar_deli_dt() %></td>
                  <td align="center"><%= rl_bean.getRent_start_dt() %></td>
                  <td align="center"><%= rl_bean.getRent_end_dt() %></td>
                  <td align="center"><%= rl_bean.getReco_dt() %></td>
                  <td align="center"><%= rl_bean.getCls_dt() %></td>
                  <td align="center"><%= rl_bean.getRent_suc_dt() %></td>				  
                </tr>
                <%	}%>
                <% 	if(rl_r.length == 0) { %>
                <tr> 
                  <td colspan=13 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
  </tr>
  <tr> 
        <td>&nbsp;</td>
  </tr>
  <tr>
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
  </tr>
</table>
</body>
</html>