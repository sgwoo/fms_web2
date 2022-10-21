<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.res_search.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
function SetCarRent(car_mng_id,rent_mng_id,rent_l_cd,firm_nm,client_nm,car_no,car_name,rent_way_nm,con_mon,rent_start_dt,o_tel,fax)
{
	var fm = opener.document.form1;
	fm.c_id.value = car_mng_id;
	fm.m_id.value = rent_mng_id;
	fm.l_cd.value = rent_l_cd;
	fm.action = 'forfeit_i_sh.jsp';
	fm.submit();
	self.close();
	
}
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=770>
    <tr>
        <td class=line>
            
      <table border=0 cellspacing=1 width=770>
        <tr> 
          <td class=title width="30">연번</td>
          <td class=title width="40">구분</td>		  
          <td class=title width="90">계약번호</td>
          <td class=title width="140">상호</td>
          <td class=title width="70">고객명</td>
          <td class=title width="90">차량번호</td>
          <td class=title width="100">차명</td>
          <td class=title width="70">대여개시일</td>
          <td class=title width="70">대여만료일</td>		  
          <td class=title width="70">해지일자</td>
        </tr>
        <%  for(int i=0; i<rl_r.length; i++){
    	rl_bean = rl_r[i];
		c_id = rl_bean.getCar_mng_id();%>
        <tr> 
          <td align="center"><%=i+1%></td>
          <td align="center"><%if(rl_bean.getUse_yn().equals("Y")){%>대여 <%}else{%>해지 <%}%></td>		  
          <td align="center"><a href="javascript:SetCarRent('<%=rl_bean.getCar_mng_id()%>','<%=rl_bean.getRent_mng_id()%>','<%=rl_bean.getRent_l_cd()%>','<%=rl_bean.getFirm_nm()%>','<%=rl_bean.getClient_nm()%>','<%=rl_bean.getCar_no()%>','<%=rl_bean.getCar_nm()%>','<%=rl_bean.getRent_way_nm()%>','<%=rl_bean.getCon_mon()%>','<%=rl_bean.getRent_start_dt()%>','<%=rl_bean.getO_tel()%>','<%=rl_bean.getFax()%>')"><%= rl_bean.getRent_l_cd() %></a></td>
          <td align="center"><%= rl_bean.getFirm_nm() %></td>
          <td align="center"><%= rl_bean.getClient_nm() %></td>
          <td align="center"><span title='최초등록번호:<%=rl_bean.getFirst_car_no()%>'><%=rl_bean.getCar_no()%></span></td>
          <td align="center"><span title='<%=rl_bean.getCar_nm()+" "+rl_bean.getCar_name()%>'><%=Util.subData(rl_bean.getCar_nm()+" "+rl_bean.getCar_name(), 9)%></span></td>
          <td align="center"><%= rl_bean.getRent_start_dt() %>&nbsp;</td>
          <td align="center"><%= rl_bean.getRent_end_dt() %>&nbsp;</td>		  
          <td align="center"><%= rl_bean.getCls_dt() %>&nbsp;</td>
        </tr>
        <%	}%>
        <% 	if(rl_r.length == 0) { %>
        <tr> 
          <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
        </tr>
        <%	}%>
      </table>
        </td>
    </tr>
</table>
<%if(gubun.equals("car_no")){
	//예약현황
	Vector conts = rs_db.getResCarList(c_id);
	int cont_size = conts.size();%>
<table border=0 cellspacing=0 cellpadding=0 width=770>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td><보유차 운행 현황></td>
    </tr>	
    <tr>
        <td class=line>
            
      <table border=0 cellspacing=1 width=770>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="70">차량번호</td>
            <td class=title width="70">구분</td>
            <td class=title width="40">상태</td>
            <td class=title width="250">대여기간</td>
            <td class=title width="100">계약자</td>
            <td class=title width="100">상호</td>
            <td class=title width="80">정상대여료</td>
          </tr>
          <%	if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><span title='최초등록번호:<%=reservs.get("FIRST_CAR_NO")%>'><%=reservs.get("CAR_NO")%></span></td>
            <td align="center"><%=reservs.get("RENT_ST")%></td>
            <td align="center"><%=reservs.get("USE_ST")%></td>
            <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
            <td align="center"><%=reservs.get("CUST_NM")%></td>
            <td align="center"><%=reservs.get("FIRM_NM")%></td>
            <td align="center"><%=AddUtil.parseDecimal(String.valueOf(reservs.get("FEE_AMT")))%></td>
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
</table>
<%	}%>
</body>
</html>