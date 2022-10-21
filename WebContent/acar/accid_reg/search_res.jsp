<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//보유차 예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//계약선택
	function Disp(rent_s_cd, rent_st, firm_nm, start_dt, end_dt){
		var fm = opener.document.form1;
		fm.rent_s_cd.value = rent_s_cd;		
		fm.sub_rent_gu_nm.value = rent_st;				
		if(rent_st == '단기대여')	fm.sub_rent_gu.value = '1';
		else if(rent_st == '정비대차')	fm.sub_rent_gu.value = '2';
		else if(rent_st == '사고대차')	fm.sub_rent_gu.value = '3';
		else if(rent_st == '보험대차')	fm.sub_rent_gu.value = '9';
		else if(rent_st == '지연대차')	fm.sub_rent_gu.value = '10';
		else if(rent_st == '업무대여')	fm.sub_rent_gu.value = '4';
		else if(rent_st == '업무지원')	fm.sub_rent_gu.value = '5';
		else if(rent_st == '차량정비')	fm.sub_rent_gu.value = '6';
		else if(rent_st == '차량점검')	fm.sub_rent_gu.value = '7';
		else if(rent_st == '사고수리')	fm.sub_rent_gu.value = '8';		
		else if(rent_st == '월렌트')	fm.sub_rent_gu.value = '12';		
		fm.sub_firm_nm.value = firm_nm;
		if(start_dt != '')	fm.sub_rent_st.value = ChangeDate(start_dt.substr(0,8));
		if(end_dt != '')	fm.sub_rent_et.value = ChangeDate(end_dt.substr(0,8));		
		self.close();
	}	
	//기타선택
	function Disp2(){
		var fm = opener.document.form1;
		fm.sub_rent_gu_nm.value = "기타";				
		fm.sub_firm_nm.value = "아마존카";
		fm.sub_rent_gu.value = '99';
		fm.sub_rent_st.value = '';
		fm.sub_rent_et.value = '';		
		fm.rent_s_cd.value = '';				
		self.close();
	}	
	
-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_res.jsp'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>보유차 운행리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
    <tr align="right"> 
      <td colspan="2"><font color="#666666">* 해당하는 건이 없으면 대여구분 기타를 선택하십시오.</font></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=100%>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="125">상호</td>
            <td class=title width="125">계약자</td>
            <td class=title width="130">대여시작일</td>
            <td class=title width="130">대여종료일</td>
            <td class=title width="70">대여구분</td>
            <td class=title width="40">상태</td>
          </tr>
          <tr> 
            <td align="center">-</td>
            <td align="center">아마존카</td>
            <td align="center">-</td>
            <td align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
            <td align="center"><a href="javascript:Disp2()">기타</a></td>
            <td align="center">-</td>
          </tr>		  
          <%	if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:Disp('<%=reservs.get("RENT_S_CD")%>', '<%=reservs.get("RENT_ST")%>', '<%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%>', '<%=reservs.get("RENT_START_DT")%>', '<%=reservs.get("RENT_END_DT")%>')" onMouseOver="window.status=''; return true"><%=reservs.get("FIRM_NM")%></a></td>
            <td align="center"><a href="javascript:Disp('<%=reservs.get("RENT_S_CD")%>', '<%=reservs.get("RENT_ST")%>', '<%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%>', '<%=reservs.get("RENT_START_DT")%>', '<%=reservs.get("RENT_END_DT")%>')" onMouseOver="window.status=''; return true"><%=reservs.get("CUST_NM")%></a></td>
            <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%></td>
            <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
            <td align="center"><%=reservs.get("RENT_ST")%></td>
            <td align="center"><%=reservs.get("USE_ST")%></td>
          </tr>
          <%		}
  			}else{%>
          <tr> 
            <td colspan='7' align='center'>등록된 데이타가 없습니다</td>
          </tr>
          <%	}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="300">&nbsp; </td>
      <td align="right"><a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript">
	//cng_input()
</script>