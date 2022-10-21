<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/off/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function SetCarRent(rent_s_cd, rent_st, firm_nm, client_nm, rent_start_dt, rent_end_dt)
{
	var fm = opener.document.form1;
	fm.s_cd.value 		= rent_s_cd;
	fm.res_firm.value 	= firm_nm;
	fm.res_client.value = client_nm;
	fm.res_st.value 	= rent_st;	
	fm.res_sdt.value 	= rent_start_dt;
	fm.res_edt.value 	= rent_end_dt;	
	self.close();	
}
//-->
</script>
</head>
<body onLoad="self.focus()">
<%	//예약현황
	Vector conts = rs_db.getResCarCauCarList(c_id);
	int cont_size = conts.size();%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>보유차운행현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title rowspan='2' width=5%>연번</td>
                    <td class=title rowspan='2' width=10%>구분</td>
                    <td class=title rowspan='2' width=5%>상태</td>					
                    <td class=title colspan='2'>자동차</td>															
                    <td class=title rowspan='2' width=30%>대여기간</td>
                    <td class=title rowspan='2' width=20%>상호/성명</td>
					<td class=title rowspan='2' width=10%>담당자</td>
                </tr>
				<tr>
                    <td class=title width="10%">보유차</td>														
                    <td class=title width="10%">사유발생</td>																			
				</tr>						
          <%	if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
					Hashtable reservs = (Hashtable)conts.elementAt(i);
					if(!reservs.get("USE_ST").equals("취소")){
					%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("RENT_ST")%></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%><font color=red><%}%><%=reservs.get("CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("CAR_NO")))){%></font><%}%></td>
                    <td align="center"><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%><font color=red><%}%><%=reservs.get("D_CAR_NO")%><%if(String.valueOf(res.get("CAR_NO")).equals(String.valueOf(reservs.get("D_CAR_NO")))){%></font><%}%></td>															
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
                    <td align="center"><a href="javascript:SetCarRent('<%=reservs.get("RENT_S_CD")%>','<%=reservs.get("RENT_ST")%>','<%=reservs.get("FIRM_NM")%>','<%=reservs.get("CUST_NM")%>','<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%>','<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%>')"><%=reservs.get("FIRM_NM")%> <%=reservs.get("CUST_NM")%></a></td>
					<td align="center"><%=reservs.get("BUS_NM")%></td>
                </tr>
          <%		}
		  }
  			}else{%>
                <tr> 
                    <td colspan='7' align='center'>등록된 데이타가 없습니다</td>
                </tr>
          <%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>
</body>
</html>